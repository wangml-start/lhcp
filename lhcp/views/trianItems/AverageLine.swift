//
//  AverageLine.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/17.
//

import SwiftUI

struct AverageLine: View{
    var pts:KlinePoints
    var lastPts:KlinePoints
    var body: some View {
        GeometryReader { geometry in
            //均线
            if (lastPts.line5Pt != nil) {
                Path { path in
                    path.move(to: lastPts.line5Pt!)
                    path.addLine(to: pts.line5Pt!)
                }.stroke(MyColor.kline_ave_5, style: StrokeStyle(lineWidth: KLineStyle.kLineBold))

            }
            if (lastPts.line10Pt != nil) {
                Path { path in
                    path.move(to: lastPts.line10Pt!)
                    path.addLine(to: pts.line10Pt!)
                }.stroke(MyColor.kline_ave_10, style: StrokeStyle(lineWidth: KLineStyle.kLineBold))

            }
            if (lastPts.line20Pt != nil) {
                Path { path in
                    path.move(to: lastPts.line20Pt!)
                    path.addLine(to: pts.line20Pt!)
                }.stroke(MyColor.kline_ave_20, style: StrokeStyle(lineWidth: KLineStyle.kLineBold))

            }
            
        }
    }
}
