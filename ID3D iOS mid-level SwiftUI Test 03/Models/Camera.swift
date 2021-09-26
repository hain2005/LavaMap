//
//  Camera.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Hai Nguyen on 9/24/21.
//

import Foundation
import UIKit
import SwiftUI
import camera

struct CameraCtrl: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {        
        let framework = Bundle(identifier: "com.lavamap.camera.test")
        let storyboard = UIStoryboard(name: "Main", bundle: framework)
        let controller = storyboard.instantiateViewController(identifier: "cameraVC")
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
