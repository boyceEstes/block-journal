//
//  BJAsset.swift
//  HabitMePrototype
//
//  Created by Boyce Estes on 2/9/24.
//

import Foundation
import SwiftUI


enum BJAsset: String, CustomStringConvertible {
    
    case numberSquare = "number.square"// Number Detail
    case characterBubble = "character.bubble" // Text Detail
    
    /// access string by typecasting `AssetLibrary` instance.
    ///
    /// Example:
    /// ```String(AssetLibrary.numberSquare)```
    var description: String {
        return self.rawValue
    }
    
    
    func image() -> some View {
        Image(systemName: self.rawValue)
    }
}
