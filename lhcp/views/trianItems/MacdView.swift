//
//  MacdView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/17.
//

import SwiftUI

struct MacdView: View {
    var pts:KlinePoints
    var lastPts:KlinePoints
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: lastPts.difPt)
                path.addLine(to: pts.difPt)
            }.stroke(MyColor.kline_ave_5, style: StrokeStyle(lineWidth:KLineStyle.kLineBold))
            Path { path in
                path.move(to: lastPts.deaPt)
                path.addLine(to: pts.deaPt)
            }.stroke(MyColor.kline_ave_10, style: StrokeStyle(lineWidth:KLineStyle.kLineBold))
            if(pts.macdState == 1){
                Path { path in
                    path.move(to: pts.macdPt)
                    path.addLine(to: pts.macdBPt)
                }.stroke(MyColor.line_up, style: StrokeStyle(lineWidth:KLineStyle.kLineBold))
            }else{
                Path { path in
                    path.move(to: pts.macdPt)
                    path.addLine(to: pts.macdBPt)
                }.stroke(MyColor.line_down, style: StrokeStyle(lineWidth:KLineStyle.kLineBold))
            }
        }
    }
}

