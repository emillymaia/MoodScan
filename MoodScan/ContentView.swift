//
//  ContentView.swift
//  MoodScan
//
//  Created by Emilly Maia on 15/05/23.
//

import SwiftUI
import Vision
import CoreML

struct ContentView: View {
    @State var showCamera: Bool = false
    @State var selectedImage: UIImage? = nil
    @State var classificationResult = ""
    
    var body: some View {
        

        ZStack {
            Rectangle()
                .fill(Color.init(red: 0.67, green: 0.55, blue: 0.73)).ignoresSafeArea()
            
            VStack {
                Text("WHAT IS YOUR EMOTION?")
                    .font(.system(size: 40).bold().lowercaseSmallCaps())
                    .frame( maxWidth: .infinity, alignment: .leading)
                    .padding(.init(top: 50, leading: 45, bottom: 30, trailing: 44))
                    .foregroundColor(.black)

                
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundColor(Color.init(red: 0.93, green: 0.86, blue: 0.83))
                        .edgesIgnoringSafeArea(.bottom)
                    
                    VStack {
                        Text("motions are complex states of mind and body that arise in response to various stimuli and experiences. They can range from joy and love to anger and sadness, and play a crucial role in human interactions and decision-making processes. ")
                            .foregroundColor(.black)

                        HStack {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 150, height: 200)
                                    .cornerRadius(30)
                                
                                Image(classificationResult)
                                    .resizable()
                                    .frame(width: 150, height: 200)
                                    .cornerRadius(30)
                                
                            } else {
                                
                                Group{}
                            }
                            
                        }
                        .padding(20)
                        
                        Text("your emotion is: \(classificationResult)")
                            .foregroundColor(.black)
                        
                        Button(action: {
                            showCamera = true
                        }) {
                            Text("Generate mood")
                        }
                        .foregroundColor(.black)
                        .cornerRadius(30)
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .tint(Color.init(red: 0.67, green: 0.55, blue: 0.73))
                        .font(.system(size: 24))
                        .padding(.top, 30)
                        
                        Spacer()
                    }
                    .padding(30)
                }
                
            }
            
        }
        .sheet(isPresented: $showCamera) {
            CameraViewController(selectedImage: $selectedImage, showCamera: $showCamera, classificationResult: $classificationResult)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

