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
        
    // MARK: - Environments
    @Environment(\.presentationMode) var presentationMode

    // MARK: - States
    @State private var fetched = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // MARK: - ObservedObject
    @ObservedObject var viewModel = ImageViewModel()

    // MARK: - Body
    var body: some View {
        VStack {
            Text("History")
                .accessibility(addTraits: .isStaticText)
                .accessibility(identifier: "HistoryLabel")
                .padding(.bottom, 5)
            List {
                ForEach(viewModel.images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                }
                .alert(isPresented: $showAlert) { () -> Alert in
                    Alert(title: Text(alertMessage),dismissButton: Alert.Button.default(
                        Text("OK".localized), action: { presentationMode.wrappedValue.dismiss()}
                    ))
                }
            }
            .onAppear() {
                viewModel.fetch { result in
                    switch result {
                    case .success( _):
                        fetched.toggle()
                    case .failure(let error):
                        self.showAlert = true
                        if let errorMessasge = error.errorDescription {
                            alertMessage = errorMessasge
                        }
                    }

                }
            }
            .padding(0)
        }
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
