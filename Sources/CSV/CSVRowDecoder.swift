//
//  CSVRowDecoder.swift
//
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

internal class CSVRowDecoder: Decoder {
    let codingPath: [CodingKey] = []
    let userInfo: [CodingUserInfoKey : Any] = [:]
    
    let header: [String]?
    let data: [String]
    
    init(header: [String]?, data: [String]) {
        self.header = header
        self.data = data
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        KeyedDecodingContainer<Key>(CSVRowKeyedDecoder(decoder: self))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("unkeyedContainer() has not yet been implemented")
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        throw CSVParserError.unsupportedAction(type: "CSVRowDecoder")
    }
}

internal class CSVSingleValueDecoder: Decoder {
    let codingPath: [CodingKey]
    let userInfo: [CodingUserInfoKey : Any] = [:]
    
    let data: String
    init(data: String, codingPath: [CodingKey]) {
        self.data = data
        self.codingPath = codingPath
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        throw CSVParserError.unsupportedAction(type: "CSVSingleValueDecoder")
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw CSVParserError.unsupportedAction(type: "CSVSingleValueDecoder")
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return CSVSingleValueDecodingContainer(data: data, codingPath: codingPath)
    }
}

internal class CSVRowKeyedDecoder<Key>: KeyedDecodingContainerProtocol where Key: CodingKey {
    
    let codingPath: [CodingKey] = []
    let allKeys: [Key]
    
    let decoder: CSVRowDecoder
    let mappedValues: [String: String]?
    
    init(decoder: CSVRowDecoder) {
        if let header = decoder.header {
            var allKeys: [Key] = []
            var mappedValues: [String: String] = [:]
            
            for i in 0..<header.count {
                let headerItem = header[i]
                guard let key = Key(stringValue: headerItem) else {
                    continue
                }
                
                mappedValues[headerItem] = decoder.data[i]
                allKeys.append(key)
            }
            
            self.allKeys = allKeys
            self.mappedValues = mappedValues
        } else {
            self.allKeys = (0..<decoder.data.count).compactMap { Key(intValue: $0) }
            self.mappedValues = nil
        }
        
        self.decoder = decoder
    }
    
    func contains(_ key: Key) -> Bool {
        if let intValue = key.intValue {
            return intValue >= 0 && decoder.data.count > intValue
        }
        
        return decoder.header?.contains(key.stringValue) == true
    }
    
    func singleKeyContainers(for key: Key) throws -> CSVSingleValueDecodingContainer {
        return CSVSingleValueDecodingContainer(data: try data(for: key), codingPath: [key])
    }
    
    func data(for key: Key) throws -> String {
        if let data = mappedValues?[key.stringValue] {
            return data
        }
        
        throw DecodingError.keyNotFound(key, .init(codingPath: [], debugDescription: "No value associated with key \(key)", underlyingError: nil))
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        try singleKeyContainers(for: key).decodeNil()
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        try singleKeyContainers(for: key).decode(type)
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw CSVParserError.unsupportedAction(type: "CSVRowKeyedDecoder")
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw CSVParserError.unsupportedAction(type: "CSVRowKeyedDecoder")
    }
    
    func superDecoder() throws -> Decoder {
        throw CSVParserError.unsupportedAction(type: "CSVRowKeyedDecoder")
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        throw CSVParserError.unsupportedAction(type: "CSVRowKeyedDecoder")
    }
}

internal class CSVSingleValueDecodingContainer: SingleValueDecodingContainer {
    
    let codingPath: [CodingKey]
    let data: String
    
    init(data: String, codingPath: [CodingKey]) {
        self.data = data
        self.codingPath = codingPath
    }
    
    func decodeNil() -> Bool {
        return data.isEmpty
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        switch data.uppercased() {
            case "TRUE", "YES", "1": return true
            case "FALSE", "NO", "0": return false
            default: throw DecodingError.typeMismatch(Bool.self, .init(codingPath: [], debugDescription: "Expected to decode Bool but found a string/data instead.", underlyingError: nil))
        }
    }
    
    func decode(_ type: String.Type) throws -> String {
        return data
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        if let value = Double(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(Double.self, .init(codingPath: [], debugDescription: "Expected to decode Double but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        if let value = Float(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(Float.self, .init(codingPath: [], debugDescription: "Expected to decode Float but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        if let value = Int(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(Int.self, .init(codingPath: [], debugDescription: "Expected to decode Int but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        if let value = Int8(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(Int8.self, .init(codingPath: [], debugDescription: "Expected to decode Int8 but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        if let value = Int16(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(Int16.self, .init(codingPath: [], debugDescription: "Expected to decode Int16 but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        if let value = Int32(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(Int32.self, .init(codingPath: [], debugDescription: "Expected to decode Int32 but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        if let value = Int64(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(Int64.self, .init(codingPath: [], debugDescription: "Expected to decode Int64 but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        if let value = UInt(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(UInt.self, .init(codingPath: [], debugDescription: "Expected to decode UInt but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        if let value = UInt8(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(UInt8.self, .init(codingPath: [], debugDescription: "Expected to decode UInt8 but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        if let value = UInt16(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(UInt16.self, .init(codingPath: [], debugDescription: "Expected to decode UInt16 but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        if let value = UInt32(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(UInt32.self, .init(codingPath: [], debugDescription: "Expected to decode UInt32 but found a string/data instead.", underlyingError: nil))
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        if let value = UInt64(data) {
            return value
        }
        
        throw DecodingError.typeMismatch(UInt64.self, .init(codingPath: [], debugDescription: "Expected to decode UInt64 but found a string/data instead.", underlyingError: nil))
    }
    
    // TODO: add support for decodeIfPresent
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        return try T(from: singleValueDecoder())
    }
    
    func singleValueDecoder() -> CSVSingleValueDecoder {
        CSVSingleValueDecoder(data: data, codingPath: codingPath)
    }
}
