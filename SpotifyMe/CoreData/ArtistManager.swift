//
//  ArtistManager.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 31/03/21.
//

import Foundation
import CoreData
import os.log

class ArtistManager {
    let mainContext: NSManagedObjectContext // Reading
    let backgroundContext: NSManagedObjectContext // Writing

    // MARK: - INIT

    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext ) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }

    // MARK: - CREATE

    func createArtist(artist: SimplifiedArtist) {
        backgroundContext.performAndWait {
            let newArtist = Artist(context: backgroundContext)
            newArtist.href = artist.href
            newArtist.id = artist.id
            newArtist.name = artist.name
            newArtist.type = artist.type
            newArtist.uri = artist.href

            do {
                try self.backgroundContext.save()
            } catch {
                os_log("Failed to create new artist with error: %@", type: .error, String(describing: error))
            }
        }
    }

    func upsertArtist(artist: SimplifiedArtist) {
        if let currentArtist = self.fetchArtist(withId: artist.id) {
            currentArtist.name = artist.name
            currentArtist.href = artist.href

            if let popularity = artist.popularity {
                currentArtist.popularity = Int16(popularity)
            }

            if let coverImage = artist.images {
                currentArtist.coverImage = coverImage[0].url
            }

            self.updateArtist(artist: currentArtist)
        } else {
            self.createArtist(artist: artist)
        }

    }

    // MARK: - UPDATE

    func updateArtist(artist: Artist) {
        backgroundContext.performAndWait {

            do {
                try self.backgroundContext.save()
            } catch {
                os_log("Failed to update artist with error: %@", type: .error, String(describing: error))
            }
        }

    }

    // MARK: - Fetch

    func fetchArtist(withId id: String) -> Artist? {
        do {
            let fetchRequest = NSFetchRequest<Artist>(entityName: "Artist")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            var artist: Artist?

            mainContext.performAndWait {
                do {
                    artist = try self.mainContext.fetch(fetchRequest).first
                } catch {
                    os_log("Failed to fetch artist with error: %@", type: .error, String(describing: error))
                }
            }
            return artist
        }
    }

    func fetchArtists(withIds ids: [String]) -> [Artist]? {
        do {
            let fetchRequest = NSFetchRequest<Artist>(entityName: "Artist")
            fetchRequest.predicate = NSPredicate(format: "id IN %@", ids)
            var artists: [Artist]?

            mainContext.performAndWait {
                do {
                    artists = try self.mainContext.fetch(fetchRequest)
                } catch {
                    os_log("Failed to fetch artists with error: %@", type: .error, String(describing: error))
                }
            }
            return artists
        }
    }

}
