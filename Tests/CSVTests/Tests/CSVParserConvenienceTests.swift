//
//  CSVParserConvenienceTests.swift
//  
//
//  Created by Ben Koska on 12/5/21.
//

import Quick
import Nimble

import Foundation
@testable import CSV

final class CSVParserConvenienceTests: QuickSpec {
    override func spec() {
        let str = "1635724800000,53228.92000000,53265.47000000,53218.59000000,53233.40000000,1.00359000,1635724859999,53430.40481810,64,0.97545000,51931.96981100,0\r\n"
        let data = str.data(using: .utf8)!
        
        describe("data convenience init") {
            context("valid params") {
                let parser1 = CSVParser(data: data)
                let parser2 = try? CSVParser(data: data, delimiter: "|")
                
                it("should also not be nil") {
                    expect(parser2).toNot(beNil())
                }
                
                it("should have next") {
                    expect(parser1.next()).toNot(beNil())
                }
                
                it("should also have next") {
                    expect(parser2?.next()).toNot(beNil())
                }
            }
            
            context("invalid parameter") {
                let parser1 = try? CSVParser(data: data, delimiter: "🐶")
                
                it("should be nil") {
                    expect(parser1).to(beNil())
                }
            }
        }
        
        describe("string convenience init") {
            context("valid params") {
                let parser1 = CSVParser(string: str)
                let parser2 = try? CSVParser(string: str, delimiter: "|")
                
                let row1 = parser1.next()
                let row2 = parser2?.next()
                
                it("should not be nil") {
                    expect(parser2).toNot(beNil())
                }
                
                it("should have next") {
                    expect(row1).toNot(beNil())
                }
                
                it("should also have next") {
                    expect(row2).toNot(beNil())
                }
                
                it("should have correct values") {
                    expect(row1) == ["1635724800000", "53228.92000000", "53265.47000000", "53218.59000000", "53233.40000000", "1.00359000", "1635724859999", "53430.40481810", "64", "0.97545000", "51931.96981100", "0"]
                }
                
                it("should also have correct values") {
                    expect(row2) == ["1635724800000,53228.92000000,53265.47000000,53218.59000000,53233.40000000,1.00359000,1635724859999,53430.40481810,64,0.97545000,51931.96981100,0"]
                }
            }
            
            context("invalid parameter") {
                let parser1 = try? CSVParser(string: str, delimiter: "🐶")
                
                it("should be nil") {
                    expect(parser1).to(beNil())
                }
            }
        }
        
        describe("url based init") {
            let url = Bundle.module.url(forResource: "BTCEUR-1m-2021-11", withExtension: "csv")!
            
            context("valid params") {
                let parser1 = try? CSVParser(url: url)
                let parser2 = try? CSVParser(url: url, delimiter: "|")
                
                it("should not be nil") {
                    expect(parser1).toNot(beNil())
                }
                
                it("should also not be nil") {
                    expect(parser2).toNot(beNil())
                }
                
                it("should have next") {
                    expect(parser1?.next()).toNot(beNil())
                }
                
                it("should also have next") {
                    expect(parser2?.next()).toNot(beNil())
                }
            }
            
            context("invalid parameter") {
                let parser1 = try? CSVParser(url: url, delimiter: "🐶")
                let parser2 = try? CSVParser(url: URL(string: "https://people.sc.fsu.edu/~jburkardt/data/csv/addresses.csv")!)
                
                it("should be nil") {
                    expect(parser1).to(beNil())
                }
                
                it("should also be nil") {
                    expect(parser2).to(beNil())
                }
            }
        }
    }
}
