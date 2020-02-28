//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import Foundation

struct Endpoint {

    private static let apiVersion = "v1"

    private static let apiBase = "https://rss.itunes.apple.com/api/\(apiVersion)/us/itunes-music/"

    struct Query {

        struct TopAlbums {
            private static let topBase = apiBase + "top-albums/"

            struct All {
                private static let allBase = topBase + "all/"

                public static let ten = allBase + "10/non-explicit.json"

                public static let hundred = allBase + "100/non-explicit.json"
            }
        }
    }
}
