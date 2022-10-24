//
//  Appearance.swift
//  Authentication block
//
//  Created by Алексей Коваленко on 13.10.2022.
//

import Foundation
import UIKit

//MARK: Appearance
class Appearance {
    // Font
    public static var titlesFont = UIFont()
    public static var buttomsFont = UIFont()
    public static var smallCursiveFont = UIFont()
    // Button logos
    public static var appleLogo = UIImage()
    public static var facebookLogo = UIImage()
    public static var googleLogo = UIImage()


    static func configure() {
        //FONTS
        guard let titlesFont = UIFont(name: "LD Grotesk Condensed Bold", size: 40) else { fatalError("failed") }
        Appearance.titlesFont = titlesFont
        guard let buttomsFont = UIFont(name: "Helvetica Bold", size: 12) else { fatalError("failed") }
        Appearance.buttomsFont = buttomsFont
        guard let smallCursiveFont = UIFont(name: "LD Grotesk Condensed Ultra Light Oblique", size: 12) else { fatalError("failed") }
        Appearance.smallCursiveFont = smallCursiveFont
        // IMAGES
        guard let appleImage = UIImage(named: "appleLogo") else { fatalError("failed") }
        self.appleLogo = appleImage
        guard let facebookLogo = UIImage(named: "fbLogo") else { fatalError("failed") }
        self.facebookLogo = facebookLogo
        guard let googleLogo = UIImage(named: "googleLogo") else { fatalError("failed") }
        self.googleLogo = googleLogo
    }
}
