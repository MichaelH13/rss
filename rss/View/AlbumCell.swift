//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import UIKit

/// Class to display an article as a tableview cell.
final class AlbumCell: UITableViewCell {

    // MARK: - Inits

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.viewModel = AlbumCellViewModel(Album.empty)
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator

        // Allow for accessibility sizes.
        self.textLabel?.adjustsFontForContentSizeCategory = true
        self.detailTextLabel?.adjustsFontForContentSizeCategory = true

        self.textLabel?.numberOfLines = 0
        self.detailTextLabel?.numberOfLines = 0

        self.textLabel?.font = .preferredFont(forTextStyle: .headline)
        self.detailTextLabel?.font = .preferredFont(forTextStyle: .subheadline)
    }

    required init?(coder aDecoder: NSCoder) {
        self.viewModel = AlbumCellViewModel(Album.empty)
        super.init(coder: aDecoder)
    }

    // MARK: - Properties

    var viewModel: AlbumCellViewModel

    /// Reuse id to register with the tableview.
    static let reuseId = "AlbumCellId"
}
