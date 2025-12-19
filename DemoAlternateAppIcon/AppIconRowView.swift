//
//  AppIconRowView.swift
//  DemoAlternateAppIcon
//
//  Created by miss.menut on 18/12/2568 BE.
//
import SwiftUI

struct AppIconRowView: View {
    let appIcon: AppIcon
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image(uiImage: appIcon.preview)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .cornerRadius(12)

            Text(appIcon.description)
                .font(.body)
                .foregroundColor(.black)

            Spacer()

            CheckboxView(isSelected: isSelected)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 16)
        .background(Color.white)
        .cornerRadius(20)
        .onTapGesture(perform: onTap)
    }
}
