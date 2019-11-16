//
//  Root.swift
//  Zoo
//
//  Created by Никита Казанцев on 16.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI

struct Root: View {
    @EnvironmentObject var socketData: Socket
    var body: some View {
        Login_page()
        
    }
}

struct Root_Previews: PreviewProvider {
    static var previews: some View {
        Root()
    }
}
