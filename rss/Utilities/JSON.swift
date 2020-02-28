//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import Foundation

public typealias JSON = [String: Any]

/// Protocol to contain methods pertaining to handling JSON in the app.
protocol JsonConvertable {

    /// Returns a generic array of instances from a JSON payload.
    static func fromArray(_ jsonArray: [JSON]) -> [Self]

    /// Required to decode a JSON array payload in fromArray(:).
    static func from(json: JSON?) -> Self

    /// Returns a JSON representation of the instance.
    func toJson() -> JSON
}

extension JsonConvertable {

    // Default implementation, yay for generic algorithms.
    static func fromArray(_ jsonArray: [JSON]) -> [Self] {
        return jsonArray.map({ (json) -> Self in
            Self.from(json: json)
        })
    }
}
