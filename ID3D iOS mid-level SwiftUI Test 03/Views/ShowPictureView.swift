//
//  ShowPictureView.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Hai Nguyen on 10/2/21.
//

import SwiftUI

struct ShowPictureView: View {
    @State var pictureURL: URL
    var body: some View {
        if let imageData = try? Data(contentsOf: pictureURL) {
            let image = UIImage(data: imageData)
            VStack {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFill()
            }.padding(0)
        } else {
            Text("Can't view: \(pictureURL.absoluteString)")
        }
    }
}

struct ShowPictureView_Previews: PreviewProvider {
    static var previews: some View {
        ShowPictureView(pictureURL: URL(fileURLWithPath: ""))
    }
}
