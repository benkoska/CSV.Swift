//
//  CSVParser+Convenience.swift
//  
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

extension CSVParser {
    
    // MARK: - Init from URL
    public convenience init(url: URL, delimiter: Character, hasHeader: Bool = false, header: [String]? = nil) throws {
        guard let delimiter = delimiter.asciiValue else {
            throw CSVParserError.invalidDelimiter
        }
        
        try self.init(url: url, delimiter: delimiter, hasHeader: hasHeader, header: header)
    }
    
    public convenience init(url: URL, delimiter: UInt8 = 0x2C, hasHeader: Bool = false, header: [String]? = nil) throws {
        guard let stream = InputStream(url: url) else {
            throw CSVParserError.invalidURL
        }
        
        self.init(inputStream: stream, delimiter: delimiter, hasHeader: hasHeader, header: header)
    }
    
    // MARK: - Init with Data
    public convenience init(data: Data, delimiter: Character, hasHeader: Bool = false, header: [String]? = nil) throws {
        guard let delimiter = delimiter.asciiValue else {
            throw CSVParserError.invalidDelimiter
        }
        
        self.init(data: data, delimiter: delimiter, hasHeader: hasHeader, header: header)
    }
    
    public convenience init(data: Data, delimiter: UInt8 = 0x2C, hasHeader: Bool = false, header: [String]? = nil) {
        self.init(inputStream: InputStream(data: data), delimiter: delimiter, hasHeader: hasHeader, header: header)
    }
    
    // MARK: - Init with String
    public convenience init(string: String, delimiter: Character, hasHeader: Bool = false, header: [String]? = nil) throws {
        guard let delimiter = delimiter.asciiValue else {
            throw CSVParserError.invalidDelimiter
        }
        
        self.init(string: string, delimiter: delimiter, hasHeader: hasHeader, header: header)
    }
    
    public convenience init(string: String, delimiter: UInt8 = 0x2C, hasHeader: Bool = false, header: [String]? = nil) {
        let data = string.data(using: .utf8)!
        self.init(
            inputStream: InputStream(data: data), // re: force-unwrap (see https://www.objc.io/blog/2018/02/13/string-to-data-and-back/)
            delimiter: delimiter,
            hasHeader: hasHeader,
            header: header
        )
    }
}
