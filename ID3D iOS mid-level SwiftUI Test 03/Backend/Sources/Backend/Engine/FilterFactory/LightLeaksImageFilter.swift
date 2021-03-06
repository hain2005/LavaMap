//
//  LightLeaksImageFilter.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 13/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

public class LightLeaksImageFilter: ImageFilterProtocol {
    private enum LeaksName: String, CaseIterable {
        case leaks1
    }
    
    private let selectedLeaksFilter: LeaksName = .leaks1
    private var strength: CGFloat = {
        return RangeConverterHelper.shared.convert(FilterValue.Lightleaks.strength, fromOldRange: [0, 10], toNewRange: [0, 1])
    }()
    
    public func process(imageToEdit image: UIImage) -> UIImage? {
        guard let leaksImage = UIImage(named: selectedLeaksFilter.rawValue) else { fatalError("Invalid name!") }
        print("Applying lightleaks with strength of: \(String(describing: strength))")
        
        // 1. Begin drawing
        UIGraphicsBeginImageContext(image.size)
        
        // 2. Draw the base image first
        let rect = CGRect(origin: .zero, size: image.size)
        image.draw(in: rect)
        
        // 3. Draw the light leaks image with screen blend mode
        leaksImage.draw(in: rect, blendMode: .screen, alpha: strength)
        
        // 4. Get the blended image and return!
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}
