//
//  RowsMap.swift
//  Zoo
//
//  Created by Никита Казанцев on 16.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI

struct RowsMap : View {
    let subItem = Text("Lorem ipsum dolor sit amet")
    @State var showSubItem = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Item").font(.headline).padding(.leading)
            
            // Show sub item when the whole view being tapped
            if showSubItem {
                subItem.transition(.identity)
                subItem.transition(.opacity)
                subItem.transition(.opacity)
                subItem.transition(.opacity)
                subItem.transition(.opacity)
            }
            
        }
        .onTapGesture {
            
            withAnimation(.easeIn) {
                    self.showSubItem.toggle()
                }
            
        }
    }
}

#if DEBUG
struct RowsMap_Previews : PreviewProvider {
    static var previews: some View {
        RowsMap()
    }
}
#endif
