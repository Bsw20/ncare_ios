//
//  test.swift
//  Zoo
//
//  Created by Никита Казанцев on 16.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI

struct test: View {
    @State private var image: Image = Image(systemName: "person")
    var body: some View {
        Text("Hellow Word")
    }
}

struct test_Previews: PreviewProvider {
    static var previews: some View {
        test()
    }
}
