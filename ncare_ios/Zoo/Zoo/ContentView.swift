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
    
    @State private var description: String = ""
    
    @ObservedObject var report = Report()
    
    @State private var showImagePicker: Bool = false
    @State private var image: UIImage = nil
    @State var showCamera: Bool = false
    @State private var showImageEditor: Bool = false
    
    @State private var location_report : String = ""
    
    private var imagetap = false
    
    
    var body: some View {
        NavigationView{
        VStack{
            
            Form
                {
                    // PICKER IN FORM TO SELECT TYPE OF REPORT FROM ARRAY OF TYPE REPORT
                    Picker(selection: $report.type, label: Text("Select type of report") )
                    {
                        ForEach(0 ..< Report.types.count)
                        {
                            Text(Report.types[$0]).tag($0)
                        }
                    }
                    
                    // OPEN NEW VIEW TO WRITE FULL DESCRIPTION OF REPORT AND SAVE IN TO $DESCRIPTION VAR
                    NavigationLink(destination:  DescriptionView(description: $description).edgesIgnoringSafeArea(.horizontal)) {
                        HStack
                            {
                        Text("Incident description")
                                Divider()
                                Spacer()
                                Text(description).opacity(0.5).lineLimit(1)
                        }
                        
                                   
                    }
                    
                    // IMAGE SCROLL VIEW WHERE YOU CAN SAVE YOUR IMAGE
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack
                            {
                                Image(uiImage: image ?? UIImage(systemName: "plus.circle.fill")!)
                        .resizable()
                        .cornerRadius(12)
                        .aspectRatio(contentMode: .fill)
                        .scaledToFit()
                                
                            .frame(minWidth: 0, idealWidth: 200, maxWidth: 300, minHeight: 0, idealHeight: 200, maxHeight: 400, alignment: .leading)
                            .onLongPressGesture {
                                self.showImagePicker = true
                            }.cornerRadius(15)
                        }
                    }
                    
                    // THING TO CHOOSE YOUR LOCATION FROM MAP
                    HStack{
                        Text("Coordinates")
                        Spacer()
                        NavigationLink(destination:  MapSearchView(location_report: $location_report), tag: 1, selection: $action) {
                            Divider()
                            if(location_report == "")
                            {
                                Spacer()
                            }
                            Text(location_report == "" ? "Set location" : location_report).lineLimit(1).opacity(location_report == "" ? 1: 0.5)
                                       .onTapGesture {
                            //perform some tasks if needed before opening Destination view
                                           self.action = 1
                                   }
                        }
                    }
    
            }
            .navigationBarTitle("Report something")
            
            
            
            
        
        
        }.sheet(isPresented: self.$showImagePicker) { // INIT PHOTO PICKER ON LONG PRESS
            PhotoCaptureView(showImagePicker: self.$showImagePicker, image: self.$image, showImageEditor: self.$showImageEditor, showCamera: self.$showCamera)
        }
            
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
struct PhotoCaptureView: View {

@Binding var showImagePicker: Bool
@Binding var image: UIImage?
@Binding var showImageEditor: Bool
@Binding var showCamera: Bool

var body: some View {
    ImagePicker(pickerIsShown: $showImagePicker, image: $image, showImageEditor: $showImageEditor, showCamera: $showCamera)
}
}

struct ImagePicker: UIViewControllerRepresentable {

@Binding var pickerIsShown: Bool
@Binding var image: UIImage?
@Binding var showImageEditor: Bool
@Binding var showCamera: Bool

func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

}

func makeCoordinator() -> ImagePickerCoordinator {
    return ImagePickerCoordinator(isShown: $pickerIsShown, image: $image, showEditor: $showImageEditor)
}

func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

    let picker = UIImagePickerController()

    if showCamera {
        picker.sourceType = .camera
    } else {
        picker.sourceType = .photoLibrary
    }

    picker.delegate = context.coordinator

    return picker
}
}

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

@Binding var isShown: Bool
@Binding var image: UIImage?
@Binding var showEditor: Bool

init(isShown: Binding<Bool>, image: Binding<UIImage?>, showEditor: Binding<Bool>) {
    _isShown = isShown
    _image = image
    _showEditor = showEditor
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
    image = uiImage
    isShown = false
    showEditor = true
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    isShown = false
}
}
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
*/
