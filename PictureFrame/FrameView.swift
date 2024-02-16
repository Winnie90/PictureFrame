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
                if let uuid = viewModel.nextImageId {
                    openWindow(id: "photo-frame", value: uuid)
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    PhotoPicker(viewModel: viewModel)
                }
                ToolbarItem(placement: .bottomOrnament) {
                    Button {
                        openWindow(id: "photo-frame", value: UUID().uuidString)
                    } label: {
                        Image(systemName: "photo.badge.plus.fill")
                            .font(.system(size: 28))
                    }.disabled(viewModel.nextImageId != nil)
                }
            }
            .onDisappear {
                viewModel.closeImage()
            }
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
            }
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 30))
                .foregroundColor(.white)
        }
    }
}
