//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import UIKit

/// Class to show a list of albums.
class AlbumListViewController: UITableViewController {

    // MARK: - Inits

    public init(viewModel: AlbumListViewModel) {
        albumListViewModel = viewModel
        super.init(style: .grouped)
    }

    required init?(coder: NSCoder) {
        self.albumListViewModel = AlbumListViewModel()
        super.init(coder: coder)
    }

    // MARK: - Properties

    private var albumListViewModel: AlbumListViewModel
}

// MARK: - View Controller Lifecycle

extension AlbumListViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

        DispatchQueue.main.async {
            self.tableView.backgroundColor = .systemGray6
        }

        Client.shared.queryTopAlbums { [weak self] (success, response, data) in
            guard success else {
                return
            }
            if let response = self?.feedResponse(from: data) {
                self?.albumListViewModel.rss = response

                DispatchQueue.main.async {
                    self?.title = self?.albumListViewModel.rss?.feed?.title
                    self?.tableView.reloadData()
                }

                self?.albumListViewModel.loadAlbumArtwork()

            } else {
                Logger.log(.error, message: "Couldn't decode response for albums")
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension AlbumListViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumListViewModel.shouldShowEmptyState() ? 1 : albumListViewModel.albums()?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard !albumListViewModel.shouldShowEmptyState() else {
            return UITableViewCell()
        }
        guard let albumCell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.reuseId, for: indexPath) as? AlbumCell else {
            return AlbumCell()
        }

        guard let album = albumListViewModel.album(for: indexPath) else {
            return albumCell
        }

        albumCell.viewModel.album = album
        albumCell.viewModel.album.setUpdatedImageCompletion({ [weak albumCell] in
            DispatchQueue.main.async {
                albumCell?.textLabel?.text = albumCell?.viewModel.album.name
                albumCell?.detailTextLabel?.text = albumCell?.viewModel.album.artistName
                if let data = albumCell?.viewModel.album.artworkData {
                    albumCell?.imageView?.image = UIImage(data: data)
                }
            }
        })

        return albumCell
    }
}

// MARK: - UITableViewDelegate

extension AlbumListViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let album = albumListViewModel.album(for: indexPath) else {
            return
        }

        navigationController?.pushViewController(AlbumDetailViewController(viewModel: AlbumDetailViewModel(album)), animated: true)
    }
}

// MARK: - Helpers

extension AlbumListViewController {

    private func feedResponse(from data: Data?) -> FeedResponse? {
        let jsonData = data
        if let jsonData = jsonData {
            let decoder = JSONDecoder()

            do {
                let response = try decoder.decode(FeedResponse.self, from: jsonData)
                return response
            } catch let error {
                Logger.log(message: error.localizedDescription)
            }
        } else {
            Logger.log(message: "Invalid response")
        }
        return nil
    }
}
