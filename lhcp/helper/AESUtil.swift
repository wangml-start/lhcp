//
//  AESUtil.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/9.
//

import CryptoSwift

extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { start in
            guard start < self.endIndex else { return nil }
            let end = self.index(start, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { start = end }
            return UInt8(self[start..<end], radix: 16)
        }
    }
}

struct AESUtil {
    
    static let aes_key =  "ASDFGHJK*&^%$#@!"
    
    //MARK: AES加密
    public static func encode(content:String)->String {
        var encryptedStr = ""
        do {
            //  AES encrypt
            let encrypted = try AES(key: aes_key.bytes, blockMode: ECB(), padding: .pkcs5).encrypt(content.bytes);
            //            let data = Data(base64Encoded: Data(encrypted), options: .ignoreUnknownCharacters)
            //加密结果从data转成string 转换失败  返回""
            encryptedStr = encrypted.toHexString().uppercased()
        } catch {
            print(error.localizedDescription)
        }
        return encryptedStr
        
        
    }
    
    //  MARK:  AES解密
    public static func decode(content:String)->String {
        var decrypted: [UInt8] = []
        do {
            // decode AES
            decrypted = try AES(key: aes_key.bytes, blockMode: ECB(), padding: .pkcs5).decrypt(content.hexaBytes);
        } catch {
            print(error.localizedDescription)
        }
        //解密结果从data转成string 转换失败  返回""
        return String(bytes: Data(decrypted).bytes, encoding: .utf8) ?? ""
    }
}
