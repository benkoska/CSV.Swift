//
//  CSVParserTests.swift
//
//
//  Created by Ben Koska on 12/4/21.
//

import Quick
import Nimble

import Foundation
@testable import CSV

final class CSVParserTests: QuickSpec {
    
    override func spec() {
        let str = "1635724800000,53228.92000000,53265.47000000,53218.59000000,53233.40000000,1.00359000,1635724859999,53430.40481810,64,0.97545000,51931.96981100,0\r\n"
        let data = str.data(using: .utf8)!
        
        describe("inputStream based parser") {
            context("array based response") {
                let parser = CSVParser(data: data)
                let row = parser.next()
                
                it("should not have next") {
                    expect(parser.next()).to(beNil())
                }
                
                it("should have correct values") {
                    expect(row) ==  ["1635724800000", "53228.92000000", "53265.47000000", "53218.59000000", "53233.40000000", "1.00359000", "1635724859999", "53430.40481810", "64", "0.97545000", "51931.96981100", "0"]
                }
                
                let parser2 = CSVParser(string: "1,2,3\n4,5,6\n\n")
                let row2 = parser2.next()
                let row3 = parser2.next()
                let row4 = parser2.next()
                
                it("should also not have next") {
                    expect(row3) == ["4", "5", "6"]
                    expect(row4).to(beNil())
                }
                
                it("should also have correct values") {
                    expect(row2) ==  ["1", "2", "3"]
                }
            }
            
            context("dictionary based response") {
                let parser1 = CSVParser(data: data)
                let row1 = try? parser1.nextAsDict()
                
                it("should be nil") {
                    expect(row1).to(beNil())
                }
                
                let parser2 = CSVParser(data: data, header: ["openTime", "open", "high", "low", "close", "volume", "closeTime", "quoteAssetVolume", "numberOfTrades", "takerBaseAssetVolume", "takerQuoteAssetVolume", "ignore"])
                let row2 = try? parser2.nextAsDict()
                
                it("should not be nil") {
                    expect(row2).toNot(beNil())
                }
                
                it("should have correct keys") {
                    let keys: [String] = row2?.keys != nil ? Array(row2!.keys) : []
                    expect(
                        keys.containsSameElements(as: ["openTime", "open", "high", "low", "close", "volume", "closeTime", "quoteAssetVolume", "numberOfTrades", "takerBaseAssetVolume", "takerQuoteAssetVolume", "ignore"])
                    ) == true
                }
                
                it("should have correct values") {
                    expect(row2?["openTime"]) == "1635724800000"
                    expect(row2?["open"]) == "53228.92000000"
                    expect(row2?["high"]) == "53265.47000000"
                    expect(row2?["low"]) == "53218.59000000"
                    expect(row2?["close"]) == "53233.40000000"
                    expect(row2?["volume"]) == "1.00359000"
                    expect(row2?["closeTime"]) == "1635724859999"
                    expect(row2?["quoteAssetVolume"]) == "53430.40481810"
                    expect(row2?["numberOfTrades"]) == "64"
                    expect(row2?["takerBaseAssetVolume"]) == "0.97545000"
                    expect(row2?["takerQuoteAssetVolume"]) == "51931.96981100"
                    expect(row2?["ignore"]) == "0"
                }
                
                let parser3 = CSVParser(data: "ben,koska\nbill".data(using: .utf8)!, header: ["firstName", "lastName"])
                let row3 = try? parser3.nextAsDict()
                let row4 = try? parser3.nextAsDict()
                
                it("should not be nil") {
                    expect(row3).toNot(beNil())
                }
                
                it("should be nil") {
                    expect(row4).to(beNil())
                }
            }
            
            context("decodable based response") {
                let parser = CSVParser(data: data, header: ["openTime", "open", "high", "low", "close", "volume", "closeTime", "quoteAssetVolume", "numberOfTrades", "takerBaseAssetVolume", "takerQuoteAssetVolume", "ignore"])
                let row = try? parser.next(as: BinanceDataEntry.self)
                
                it("should not be nil") {
                    expect(row).toNot(beNil())
                }
                
                it("should have correct values") {
                    expect(row?.openTime) == 1635724800000
                    expect(row?.open) == 53228.92
                    expect(row?.high) == 53265.47
                    expect(row?.low) == 53218.59
                    expect(row?.close) == 53233.40
                    expect(row?.volume) == 1.00359
                    expect(row?.closeTime) == 1635724859999
                    expect(row?.quoteAssetVolume) == 53430.4048181
                    expect(row?.numberOfTrades) == 64
                    expect(row?.takerBaseAssetVolume) == 0.97545
                    expect(row?.takerQuoteAssetVolume) == 51931.969811
                    expect(row?.ignore) == false
                }
                
                let parser2 = CSVParser(string: "firstName,lastName", hasHeader: true)
                let row2 = try? parser2.next(as: BinanceDataEntry.self)
                
                it("should be nil") {
                    expect(row2).to(beNil())
                }
                
                it("should have parsed header") {
                    expect(parser2.header) == ["firstName", "lastName"]
                }
            }
            
            context("parse header") {
                let dataWithHeader = "openTime,open,high,low,close,volume,closeTime,quoteAssetVolume,numberOfTrades,takerBaseAssetVolume,takerQuoteAssetVolume,ignore\n1635724800000,53228.92000000,53265.47000000,53218.59000000,53233.40000000,1.00359000,1635724859999,53430.40481810,64,0.97545000,51931.96981100,0".data(using: .utf8)!
                
                let parser = CSVParser(data: dataWithHeader, hasHeader: true)
                let row = try? parser.next(as: BinanceDataEntry.self)
                
                it("should have header") {
                    expect(parser.header) == ["openTime","open","high","low","close","volume","closeTime","quoteAssetVolume","numberOfTrades","takerBaseAssetVolume","takerQuoteAssetVolume","ignore"]
                }
                
                it("should not be nil") {
                    expect(row).toNot(beNil())
                }
            }
            
            context("loadAll") {
                let parser1 = CSVParser(data: "1635724800000,53228.92000000,53265.47000000,53218.59000000,53233.40000000,1.00359000,1635724859999,53430.40481810,64,0.97545000,51931.96981100,0\n1635724800000,53228.92000000,53265.47000000,53218.59000000,53233.40000000,1.00359000,1635724859999,53430.40481810,64,0.97545000,51931.96981100,0".data(using: .utf8)!)
                
                let response1 = parser1.loadAll()
                
                let parser2 = CSVParser(data: "1,2,3\n4,5,6".data(using: .utf8)!)
                let response2 = parser2.loadAll(rowCount: 2)
                
                it("should not be nil") {
                    expect(response1).toNot(beNil())
                }
                
                it("should also not be nil") {
                    expect(response2).toNot(beNil())
                }
                
                it("should correct values") {
                    expect(response1) == [["1635724800000", "53228.92000000", "53265.47000000", "53218.59000000", "53233.40000000", "1.00359000", "1635724859999", "53430.40481810", "64", "0.97545000", "51931.96981100", "0"], ["1635724800000", "53228.92000000", "53265.47000000", "53218.59000000", "53233.40000000", "1.00359000", "1635724859999", "53430.40481810", "64", "0.97545000", "51931.96981100", "0"]]
                }
                
                it("should also correct values") {
                    expect(response2) == [["1", "2", "3"], ["4", "5", "6"]]
                }
            }
        }
    }
}
