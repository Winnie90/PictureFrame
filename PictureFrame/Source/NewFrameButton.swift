//
//  NewFrameButton.swift
//  PictureFrame
//
//  Created by Chris Winstanley on 17/02/2024.
//

import SwiftUI

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
