//  File.swift
//  ShowcaseKit
//
//  Created by priyal on 28/05/26.
//

import Foundation
import UIKit

public enum ShowcaseButtonImagePlacement {
    case leading
    case trailing
}

public struct ShowcaseTooltipStyle {
    public let backgroundColor:  UIColor
    public let cornerRadius:     CGFloat
    public let padding:          UIEdgeInsets
    public let descriptionFont:  UIFont
    public let descriptionColor: UIColor
    public let buttonColor:      UIColor
    public let buttonTextColor:  UIColor
    public var nextButtonFont:   UIFont?
    public var doneButtonFont:   UIFont?
    public var backButtonFont:   UIFont?
    public var skipButtonFont:   UIFont?
    public var nextButtonTextColor: UIColor?
    public var doneButtonTextColor: UIColor?
    public var backButtonTextColor: UIColor?
    public var skipButtonTextColor: UIColor?
    public var nextButtonImage: UIImage?
    public var backButtonImage: UIImage?
    public var nextButtonImagePlacement: ShowcaseButtonImagePlacement
    public var backButtonImagePlacement: ShowcaseButtonImagePlacement

    public init(
        backgroundColor:  UIColor   = UIColor(red: 0.13, green: 0.13, blue: 0.18, alpha: 1),
        cornerRadius:     CGFloat   = 16,
        padding:          UIEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16),
        descriptionFont:  UIFont    = UIFont.preferredFont(forTextStyle: .subheadline),
        descriptionColor: UIColor   = UIColor.white.withAlphaComponent(0.8),
        buttonColor:      UIColor   = .systemIndigo,
        buttonTextColor:  UIColor   = .white,
        nextButtonFont: UIFont? = nil,
        doneButtonFont: UIFont? = nil,
        backButtonFont: UIFont? = nil,
        skipButtonFont: UIFont? = nil,
        nextButtonTextColor: UIColor? = nil,
        doneButtonTextColor: UIColor? = nil,
        backButtonTextColor: UIColor? = nil,
        skipButtonTextColor: UIColor? = nil,
        nextButtonImage: UIImage? = nil,
        backButtonImage: UIImage? = nil,
        nextButtonImagePlacement: ShowcaseButtonImagePlacement = .trailing,
        backButtonImagePlacement: ShowcaseButtonImagePlacement = .leading
    ) {
        self.backgroundColor  = backgroundColor
        self.cornerRadius     = cornerRadius
        self.padding          = padding
        self.descriptionFont  = descriptionFont
        self.descriptionColor = descriptionColor
        self.buttonColor      = buttonColor
        self.buttonTextColor  = buttonTextColor
        self.nextButtonFont   = nextButtonFont
        self.doneButtonFont   = doneButtonFont
        self.backButtonFont   = backButtonFont
        self.skipButtonFont   = skipButtonFont
        self.nextButtonTextColor = nextButtonTextColor
        self.doneButtonTextColor = doneButtonTextColor
        self.backButtonTextColor = backButtonTextColor
        self.skipButtonTextColor = skipButtonTextColor
        self.nextButtonImage = nextButtonImage
        self.backButtonImage = backButtonImage
        self.nextButtonImagePlacement = nextButtonImagePlacement
        self.backButtonImagePlacement = backButtonImagePlacement
    }

    public static let `default` = ShowcaseTooltipStyle()
}
