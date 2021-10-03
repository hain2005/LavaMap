//
//  ImageViewModel.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Hai Nguyen on 10/2/21.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

public enum CoreDataError: Error {
    case success
    case failedSaved
    case failedFetched
}

extension CoreDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .success:
            return "Image saved.".localized
        case .failedSaved:
            return "Image failed to save.".localized
        case .failedFetched:
            return "Failed to retrieve images".localized
        }
    }
}

public protocol ImageCoreData {
    func save(captureIndex: Int16, url: URL, completionHandler: @escaping (Result<Void,CoreDataError>) -> Void)
    func fetch(completionHandler: @escaping (Result<[UIImage],CoreDataError>) -> Void)
}

class ImageViewModel : ObservableObject, ImageCoreData {
    
    @Published var images = [UIImage]()
        
    let managedObjectContext = PersistenceController.shared.container.viewContext
    func save(captureIndex: Int16, url: URL, completionHandler: @escaping (Result<Void, CoreDataError>) -> Void) {
        
        let picture = Capture(context: managedObjectContext)
        let uuid = UUID()
        picture.captureIndex = captureIndex
        picture.id = uuid
        picture.sessionId = uuid
        picture.timestamp = Date()
        picture.url = url
        
        if localFileExists(url: url) {
            do {
                try managedObjectContext.save()
                completionHandler(.success(()))
            } catch {
                completionHandler(.failure(.failedSaved))
            }
        } else {
            completionHandler(.failure(.failedSaved))
        }
    }
    
    func localFileExists(url: URL) -> Bool {
        let filePath = url.path
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: filePath)
    }
    
    func fetch(completionHandler: @escaping (Result<[UIImage], CoreDataError>) -> Void) {
 
        images.removeAll()
        
        var result = [NSManagedObject]()

        do {
            
            // Create Fetch Request
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Capture")

            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)

            if let records = records as? [NSManagedObject] {
                result = records
            }
            
            for object in result {
                let url = object.value(forKey: "url") as! URL
                if let imageData = try? Data(contentsOf: url) {
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                    }
                }
            }
            completionHandler(.success(images))
        } catch {
            completionHandler(.failure(.failedFetched))
        }

    }
    
}
