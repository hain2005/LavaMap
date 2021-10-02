//
//  CameraView.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Hai Nguyen on 9/24/21.
//

import SwiftUI
import camera
import Combine

class ProgressItem: ObservableObject {
    @Published var progressValue: Progress = Progress(totalUnitCount: 0)
}

struct CameraView: View {
    
    // MARK: - Environments
    @Environment(\.presentationMode) var presentationMode

    // MARK: - States
    @State var pictureTakenCount: Int = 0
    @State var fileURL: URL
    @State private var timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var isCompression: Bool = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var subscription: AnyCancellable?

    // MARK: - ObservedObject
    @ObservedObject var progress = ProgressItem()
    
    // MARK: - Bindings
    let maxPicturesAllow = Int.random(in: 3...8)

    // MARK: - Body
    var body: some View {
        VStack {
            if pictureTakenCount == maxPicturesAllow {
                Text("Session is completed.".localized)
                    .padding(.bottom, 5)
            } else {
                VStack {
                    Text("Picture(s) taken: %@".localized(with: String(pictureTakenCount)))
                    Text("(max %@ pictures)".localized(with: String(maxPicturesAllow)))
                }
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
                if pictureTakenCount > 0 {
                    NavigationLink(destination: ShowPictureView(pictureURL: fileURL)) {
                        Text("Verify".localized)
                    }
                }
            }
            CameraControllerRepresentable(pictureTakenCount: $pictureTakenCount, fileURL: $fileURL)
                    .scaledToFill()
                    .padding(0)
            if isCompression {
                VStack {
                    ProgressView("Compressing …".localized)
                        .frame(width: 350, height: 40)
                        .onAppear {
                            let dirUrl = fileURL.deletingLastPathComponent
                            DispatchQueue.main.async {
                                ArchiveManager.shared.zip(directoryUrl: dirUrl(), progress: &progress.progressValue, overwrite: true) { result in
                                    showAlert = true
                                    isCompression = false
                                    switch result{
                                    case .success(_):
                                        alertMessage = "Compression is completed.".localized
                                    case .failure(_):
                                        alertMessage = "Compression failed, please try again.".localized
                                    }
                                }
                            }
                        }
                }

            } else {
                Button("Compress Last Session".localized) {
                    if pictureTakenCount > 0 {
                        isCompression = true
                    }
                }
                .padding(.top, 5)
                .foregroundColor(Color.appLabel)
                .frame(width: 250, height: 50)
                .background(Color.appButtonBackground)
                .font(.system(size: 20))
                .cornerRadius(5)
                .alert(isPresented: $showAlert) { () -> Alert in
                    Alert(title: Text(alertMessage),dismissButton: Alert.Button.default(
                        Text("OK"), action: { presentationMode.wrappedValue.dismiss()}
                    ))
                }
            }
        }
        .padding(0)
        .onChange(of: pictureTakenCount) { newValue in
            if newValue == maxPicturesAllow {
                self.timer = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
            }
        }
        .onReceive(timer) { input in
            self.timer.upstream.connect().cancel()
            presentationMode.wrappedValue.dismiss()
        }
        .onAppear() {
            self.timer.upstream.connect().cancel()
            self.subscription = progress.$progressValue
                .sink { progress in
                    if showAlert {
                        self.subscription?.cancel()
                    }
                }
        }
        .padding(0)
     }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(pictureTakenCount: 0, fileURL: URL(fileURLWithPath: ""))
    }
}
