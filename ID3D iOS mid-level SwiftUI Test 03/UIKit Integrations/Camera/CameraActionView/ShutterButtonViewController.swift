//
//  ShutterButtonViewController.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 22/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit
import MobileCoreServices
import MediaPlayer
//import Backend

class ShutterButtonViewController: UIViewController {
    
    private enum TouchEvent {
        case begin, end
    }
    
    private let animationDuration: TimeInterval = 0.1
    private var color = UIColor.label
    private let touchedColor = UIColor.label.withAlphaComponent(0.8)
    
    private let systemVolumeView = MPVolumeView(frame: CGRect(x: -CGFloat.greatestFiniteMagnitude, y: 0, width: 0, height: 0))
    private var volume: Float = 0
    private var shouldDetectVolume = false
    
    var oriFrame: CGSize! // Passed from parent to determined the size of the shutter button
    private let innerCircle = UIView()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(innerCircle)
        self.view.isUserInteractionEnabled = true
        self.view.layer.borderWidth = 2
        self.view.translatesAutoresizingMaskIntoConstraints = false
        innerCircle.translatesAutoresizingMaskIntoConstraints = false
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(shutterTapped))
        gesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gesture)
        
        setupConstraint()
        
        touchEvent(event: .begin)
        renderSize()
        
        // Hide the VolumeHUD
        self.view.addSubview(systemVolumeView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupVolumeObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeVolumeObserver()
    }
    
    private func setupVolumeObserver() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(true)
            volume = audioSession.outputVolume
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let systemVolumeSlider = systemVolumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            systemVolumeSlider.addTarget(self, action: #selector(onVolumeTrigger), for: .valueChanged)
        }
    }
    
    private func removeVolumeObserver() {
        if let systemVolumeSlider = systemVolumeView.subviews.first(where: { $0 is UISlider }) as? UISlider {
            systemVolumeSlider.removeTarget(self, action: #selector(onVolumeTrigger), for: .valueChanged)
            systemVolumeSlider.value = volume
        }
    }
    
    @objc private func onVolumeTrigger() {
        if shouldDetectVolume {
            shutterTapped()
        }
        shouldDetectVolume = true
    }
    
    private func setupConstraint() {
        self.view.layer.cornerRadius = oriFrame.width / 2
        innerCircle.layer.cornerRadius = oriFrame.width * 0.9 / 2
        
        self.view.snp.makeConstraints { (make) in
            make.height.width.equalTo(oriFrame.width)
        }
        
        innerCircle.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(oriFrame.width * 0.9)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.view.layer.borderColor = color.resolvedColor(with: self.traitCollection).cgColor
    }
    
    // MARK: - Shutter tapped
    /// Handles the shutter button tapped
    @objc func shutterTapped() {
        self.view.isUserInteractionEnabled = false
        let parent = self.parent as! CameraActionViewController
        let loadingVC = LoadingViewController()
        if parent.timerEngine.currentTime != 0 { parent.timerEngine.presentTimerDisplay() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(parent.timerEngine.currentTime)) {
            parent.cameraEngine?.captureImage(completion: { [weak self] (capturedImage) in
                guard let self = self, let image = capturedImage else { return }
                parent.cameraEngine?.isCapturing = true
                parent.parent!.addVC(loadingVC)
                
                DispatchQueue.main.async {
                    guard let editedImage = FilterEngine.shared.process(originalImage: image) else { return }
                    
                    guard let editedData = editedImage.jpegData(compressionQuality: 1.0) else { return }
                    DataEngine.shared.save(imageData: editedData)
                    
                    TapticHelper.shared.successTaptic()
                    loadingVC.removeVC()
                    parent.cameraEngine?.isCapturing = false
                }
                self.view.isUserInteractionEnabled = true
            })
        }
    }
    
    private func renderSize(multiplier: CGFloat = 1) {
        innerCircle.transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
    }
    
    /// Tell the UI to render the layout according to the event
    /// - Parameter event: The event. Begin: When no event detected. End: When event has ended.
    private func touchEvent(event: TouchEvent) {
        switch event {
        case .begin:
            self.view.layer.borderColor = color.resolvedColor(with: self.traitCollection).cgColor
            innerCircle.backgroundColor = color
            
        case .end:
            self.view.layer.borderColor = color.resolvedColor(with: self.traitCollection).cgColor
            innerCircle.backgroundColor = touchedColor
        }
    }
}

extension ShutterButtonViewController {
    // MARK: - Touch event listener
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.touchEvent(event: .begin)
            UIView.animate(withDuration: self.animationDuration) {
                self.touchEvent(event: .end)
                self.renderSize(multiplier: 0.98)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.touchEvent(event: .end)
            self.renderSize(multiplier: 0.98)
            UIView.animate(withDuration: self.animationDuration) {
                self.touchEvent(event: .begin)
                self.renderSize()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.touchEvent(event: .end)
            self.renderSize(multiplier: 0.98)
            UIView.animate(withDuration: self.animationDuration) {
                self.touchEvent(event: .begin)
                self.renderSize()
            }
        }
    }
}
