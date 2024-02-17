//
//  ContentView.swift
//  PictureFrame
//
//  Created by Chris Winstanley on 16/02/2024.
//

import SwiftUI
import PhotosUI

struct FrameView: View {
    @Environment(\.openWindow) private var openWindow
    @StateObject var viewModel: FrameModel
    
    var body: some View {
        FrameImage(frameModel: viewModel)
            .onAppear {
                if let uuid = viewModel.nextFrameId {
                    openWindow(id: "photo-frame", value: uuid)
                }
            }
            .onDisappear {
                viewModel.closeFrame()
            }
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    PhotoPicker(viewModel: viewModel)
                }
                ToolbarItem(placement: .bottomOrnament) {
                   NewFrameButton()
                }
            }
            
    }
}
