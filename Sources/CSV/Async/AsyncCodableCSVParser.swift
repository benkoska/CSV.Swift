//
//  AsyncCodableCSVParser.swift
//  
//
//  Created by Ben Koska on 12/5/21.
//

import Foundation

@available(macOS 12.0, *)
public class AsyncCodableCSVParser<Element>: AsyncSequence where Element: Decodable {
    let parser: CSVParser
    public init(parser: CSVParser, as: Element.Type) {
        self.parser = parser
    }
    
    public func makeAsyncIterator() -> AsyncCodableCSVParserIterator<Element> {
        return AsyncCodableCSVParserIterator(parser: parser, as: Element.self)
    }
}

@available(macOS 12.0.0, *)
public class AsyncCodableCSVParserIterator<Element>: AsyncIteratorProtocol where Element: Decodable {
    
    let parser: CSVParser
    
    internal init(parser: CSVParser, as: Element.Type) {
        self.parser = parser
    }
    
    public func next() async throws -> Element? {
        try parser.next(as: Element.self)
    }
}
