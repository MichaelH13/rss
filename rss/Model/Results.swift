import Foundation

struct Results: Codable {
	let artistName: String?
	let id: String?
	let releaseDate: String?
	let name: String?
	let kind: String?
	let copyright: String?
	let artistId: String?
	let artistUrl: String?
	let artworkUrl100: String?
	let genres: [Genres]?
	let url: String?

	enum CodingKeys: String, CodingKey {
        case artistName
		case id
		case releaseDate
		case name
		case kind
		case copyright
		case artistId
		case artistUrl
		case artworkUrl100
		case genres
		case url
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		artistName = try values.decodeIfPresent(String.self, forKey: .artistName)
		id = try values.decodeIfPresent(String.self, forKey: .id)
		releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		kind = try values.decodeIfPresent(String.self, forKey: .kind)
		copyright = try values.decodeIfPresent(String.self, forKey: .copyright)
		artistId = try values.decodeIfPresent(String.self, forKey: .artistId)
		artistUrl = try values.decodeIfPresent(String.self, forKey: .artistUrl)
		artworkUrl100 = try values.decodeIfPresent(String.self, forKey: .artworkUrl100)
		genres = try values.decodeIfPresent([Genres].self, forKey: .genres)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}

}
