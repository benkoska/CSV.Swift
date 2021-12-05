//
//  CSVRowDecoderTests.swift
//  
//
//  Created by Ben Koska on 12/5/21.
//

import Quick
import Nimble

import Foundation
@testable import CSV

final class CSVRowDecoderTests: QuickSpec {
    
    override func spec() {
        let header = ["string", "smi", "mediu", "integer", "decimal"]
        let data   = ["string", "127", "32767", "1234567", "123.456"]
        
        describe("csv row decoder") {
            let decoder = CSVRowDecoder(header: header, data: data)
            let container = try? decoder.container(keyedBy: CodingKeys.self)
            
            it("should not be nil") {
                expect(container).toNot(beNil())
            }
            
            context("decode as string") {
                let validValue = try? container?.decode(String.self, forKey: .string)
                let invalidValue = try? container?.decode(String.self, forKey: .iDontExist)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == "string"
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as double") {
                let validValue = try? container?.decode(Double.self, forKey: .decimal)
                let invalidValue = try? container?.decode(Double.self, forKey: .string)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 123.456
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as float") {
                let validValue = try? container?.decode(Float.self, forKey: .decimal)
                let invalidValue = try? container?.decode(Float.self, forKey: .string)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 123.456
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as int8") {
                let validValue = try? container?.decode(Int8.self, forKey: .smallInteger)
                let invalidValue = try? container?.decode(Int8.self, forKey: .integer)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 127
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as int16") {
                let validValue = try? container?.decode(Int16.self, forKey: .mediumInteger)
                let invalidValue = try? container?.decode(Int16.self, forKey: .decimal)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 32767
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as int32") {
                let validValue = try? container?.decode(Int32.self, forKey: .integer)
                let invalidValue = try? container?.decode(Int32.self, forKey: .decimal)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 1234567
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as int64") {
                let validValue = try? container?.decode(Int64.self, forKey: .integer)
                let invalidValue = try? container?.decode(Int64.self, forKey: .decimal)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 1234567
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as int") {
                let validValue = try? container?.decode(Int.self, forKey: .integer)
                let invalidValue = try? container?.decode(Int.self, forKey: .decimal)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 1234567
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as uint8") {
                let validValue = try? container?.decode(UInt8.self, forKey: .smallInteger)
                let invalidValue = try? container?.decode(UInt8.self, forKey: .integer)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 127
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as uint16") {
                let validValue = try? container?.decode(UInt16.self, forKey: .mediumInteger)
                let invalidValue = try? container?.decode(UInt16.self, forKey: .decimal)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 32767
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as uint32") {
                let validValue = try? container?.decode(UInt32.self, forKey: .integer)
                let invalidValue = try? container?.decode(UInt32.self, forKey: .decimal)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 1234567
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as uint64") {
                let validValue = try? container?.decode(UInt64.self, forKey: .integer)
                let invalidValue = try? container?.decode(UInt64.self, forKey: .decimal)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 1234567
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as uint") {
                let validValue = try? container?.decode(UInt.self, forKey: .integer)
                let invalidValue = try? container?.decode(UInt.self, forKey: .decimal)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue) == 1234567
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("decode as custominteger") {
                let validValue = try? container?.decode(CustomInteger.self, forKey: .integer)
                let invalidValue = try? container?.decode(CustomInteger.self, forKey: .decimal)
                
                it("should not be nil") {
                    expect(validValue).toNot(beNil())
                    expect(validValue?.value) == 1234567
                }
                
                it("should be nil") {
                    expect(invalidValue).to(beNil())
                }
            }
            
            context("other tests") {
                it("should contain keys") {
                    expect(container?.contains(.string)).to(beTrue())
                    expect(container?.contains(.integer)).to(beTrue())
                    expect(container?.contains(.mediumInteger)).to(beTrue())
                    expect(container?.contains(.smallInteger)).to(beTrue())
                    expect(container?.contains(.decimal)).to(beTrue())
                }
                
                it("should not contain key") {
                    expect(container?.contains(.iDontExist)).to(beFalse())
                }
                
                it("should be nil") {
                    expect(try? container?.nestedUnkeyedContainer(forKey: .iDontExist)).to(beNil())
                    expect(try? container?.superDecoder()).to(beNil())
                    expect(try? container?.superDecoder(forKey: .iDontExist)).to(beNil())
                    expect(try? container?.nestedContainer(keyedBy: CodingKeys.self, forKey: .iDontExist)).to(beNil())
                }
            }
        }
    }
    
    fileprivate enum CodingKeys: String, CodingKey {
        case smallInteger = "smi"
        case mediumInteger = "mediu"
            
        case string, integer, decimal, iDontExist
    }
    
    fileprivate struct CustomInteger: Decodable {
        let value: Int
        
        init(from decoder: Decoder) throws {
            let singleValueContainer = try decoder.singleValueContainer()
            self.value = try singleValueContainer.decode(Int.self)
        }
    }
}
