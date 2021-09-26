//
//  FilterFactory.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 27/5/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import Foundation
import UIKit

public protocol ImageFilterProtocol {
    
    /// Proccess the image with the selected  filter
    /// - Parameter image: The image that will be overlayed with grain
    /// - Returns: The image either exist or not
    func process(imageToEdit image: UIImage) -> UIImage?
}

public class FilterFactory {
    
    static let shared = FilterFactory()
    private init() { }
    
    /// Get the filter and returns the object
    /// - Parameters:
    ///   - filterType: The type of the filter
    ///   - filterName: The image name of the ilter as specified in assets folder
    /// - Returns: The ImageFilter ready to be used
    public func getFilter(ofFilterType filterType: FilterType) -> ImageFilterProtocol {
        
        switch filterType {
        case .lut: return LUTImageFilter()
        case .grain: return GrainImageFilter()
        case .dust: return DustImageFilter()
        case .lightleaks: return LightLeaksImageFilter()
        case .datestamp: return DatestampImageFilter()
        case .colourleaks: return ColourLeaksImageFilter()
        }
    }
}
