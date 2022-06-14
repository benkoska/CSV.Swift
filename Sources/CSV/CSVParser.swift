//
//  CSVParser.swift
//  
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

public class CSVParser {
    
    let delimiter: UInt8
    let quotationMark: UInt8
    let reader: BufferedByteReader
    
    var hasHeader: Bool
    var header: [String]?
    
    /**
     Creates a new CSV parser
     
     - Parameter inputStream: The input stream for CSVParser to use to read data from
     - Parameter delimiter: Delimiter to be used to signify a new column
     - Parameter quotationMark: Character to be used to signify the start/end of a quotation (which may contain delimiters and linebreaks)
     - Parameter hasHeader: Indicates whether the CSV contains a header
     - Parameter header: Manually set a header (if set, hasHeader will be disregarded)
     */
    public init(inputStream: InputStream, delimiter: UInt8 = 0x2C, quotationMark: UInt8 = 0x22, hasHeader: Bool = false, header: [String]? = nil) {
        self.delimiter = delimiter
        self.quotationMark = quotationMark
        self.reader = BufferedByteReader(inputStream: inputStream)
        
        if let header = header {
            self.header = header
            self.hasHeader = false
        } else {
            self.header = nil
            self.hasHeader = hasHeader
        }
    }
    
    /**
     Returns the next item parsed as Array of Strings (if not further rows avaliable, returns nil)
     */
    public func next() -> [String]? {
        var fieldBuffer: [UInt8] = []
        var rowBuffer: [String] = []
        
        if let header = header {
            rowBuffer.reserveCapacity(header.count)
        }
        
        var isInQuotation = false
        
        while let char = reader.pop()  {
            if isInQuotation {
                if char == quotationMark && reader.peek() == delimiter {
                    isInQuotation = false
                } else {
                    fieldBuffer.append(char)
                }
            } else {
                if char == delimiter {
                    if let str = String(bytes: fieldBuffer, encoding: .utf8) {
                        rowBuffer.append(str)
                    }
                    
                    fieldBuffer = []
                } else if char == 0x0A || (char == 0x0D && reader.peek() == 0x0A) { // new line (\n or \r\n)
                    if char == 0x0D && reader.peek() == 0x0A {
                        _ = reader.pop()
                    }
                    
                    if !fieldBuffer.isEmpty {
                        if let str = String(bytes: fieldBuffer, encoding: .utf8) {
                            rowBuffer.append(str)
                        }
                    }

                    return !rowBuffer.isEmpty ? rowBuffer : nil
                } else if char == quotationMark && fieldBuffer.isEmpty {
                    isInQuotation = true
                } else {
                    fieldBuffer.append(char)
                }
            }
        }
        
        if !fieldBuffer.isEmpty {
            if let str = String(bytes: fieldBuffer, encoding: .utf8) {
                rowBuffer.append(str)
            }
        }

        return !rowBuffer.isEmpty ? rowBuffer : nil
    }
    
    /**
     Returns the next item parsed as given Decodable (if not further rows avaliable, returns nil)
     
     - Precondition: `header` is set, or `hasHeader` is true, and CSV contains a header
     - Parameter as: Type that should be used for decoding
     
     */
    public func next<T>(as: T.Type) throws -> T? where T: Decodable {
        guard var rawData = next() else {
            return nil
        }
        
        if hasHeader {
            hasHeader = false
            header = rawData
            
            guard let newRawData = next() else {
                return nil
            }
            
            rawData = newRawData
        }
        
        return try T(from: CSVRowDecoder(header: header, data: rawData))
    }
    
    /**
     Returns the next item as a dictionary (if not further rows avaliable, returns nil)
     
     - Precondition: `header` is set, or `hasHeader` is true, and CSV contains a header
     */
    public func nextAsDict() throws -> [String: String]? {
        guard var rawData = next() else {
            return nil
        }
        
        if hasHeader {
            hasHeader = false
            header = rawData
            
            guard let newRawData = next() else {
                return nil
            }
            
            rawData = newRawData
        }
        
        guard let header = header else {
            throw CSVParserError.noHeaderFound
        }
        
        guard rawData.count == header.count else {
            throw CSVParserError.rowLengthMismatch
        }
        
        // TODO: see if we can improve the below
        var response: [String: String] = [:]
        for index in 0..<rawData.count {
            let entry = rawData[index]
            response[header[index]] = entry
        }
        
        return response
    }
    
    /**
     Loads all rows from CSV as String Array
     
     - Parameter rowCount: Optional, amount of expected rows
     - Returns: Array of String Arrays, with each top-level Array Entry representing one row, and each element of given Entry representing one column
     */
    public func loadAll(rowCount: Int? = nil) -> [[String]]? {
        var response: [[String]] = []
        
        if let rowCount = rowCount {
            response.reserveCapacity(rowCount)
        }
        
        while let row = next() {
            response.append(row)
        }
        
        return response
    }
    
    /**
     Loads all rows from CSV as Dictionary ([String: String])
     
     - Precondition: `header` is set, or `hasHeader` is true, and CSV contains a header
     - Parameter rowCount: Optional, amount of expected rows
     - Returns: Array of Dictionaries, with each Dictionary representing one row
     */
    public func loadAllAsDict(rowCount: Int? = nil) throws -> [[String: String]]? {
        var response: [[String: String]] = []
        
        if let rowCount = rowCount {
            response.reserveCapacity(rowCount)
        }
        
        while let row = try nextAsDict() {
            response.append(row)
        }
        
        return response
    }
    
    /**
     Loads all rows from CSV and parses them as given Decodable
     
     - Precondition: `header` is set, or `hasHeader` is true, and CSV contains a header
    
     - Parameter as: Type that should be used for decoding
     - Parameter rowCount: Optional, amount of expected rows
     */
    public func loadAll<T>(as: T.Type, rowCount: Int? = nil) throws -> [T]? where T: Decodable {
        var response: [T] = []
        
        if let rowCount = rowCount {
            response.reserveCapacity(rowCount)
        }
        
        while let row = try next(as: T.self) {
            response.append(row)
        }
        
        return response
    }
}
