import Foundation

struct FeedResponse: Codable {
	let feed: Feed?

	enum CodingKeys: String, CodingKey {
		case feed
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		feed = try values.decodeIfPresent(Feed.self, forKey: .feed)
	}

}
