//
//  CheckboxView.swift
//  DemoAlternateAppIcon
//
//  Created by miss.menut on 18/12/2568 BE.
//

import SwiftUI

struct CheckboxView: View {
    let isSelected: Bool

    private var image: UIImage {
        let imageName = isSelected ? "icon-checked" : "icon-unchecked"
        return UIImage(named: imageName) ?? UIImage(systemName: isSelected ? "checkmark.circle.fill" : "circle")!
    }

    var body: some View {
        Image(uiImage: image)
    }
}
