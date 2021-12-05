////
////  PerformanceTests.swift
////
////
////  Created by Ben Koska on 12/4/21.
////
//
//import XCTest
//import CSV
//
//final class PerformanceTests: XCTestCase {
//
//    static let iterationCount = 1 // 10_000
//
//    func testPerformance() throws {
//        let standardSpeed = try runSpeedTest {
//            while $0.next() != nil {}
//        }
//
//        let dictSpeed = try runSpeedTest(withHeader: true) {
//            while try $0.nextAsDict() != nil {}
//        }
//
//        let decodableSpeed = try runSpeedTest(withHeader: true) {
//            while try $0.next(as: BinanceDataEntry.self) != nil { }
//        }
//
//        print("CSVParser.next(): total=\(standardSpeed / 1_000_000)s per_row=\(standardSpeed / 43200)μs")
//        print("CSVParser.nextAsDict(): total=\(dictSpeed / 1_000_000)s per_row=\(dictSpeed / 43200)μs")
//        print("CSVParser.next(as:): total=\(decodableSpeed / 1_000_000)s per_row=\(decodableSpeed / 43200)μs")
//    }
//
//    @available(macOS 12.0.0, *)
//    func testAsyncPerformance() async throws {
//        let asyncSpeed = try await runAsyncSpeedTest {
//            let asyncReader = AsyncCSVParser(parser: $0)
//
//            for await _ in asyncReader {}
//        }
//
//        print("AsyncCSVParser: total=\(asyncSpeed / 1_000_000)s per_row=\(asyncSpeed / 43200)μs")
//    }
//
//    // MARK: - Internal
//
//    @available(macOS 12.0.0, *)
//    private func runAsyncSpeedTest(_ function: (_ parser: CSVParser) async throws -> Void) async throws -> Double {
//        guard let url = Bundle.module.url(forResource: "BTCEUR-1m-2021-11", withExtension: "csv") else {
//            XCTFail("Can't load test data!")
//            fatalError()
//        }
//
//        let time = try await measureExecutionTimeAsync(iterationCount: Self.iterationCount, function: {
//            try await function(try CSVParser(url: url))
//        })
//
//        return Double(time) / 1_000
//    }
//
//    private func runSpeedTest(withHeader: Bool = false, _ function: (_ parser: CSVParser) throws -> Void) throws -> Double {
//        guard let url = Bundle.module.url(forResource: "BTCEUR-1m-2021-11", withExtension: "csv") else {
//            XCTFail("Can't load test data!")
//            fatalError()
//        }
//
//        let time: UInt64
//        if withHeader {
//            time = try measureExecutionTime(iterationCount: Self.iterationCount, function: {
//                try function(try CSVParser(url: url, header: ["openTime", "open", "high", "low", "close", "volume", "closeTime", "quoteAssetVolume", "numberOfTrades", "takerBaseAssetVolume", "takerQuoteAssetVolume", "ignore"]))
//            })
//        } else {
//            time = try measureExecutionTime(iterationCount: Self.iterationCount, function: {
//                try function(try CSVParser(url: url))
//            })
//        }
//
//        return Double(time) / 1_000
//    }
//
//    @available(macOS 12.0.0, *)
//    private func measureExecutionTimeAsync(iterationCount: Int = 100, function: () async throws -> Void) async throws -> UInt64 {
//        var durations: [UInt64] = []
//        durations.reserveCapacity(iterationCount)
//
//        for _ in 0..<iterationCount {
//            let startTime = DispatchTime.now()
//            try await function()
//            durations.append(DispatchTime.now().uptimeNanoseconds - startTime.uptimeNanoseconds)
//        }
//
//        return durations.reduce(UInt64(0), +) / UInt64(durations.count)
//    }
//
//    private func measureExecutionTime(iterationCount: Int = 100, function: () throws -> Void) throws -> UInt64 {
//        var durations: [UInt64] = []
//        durations.reserveCapacity(iterationCount)
//
//        for _ in 0..<iterationCount {
//            let startTime = DispatchTime.now()
//            try function()
//            let endTime = DispatchTime.now()
//            durations.append(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds)
//        }
//
//        return durations.reduce(UInt64(0), +) / UInt64(durations.count)
//    }
//}
