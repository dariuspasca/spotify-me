//
//  TrackManager.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 20/03/21.
//

import Foundation
import CoreData
import os.log

class TrackManager {
    let mainContext: NSManagedObjectContext // Reading
    let backgroundContext: NSManagedObjectContext // Writing

    // MARK: - INIT

    // swiftlint:disable:next line_length
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext ) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }

    // MARK: - CREATE

    func createTrack(track: SimplifiedTrack) {
        backgroundContext.performAndWait {
            // Create album
            let album = Album(context: backgroundContext)
            album.albumType = track.album.type
            if let coverImage = track.album.images.first {
                album.coverImageUrl = coverImage.url
            }
            album.href =  track.album.href
            album.id = track.album.id
            album.name = track.album.name
            album.type = track.album.type
            album.uri = track.album.uri
            album.releaseDate = track.album.releaseDate

            // Create artist
            var artists:[Artist] = []
            for artist in track.artists {
                let newArtist = Artist(context: backgroundContext)
                newArtist.href = track.album.href
                newArtist.id = artist.id
                newArtist.name = artist.name
                newArtist.type = artist.type
                newArtist.uri = artist.href

                artists.append(newArtist)
            }

            let newTrack = Track(context: backgroundContext)
            newTrack.durationMs = Int16(track.durationMs)
            newTrack.href = track.href
            newTrack.id = track.id
            newTrack.name = track.name
            newTrack.popularity = Int16(track.popularity)
            newTrack.uri = track.uri

            newTrack.addToAlbums(album)
            newTrack.addToArtists(NSSet.init(array: artists))

            do {
                try self.backgroundContext.save()
                os_log("Playlist '%@' created", type: .info, String(describing: track.name))
            } catch {
                os_log("Failed to create new Playlist with error: %@", type: .error, String(describing: error))
            }
        }
    }

    // MARK: - UPDATE

    func updateTrack(playlist: Playlist) {
        backgroundContext.performAndWait {

            do {
                try self.backgroundContext.save()
                os_log("Playlist '%@' updated", type: .info, String(describing: playlist.name))
            } catch {
                os_log("Failed to update Playlist with error: %@", type: .error, String(describing: error))
            }
        }

    }

    // MARK: - Fetch

    func fetchTrack(withId id: String) -> Track? {
        do {
            let fetchRequest = NSFetchRequest<Track>(entityName: "Track")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)

            var track: Track?
            mainContext.performAndWait {
                do {
                    os_log("Fetching Track", type: .info)
                    track = try self.mainContext.fetch(fetchRequest).first
                } catch {
                    os_log("Failed to fetch Track", type: .info)
                }
            }

            return track
        }
    }

}
