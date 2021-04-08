//
//  LyricsViewController.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 05/04/21.
//

import UIKit

class LyricsViewController: UIViewController {

    var track: Track?
    let downloadManager = DownloadManager()

    var containerViewHeight: CGFloat = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissSelf))

        configureScrollView()
        configurelyricsTextView()

        guard track != nil else { return }
        getTrackLyrics(track: track!) { (trackLyrics) in
            if let lyrics = trackLyrics {
                self.lyricsTextView.text = lyrics
                // self.updateContainerViewHeight()
            }
            DispatchQueue.main.async {
                self.removeLoadingSpinner()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.showLoadingSpinner()
    }

    @objc func dismissSelf() {
        self.dismiss(animated: true)
    }

    var scrollView = UIScrollView()
    var contentView = UIView()

    var lyricsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        return textView
    }()

    func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        setScrollViewConstraints()
        setContentViewConstraints()
    }

    func configurelyricsTextView() {
        contentView.addSubview(lyricsTextView)
        setLyricsTextViewConstraints()
    }

    func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func setContentViewConstraints() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func setLyricsTextViewConstraints() {
        lyricsTextView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [lyricsTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
                           lyricsTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                           lyricsTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                           lyricsTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

}

// MARK: - Lyrics

extension LyricsViewController {

    func getTrackLyrics(track: Track, completion: @escaping (String?) -> Void) {
        var trackArtists: String = ""
        if let artists = track.artists?.allObjects as? [Artist] {
            trackArtists = artists.map { ($0.name!)}.joined(separator: " ")
        }
        
        MusixmatchService.shared.getLyrics(name: track.name!, artist: trackArtists ) { (lyrics) in
            if let trackLyrics = lyrics, trackLyrics != "" {
                let cleanLyrics = self.clearLyricsFromWatermark(lyrics: trackLyrics)
                completion(cleanLyrics)
            } else {
                completion("🥲 No lyrics found")
            }
        }

    }

    func clearLyricsFromWatermark(lyrics: String) -> String {
        var newLyrics = lyrics
        if let indexOf = lyrics.range(of: "\n\n*******") {
            let start = lyrics.index(after: lyrics.startIndex)
            let end = indexOf.lowerBound
            newLyrics = String(lyrics[start..<end])
        }
        return newLyrics
    }
}
