//
//  DemoAlternateAppIconApp.swift
//  DemoAlternateAppIcon
//
//  Created by miss.menut on 10/11/2568 BE.
//

import SwiftUI

@main
struct DemoAlternateAppIconApp: App {
    @StateObject private var viewModel: ChangeAppIconViewModel
    @StateObject private var notificationManager: NotificationManager

    init() {
        let viewModel = ChangeAppIconViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
        _notificationManager = StateObject(wrappedValue: NotificationManager(iconViewModel: viewModel))
    }

    var body: some Scene {
        WindowGroup {
            ChangeAppIconView()
                .environmentObject(viewModel)
                .environmentObject(notificationManager)
        }
    }
}
