//
//  BufferedByteReader.swift
//  
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

internal class BufferedByteReader {
    
    private var bufferIndex = 0
    private var bufferLength = 0
    private var buffer: UnsafeMutablePointer<UInt8>? // [UInt8] = []
    
    private let inputStream: InputStream
    
    
    init(inputStream: InputStream) {
        if inputStream.streamStatus == .notOpen {
            inputStream.open()
        }
        
        self.inputStream = inputStream
    }
    
    func pop() -> UInt8? {
        guard let byte = self.peek() else {
            return nil
        }
        
        bufferIndex += 1
        return byte
    }
    
    func peek(at index: Int = 0) -> UInt8? {
        let peekIndex = bufferIndex + index
        guard peekIndex < bufferLength, let buffer = buffer else {
            guard read(16384) > 0 else {
                return nil
            }
            
            return self.peek(at: index)
        }
        
        return buffer[peekIndex]
    }
    
    private func read(_ amount: Int) -> Int {
        let temp = UnsafeMutablePointer<UInt8>.allocate(capacity: amount)
        let length = inputStream.read(temp, maxLength: amount)
        
        bufferIndex = 0
        bufferLength = length
        
        if length > 0 {
            buffer = temp
        }
        
        return length
    }
}
