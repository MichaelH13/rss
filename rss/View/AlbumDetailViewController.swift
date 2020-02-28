//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import UIKit

/// Class to show details of a given album.
class AlbumDetailViewController: UIViewController {

    // MARK: - Inits

    init(viewModel: AlbumDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
    }

    required init?(coder: NSCoder) {
        self.viewModel = AlbumDetailViewModel(Album.empty)
        super.init(coder: coder)
    }

    // MARK: - Properties

    private let viewModel: AlbumDetailViewModel

    private let padding: CGFloat = 20

    private let scrollView = UIScrollView()

    private let coverArtImageView = UIImageView()

    private let titleTextLabel = UILabel()

    private let artistNameTextLabel = UILabel()

    private let genreTextLabel = UILabel()

    private let releaseDateTextLabel = UILabel()

    private let copyrightTextLabel = UILabel()

    private let showOnITunesButton = UIButton(type: .roundedRect)
}

// MARK: - View Controller Lifecycle

extension AlbumDetailViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}

// MARK: - Layout

extension AlbumDetailViewController {

    private func setupViews() {
        view.backgroundColor = .systemGray6
        setupScrollView()
        setupCoverArtImageView()
        setupTitleTextLabel()
        setupArtistNameTextLabel()
        setupGenreTextLabel()
        setupReleaseDateTextLabel()
        setupCopyrightTextLabel()
        setupShowOnITunesButton()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.scrollsToTop = true
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        let scrollGuide = scrollView.layoutMarginsGuide
        NSLayoutConstraint.activate([
            scrollGuide.leftAnchor.constraint(equalTo: guide.leftAnchor),
            scrollGuide.rightAnchor.constraint(equalTo: guide.rightAnchor),
            scrollGuide.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            scrollGuide.topAnchor.constraint(equalTo: guide.topAnchor)
        ])
    }

    private func setupCoverArtImageView() {
        coverArtImageView.translatesAutoresizingMaskIntoConstraints = false
        if let data = viewModel.album.artworkData {
            coverArtImageView.image = UIImage(data: data)
        }
        coverArtImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(coverArtImageView)
        let artworkGuide = coverArtImageView.layoutMarginsGuide

        NSLayoutConstraint.activate([
            artworkGuide.heightAnchor.constraint(equalTo: artworkGuide.widthAnchor, multiplier: 1.0),
            artworkGuide.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            artworkGuide.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: padding)
        ])
    }

    private func setupTitleTextLabel() {
        titleTextLabel.text = viewModel.album.name
        titleTextLabel.font = .preferredFont(forTextStyle: .title1)
        titleTextLabel.textColor = .label
        titleTextLabel.numberOfLines = 0
        titleTextLabel.textAlignment = .center

        attach(titleTextLabel, below: coverArtImageView)
    }

    private func setupArtistNameTextLabel() {
        artistNameTextLabel.text = viewModel.album.artistName
        artistNameTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        artistNameTextLabel.textColor = .label
        artistNameTextLabel.numberOfLines = 0
        artistNameTextLabel.textAlignment = .center

        attach(artistNameTextLabel, below: titleTextLabel)
    }

    private func setupGenreTextLabel() {

        // Worth a couple notes here:
        // 1. For localizations, Swift string interpolation does not work,
        //    therefore it's avoided and I use String(format:) to ensure the strings are properly localized.
        // 2. The plural case probably won't come up as I couldn't find an album genre list that
        //    didn't include "Music" in addition to a traditional genre.
        let releaseDateFormat = NSLocalizedString("Genre: %@", comment: "Genre: <Pop>")
        let releaseDateFormatPlural = NSLocalizedString("Genres: %@", comment: "Genres: <Pop, Music>")
        let genres = viewModel.album.genres
        let showPluralFormat = genres?.count ?? 0 > 1
        let releaseDate = genres?.compactMap({ (genre) -> String? in
            genre.name
        }).joined(separator: ", ") ?? NSLocalizedString("Unspecified", comment: "empty field value")
        genreTextLabel.text = String(format: showPluralFormat ? releaseDateFormatPlural : releaseDateFormat, releaseDate)
        genreTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        genreTextLabel.textColor = .label
        genreTextLabel.numberOfLines = 0
        genreTextLabel.textAlignment = .center

        attach(genreTextLabel, below: artistNameTextLabel)
    }

    private func setupReleaseDateTextLabel() {
        let releaseDateFormat = NSLocalizedString("Released %@", comment: "Released <localized-date>")
        let releaseDate = viewModel.album.releaseDate ?? NSLocalizedString("Unspecified", comment: "empty field value")
        releaseDateTextLabel.text = String(format: releaseDateFormat, releaseDate)
        releaseDateTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        releaseDateTextLabel.textColor = .label
        releaseDateTextLabel.numberOfLines = 0
        releaseDateTextLabel.textAlignment = .center

        attach(releaseDateTextLabel, below: genreTextLabel)
    }

    private func setupCopyrightTextLabel() {
        // Worth a note here: For localizations, Swift string interpolation does not work,
        // therefore it's avoided and I use String(format:) to ensure the strings are properly localized.
        copyrightTextLabel.text = viewModel.album.copyright
        copyrightTextLabel.font = .preferredFont(forTextStyle: .subheadline)
        copyrightTextLabel.textColor = .label
        copyrightTextLabel.numberOfLines = 0
        copyrightTextLabel.textAlignment = .center

        attach(copyrightTextLabel, below: releaseDateTextLabel)
    }

    private func setupShowOnITunesButton() {
        showOnITunesButton.translatesAutoresizingMaskIntoConstraints = false
        showOnITunesButton.setTitle(NSLocalizedString("Show on iTunes", comment: "button title"), for: .normal)
        showOnITunesButton.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        showOnITunesButton.titleLabel?.numberOfLines = 0
        showOnITunesButton.titleLabel?.textAlignment = .center
        showOnITunesButton.titleLabel?.textColor = .systemBlue
        showOnITunesButton.backgroundColor = .systemGray6
        showOnITunesButton.addTarget(self, action: #selector(showOnITunesAction), for: .touchUpInside)

        view.insertSubview(showOnITunesButton, aboveSubview: scrollView)
        let ctaGuide = showOnITunesButton.layoutMarginsGuide
        NSLayoutConstraint.activate([
            ctaGuide.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -padding),
            ctaGuide.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: padding),
            ctaGuide.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -padding)
        ])
    }
}

// MARK: - Helpers

extension AlbumDetailViewController {

    private func attach(_ view: UIView, below: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false

        below.superview?.addSubview(view)

        let viewGuide = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            viewGuide.topAnchor.constraint(equalTo: below.bottomAnchor, constant: padding),
            viewGuide.leftAnchor.constraint(equalTo: guide.leftAnchor, constant: padding),
            viewGuide.rightAnchor.constraint(equalTo: guide.rightAnchor, constant: -padding)
        ])
    }
}

// MARK: - Actions

extension AlbumDetailViewController {

    @objc private func showOnITunesAction() {
        guard let urlString = viewModel.album.url,
            let url = URL(string: urlString) else {
                Logger.log(.error, message: "Can't open \(String(describing: viewModel.album.url))")
                return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            Logger.log(.error, message: "Can't open \(url)")
        }
    }
}
