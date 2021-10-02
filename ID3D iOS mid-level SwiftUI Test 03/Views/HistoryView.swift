//
//  HistoryView.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Hai Nguyen on 9/27/21.
//

import SwiftUI
import CoreData
import UIKit

struct HistoryView: View {
        
    // MARK: - States
    @State private var lists: [NSManagedObject]?
    
    // MARK: - ObservedObject
    @ObservedObject var viewModel = ImageViewModel()

    // MARK: - Body
    var body: some View {
        
        List {
            ForEach(viewModel.images, id: \.self) { object in
                let url = object.value(forKey: "url") as! URL
                if let imageData = try? Data(contentsOf: url) {
                    if let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    }
                }
            }
       }
        .onAppear() {
            viewModel.fetchImages()
        }
     }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
