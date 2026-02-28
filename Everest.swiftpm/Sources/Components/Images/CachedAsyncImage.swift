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
        
        // Extract asset name from URL path
        let assetName = url.lastPathComponent
            .replacingOccurrences(of: ".png", with: "")
            .replacingOccurrences(of: ".jpg", with: "")
        let cleanName = assetName.components(separatedBy: "?").first ?? assetName
        
        // Try Bundle.module first (Swift Package resources), then main bundle
        if let uiImage = UIImage(named: cleanName, in: Bundle.module, compatibleWith: nil) {
            self.image = uiImage
        } else if let uiImage = UIImage(named: cleanName) {
            self.image = uiImage
        }
        // If not found, silently fall through to placeholder — no spammy logging
        self.isLoading = false
    }
}
