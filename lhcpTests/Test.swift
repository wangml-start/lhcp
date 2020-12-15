//
//  Test.swift
//  lhcpTests
//
//  Created by V-MAC10 on 2020/12/9.
//
@testable import lhcp
import XCTest
import CryptoSwift

class Test: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let str = "123456789"
        let en = AESUtil.encode(content: str)
        print("加密结果(base64)：\(en)")
        
        print("解密结果1：\(AESUtil.decode(content: en))")
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
