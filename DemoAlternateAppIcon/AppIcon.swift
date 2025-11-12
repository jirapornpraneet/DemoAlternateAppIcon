//
//  AppIcon.swift
//  DemoAlternateAppIcon
//
//  Created by miss.menut on 10/11/2568 BE.
//
import UIKit

public enum AppIcon: String, CaseIterable, Identifiable {
    case primary = "AppIcon"
    case christmas = "AppIcon-Christmas"
    
    public var id: String { rawValue }
    public var iconName: String? {
        self == .primary ? nil : rawValue
    }
    
    public var iconPreview: String {
        switch self {
        case .primary: "PreviewAppIcon"
        case .christmas: "PreviewAppIconChristmas"
        }
    }
    
    public var description: String {
        switch self {
        case .primary: return "AppIcon"
        case .christmas: return "AppIcon-Christmas"
        }
    }
    
    public var preview: UIImage {
        UIImage(named: iconPreview) ?? UIImage()
    }
}
