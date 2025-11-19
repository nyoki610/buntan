//
//  buntanTests.swift
//  buntanTests
//
//  Created by 二木裕也 on 2024/12/08.
//

import Testing
@testable import buntan

struct buntanTests {

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }

    @Test func dummyTestAlwaysSuccess() {
        #expect(true)
    }

    @Test func dummyTestBasicArithmetic() {
        let result = 2 + 2
        #expect(result == 4)
    }

    @Test func dummyTestStringComparison() {
        let greeting = "Hello, World!"
        #expect(greeting.contains("World"))
    }

    @Test func dummyTestArrayOperations() {
        let numbers = [1, 2, 3, 4, 5]
        #expect(numbers.count == 5)
        #expect(numbers.first == 1)
        #expect(numbers.last == 5)
    }
}
