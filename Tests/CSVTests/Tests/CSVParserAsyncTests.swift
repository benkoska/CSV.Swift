//
//  CSVParserAsyncTests.swift
//  
//
//  Created by Ben Koska on 12/5/21.
//

import XCTest
@testable import CSV

@available(macOS 12.0.0, *)
final class CSVParserAsyncTests: XCTestCase {
    let data: Data = "1635724800000,53228.92000000,53265.47000000,53218.59000000,53233.40000000,1.00359000,1635724859999,53430.40481810,64,0.97545000,51931.96981100,0".data(using: .utf8)!
    
    func testAysncCSVParser() async throws {
        let parser = CSVParser(data: data)
        let asyncParser = AsyncCSVParser(parser: parser)
        
        for await item: [String] in asyncParser {
            XCTAssert(item == ["1635724800000", "53228.92000000", "53265.47000000", "53218.59000000", "53233.40000000", "1.00359000", "1635724859999", "53430.40481810", "64", "0.97545000", "51931.96981100", "0"])
        }
        
        XCTAssert(parser.next() == nil)
    }
    
    func testAsyncDictionaryCSVParser() async throws {
        let parser = CSVParser(data: data, header: ["openTime", "open", "high", "low", "close", "volume", "closeTime", "quoteAssetVolume", "numberOfTrades", "takerBaseAssetVolume", "takerQuoteAssetVolume", "ignore"])
        let asyncParser = AsyncDictionaryCSVParser(parser: parser)
        
        for try await item: [String: String] in asyncParser {
            let keys: [String] = Array(item.keys)
            
            XCTAssert(
                keys.containsSameElements(as: ["openTime", "open", "high", "low", "close", "volume", "closeTime", "quoteAssetVolume", "numberOfTrades", "takerBaseAssetVolume", "takerQuoteAssetVolume", "ignore"])
            )
            
            XCTAssert(item["openTime"] == "1635724800000")
            XCTAssert(item["open"] == "53228.92000000")
            XCTAssert(item["high"] == "53265.47000000")
            XCTAssert(item["low"] == "53218.59000000")
            XCTAssert(item["close"] == "53233.40000000")
            XCTAssert(item["volume"] == "1.00359000")
            XCTAssert(item["closeTime"] == "1635724859999")
            XCTAssert(item["quoteAssetVolume"] == "53430.40481810")
            XCTAssert(item["numberOfTrades"] == "64")
            XCTAssert(item["takerBaseAssetVolume"] == "0.97545000")
            XCTAssert(item["takerQuoteAssetVolume"] == "51931.96981100")
            XCTAssert(item["ignore"] == "0")
        }
        
        XCTAssert(parser.next() == nil)
    }
    
    func testAsyncCodableCSVParser() async throws {
        let parser = CSVParser(data: data, header: ["openTime", "open", "high", "low", "close", "volume", "closeTime", "quoteAssetVolume", "numberOfTrades", "takerBaseAssetVolume", "takerQuoteAssetVolume", "ignore"])
        let asyncParser = AsyncCodableCSVParser(parser: parser, as: BinanceDataEntry.self)
        
        for try await item: BinanceDataEntry in asyncParser {
            XCTAssert(item.openTime == 1635724800000)
            XCTAssert(item.open == 53228.92)
            XCTAssert(item.high == 53265.47)
            XCTAssert(item.low == 53218.59)
            XCTAssert(item.close == 53233.40)
            XCTAssert(item.volume == 1.00359)
            XCTAssert(item.closeTime == 1635724859999)
            XCTAssert(item.quoteAssetVolume == 53430.4048181)
            XCTAssert(item.numberOfTrades == 64)
            XCTAssert(item.takerBaseAssetVolume == 0.97545)
            XCTAssert(item.takerQuoteAssetVolume == 51931.969811)
            XCTAssert(item.ignore == false)
        }
        
        XCTAssert(parser.next() == nil)
    }
}
