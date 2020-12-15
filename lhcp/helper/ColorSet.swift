//
//  ColorSet.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/9.
//

import SwiftUI
import CoreGraphics
import UIKit


//UIColor扩展
extension UIColor {
     
    //使用rgb方式生成自定义颜色
    static func fromRGB(rgb: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension Color {

    //使用rgb方式生成自定义颜色
    static func fromRGB(rgb: UInt) -> Color {
        return Color(.sRGB,
                     red: Double((rgb & 0xFF0000) >> 16) / 255.0,
                     green: Double((rgb & 0x00FF00) >> 8) / 255.0,
                     blue: Double(rgb & 0x0000FF) / 255.0)
       
    }
}


struct MyUIColor{
    //mornal
    public static var toorBarColor = UIColor.fromRGB(rgb: 0x000011)
    
    //chart
    public static var ma5Color = UIColor.fromRGB(rgb: 0xe8de85)
    public static var ma10Color = UIColor.fromRGB(rgb: 0x6fa8bb)
    public static var ma20Color = UIColor.fromRGB(rgb: 0xdf8fc6)
    public static var borderColor = UIColor.fromRGB(rgb: 0xe4e4e4)
    public static var crossLineColor = UIColor.fromRGB(rgb: 0x546679)
    public static var textColor = UIColor.fromRGB(rgb: 0x8695a6)
    public static var riseColor = UIColor.fromRGB(rgb: 0xf24957)
    public static var fallColor = UIColor.fromRGB(rgb: 0x1dbf60)
    public static var priceLineCorlor = UIColor.fromRGB(rgb: 0x0095ff)
    public static var avgLineCorlor = UIColor.fromRGB(rgb: 0xffc004)
    public static var fillColor = UIColor.fromRGB(rgb: 0xe3efff)
}


struct MyColor{
    //mornal
    public static var normal = Color.fromRGB(rgb: 0xffff01)
    public static var div_white = Color.fromRGB(rgb: 0xFBFBFB)
    
    public static var line_down = Color.fromRGB(rgb: 0x05870A)
    public static var line_up = Color.fromRGB(rgb: 0xB81206)

}


struct FontSet{
    public static var fangsc = "PingFangSC-Regular"
    public static var font10 = Font.custom(fangsc, size: 10)
    public static var font12 = Font.custom(fangsc, size: 12)
    public static var font14 = Font.custom(fangsc, size: 14)
    public static var font16 = Font.custom(fangsc, size: 16)
    public static var font20 = Font.custom(fangsc, size: 20)
}
