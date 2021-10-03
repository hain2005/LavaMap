//
//  ID3D_iOS_mid_level_SwiftUI_Test_03UITests.swift
//  ID3D iOS mid-level SwiftUI Test 03UITests
//
//  Created by Elliott Io on 5/14/21.
//

import XCTest

class ID3D_iOS_mid_level_SwiftUI_Test_03UITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLandingPage() throws {
        // UI tests must launch the application that they test.
        let cameraCard = app.buttons["ContentView_CameraButton"]
        XCTAssert(cameraCard.exists)
        
        let historyCard = app.buttons["ContentView_HistoryButton"]
        XCTAssert(historyCard.exists)
    }
    
    func testCameraPage() throws {
        // UI tests must launch the application that they test.
        waitAndTap(element: app.buttons["ContentView_CameraButton"])
        
        let takePictureButton = app.buttons["buttonTakePicture"]
        XCTAssert(takePictureButton.exists)
        
        let maximumPicturesAllowLabel = app.staticTexts["MaximumPicturesAllow"]
        XCTAssert(maximumPicturesAllowLabel.exists)

    }
    
    func testHistoryPage() throws {
        waitAndTap(element: app.buttons["ContentView_HistoryButton"])

        let maximumPicturesAllowLabel = app.staticTexts["HistoryLabel"]
        XCTAssert(maximumPicturesAllowLabel.exists)
    }

    func testTakePictures() throws {
        waitAndTap(element: app.buttons["ContentView_CameraButton"])

        let maximumPicturesAllowLabel = app.staticTexts["MaximumPicturesAllow"]
        XCTAssert(maximumPicturesAllowLabel.exists)

        let count = Int(maximumPicturesAllowLabel.label) ?? 1
        
        for _ in 0..<count {
            waitAndTap(element: app.buttons["buttonTakePicture"])
        }

        let sessionCompletedLabel = app.staticTexts["SessionCompletedLabel"]
        _ = sessionCompletedLabel.waitForExistence(timeout: 3)
        XCTAssert(sessionCompletedLabel.exists)
    }
    
    func waitAndTap(element: XCUIElement) {
        _ = element.waitForExistence(timeout: 5)
        element.tap()
    }
}
