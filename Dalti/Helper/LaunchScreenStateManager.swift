//
//  LaunchScreenStateManager.swift
//  Dalti
//
//  Created by Sara Alhumidi on 27/07/1444 AH.
//

import Foundation
import UIKit
import SwiftUI

final class LaunchScreenStateManager: ObservableObject {

@MainActor @Published private(set) var state: LaunchScreenStep = .firstStep

    @MainActor func dismiss() {
        Task {
            state = .secondStep

            try? await Task.sleep(for: Duration.seconds(1))

            self.state = .finished
        }
    }
}
