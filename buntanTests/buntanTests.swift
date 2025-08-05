//
//  buntanTests.swift
//  buntanTests
//
//  Created by 二木裕也 on 2024/12/08.
//

import Testing
@testable import buntan

struct buntanTests {

    @Test func testBasicSuccess() async throws {
        // 確実に成功するテスト
        let result = 2 + 2
        #expect(result == 4, "2 + 2 should equal 4")
    }
    
    @Test func testStringComparison() async throws {
        // 文字列比較のテスト
        let hello = "Hello, World!"
        #expect(hello.contains("Hello"), "String should contain 'Hello'")
        #expect(hello.count == 13, "String should have 13 characters")
    }
    
    @Test func testArrayOperations() async throws {
        // 配列操作のテスト
        let numbers = [1, 2, 3, 4, 5]
        #expect(numbers.count == 5, "Array should have 5 elements")
        #expect(numbers.first == 1, "First element should be 1")
        #expect(numbers.last == 5, "Last element should be 5")
    }
    
    @Test func testBooleanLogic() async throws {
        // 論理演算のテスト
        let isTrue = true
        let isFalse = false
        
        #expect(isTrue == true, "isTrue should be true")
        #expect(isFalse == false, "isFalse should be false")
        #expect(isTrue != isFalse, "isTrue should not equal isFalse")
    }
    
    @Test func testOptionalHandling() async throws {
        // Optional処理のテスト
        let optionalString: String? = "test"
        let nilString: String? = nil
        
        #expect(optionalString != nil, "optionalString should not be nil")
        #expect(nilString == nil, "nilString should be nil")
        #expect(optionalString?.count == 4, "optionalString should have 4 characters")
    }
    
    @Test func testIntExtensionBasic() async throws {
        // Int拡張の基本的なテスト
        let number = 42
        let stringResult = number.string
        #expect(stringResult == "42", "42 should convert to string '42'")
    }
    
    @Test func testStringExtensionBasic() async throws {
        // String拡張の基本的なテスト
        let testString = "test"
        let parenthesesResult = testString.parentheses()
        #expect(parenthesesResult == "(test)", "test should be wrapped as (test)")
    }
}
