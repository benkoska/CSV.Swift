//
//  MaxPerformanceCSVReaderTests.swift
//  
//
//  Created by Ben Koska on 12/5/21.
//

import Quick
import Nimble

import Foundation
@testable import CSV

class MaxPerformanceCSVReaderTests: QuickSpec {
    override func spec() {
        let data: Data = "1635724800000,53228.92000000,53265.47000000,53218.59000000,53233.40000000,1.00359000,1635724859999,53430.40481810,64,0.97545000,51931.96981100,0\r\n1635724800000,53228.92000000,53265.47000000,53218.59000000,53233.40000000,2.00359000,1635724859999,53430.40481810,64,0.97545000,51931.96981100,1".data(using: .utf8)!
        
        describe("max performance reader") {
            let reader = MaxPerformanceCSVReader(inputStream: InputStream(data: data), columnCount: 12)
            
            let row = reader.next()
            let row2 = reader.next()
            
            it("should not have next") {
                expect(reader.next()).to(beNil())
            }
            
            it("should have correct values") {
                expect(row) ==  ["1635724800000", "53228.92000000", "53265.47000000", "53218.59000000", "53233.40000000", "1.00359000", "1635724859999", "53430.40481810", "64", "0.97545000", "51931.96981100", "0"]
                expect(row2) ==  ["1635724800000", "53228.92000000", "53265.47000000", "53218.59000000", "53233.40000000", "2.00359000", "1635724859999", "53430.40481810", "64", "0.97545000", "51931.96981100", "1"]
            }
        }
    }
}
