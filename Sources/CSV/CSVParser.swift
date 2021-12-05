//
//  CSVParser.swift
//  
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

public class CSVParser {
    
    let delimiter: UInt8
    let reader: BufferedByteReader
    
    var hasHeader: Bool
    var header: [String]?
    
    public init(inputStream: InputStream, delimiter: UInt8 = 0x2C, hasHeader: Bool = false, header: [String]? = nil) {
        self.delimiter = delimiter
        self.reader = BufferedByteReader(inputStream: inputStream)
        
        if let header = header {
            self.header = header
            self.hasHeader = false
        } else {
            self.header = nil
            self.hasHeader = hasHeader
        }
    }
    
    public func next() -> [String]? {
        var fieldBuffer: [UInt8] = []
        var rowBuffer: [String] = []
        
        if let header = header {
            rowBuffer.reserveCapacity(header.count)
        }
        
        while let char = reader.pop()  {
            if char == delimiter {
                if !fieldBuffer.isEmpty {
                    if let str = String(bytes: fieldBuffer, encoding: .utf8) {
                        rowBuffer.append(str)
                    }
                    
                    fieldBuffer = []
                }
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
            } else {
                fieldBuffer.append(char)
            }
        }
        
        if !fieldBuffer.isEmpty {
            if let str = String(bytes: fieldBuffer, encoding: .utf8) {
                rowBuffer.append(str)
            }
        }
        
        return !rowBuffer.isEmpty ? rowBuffer : nil
    }
    
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
}
