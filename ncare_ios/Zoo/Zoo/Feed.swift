//
//  Feed.swift
//  Zoo
//
//  Created by Никита Казанцев on 16.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI
import MapKit
import Foundation
struct Feed: View {
    var posts: [Post] = [Post( username: "User1", description: "Oh my good huys i feel really sick of this shit", images: [Image("nature")], geo: CLLocation(latitude: 1.111, longitude: 2.222)),
                         Post( username: "User2", description: "today i did somwething bad to our mother nature oh goodewr", images: [Image("nature"),Image("nature")], geo: CLLocation(latitude: 1.111, longitude: 2.222))]
    
    var body: some View {
        
        VStack {
            ForEach(posts){ post in
                PostView(post: post).padding(.top, 16)
                Divider()
            }
        }
    }
}

struct Post: Identifiable
{
    let id = UUID()
    let username: String
    let description: String
    let images: [Image]
    let geo: CLLocation
}

struct PostView: View
{
    let post: Post
    var body: some View
    {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "person.circle")
                    .scaleEffect(2)
                .padding(.leading, 22)
                Text(post.username)
                    .padding(.leading, 16)
                
                Spacer()
            }
            
            Text(post.description).padding(.leading, 16).padding(.trailing, 16).padding(.top, 8).opacity(0.5)
            
            HStack{
                if post.images.count == 1{
                    post.images[0]
                    .resizable()
                    .scaledToFit()
                        
                }
                if post.images.count == 2{
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            
                        post.images[0]
                            .resizable()
                            .scaledToFit()
                        post.images[1]
                        .resizable()
                        .scaledToFit()
                        
                        }
                    }
                }
                
                if post.images.count == 3{
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            
                        post.images[0]
                            .resizable()
                            .scaledToFit()
                        post.images[1]
                        .resizable()
                        .scaledToFit()
                        
                        post.images[2]
                            .resizable()
                            .scaledToFit()
                        }
                    }
                }
                
            }
            
            
            
            HStack{
                Image(systemName: "location")
                Text(String(post.geo.coordinate.latitude) + " : " + String(post.geo.coordinate.longitude) )
            }.padding(.leading, 16).padding(.trailing, 16).opacity(0.5)
        }
    }
}

struct Feed_Previews: PreviewProvider {
    static var previews: some View {
        Feed()
    }
}
