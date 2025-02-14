//
//  CachedAsyncImage.swift
//  MovieDB
//
//  Created by Ahmed Eldyahi on 14/02/2025.
//
import SwiftUI

struct CachedAsyncImage<Placeholder: View, Content: View, Failure: View>: View {
    private let url: URL?
    private let placeholder: () -> Placeholder
    private let content: (Image) -> Content
    private let failure: () -> Failure

    @State private var phase: AsyncImagePhase = .empty

    init(
        url: URL?,
        @ViewBuilder placeholder: @escaping () -> Placeholder,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder failure: @escaping () -> Failure
    ) {
        self.url = url
        self.placeholder = placeholder
        self.content = content
        self.failure = failure
    }

    var body: some View {
        Group {
            switch phase {
            case .success(let image):
                content(image)
            case .failure:
                failure()
            default:
                placeholder()
            }
        }
        .task(id: url) { await loadImage() }
    }

    private func loadImage() async {
        guard  case .empty = phase, let url = url else { return }

        if let cachedImage = await ImageCache.shared.image(for: url) {
            phase = .success(Image(uiImage: cachedImage))
            return
        }

        do {
            let image = try await ImageLoader.shared.loadImage(from: url)
            phase = .success(Image(uiImage: image))
        } catch {
            phase = .failure(error)
        }
    }
}

final class CachedAsyncImageLoader: ObservableObject {
    @Published var phase: AsyncImagePhase = .empty
    private var hasLoaded = false

    func loadImage(url: URL?) {
        guard let url = url else { return }
        
        guard !hasLoaded else { return }
        hasLoaded = true
        
        Task {
            if let cachedImage = await ImageCache.shared.image(for: url) {
                await MainActor.run { phase = .success(Image(uiImage: cachedImage)) }
                return
            }
            
            do {
                let image = try await ImageLoader.shared.loadImage(from: url)
                await MainActor.run { phase = .success(Image(uiImage: image)) }
            } catch {
                await MainActor.run { phase = .failure(error) }
            }
        }
    }
}
// MARK: - Image Loader
actor ImageLoader {
    static let shared = ImageLoader()
    private init() {}
    
    func loadImage(from url: URL) async throws -> UIImage {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: request),
           let image = UIImage(data: cachedResponse.data) {
            return image
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let image = UIImage(data: data) else {
            throw ImageError.invalidImageData
        }
        
        await ImageCache.shared.set(image: image, for: url)
        URLCache.shared.storeCachedResponse(
            CachedURLResponse(response: response, data: data),
            for: request
        )
        
        return image
    }
}

// MARK: - Image Cache
final class ImageCache {
    static let shared = ImageCache()
    private let memoryCache = NSCache<NSURL, UIImage>()
    private let fileManager = FileManager.default
    private let diskCacheURL: URL
    private let queue = DispatchQueue(label: "com.imagecache.queue", qos: .utility)
    
    private init() {
        diskCacheURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageCache")
        createCacheDirectory()
        memoryCache.countLimit = 200
    }
    
    func image(for url: URL) async -> UIImage? {
        await withCheckedContinuation { continuation in
            queue.async {
                if let memoryImage = self.memoryCache.object(forKey: url as NSURL) {
                    continuation.resume(returning: memoryImage)
                    return
                }
                
                let fileURL = self.diskCacheURL.appendingPathComponent(url.fileName)
                if let diskImage = self.loadFromDisk(fileURL: fileURL) {
                    self.memoryCache.setObject(diskImage, forKey: url as NSURL)
                    continuation.resume(returning: diskImage)
                    return
                }
                
                continuation.resume(returning: nil)
            }
        }
    }
    
    func set(image: UIImage, for url: URL) async {
        await withCheckedContinuation { continuation in
            queue.async {
                self.memoryCache.setObject(image, forKey: url as NSURL)
                let fileURL = self.diskCacheURL.appendingPathComponent(url.fileName)
                self.saveToDisk(image: image, fileURL: fileURL)
                continuation.resume()
            }
        }
    }
    
    private func createCacheDirectory() {
        guard !fileManager.fileExists(atPath: diskCacheURL.path) else { return }
        try? fileManager.createDirectory(
            at: diskCacheURL,
            withIntermediateDirectories: true
        )
    }
    
    private func saveToDisk(image: UIImage, fileURL: URL) {
        guard let data = image.pngData() else { return }
        try? data.write(to: fileURL)
    }
    
    private func loadFromDisk(fileURL: URL) -> UIImage? {
        guard fileManager.fileExists(atPath: fileURL.path),
              let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}

// MARK: - Extensions
private extension URL {
    var fileName: String {
        absoluteString
            .components(separatedBy: .urlHostAllowed.inverted)
            .joined()
            .appending(".png")
    }
}

enum ImageError: Error {
    case invalidImageData
}
