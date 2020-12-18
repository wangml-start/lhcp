//
//  VolumeView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/17.
//

import SwiftUI

struct VolumeView: View {
    var pts:KlinePoints
    
    var bottomY:CGFloat {
        return pts.volBPt.y
    }
    var kWidth: CGFloat {
        return (pts.highPt.x - pts.openPt.x) * 2
    }
    var lWidth:CGFloat {
        return KLineStyle.kLineBold
    }

    var body: some View {
        GeometryReader { geometry in
            if(pts.state >= 0){
                Path { path in
                    path.move(to: pts.volumePt)
                    path.addLine(to: CGPoint(x: pts.volumePt.x, y: bottomY))
                    path.addLine(to: CGPoint(x: pts.volumePt.x+kWidth, y: bottomY))
                    path.addLine(to: CGPoint(x: pts.volumePt.x+kWidth, y: pts.volumePt.y))
                    path.addLine(to: pts.volumePt)
                }.stroke(MyColor.line_up, style: StrokeStyle(lineWidth: lWidth,lineCap: .round, lineJoin: .round))
            }else if (pts.state < 0){
                Path { path in
                    path.move(to: pts.volumePt)
                    path.addLine(to: CGPoint(x: pts.volumePt.x, y: bottomY))
                    path.addLine(to: CGPoint(x: pts.volumePt.x+kWidth, y: bottomY))
                    path.addLine(to: CGPoint(x: pts.volumePt.x+kWidth, y: pts.volumePt.y))
                }.fill(MyColor.line_down)

            }
        }
    }
}
