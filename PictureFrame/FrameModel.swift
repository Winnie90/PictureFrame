
import SwiftUI
import PhotosUI
import CoreTransferable

@MainActor
class FrameModel: ObservableObject {
    
    // MARK: - Profile Image
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
            }
        }
    }
    
    @Published private(set) var imageState: ImageState = .empty
    
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    
    private let windowName: String
    
    init(windowName: String?) {
        self.windowName = windowName ?? UUID().uuidString
        if let image = loadImage() {
            imageState = .success(Image(uiImage: image))
        }
    }
    
    func nextImage() -> String {
        let imageIndex = loadImageIndex()
        guard let currentIndex = imageIndex.firstIndex(of: windowName), let nextIndex = imageIndex[safe: currentIndex + 1] else { return UUID().uuidString }
        return nextIndex
    }
    
    // MARK: - Private Methods
    
    private func saveImage(image: Image) {
        guard let uiImage = image.getUIImage(),
              let data = uiImage.jpegData(compressionQuality: 1.0) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        
        let pictureName = "PictureFrame-\(windowName)"
        UserDefaults.standard.set(encoded, forKey: pictureName)
        
        var imageIndexes = loadImageIndex()
        imageIndexes.append(pictureName)
        save(imageIndexes)
    }
    
    private func loadImage() -> UIImage? {
        guard let data = UserDefaults.standard.data(forKey: windowName) else { return nil }
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data)
        return UIImage(data: decoded)
    }
    
    private func loadImageIndex() -> [String] {
        UserDefaults.standard.array(forKey: "PictureFrameIndex") as? [String] ?? []
    }
    
    private func save(_ imageIndexes: [String]) {
        UserDefaults.standard.setValue(imageIndexes, forKey: "PictureFrameIndex")
    }
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.saveImage(image: profileImage.image)
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}

extension Image {
    @MainActor
    func getUIImage() -> UIImage? {
        let image = resizable()
            .scaledToFill()
            .clipped()
        return ImageRenderer(content: image).uiImage
    }
}

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
