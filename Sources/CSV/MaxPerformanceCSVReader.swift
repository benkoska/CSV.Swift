//
//  MaxPerformanceCSVReader.swift
//  
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

// Work in progressq
internal class MaxPerformanceCSVReader {

    let delimiter: UInt8
    let columnCount: Int
    let reader: BufferedByteReader

    public init(inputStream: InputStream, columnCount: Int, delimiter: UInt8 = 0x2C) {
        self.delimiter = delimiter
        self.reader = BufferedByteReader(inputStream: inputStream)
        self.columnCount = columnCount
    }

    public func next() -> [String]? {
        var fieldBuffer: [UInt8] = []
        var rowBuffer: [String] = []

        rowBuffer.reserveCapacity(columnCount)

        while let char = reader.pop()  {
            if char == delimiter {
                if !fieldBuffer.isEmpty {
                    rowBuffer.append(String(bytes: fieldBuffer, encoding: .utf8)!)
                    fieldBuffer = []
                }
            } else if char == 0x0A || (char == 0x0D && reader.peek() == 0x0A) { // new line (\n or \r\n)
                if reader.peek() == 0x0A {
                    _ = reader.pop()
                }
                
                if !fieldBuffer.isEmpty {
                    rowBuffer.append(String(bytes: fieldBuffer, encoding: .utf8)!)
                }

                return !rowBuffer.isEmpty ? rowBuffer : nil
            } else {
                fieldBuffer.append(char)
            }
        }
        
        if !fieldBuffer.isEmpty {
            rowBuffer.append(String(bytes: fieldBuffer, encoding: .utf8)!)
        }

        return !rowBuffer.isEmpty ? rowBuffer : nil
    }
}
