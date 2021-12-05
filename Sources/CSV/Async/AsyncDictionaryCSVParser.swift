//
//  AsyncDictionaryCSVParser.swift
//  
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

@available(macOS 12.0, *)
public class AsyncDictionaryCSVParser: AsyncSequence {
    public typealias Element = [String: String]
    
    let parser: CSVParser
    public init(parser: CSVParser) {
        self.parser = parser
    }
    
    public func makeAsyncIterator() -> AsyncDictionaryCSVParserIterator {
        return AsyncDictionaryCSVParserIterator(parser: parser)
    }
}

@available(macOS 12.0.0, *)
public class AsyncDictionaryCSVParserIterator: AsyncIteratorProtocol {
    let parser: CSVParser
    
    internal init(parser: CSVParser) {
        self.parser = parser
    }
    
    public func next() async throws -> [String: String]? {
        try parser.nextAsDict()
    }
}
