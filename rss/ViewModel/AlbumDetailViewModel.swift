//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import Foundation

final class AlbumDetailViewModel: AlbumViewModel {

    init(_ album: Album) {
        self.album = album
    }

    var album: Album
}
