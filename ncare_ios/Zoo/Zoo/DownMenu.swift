//
//  BottomMenu.swift
//  Zoo
//
//  Created by Никита Казанцев on 17.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI


struct DownMenu: View {
    @Binding var downMenuButton: Int // 1 -people, 2- messages, 3 - world,4 - profile
    var body: some View {
        
        VStack {
            
            Rectangle()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 1)
            .foregroundColor(Color("TextFixed")).opacity(0.3)
            
            HStack(alignment: .bottom, spacing: 80){
                
                DownButton(downMenuButton: $downMenuButton, image_name: "person.2", button_text: "Panic", change_binding_to: 1)
                
                DownButton(downMenuButton: $downMenuButton, image_name: "message", button_text: "Reports", change_binding_to: 2)
                
                DownButton(downMenuButton: $downMenuButton, image_name: "o.circle", button_text: "Profile", change_binding_to: 3)
                
                
                
            }
        }
        
        
        
        
    }
}

struct DownButton: View
{
    @Binding var downMenuButton: Int
    var image_name: String
    var button_text: String
    var change_binding_to: Int
    var body: some View
    {
        Button(action: {
            self.downMenuButton = self.change_binding_to
        }) {
            VStack{
                Image(systemName: image_name)
                    .foregroundColor(self.downMenuButton == change_binding_to ?
                    .green:Color.primary)
                    .animation(.spring())
                    .animation(.spring())
                Text(button_text).foregroundColor(self.downMenuButton == change_binding_to ?
                    .green:Color.primary)
                    .animation(.spring())
                    .font(.system(size: 12))
                    .lineLimit(1)
            }
        }
    }
}
