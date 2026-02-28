import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder
    
    @State private var image: UIImage? = nil
    @State private var isLoading = false
    
    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
            } else {
                placeholder()
                    .onAppear {
                        load()
                    }
            }
        }
    }
    
    private func load() {
        guard let url else { return }
        guard !isLoading else { return }
        isLoading = true
        
        // Use local assets in playground instead of network downloads
        let assetName = url.lastPathComponent
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: ".jpg", with: "")
        
        // Strip query params if they exist (common in firebase urls)
        let cleanName = assetName.components(separatedBy: "?").first ?? assetName
        
        if let uiImage = UIImage(named: cleanName) {
            self.image = uiImage
        } else if let uiImage = UIImage(named: url.absoluteString) {
             self.image = uiImage
        } else {
            #if true
            print("[CachedAsyncImage] Failed to find local asset: \(cleanName)")
            #endif
        }
        self.isLoading = false
    }
}
