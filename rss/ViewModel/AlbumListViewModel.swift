//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import Foundation

class AlbumListViewModel: AlbumListViewModelProtocol {

    // MARK: - Properties

    var rss: FeedResponse?

    var didSetFeed: (() -> Void)?

    func albums() -> [Album]? {
        return rss?.feed?.albums
    }

    func loadAlbumArtwork() {
        albums()?.forEach { (album) in

            if let artworkUrl = album.artworkUrl100,
                let url = URL(string: artworkUrl) {

                Client.shared.getData(from: url) { data, _, error in
                    guard let data = data,
                        error == nil else {
                        Logger.log(message: "Download finished with failure")
                        return
                    }
                    Logger.log(message: "Download finished successfully")

                    album.artworkData = data
                }
            } else {
                Logger.log(.error, message: "No url for \(String(describing: album.name))")
            }
        }
    }

    func shouldShowEmptyState() -> Bool {
        return albums()?.isEmpty ?? true
    }

    func album(for indexPath: IndexPath) -> Album? {
        assert(indexPath.row < albums()?.count ?? 0, "indexpath is greater than the album count")
        return albums()?[indexPath.row]
    }
}
