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

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureViews()

        populateTopTracks()
        populateFeaturedPlaylists()
        populateNewReleases()

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
            artistCell?.set(artist: "Test Artist")
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

    func populateTopTracks() {
        DownloadManager.shared.downloadPlaylist(url: SpotifyEndpoint.playlist(global50PlaylistId).url) { res in
            switch res {
            case .success:
                DownloadManager.shared.downloadTracks(playlist: self.global50PlaylistId) { (res) in
                    switch res {
                    case .success:
                        let playlist = self.playlistManager.fetchPlaylist(withId: self.global50PlaylistId)
                        self.topTracks = playlist!.tracks?.allObjects as? [Track]
                        DispatchQueue.main.async {
                            self.topTracksTableView.reloadData()
                        }
                        self.populatePopularArtists()
                    case .failure:
                        print("uff")
                    }
                }
            case .failure:
                // should handle error
                print("Failed to get global50 playlist")
            }
        }
    }

    func populateFeaturedPlaylists() {
        DownloadManager.shared.downloadFeaturedPlaylists(url: SpotifyEndpoint.featuredPlaylists.url) { (res) in
            switch res {
            case .success:
                self.featuredPlaylists = self.playlistManager.fetchPlaylists(withType: "featured")
                DispatchQueue.main.async {
                    self.featuredPlaylistsCollectionView.reloadData()
                }
            case .failure:
                // should handle error
                print("Failed to get featured playlists")
            }
        }
    }

    func populateNewReleases() {
        DownloadManager.shared.downloadNewReleases(url: SpotifyEndpoint.newReleases.url) { (res) in
            switch res {
            case .success:
                self.newReleases = self.albumManager.fetchAlbums(withType: "newReleases")
                DispatchQueue.main.async {
                    self.newReleasesCollectionView.reloadData()
                }
            case .failure:
                // should handle error
                print("Failed to get new releases")
            }
        }
    }

    func populatePopularArtists() {
       
    }
}
