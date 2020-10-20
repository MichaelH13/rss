//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import Foundation

final class AlbumCellViewModel: AlbumViewModelProtocol {

    // MARK: - Inits

    init(_ album: Album) {
        self.album = album
    }

    // MARK: - Properties

    var album: Album

    var textLabelTitle: String? {
        return album.name
    }

    var detailLabelTitle: String? {
        return album.artistName
    }

    var artworkImageData: Data? {
        return album.artworkData
    }
}
