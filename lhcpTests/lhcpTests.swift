//
//  lhcpTests.swift
//  lhcpTests
//
//  Created by V-MAC10 on 2020/12/6.
//

import XCTest
@testable import lhcp

class lhcpTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
//        let key = "ASDFGHJK*&^%$#@!"
//        let iv = "AES/ECB/PKCS5Padding"
//        let strToEncode = "123456789"
//        // 从String 转成data
//               let data = strToEncode.data(using: String.Encoding.utf8)
//
//               // byte 数组
//               var encrypted: [UInt8] = []
//               do {
//                   encrypted = try AES(key: key, iv: iv, blockMode: .CBC, padding: PKCS7()).encrypt(data!.bytes)
//               } catch AES.Error.dataPaddingRequired {
//                   // block size exceeded
//               } catch {
//                   // some error
//               }
//
//               let encoded = NSData.init(bytes: encrypted, length: encrypted.count)
//               //加密结果要用Base64转码
//               var ee = encoded.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters)
//        print("解密结果2：\(ee)")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
