//
//  DocumentView.swift
//  Zoo
//
//  Created by Никита Казанцев on 16.11.2019.
//  Copyright © 2019 sudox.kazantsev.com. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit



struct MapSearchView: UIViewControllerRepresentable {
    
    @Binding var location_report: String
    
 class Coordinator: NSObject, MapViewDelegate {
  func saveLocation(placemark: MKPlacemark) {
    
   print("add placemark" )
  }
    }
func makeCoordinator() -> Coordinator {
    
  return Coordinator()
    }
func makeUIViewController(context: UIViewControllerRepresentableContext<MapSearchView>) -> MapViewController {
    let mapController = MapViewController()
        print(2)
        return mapController
    }
    
func updateUIViewController(_ uiViewController: MapViewController,
                                context: UIViewControllerRepresentableContext<MapSearchView>) {
  
  uiViewController.delegate = context.coordinator
    
    
    do{
        location_report =  UserDefaults.standard.string(forKey: "location_report") ?? "no location"
        print("GETTING LOCATION")
        print(location_report)
    }
    catch{
    print("ERROR")
    }
    
    }

    /*
struct DocumentView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
 */
}
