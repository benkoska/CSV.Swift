//
//  BinanceDataEntry.swift
//  
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

struct BinanceDataEntry: Decodable {
    let openTime: Int
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Double
    let closeTime: Int
    let quoteAssetVolume: Double
    let numberOfTrades: Int
    let takerBaseAssetVolume: Double
    let takerQuoteAssetVolume: Double
    let ignore: Bool
}
