//
//  SwiftUIView.swift
//  Zoo
//
//  Created by Никита Казанцев on 16.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI

struct SwiftUIView: View {
    @State private var ll : String = ""
    var body: some View {
        MapSearchView(location_report: $ll)
        
    }
}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
