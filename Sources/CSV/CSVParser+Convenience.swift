//
//  CSVParser+Convenience.swift
//  
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

extension CSVParser {
    
    // MARK: - Init from URL
    public convenience init(url: URL, delimiter: Character, quotationMark: Character = "\"", hasHeader: Bool = false, header: [String]? = nil) throws {
        guard let delimiter = delimiter.asciiValue else {
            throw CSVParserError.invalidDelimiter
        }

        guard let quotationMark = quotationMark.asciiValue else {
            throw CSVParserError.invalidQuotationMark
        }

        try self.init(url: url, delimiter: delimiter, quotationMark: quotationMark, hasHeader: hasHeader, header: header)
    }
    
    public convenience init(url: URL, delimiter: UInt8 = 0x2C, quotationMark: UInt8 = 0x22, hasHeader: Bool = false, header: [String]? = nil) throws {
        guard let stream = InputStream(url: url) else {
            throw CSVParserError.invalidURL
        }
        
        self.init(inputStream: stream, delimiter: delimiter, quotationMark: quotationMark, hasHeader: hasHeader, header: header)
    }
    
    // MARK: - Init with Data
    public convenience init(data: Data, delimiter: Character, quotationMark: Character = "\"", hasHeader: Bool = false, header: [String]? = nil) throws {
        guard let delimiter = delimiter.asciiValue else {
            throw CSVParserError.invalidDelimiter
        }
        
        guard let quotationMark = quotationMark.asciiValue else {
            throw CSVParserError.invalidQuotationMark
        }

        self.init(data: data, delimiter: delimiter, quotationMark: quotationMark, hasHeader: hasHeader, header: header)
    }
    
    public convenience init(data: Data, delimiter: UInt8 = 0x2C, quotationMark: UInt8 = 0x22, hasHeader: Bool = false, header: [String]? = nil) {
        self.init(inputStream: InputStream(data: data), delimiter: delimiter, quotationMark: quotationMark, hasHeader: hasHeader, header: header)
    }
    
    // MARK: - Init with String
    public convenience init(string: String, delimiter: Character, quotationMark: Character = "\"", hasHeader: Bool = false, header: [String]? = nil) throws {
        guard let delimiter = delimiter.asciiValue else {
            throw CSVParserError.invalidDelimiter
        }
        
        guard let quotationMark = quotationMark.asciiValue else {
            throw CSVParserError.invalidQuotationMark
        }
        
        self.init(string: string, delimiter: delimiter, quotationMark: quotationMark, hasHeader: hasHeader, header: header)
    }
    
    public convenience init(string: String, delimiter: UInt8 = 0x2C, quotationMark: UInt8 = 0x22, hasHeader: Bool = false, header: [String]? = nil) {
        let data = string.data(using: .utf8)!
        self.init(
            inputStream: InputStream(data: data), // re: force-unwrap (see https://www.objc.io/blog/2018/02/13/string-to-data-and-back/)
            delimiter: delimiter,
            hasHeader: hasHeader,
            header: header
        )
    }
}
