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

class ImageViewModel : ObservableObject {
    
    @Published var images = [NSManagedObject]() //[UIImage]()
        
    let managedObjectContext = PersistenceController.shared.container.viewContext

    func saveToCoreData(captureIndex: Int16, url: URL) {
        let picture = Capture(context: managedObjectContext)
        let uuid = UUID()
        picture.captureIndex = captureIndex
        picture.id = uuid
        picture.sessionId = uuid
        picture.timestamp = Date()
        picture.url = url
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving managed object context: \(error.localizedDescription)")
        }
    }
    
    func fetchImages(){
 
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
            self.images = result
        } catch {
            print("Unable to fetch managed objects")
        }

    }
    
}
