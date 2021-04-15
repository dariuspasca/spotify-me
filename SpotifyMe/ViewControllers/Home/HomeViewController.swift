//
//  HomeViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 12/04/21.
//

import UIKit

class HomeViewController: UIViewController {

    let global50PlaylistId: String = "37i9dQZEVXbLiRSasKsNU9"

    var popularArtists: [Artist]?
    var topTracks: [Track]?
    var featuredPlaylists: [Playlist]?
    var newReleases: [Album]?

    var playlistManager = PlaylistManager()
    var albumManager = AlbumManager()
    var artistManager = ArtistManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViews()

        let dispatchGroup = DispatchGroup()

        // Weekly Top Tracks Table
        dispatchGroup.enter()
        populateTopTracks { (res) in
            dispatchGroup.enter()
            switch res {
            case .success:
                dispatchGroup.leave()
            case .failure(let err):
                // should handle error
                print("uff \(err)")
                dispatchGroup.leave()
            }
            dispatchGroup.leave()
        }

        // Featured Playlists Collection
        dispatchGroup.enter()
        populateFeaturedPlaylists { (res) in
            dispatchGroup.enter()
            switch res {
            case .success:
                dispatchGroup.leave()
            case .failure(let err):
                // should handle error
                print("uff \(err)")
                dispatchGroup.leave()
            }
            dispatchGroup.leave()
        }

        // New Releases Collection
        dispatchGroup.enter()
        populateNewReleases { (res) in
            dispatchGroup.enter()
            switch res {
            case .success:
                dispatchGroup.leave()
            case .failure(let err):
                // should handle error
                print("uff \(err)")
                dispatchGroup.leave()
            }
            dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) {
            self.newReleases = self.albumManager.fetchAlbums(withType: "newReleases")
            self.newReleasesCollectionView.reloadData()

            self.featuredPlaylists = self.playlistManager.fetchPlaylists(withType: "featured")
            self.featuredPlaylistsCollectionView.reloadData()

            let playlist = self.playlistManager.fetchPlaylist(withId: self.global50PlaylistId)
            self.topTracks = playlist!.tracks?.allObjects as? [Track]
            self.topTracksTableView.reloadData()

            // Popular Artists Collection
            self.populatePopularArtists { (res) in
                switch res {
                case .success(let artists):
                    self.popularArtists = self.artistManager.fetchArtists(withIds: artists)
                    self.popularArtistsCollectionView.reloadData()
                case .failure(let err):
                    // should handle error
                    print("uff \(err)")
                }
            }
        }

    }

    func configureViews() {
        configureScrollView()
        configurePopularArtistsCollectionView()
        configureFeaturedPlaylistCollectionView()
        configureTopTracksTableView()
        configureNewReleasesCollectionView()
    }

    // MARK: - NavigationBar

    func configureNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        ]
        self.navigationController?.navigationBar.topItem!.title = "MY MUSIC"
        self.navigationController?.navigationBar.barTintColor = .systemBackground
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    // MARK: - ScrollView

    var scrollView = UIScrollView()
    var contentView = UIView()

    // MARK: - PopularArtistsCollectionView

    var popularArtistsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    var popularArtistsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - FeaturedPlaylistCollectionView

    var featuredPlaylistsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    var featuredPlaylistsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - TopTracksTableView

    var topTracksTableView = UITableView()

    var topTracksLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - NewReleasesCollectionView

    var newReleasesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        return collectionView
    }()

    var newReleasesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .left
        label.textColor = UIColor(named: "dark_gray")
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

// MARK: - ScrollView

extension HomeViewController {

    func configureScrollView() {
        view.addSubview(scrollView)
        setScrollViewConstraints()

        scrollView.addSubview(contentView)
        setContentViewConstraints()
    }

    func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pin(to: view)
    }

    func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.pin(to: scrollView)
        let constraints = [
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - UICollectionView

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var itemsNumber: Int = 0
        switch collectionView {
        case popularArtistsCollectionView:
            if popularArtists != nil { itemsNumber = 10 }
        case featuredPlaylistsCollectionView:
            if featuredPlaylists != nil { itemsNumber = 10 }
        case newReleasesCollectionView:
            if newReleases != nil { itemsNumber = 10 }
        default:
            itemsNumber = 10
        }
        return itemsNumber
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case popularArtistsCollectionView:
            let artistCell = popularArtistsCollectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCell", for: indexPath) as? ArtistCollectionViewCell
            artistCell?.set(artist: popularArtists![indexPath.row])
            return artistCell!
        case featuredPlaylistsCollectionView:
            let playlistCell = featuredPlaylistsCollectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedPlaylistCell", for: indexPath) as? FeaturedPlaylistCollectionViewCell
            playlistCell?.set(playlist: featuredPlaylists![indexPath.row])
            return playlistCell!
        case newReleasesCollectionView:
            let releaseCell = newReleasesCollectionView.dequeueReusableCell(withReuseIdentifier: "NewReleaseCell", for: indexPath) as? NewReleaseCollectionViewCell
            releaseCell?.set(album: newReleases![indexPath.row])
            return releaseCell!
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat!
        var height: CGFloat!

        if collectionView == newReleasesCollectionView {
            width = collectionView.frame.width * 0.5 - 10 // minus insets
            height = collectionView.frame.width * 0.55
        } else {
            width = collectionView.frame.height * 0.9
            height = collectionView.frame.height * 0.9
        }
        return CGSize(width: width, height: height)
    }

}

// MARK: - Business Logic

extension HomeViewController {

    func populateTopTracks(completion: @escaping  ((Result<Void, Error>) -> Void)) {
        DownloadManager.shared.downloadPlaylist(url: SpotifyEndpoint.playlist(global50PlaylistId).url) { res in
            switch res {
            case .success:
                DownloadManager.shared.downloadTracks(playlist: self.global50PlaylistId) { (res) in
                    switch res {
                    case .success:
                        completion(.success(()))
                    case .failure(let err):
                        completion(.failure(err))
                    }
                }
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func populateFeaturedPlaylists(completion: @escaping  ((Result<Void, Error>) -> Void)) {
        DownloadManager.shared.downloadFeaturedPlaylists(url: SpotifyEndpoint.featuredPlaylists.url) { (res) in
            switch res {
            case .success:
                completion(.success(()))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func populateNewReleases(completion: @escaping  ((Result<Void, Error>) -> Void)) {
        DownloadManager.shared.downloadNewReleases(url: SpotifyEndpoint.newReleases.url) { (res) in
            switch res {
            case .success:
                completion(.success(()))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }

    func populatePopularArtists(completion: @escaping  ((Result<[String], Error>) -> Void)) {
        var artists: Set<String> = []

        for track in topTracks! {
            if let trackArtists = track.artists?.allObjects as? [Artist] {
                let artistsIds = trackArtists.map { ($0.id)}
                artistsIds.forEach { (artistId) in
                    artists.insert(artistId!)
                }
            }
        }
        let artistsList = artists.map { ($0) }
        DownloadManager.shared.downloadArtists(artists: artistsList) { (res) in
            switch res {
            case .success:
                completion(.success(artists.map { $0 }))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
}
