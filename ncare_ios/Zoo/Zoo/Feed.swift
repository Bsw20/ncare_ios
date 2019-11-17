
import SwiftUI
import MapKit
import Foundation
struct Feed: View {
    @State var posts: [Post] = []
    @State var posts_my: [Post] = []
    @State var posts2: [Dictionary<String, Any>]
    @State var hasCommunity: Bool = true
    @EnvironmentObject var socketData: Socket
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
        VStack {
            if (posts.count != 0)
            {
                Text("Your reports").bold()
            ForEach(posts){ post in
                PostView(post: post)
                }
                
                if(self.posts_my.count != 0)
                {
                    
                        Text("Organization reports")
                    ForEach(self.posts_my){ post in
                            PostView(post: post)

                    }
            }
            }
            else
            {
                Text("None of them found. Maybe you are not a member of any orgranization")
            }
            
        }.padding(.leading, 16)
        }.padding(.bottom, 130).edgesIgnoringSafeArea(.horizontal)
        .onAppear(){
            
            self.socketData.emit("reports:get", with: [])
                
               
            // if you are already loggined socket
            self.socketData.on("reports:get", callback: { (data, ack) in
                
                print("GOT ANSWER REPORTS GET")
                print("#####")
                print(data)
                let b = data as!  [Dictionary<String, AnyObject>]
                if b[0]["res"] as! Int == 0
                {
                let c = b[0]["reports"]  as! [Dictionary<String, AnyObject>]
                self.posts2 = c
                //print(self.posts2)
                
                for i in 0..<self.posts2.count {
                    let coordarr = self.posts2[i]["coordinates"] as! Array<Double>
                    print(coordarr)
                    
                    
                    if self.posts2[i]["uid"] as! String == UserDefaults.standard.string(forKey: "id")! {
                        self.hasCommunity = false
                        print(1)
                        self.posts.append(Post(title: self.posts2[i]["name"] as! String, description: self.posts2[i]["description"] as! String, type: String(Report.types[ self.posts2[i]["type"] as! Int]) , geo: CLLocation.init(latitude: coordarr[0], longitude: coordarr[1])))
                    }
                    else
                    {
                        print(2)
                        self.posts_my.append(Post(title: self.posts2[i]["name"] as! String, description: self.posts2[i]["description"] as! String, type: String(Report.types[ self.posts2[i]["type"] as! Int]) , geo: CLLocation.init(latitude: coordarr[0], longitude: coordarr[1])))
                    }
                }
                }
                 
                //print(data)
                //print(ack)
            })
            
            
        }
    }
}

struct Post: Identifiable
{
    let id = UUID()
    let title: String
    let description: String
    let type: String
    let geo: CLLocation
    
    
}

struct PostView: View
{
    var maincolor: Color = Color(red: 136 / 255, green: 177 / 255, blue: 83 / 255)
    let post: Post
    var body: some View
    {
        HStack{
            Image("nature" + String(Int.random(in: 1 ..< 9))).resizable().frame(width: 100, height: 100).scaledToFit().cornerRadius(5, antialiased: true, corners: [.topLeft, .bottomLeft])
            
            VStack(alignment: .leading) {
                Text(post.title).bold().foregroundColor(maincolor)
                Text(post.type)
                Text(post.description).lineLimit(2).font(.system(size: 15)).opacity(0.5)
                
                HStack {
                    
                    
                    Image(systemName: "location").foregroundColor(maincolor).padding(.leading, 4)
                    Text(post.geo.coordinate.longitude.description + " " + post.geo.coordinate.latitude.description).lineLimit(2).font(.system(size: 10)).opacity(0.2)
                    Spacer()
                }
            }
            Spacer()
            }.frame(width: 340, height: 100)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.primary . opacity(0.1), lineWidth: 1)
                
        )
    }
    
}
extension View {
    func cornerRadius(_ radius: CGFloat, antialiased: Bool = true, corners: UIRectCorner) -> some View {
        clipShape(
            RoundedCorner(radius: radius, style: antialiased ? .continuous : .circular, corners: corners)
        )
    }
}


struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var style: RoundedCornerStyle = .continuous
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
