//
//  CommonUtil.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/6.
//

import SwiftUI

struct CommonUtil{
    
    static func validEmail(email : String) -> Bool{
        let emailRegex = "^[0-9a-z]+\\w*@([0-9a-z]+\\.)+[0-9a-z]+$"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    static func formatPercent(num : CFloat) -> String{
        let number = NSNumber(value: num)
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "#0.0#%" //设置格式
        return numberFormatter.string(from: number)!
    }
    
    static func formatNumber(num : CFloat) -> String{
        let number = NSNumber(value: num)
        let numberFormatter = NumberFormatter()
        numberFormatter.positiveFormat = "##,##0.00" //设置格式
        return numberFormatter.string(from: number)!
    }
    static func floatNumEqual(_ num1:CFloat, _ num2:CFloat) -> Bool{
        let delta = num1 - num2
        if(abs(delta) < 0.00001){
            return true;
        }
        return false
    }
    
    static func getHalfSW(_ text:String) -> CGFloat {
        let font:UIFont = UIFont.init(name: "System", size: 12)!
        let nsText: NSString = NSString(string: text)
        let size:CGSize = CGSize(width: UIScreen.main.bounds.width, height: 0)
        let options:NSStringDrawingOptions =  NSStringDrawingOptions.usesFontLeading
        let boundRec = nsText.boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil)
       
        return boundRec.width/2
    }
    
}
