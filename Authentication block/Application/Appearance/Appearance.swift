//
//  Appearance.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 13.10.2022.
//

import Foundation
import UIKit

class Appearance {
    static var titlesFont = UIFont()
    static var buttomsFont = UIFont()
    static var smallCursiveFont = UIFont()
    
    static func configure() {
//        guard let titlesFont = UIFont(name: "Titles1", size: UIFont.labelFontSize) else { fatalError("failed") }
        Appearance.titlesFont = UIFont.boldSystemFont(ofSize: 30)        Appearance.titlesFont = UIFont.boldSystemFont(ofSize: 30)
        Appearance.titlesFont = UIFont.boldSystemFont(ofSize: 30)
//        guard let buttomsFont = UIFont(name: "Buttons", size: UIFont.buttonFontSize) else { fatalError("failed") }
        Appearance.buttomsFont = UIFont.boldSystemFont(ofSize: 12)
//        guard let smallCursiveFont = UIFont(name: "CursiveText", size: UIFont.smallSystemFontSize) else { fatalError("failed") }
        Appearance.smallCursiveFont = UIFont.boldSystemFont(ofSize: 10)
    }
}
