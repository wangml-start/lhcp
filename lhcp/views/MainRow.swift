//
//  MainRow.swift
//  lhcp
//
//  Created by V-MAC10 on 2020/12/14.
//

import SwiftUI

struct MainRow: View {
    var mainItem: MainItem
    
    var image : Image {
        ImageStore.shared.image(name: mainItem.imageName, extens: mainItem.nameExtension)
    }
    var body: some View {
        HStack {
            CircleImage(image: self.image)
            Text(mainItem.title)
            Spacer()
        }
    }
}

struct MainSection:Identifiable{
    var id: Int
    var header:String
    var items:[MainItem]
}

struct MainItem:Identifiable{
    var id: Int
    var title:String
    var imageName:String
    var nameExtension:String
}

struct MainRow_Previews: PreviewProvider {
    static var previews: some View {
        MainRow(mainItem: MainItem(id: 6, title: "模式设置", imageName: "main_1", nameExtension: "png"))
    }
}
