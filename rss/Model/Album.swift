import Foundation

final class Album: Codable {

    // MARK: - Properties

    /// Empty, placeholder album.
    static var empty: Album = Album()

    let artistName: String?
    let id: String?
    let releaseDate: String?
    let name: String?
    let kind: String?
    let copyright: String?
    let artistId: String?
    let artistUrl: String?
    let artworkUrl100: String?
    let genres: [Genre]?
    let url: String?
    var updatedImageCompletion: (() -> Void)?

    /// Optional image data for the album artwork.
    var artworkData: Data? {
        didSet {
            if let completion = updatedImageCompletion {
                completion()
                updatedImageCompletion = nil
            }
        }
    }

    func setUpdatedImageCompletion(_ completion: (() -> Void)?) {
        if artworkData != nil {
            completion?()
        } else {
            updatedImageCompletion = completion
        }
    }

    // MARK: - Codable

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
        genres = try values.decodeIfPresent([Genre].self, forKey: .genres)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

    init() {
        artistName = nil
        id = nil
        releaseDate = nil
        name = nil
        kind = nil
        copyright = nil
        artistId = nil
        artistUrl = nil
        artworkUrl100 = nil
        genres = nil
        url = nil
    }
}
