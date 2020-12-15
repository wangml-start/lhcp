//
//  DiscussView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/13.
//

import SwiftUI

struct DiscussView: View {
    var body: some View {
        VStack {
            HStack {
                Text("头像").padding(.leading)
                Spacer()
                Text("发帖").padding(.trailing)
            }.frame(height: 15)
            Divider()
            HStack {
                Spacer()
                Text("最新").tag(0)
                Spacer()
                Text("热门").tag(1)
                Spacer()
            }.frame(height: 10)
            Divider()
                
            
            Spacer()
        }
    }
}

struct DiscussView_Previews: PreviewProvider {
    static var previews: some View {
        DiscussView()
    }
}
