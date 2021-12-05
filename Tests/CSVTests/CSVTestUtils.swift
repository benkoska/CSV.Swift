//
//  CSVTestUtils.swift
//  
//
//  Created by Ben Koska on 12/4/21.
//

import Foundation

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
