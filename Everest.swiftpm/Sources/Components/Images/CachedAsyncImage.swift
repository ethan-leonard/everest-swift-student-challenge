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
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let downloadedImage = UIImage(data: data) {
                    await MainActor.run {
                        self.image = downloadedImage
                    }
                }
            } catch {
                #if DEBUG
                print("[CachedAsyncImage] Failed to load: \(error.localizedDescription)")
                #endif
            }
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}
