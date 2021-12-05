//
//  AsyncCSVParser.swift
//
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

@available(macOS 12.0, *)
public class AsyncCSVParser: AsyncSequence {
    public typealias Element = [String]
    
    let parser: CSVParser
    public init(parser: CSVParser) {
        self.parser = parser
    }
    
    public func makeAsyncIterator() -> AsyncCSVParserIterator {
        return AsyncCSVParserIterator(parser: parser)
    }
}

@available(macOS 12.0.0, *)
public class AsyncCSVParserIterator: AsyncIteratorProtocol {
    let parser: CSVParser
    
    internal init(parser: CSVParser) {
        self.parser = parser
    }
    
    public func next() async -> [String]? {
        parser.next()
    }
}
