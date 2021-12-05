<p align="center">
	<a href="https://github.com/benkoska/CSV.Swift/actions">
		<img src="https://img.shields.io/github/workflow/status/benkoska/csv.swift/Main%20Workflow/master" alt="CI Status" />
	</a>
    <a href="https://codecov.io/gh/benkoska/CSV.Swift">
		<img src="https://img.shields.io/codecov/c/gh/benkoska/csv.swift?token=YKK7P9ARXM" alt="Code Coverage" />
    </a>
	<a href="https://github.com/alchemy-swift/alchemy/releases">
		<img src="https://img.shields.io/github/release/benkoska/csv.swift.svg" alt="Latest Release">
	</a>
	<a href="https://github.com/alchemy-swift/alchemy/blob/main/LICENSE">
		<img src="https://img.shields.io/github/license/benkoska/csv.swift.svg" alt="License">
	</a>
	<a href="https://swift.org">
		<img src="https://img.shields.io/badge/Swift-5.5-orange.svg" alt="Swift Version">
	</a>
</p>


# CSV
CSV.swift is a powerful swift library for parsing CSV files that supports reading as `[String]`, `[String: String]` and `Decodable`, without sacrificing performance.

CSV.swift also supports the new `async/await` functionality of swift 5.5.

# Why?
There are already a few CSV parsers for Swift, but I was not able to find one that had support for high-speed parsing, while still offering convenience features, such as parsing Decodables.


## ⚡ Speed Comparison
[Coming Soon]

# Installation
## Swift Package Manager
CSV.Swift is compatible with Swift Package Manager. Simply add it to your project's `Package.swift`.
```swift
dependencies: [
	.package(url: "https://github.com/benkoska/csv.swift.git", from: "0.1.0")
],
targets: [
	.target(
		name: "Project",
		dependencies: [
			.product(name: "CSV", package: "csv")
		]
	)
]
```

After the installation you can import `CSV` in your `.swift` files.

```swift
import CSV
```

# Usage
```swift
let string = "joe,doe,28"
let parser = try CSVParser(url: url, header: ["firstName", "lastName", "age"])
```

Get next as array
```swift
parser.next() // => Optional<["joe", "doe", "28"]>
```

Get next as dictionary
```swift
try parser.nextAsDict() // => Optional<["firstName": "joe", "lastName": "doe", "age": "28"]>
```

Decode next from `Decodable`
```swift
struct Person: Decodable {
	let firstName: String
	let lastName: String
	let age: Int
}

try parser.next(as: Person.self) // => Optional<Person(firstName: "joe", lastName: "doe", age: 28)>
```

## Create parser from `URL`
```swift
let parser = try CSVParser(url: url)
let parser = try CSVParser(url: url, delimiter: "|")
let parser = try CSVParser(url: url, delimiter: "|", hasHeader: true)
let parser = try CSVParser(url: url, delimiter: "|", header: ["firstName", "lastName", "age"])
```

## Create parser from `String`
```swift
let string = "joe,doe,28\njane,doe,21"
let string2 = "joe|doe|28\njane|doe|21"
let string3 = "firstName|lastName|age\njoe|doe|28\njane|doe|21"

let parser = try CSVParser(string: string)
let parser = try CSVParser(string: string2, delimiter: "|")
let parser = try CSVParser(string: string3, delimiter: "|", hasHeader: true)
let parser = try CSVParser(string: string2, delimiter: "|", header: ["firstName", "lastName", "age"])
```

## Create parser from `Data`
```swift
let parser = try CSVParser(data: data)
let parser = try CSVParser(data: data, delimiter: "|")
let parser = try CSVParser(data: data, delimiter: "|", hasHeader: true)
let parser = try CSVParser(data: data, delimiter: "|", header: ["firstName", "lastName", "age"])
```

# Disclaimer
Until `Swift.CSV` reaches version 1.0.0 the API is subject to breaking changes between minor version jumps.

The being said, I will try to minimize breaking changes to the public API.

# Author
Ben Koska, hello@benkoska.com

# License
Swift.CSV is available under the MIT license. See the LICENSE file for more info.