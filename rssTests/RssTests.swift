//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import XCTest
@testable import rss

enum JsonFile: String, CaseIterable {
    case valid = "Valid"
    case invalid = "Invalid"
    case missing = "Missing"
}

class RssTests: XCTestCase {

    func testAlbumTitle() {
        let response = loadResponse(.valid)
        let title = response?.feed?.title
        XCTAssert(title == "Top Albums", "Feed title is incorrect or missing: \(String(describing: title))")
    }

    func testAlbumsExist() {
        let expectedAlbumTotal = 100
        let response = loadResponse(.valid)
        let albumsExist = response?.feed?.albums?.count == expectedAlbumTotal
        XCTAssert(albumsExist, "Albums do not total \(expectedAlbumTotal)")
    }
}

// MARK: - Helpers

extension RssTests {

    private func loadResponse(_ jsonFile: JsonFile = .valid) -> FeedResponse? {

        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: jsonFile.rawValue, withExtension: "json"),
            let jsonData = try? Data(contentsOf: url) else {

                let response = JsonFile(rawValue: jsonFile.rawValue)
                if let response = response {
                    switch response {
                    case .valid:
                        XCTFail("Valid response detected as invalid: \(jsonFile.rawValue)")
                    case .invalid, .missing:
                        // Invalid detected as invalid.
                        break
                    }
                } else {
                    XCTFail("Unknown fileName: \(jsonFile.rawValue)")
                }
                return nil
        }

        let decoder = JSONDecoder()

        do {
            let response = try decoder.decode(FeedResponse.self, from: jsonData)
            return response
        } catch let error {
            XCTFail(error.localizedDescription)
        }

        return nil
    }
}
