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

        configureContainerView()
        configurelyricsTextView()

        guard track != nil else { return }
        getTrackLyrics(track: track!) { (trackLyrics) in
            if let lyrics = trackLyrics {
                self.lyricsTextView.text = lyrics
                self.updateContainerViewHeight()
            }
            DispatchQueue.main.async {
                self.removeLoadingSpinner()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        self.showLoadingSpinner()
    }

    @objc func dismissSelf() {
        self.dismiss(animated: true)
    }

    var lyricsTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        textView.textAlignment = .center
        textView.isScrollEnabled = true
        return textView
    }()

    var containerView: UIView = {
        let view = UIView()
        return view
    }()

    func configureContainerView() {
        view.addSubview(containerView)
        setContainerViewConstraints()
    }

    func configurelyricsTextView() {
        view.addSubview(lyricsTextView)
        setLyricsTextViewConstraints()
    }

    func setContainerViewConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
                            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)

        ]

        NSLayoutConstraint.activate(constraints)
    }

    func setLyricsTextViewConstraints() {
        lyricsTextView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [ lyricsTextView.topAnchor.constraint(equalTo: containerView.topAnchor),
                            lyricsTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
                            lyricsTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                            lyricsTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    func updateContainerViewHeight() {
        containerViewHeight = DynamicTextViewSize.height(text: lyricsTextView.text, font: lyricsTextView.font!, width: (view.frame.width-40))
        containerView.heightAnchor.constraint(equalToConstant: containerViewHeight*2).isActive = true
        containerView.layoutIfNeeded()
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
            }
            completion(nil)
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
