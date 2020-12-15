//
//  CommonUtil.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/6.
//

import Foundation

struct CommonUtil{
    
    static func validEmail(email : String) -> Bool{
        let emailRegex = "^[0-9a-z]+\\w*@([0-9a-z]+\\.)+[0-9a-z]+$"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    static func formatPercent(num : CFloat) -> String{
        let number = NSNumber(value: num)
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "##.##%" //设置格式
        return numberFormatter.string(from: number)!
    }
    
    static func formatNumber(num : CFloat) -> String{
        let number = NSNumber(value: num)
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "##,###.00" //设置格式
        return numberFormatter.string(from: number)!
    }
}
