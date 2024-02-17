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
            FrameView(viewModel: FrameModel(frameId: loadFirstImageId()))
        }
        
        WindowGroup(id: "photo-frame", for: String.self) { $uuid in
            FrameView(viewModel: FrameModel(frameId: uuid ?? UUID().uuidString))
        }
    }
    
    private func loadFirstImageId() -> String {
        if let imageIndex = UserDefaults.standard.array(forKey: "PictureFrameIndex") as? [String], !imageIndex.isEmpty {
            return imageIndex.sorted()[0]
        } else {
            return UUID().uuidString
        }
    }
}
