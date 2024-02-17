//
//  PhotoPicker.swift
//  PictureFrame
//
//  Created by Chris Winstanley on 17/02/2024.
//

import SwiftUI
import PhotosUI

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
