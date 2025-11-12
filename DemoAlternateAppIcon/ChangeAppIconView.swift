//
//  ChangeAppIconView.swift
//  DemoAlternateAppIcon
//
//  Created by miss.menut on 10/11/2568 BE.
//
import SwiftUI

// MARK: - Main View
struct ChangeAppIconView: View {
    @EnvironmentObject private var viewModel: ChangeAppIconViewModel
    @EnvironmentObject private var notificationManager: NotificationManager
    @State private var notificationDelay: Double = 5

    var body: some View {
        VStack(spacing: 24) {
            notificationSection

            ScrollView {
                let appIcons = AppIcon.allCases

                VStack(spacing: 11) {
                    ForEach(appIcons) { appIcon in
                        AppIconRowView(
                            appIcon: appIcon,
                            isSelected: viewModel.selectedAppIcon == appIcon
                        ) {
                            withAnimation {
                                viewModel.updateAppIcon(to: appIcon)
                            }
                        }
                        .contextMenu {
                            Button {
                                notificationManager.scheduleIconChangeNotification(
                                    for: appIcon,
                                    after: notificationDelay
                                )
                            } label: {
                                Label("Schedule notification", systemImage: "bell.badge")
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 40)
            }
        }
        .background(Color(UIColor.systemPink).ignoresSafeArea())
    }
}

private extension ChangeAppIconView {
    var notificationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Tap an icon to switch instantly or long-press to queue a notification that will change it automatically when delivered.")
                .font(.callout)
                .foregroundColor(.white)

            VStack(alignment: .leading, spacing: 8) {
                Text("Notification delay: \(Int(notificationDelay)) seconds")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))

                Slider(value: $notificationDelay, in: 3...30, step: 1)
                    .tint(.white)

                Text("Add assets named AppIconPrimaryPreview / AppIconChristmasPreview to replace the generated previews.")
                    .font(.caption2)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(20)
        .background(Color.white.opacity(0.15))
        .cornerRadius(24)
        .padding(.horizontal)
        .padding(.top, 24)
    }
}


// MARK: - Preview
struct ChangeAppIconView_Previews: PreviewProvider {
    static let previewViewModel = ChangeAppIconViewModel()
    static let previewNotificationManager = NotificationManager(
        iconViewModel: previewViewModel,
        requestPermissionOnInit: false
    )

    static var previews: some View {
        Group {
            ChangeAppIconView()
                .environmentObject(previewViewModel)
                .environmentObject(previewNotificationManager)
                .previewDisplayName("Change App Icon")
        }
    }
}

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
