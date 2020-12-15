//
//  MainAppView.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/13.
//

import SwiftUI

struct MainAppView: View {
   
    @State var selectedTabbar = 0
    var body: some View {
        VStack {
            TabView(selection: $selectedTabbar) {
                DiscussView()
                    .tabItem {
                        Image(systemName: "1.circle")
                        Text("讨论区")
                    }.tag(0)
                TrainView()
                    .tabItem {
                        Image(systemName: "2.circle")
                        Text("训练区")
                    }.tag(1)
                MySettingView()
                    .tabItem {
                        Image(systemName: "7.circle")
                        Text("我的")
                    }.tag(2)
            }
            .accentColor(.orange)
        }
    }
}

struct MainAppView_Previews: PreviewProvider {
    static var previews: some View {
        MainAppView()
    }
}
