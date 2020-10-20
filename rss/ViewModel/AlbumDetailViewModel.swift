//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import Foundation

final class AlbumDetailViewModel: AlbumViewModelProtocol {

    init(_ album: Album) {
        self.album = album
    }

    var album: Album
}
