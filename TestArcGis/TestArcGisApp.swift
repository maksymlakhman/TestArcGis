//
//  TestArcGisApp.swift
//  TestArcGis
//
//  Created by Максим Лахман on 31.10.2024.
//

import SwiftUI
import ArcGIS

@main
struct TestArcGisApp: App {
    init() {
        // Встановіть ваш API ключ тут
        AGSArcGISRuntimeEnvironment.apiKey = "AAPTxy8BH1VEsoebNVZXo8HurItqoauDlCtBHnEjtXVvxob_kGaKWWR1z0HYlpmpSMZK5eXXYwb62fp2Il7sKAByP6CelrGCKOz_PMoYAKiqHiszjYkfSBn85XZgayHZQvd_u_KD2BAth708xbQCJgcSm-YWhDf20ZQM1WiPvJs8Iwa5xLg8gXDdbeQ0jaLxr91eBwQ0X4kRXACt311a-hwhEWpRgdtrxiZyh2YLkEmKyj8.AT1_u5MxSP2L"
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
