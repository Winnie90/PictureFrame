//
//  PictureFrameApp.swift
//  PictureFrame
//
//  Created by Chris Winstanley on 16/02/2024.
//

import SwiftUI

@main
struct PictureFrameApp: App {
    var body: some Scene {
        WindowGroup {
            FrameView(viewModel: FrameModel(windowName: loadImageIndex()))
        }
        
        WindowGroup(id: "photo-frame", for: String.self) { $uuid in
            FrameView(viewModel: FrameModel(windowName: uuid))
        }
    }
    
    private func loadImageIndex() -> String {
        if let imageIndex = UserDefaults.standard.array(forKey: "PictureFrameIndex") as? [String], !imageIndex.isEmpty {
            return imageIndex[0]
        } else {
            return UUID().uuidString
        }
    }
}
