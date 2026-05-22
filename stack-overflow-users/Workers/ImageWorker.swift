//
//  ImageWorker.swift
//  stack-overflow-users
//
//  Created by Ian-Andoni Magarzo Fernandez on 22/5/26.
//

import UIKit

protocol ImageWorkerContract {
    func loadImage(from url: URL) async -> UIImage?
}

final class ImageWorker: ImageWorkerContract {
    static let shared = ImageWorker()

    private let session: URLSession
    private let cache: NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL, UIImage>()
        cache.countLimit = 200 // 200 images
        cache.totalCostLimit = 10 * 1024 * 1024 // 10 MB
        return cache
    }()

    init(session: URLSession = .shared) {
        self.session = session
    }

    func loadImage(from url: URL) async -> UIImage? {
        if let cached = cache.object(forKey: url as NSURL) {
            return cached
        }
        guard
            let (data, _) = try? await session.data(from: url),
            let image = UIImage(data: data)
        else { return nil }

        cache.setObject(image, forKey: url as NSURL, cost: data.count)
        return image
    }
}
