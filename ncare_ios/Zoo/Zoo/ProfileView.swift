//
//  ProfileView.swift
//  Zoo
//
//  Created by Никита Казанцев on 17.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    let defaults = UserDefaults.standard
    var maincolor: Color = Color(red: 136 / 255, green: 177 / 255, blue: 83 / 255)
    var body: some View {
        
        VStack(alignment: .center, spacing: 15)
        {
            Image("nature").resizable().overlay(Circle().stroke( maincolor, lineWidth: 4).opacity(0.7)).frame(width: 120, height: 120).cornerRadius(60).padding(.top, 30)
            Text(defaults.string(forKey: "nickname") ?? "").bold().foregroundColor(maincolor)
            Text(defaults.string(forKey: "email") ?? "")
            
            Text("Volunteering in NCare gives you an opportunity to change people's lives and future of nature. It gives you the satisfaction of playing a role in someone else's life, helping people who may not be able to help themselves. Volunteering is a way of giving back to your community while developing important social skills, and gaining valuable work experience all at the same time. We hope you will work best to save our planet").font(.system(size: 20)).padding(.leading, 20).padding(.trailing, 22).opacity(0.5).multilineTextAlignment(.center)
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
