//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import Foundation

protocol AlbumListViewModelProtocol {

    // MARK: - Properties

    /// The `FeedResponse` to display.
    var rss: FeedResponse? { get set }

    /// Closure to call after the feed is updated.
    var didSetFeed: (() -> Void)? { get set }

    /// - Returns: An optional arrary of albums received in the `FeedResponse`.
    func albums() -> [Album]?

    /// Queries the available `Album` artwork.
    func loadAlbumArtwork()

    /// - parameter indexPath  The `IndexPath` to fetch the `Album` to display
    ///
    /// - Returns: The `Album` to display for the given `IndexPath` passed as a parameter.
    func album(for indexPath: IndexPath) -> Album?

    /// - Returns: True if the empty state should be shown, false otherwise.
    func shouldShowEmptyState() -> Bool
}
