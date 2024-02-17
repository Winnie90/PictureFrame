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

struct NewFrameButton: View {
    @Environment(\.openWindow) private var openWindow
    var body: some View {
        Button {
            openWindow(id: "photo-frame", value: UUID().uuidString)
        } label: {
            Image(systemName: "photo.badge.plus.fill")
                .font(.system(size: 28))
        }
        .accessibilityLabel("Open new frame")
    }
}

struct PhotoPicker: View {
    @StateObject var viewModel: FrameModel
    
    var body: some View {
        PhotosPicker(selection: $viewModel.imageSelection,
                     matching: .images,
                     photoLibrary: .shared()) {
            Image(systemName: "pencil.circle.fill")
                .font(.system(size: 28))
        }
        .buttonStyle(.borderless)
        .accessibilityLabel("Edit photo")
        .accessibilityValue("Opens your photo library to select a photo")
    }
}

struct FrameImage: View {
    @ObservedObject var frameModel: FrameModel
    
    var body: some View {
        switch frameModel.imageState {
        case .success(let image):
            image
                .resizable()
                .scaledToFill()
        case .loading:
            ProgressView()
        case .empty:
            VStack {
                PhotoPicker(viewModel: frameModel)
                Text("Please select a photo.")
                    .font(.headline)
            }
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 28))
                .foregroundColor(.white)
        }
    }
}
