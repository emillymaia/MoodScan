//
//  CameraViewController.swift
//  MoodScan
//
//  Created by Emilly Maia on 17/05/23.
//

import SwiftUI
import Vision
import CoreML

struct CameraViewController: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    @Binding var selectedImage: UIImage?
    @Binding var showCamera: Bool
    @Binding var classificationResult: String
    
    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.delegate = context.coordinator
        viewController.sourceType = .camera
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> CameraViewController.Coordinator {
        return Coordinator(parent: self)
    }
    
}

extension CameraViewController {
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: CameraViewController
        
        init(parent: CameraViewController) {
            self.parent = parent
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.showCamera = false
            print("Cancel Pressed")
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                parent.selectedImage = image
                parent.showCamera = false
                
                if let ciImage = CIImage(image: image) {
                    classifyImage(ciImage)
                }
            }
        }
        
        func classifyImage(_ image: CIImage) {
            do {
                let model = try VNCoreMLModel(for: MemeEmotions().model)
                let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                    guard let results = request.results as? [VNClassificationObservation],
                          let topResult = results.first else {
                        self?.parent.classificationResult = "Unable to classify the image."
                        return
                    }
                    
                    self?.parent.classificationResult = "\(topResult.identifier)"
                }
                let handler = VNImageRequestHandler(ciImage: image)
                try handler.perform([request])
            } catch {
                parent.classificationResult = "Error: \(error.localizedDescription)"
            }
        }
    }
}
