//
//  FilterStrength.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 20/6/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import UIKit

/// Parent struct of all the changeable value of the effects.
public struct FilterValue {
    
    /// Colourleaks component. Stores the selected value, along its options.
    public struct Colourleaks {
        // Red by default
        public static var selectedColourValue: ColourValue = .red
        
        public enum ColourValue: String, CaseIterable {
            case random, red, green, blue
            
            // Value for the engine
            public var value: UIColor {
                switch self {
                case .random: return ColourValue.allCases.dropFirst().randomElement()!.value
                case .red: return .red
                case .green: return .green
                case .blue: return .blue
                }
            }
            
            // Value for UI. This means to display a friendlier colour.
            public var displayValue: UIColor {
                switch self {
                case .random: return .systemGray
                case .red: return UIColor(displayP3Red: 173/255, green: 36/255, blue: 41/255, alpha: 1)
                case .green: return UIColor(displayP3Red: 6/255, green: 81/255, blue: 37/255, alpha: 1)
                case .blue: return UIColor(displayP3Red: 5/255, green: 42/255, blue: 83/255, alpha: 1)
                }
            }
        }
    }
    
    /// Grain component. Stores its strength value.
    /// Can be improved in the future to include more attributes. (Maybe variety of dust? randomise option?
    public struct Grain {
        public static var strength: CGFloat = 10
    }
    
    /// Dust component. Stores its strength value.
    /// Can be improved in the future to include more attributes. (Maybe variety of dust? randomise option?
    public struct Dust {
        public static var strength: CGFloat = 10
    }
    
    /// Lightleaks component. Stores its strength value.
    /// Can be improved in the future to include more attributes. (Maybe variety of lightleaks? randomise option?
    public struct Lightleaks {
        public static var strength: CGFloat = 10
    }
    
    private init() { }
    
    public static func reset() {
        Colourleaks.selectedColourValue = .red
        Grain.strength = 10
        Dust.strength = 10
        Lightleaks.strength = 10
    }
}
