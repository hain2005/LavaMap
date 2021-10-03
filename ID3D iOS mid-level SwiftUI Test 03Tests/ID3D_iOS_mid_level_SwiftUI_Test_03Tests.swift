//
//  ID3D_iOS_mid_level_SwiftUI_Test_03Tests.swift
//  ID3D iOS mid-level SwiftUI Test 03Tests
//
//  Created by Elliott Io on 5/14/21.
//

import XCTest
@testable import ID3D_iOS_mid_level_SwiftUI_Test_03

class ID3D_iOS_mid_level_SwiftUI_Test_03Tests: XCTestCase {

    internal class MockImageCoreData: ImageCoreData {
        func save(captureIndex: Int16, url: URL, completionHandler: @escaping (Result<Void,CoreDataError>) -> Void) {
            completionHandler(.success(()))
        }
        func fetch(completionHandler: @escaping (Result<[UIImage],CoreDataError>) -> Void) {
            if let image = UIImage(named: "swift") {
                completionHandler(.success([image]))
            } else {
                completionHandler(.failure(.failedFetched))
            }
        }
    }

    override func setUpWithError() throws {
        try super.setUpWithError()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testSuccessSave() throws {

        let imageViewModel = MockImageCoreData()
        imageViewModel.save(captureIndex: 1, url: URL(fileURLWithPath: "file://")) { result in
            switch result {
            case .success():
                XCTAssertTrue(true)
            case .failure(_):
                XCTFail("Bad url should not get a failed save.")
           }
        }
    }
    
    func testFailedSave() throws {
    
        let imageViewModel = ImageViewModel()
        imageViewModel.save(captureIndex: 1, url: URL(fileURLWithPath: "badurl")) { result in
            switch result {
            case .success():
                XCTFail("Bad url should not get successful save.")
            case .failure(let error):
                XCTAssertEqual(error, .failedSaved, "Failed saved with bad url")
           }
        }
    }

    func testFetchImage() throws {
        let mockImageCoreData = MockImageCoreData()
        mockImageCoreData.fetch { result in
            switch result {
            case .success(let images):
                XCTAssertEqual(images[0], UIImage(named: "swift"), "Failed saved with bad url")

            case .failure(_):
                XCTFail("Bad url should not get successful fetch.")
            }
        }
    }

}
