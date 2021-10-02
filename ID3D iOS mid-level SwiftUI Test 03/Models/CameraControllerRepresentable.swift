//
//  CameraControllerRepresentable.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Hai Nguyen on 9/24/21.
//

import Foundation
import UIKit
import SwiftUI
import camera
import CoreData

struct CameraControllerRepresentable: UIViewControllerRepresentable {
    
    @Binding var pictureTakenCount: Int
    @Binding var fileURL: URL
    
    var imageViewModel = ImageViewModel()
    
    class Coordinator: NSObject, CameraControllerDelegate {

        var parent: CameraControllerRepresentable

        init(_ parent: CameraControllerRepresentable) {
            self.parent = parent
        }
        
        func pictureTaken(url: URL) {
            parent.pictureTakenCount +=  1
            parent.fileURL = url
            parent.imageViewModel.saveToCoreData(captureIndex: Int16(parent.pictureTakenCount), url: url)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let framework = Bundle(identifier: "com.lavamap.camera.test")
        let storyboard = UIStoryboard(name: "Main", bundle: framework)
        let controller = storyboard.instantiateViewController(identifier: "cameraVC") as CameraController
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
