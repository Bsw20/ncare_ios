//
//  ContentView.swift
//  Zoo
//
//  Created by Никита Казанцев on 09.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI
import Combine
import MapKit
struct ContentView: View {
    @State private var action: Int? = 0
    
    @State private var title: String = ""
    @State private var description: String = ""
    
    @ObservedObject var report = Report()
    @EnvironmentObject var socketData: Socket
    
    @State private var report_choosen: Int = 0
    
    @State private var showImagePicker: Bool = false
    
    @State var showingMap = false
    
    @State var showingNotification = false
    
    @State private var image1: UIImage = nil
    @State private var image2: UIImage = nil
    @State private var image3: UIImage = nil
    @State private var image4: UIImage = nil
    @State private var image5: UIImage = nil
    var maincolor: Color = Color(red: 136 / 255, green: 177 / 255, blue: 83 / 255)
    
    @State var showCamera: Bool = false
    @State private var showImageEditor: Bool = false
    
    @State private var location_report : String = ""
    
    private var imagetap = false
    
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Text("Briefly explain what happened \nnear with you").padding(.leading, 22).opacity(0.7).padding(.top,5).padding(.bottom, 15)
                
                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack
                                        {
                                            
                                            
                                            HStack(spacing: 16){
                                                
                                                LibraryImage(uiImage: self.$image1).frame(width: 105, height: 105).overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.primary . opacity(0.1), lineWidth: 1.5)
                                                        
                                                ).padding(.leading, 16)
                                                LibraryImage(uiImage: self.$image2).frame(width: 105, height: 105).overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.primary . opacity(0.1), lineWidth: 1.5)
                                                    
                                            )
                                            LibraryImage(uiImage: self.$image3).frame(width: 105, height: 105).overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.primary . opacity(0.1), lineWidth: 1.5)
                                                    
                                            )
                                                LibraryImage(uiImage: self.$image4).frame(width: 105, height: 105).overlay(
                                                    RoundedRectangle(cornerRadius: 5)
                                                        .stroke(Color.primary . opacity(0.1), lineWidth: 1.5)
                                                        
                                                )
                                                
                                            LibraryImage(uiImage: self.$image5).frame(width: 105, height: 105).overlay(
                                                RoundedRectangle(cornerRadius: 5)
                                                    .stroke(Color.primary . opacity(0.1), lineWidth: 1.5)
                                                    
                                            )
                                           
                                                
                                            }.padding(.leading, 6).padding(.trailing,15)
                                            
                                            
                                            
                                            
                    
                                            
                                            Spacer()
                
                                    }
                }.edgesIgnoringSafeArea(.horizontal).padding(.bottom, 10)
                
                InputFieldView(input: $title ,textfield_label: "Enter incedent's title", image_name: "text.cursor", label: "Title").padding(.leading, 6).padding(.trailing, 6).padding(.bottom,10)
                
                
                
                
                HStack {
                    
                    NavigationLink(destination:  DescriptionView(description: $description)) {
                        VStack(alignment: .leading) {
                            HStack
                                {
                                    Image(systemName: "text.justifyleft")
                                    .resizable()
                                    .frame(width: 14, height: 16)
                                    .foregroundColor(maincolor)
                                    Text("Incident description").padding(.leading, 8).foregroundColor(Color.primary)

                                    Spacer()
                            }
                            Text(self.description == "" ? "Enter incident's description": self.description).foregroundColor(Color.primary).opacity(self.description == "" ? 0.2 : 0.7).lineLimit(1).padding(.leading, 32)
                        }.padding(.leading, 16).padding(.trailing, 16)
                        
                                   
                    }.frame(height: 60).overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.primary . opacity(0.1), lineWidth: 1)
                            
                    )
                }.padding(.leading, 22).padding(.trailing, 22).padding(.bottom, 7)
               
                
                HStack{
                    HStack{
                        
                        NavigationLink(destination: ReportPickerView(choose: $report_choosen)) {
                            Image(systemName: "text.justify").foregroundColor(maincolor).padding(.leading, 8)
                            
                            Text(String(Report.types[ report_choosen])).foregroundColor(Color.primary).lineLimit(1)
                            Spacer()
                            Image(systemName: "chevron.down").foregroundColor(maincolor).padding(.trailing, 8)
                        }
                        
                        
                        
                    }.frame(width: 170, height: 60).overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.primary . opacity(0.1), lineWidth: 1)
                            
                    )
                    Button(action: {
                        self.showingMap.toggle()
                    }) {
                        HStack{

                                    Image(systemName: "location").foregroundColor(maincolor).padding(.leading, 8)
                                    
                                    Text(location_report == "" ? "Set location" : location_report).lineLimit(1).foregroundColor(Color.primary).opacity(location_report == "" ? 1: 0.5)
                                    
                                    Spacer()
                                    Image(systemName: "chevron.down").foregroundColor(maincolor).padding(.trailing, 8)
                                
                                
                            Spacer()
                            
                            
                        }.frame(width: 170, height: 60).overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.primary . opacity(0.1), lineWidth: 1)
                                
                        )
                    }
                    
                }.padding(.leading, 22).padding(.trailing, 22)
                
                Button(action: { // BUTTON TO CHANGE FORMS OF AUTHORISATIONS
                            print(" REPORT")
                            let defaults = UserDefaults.standard
                            if defaults.object(forKey: "longitude") != nil
                            {
                                print("SEnDING REPORT")
                                self.socketData.emit("reports:create", with:  [ "title" : self.title, "description" : self.description , "type": self.report.type, "coordinates": [defaults.double(forKey: "longitude"),defaults.double(forKey: "latitude")] ] )
                            }
                        // emit
                    }) {
                        
                        // MAIN GREEN BUTTON TO INIT REGISTER/LOGIN REQUEST TO SERVER
                        Text("Notify eco-organisation")
                        .foregroundColor((.white))
                        .frame(minWidth: 0, idealWidth: .infinity, maxWidth: .infinity, minHeight: 0, idealHeight: 45, maxHeight: 45).padding(.leading, 16)
                        .padding(.trailing, 16)
                        .background(maincolor)
                        .cornerRadius(5)
                        .font(.system(size: 16))
                            
                    }.padding(.leading, 22).padding(.trailing, 22).padding(.top, 18)
                
                HStack {
                    Text("Keep in mind that for false testimony your \naccount will be blocked").multilineTextAlignment(.center)
                }.padding(.leading, 33).padding(.trailing, 33).padding(.top, 8).opacity(0.2)
                
                
                Spacer()
                
            
            .navigationBarTitle("Create a report")
            .navigationBarItems(leading:
                LogoView()
            )
            
            
            .alert(isPresented: self.$showingNotification) {
                Alert(title: Text("New report"), message: Text("ok"), dismissButton: .default(Text("Got it!")))
            }
                    .sheet(isPresented: $showingMap) {
                        MapSearchView(location_report: self.$location_report)
                    
                            
                }.onAppear(){
                    print("Appeared")
                    
                    
                    
                    
                    self.socketData.on("reports:create",callback: { (data, ack) in
                        
                        print("ON METHOD OF REPORT")
                        print(data)
                        print(ack)

                    })
                    
                    self.socketData.on("updates:reports:new",callback: { (data, ack) in
                        
                        print("ON METHOD OF REPORT")
                        let b = data as!  [Dictionary<String, AnyObject>]
                        let report_data = b[0]["report"] as!  Dictionary<String, Any>
                        print(data)
                        print(ack)
                        self.showingNotification = true
                    })
                }
        
        
        }
           .modifier(DismissingKeyboard()) 
        }
        
    }
    
    
}




struct DescriptionView: View {
    @Binding var description: String

@ObservedObject var report = Report()
var body: some View {
    
    TextView(
        text: $description).padding(.leading, 5).padding(.trailing,5).cornerRadius(15)
    .navigationBarTitle("Description")
    }
}


class Report: ObservableObject {
    var didChange = PassthroughSubject<Void, Never>()
    
    static let types = ["Animal murderer", "Setting fire", "Unauthorized fishing","Animal murderer", "Setting fire", "Unauthorized fishing","Animal murderer", "Setting fire", "Unauthorized fishing","Animal murderer", "Setting fire", "Unauthorized fishing","Animal murderer", "Setting fire", "Unauthorized fishing","Animal murderer", "Setting fire", "Unauthorized fishing","Animal murderer", "Setting fire", "Unauthorized fishing"]
    var type = 0 {didSet {update() } }
    
    func update()
    {
        didChange.send(())
    }
}

struct ReportPickerView : View {
    // 1.
    @Binding var choose: Int
    let arrtypes = Report.types
    
    var body: some View {
        // 2.
        VStack {
            
            Picker(selection: self.$choose, label:
            Text("")) {
                ForEach(0 ..< arrtypes.count) { index in
                    Text(self.arrtypes[index]).tag(index)
                }
            }
            .navigationBarTitle("Choose type of report")
            Spacer()
        }
        
    }
}


struct TextView: UIViewRepresentable {
    @Binding var text: String

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = UIFont(name: "system", size: 15)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = true
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)

        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {

    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @Binding var isShown: Bool
        @Binding var uiImage: UIImage?

        init(isShown: Binding<Bool>, uiImage: Binding<UIImage?>) {
            _isShown = isShown
            _uiImage = uiImage
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            uiImage = imagePicked
            isShown = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown = false
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: $isShown, uiImage: $uiImage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

}

struct LibraryImage: View {

    @State var showAction: Bool = false
    @State var showImagePicker: Bool = false

    @Binding var uiImage: UIImage?
    var maincolor: Color = Color(red: 136 / 255, green: 177 / 255, blue: 83 / 255)
    var sheet: ActionSheet {
        ActionSheet(
            title: Text("Action"),
            message: Text("Quotemark"),
            buttons: [
                .default(Text("Change"), action: {
                    self.showAction = false
                    self.showImagePicker = true
                }),
                .cancel(Text("Close"), action: {
                    self.showAction = false
                }),
                .destructive(Text("Remove"), action: {
                    self.showAction = false
                    self.uiImage = nil
                })
            ])

    }

    

    var body: some View {
        VStack {

            
            if (uiImage == nil) {
                Image(systemName: "camera.on.rectangle")
                    .opacity(0.5)
                    .foregroundColor(maincolor)
                    .background(
                        Color.clear
                            .frame(width: 105, height: 105)
                            .cornerRadius(6))
                    .onTapGesture {
                        self.showImagePicker = true
                    }
                Text("Add image").fixedSize().opacity(0.7)
            } else {
                Image(uiImage: uiImage!)
                    .resizable()
                .scaledToFill()
                    .frame(width: 105, height: 105)
                    .cornerRadius(6)
                    .onTapGesture {
                        self.showAction = true
                    }
            }
            

        }

        .sheet(isPresented: $showImagePicker, onDismiss: {
            self.showImagePicker = false
        }, content: {
            ImagePicker(isShown: self.$showImagePicker, uiImage: self.$uiImage)
        })

        .actionSheet(isPresented: $showAction) {
            sheet
        }
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
