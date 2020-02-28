import Foundation

final class FeedResponse: Codable {

    // MARK: - Properties

    let feed: Feed?

    // MARK: - Codable

	enum CodingKeys: String, CodingKey {
		case feed
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		feed = try values.decodeIfPresent(Feed.self, forKey: .feed)
	}
}
