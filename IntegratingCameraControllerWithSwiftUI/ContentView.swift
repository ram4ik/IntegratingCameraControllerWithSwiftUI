//
//  ContentView.swift
//  IntegratingCameraControllerWithSwiftUI
//
//  Created by ramil on 04.11.2019.
//  Copyright © 2019 com.ri. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var imageData: Data = .init(capacity: 0)
    @State var show = false
    @State var imagePicker = false
    @State var source: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                
                NavigationLink(destination: Imagepicker(show: $imagePicker, image: $imageData, source: source), isActive: $imagePicker) {
                    
                    Text("")
                }
                
                  VStack {
                      if imageData.count != 0 {
                          Image(uiImage: UIImage(data: self.imageData)!)
                              .resizable()
                              .frame(width: 250, height: 250)
                              .cornerRadius(15)
                      }
                      
                      Button(action: {
                          self.show.toggle()
                      }) {
                          Text("Pic")
                      }
            
                  }.navigationBarTitle("", displayMode: .inline)
                  .navigationBarHidden(true)
                  .actionSheet(isPresented: $show) {
                    
                    
                      ActionSheet(title: Text(""), message: Text(""), buttons: [.default(Text("Upload"), action: {
                          
                          self.source = .photoLibrary
                          self.imagePicker.toggle()
                          
                      }), .default(Text("Take a Picture"), action: {
                          
                          self.source = .camera
                          self.imagePicker.toggle()
                          
                      })])
                  }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Imagepicker: UIViewControllerRepresentable {
    
    func makeCoordinator() -> Imagepicker.Coordinator {
        return Imagepicker.Coordinator(parent1: self)
    }
    
    @Binding var show: Bool
    @Binding var image: Data
    var source: UIImagePickerController.SourceType
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Imagepicker>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<Imagepicker>) {
        
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: Imagepicker
        
        init(parent1: Imagepicker) {
            parent = parent1
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show.toggle()
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let image = info[.originalImage] as! UIImage
            let data = image.pngData()
            self.parent.image = data!
            self.parent.show.toggle()
        }
    }
}

// In simulator camera wont work if u test it with real device it will capture and display the image in the screen...
