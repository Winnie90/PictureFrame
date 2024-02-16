//
//  ContentView.swift
//  PictureFrame
//
//  Created by Chris Winstanley on 16/02/2024.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel = ProfileModel()
    
    var body: some View {
        EditableFrameImage(viewModel: viewModel)
    }
}

struct EditableFrameImage: View {
    @Environment(\.openWindow) private var openWindow
    @ObservedObject var viewModel: ProfileModel
    
    var body: some View {
        FrameImage(profileModel: viewModel)
            .toolbar {
                ToolbarItem(placement: .bottomOrnament) {
                    PhotosPicker(selection: $viewModel.imageSelection,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.system(size: 30))
                    }
                    .buttonStyle(.borderless)
                }
                ToolbarItem(placement: .bottomOrnament) {
                    Button {
                        openWindow(id: "photo-frame")
                    } label: {
                        Image(systemName: "photo.badge.plus.fill")
                            .font(.system(size: 30))
                    }
                }
            }
    }
}

struct FrameImage: View {
    let profileModel: ProfileModel
    
    var body: some View {
        PickerImage(profileModel: profileModel)
            .scaledToFill()
    }
}

struct PickerImage: View {
    @ObservedObject var profileModel: ProfileModel
    
    var body: some View {
        switch profileModel.imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            PhotosPicker(selection: $profileModel.imageSelection,
                         matching: .images,
                         photoLibrary: .shared()) {
                Image(systemName: "pencil.circle.fill")
                    .font(.system(size: 30))
            }
            .buttonStyle(.borderless)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
