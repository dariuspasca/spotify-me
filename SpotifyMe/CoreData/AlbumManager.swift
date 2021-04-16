//
//  AlbumManager.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 31/03/21.
//

import Foundation
import CoreData
import os.log

class AlbumManager {
    let mainContext: NSManagedObjectContext // Reading
    let backgroundContext: NSManagedObjectContext // Writing

    // MARK: - INIT

    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext ) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }

    // MARK: - CREATE

    func createAlbum(album: SimplifiedAlbum, type: String = "private") {
        backgroundContext.performAndWait {
            let newAlbum = Album(context: backgroundContext)
            newAlbum.albumType = album.type
            newAlbum.href =  album.href
            newAlbum.id = album.id
            newAlbum.name = album.name
            newAlbum.type = type
            newAlbum.uri = album.uri
            newAlbum.releaseDate = album.releaseDate

            if let coverImage = album.images.first {
                newAlbum.coverImage = coverImage.url
            }

            do {
                try self.backgroundContext.save()
            } catch {
                os_log("Failed to create new album with error: %@", type: .error, String(describing: error))
            }
        }
    }

    func upsertAlbum(album: SimplifiedAlbum, type: String = "private") {
        if let currentAlbum = self.fetchAlbum(withId: album.id) {
            currentAlbum.href =  album.href
            currentAlbum.id = album.id
            currentAlbum.name = album.name
            currentAlbum.type = type
            currentAlbum.uri = album.uri
            currentAlbum.releaseDate = album.releaseDate

            if currentAlbum.type != type {
                currentAlbum.type = "\(currentAlbum.type!) \(type)"
            }

            self.updateAlbum(album: currentAlbum)

        } else {
            createAlbum(album: album, type: type)
        }
    }

    // MARK: - UPDATE

    func updateAlbum(album: Album) {
        backgroundContext.performAndWait {

            do {
                try self.backgroundContext.save()
            } catch {
                os_log("Failed to update album with error: %@", type: .error, String(describing: error))
            }
        }

    }

    // MARK: - Fetch

    func fetchAlbum(withId id: String) -> Album? {
        do {
            let fetchRequest = NSFetchRequest<Album>(entityName: "Album")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            var album: Album?

            mainContext.performAndWait {
                do {
                    album = try self.mainContext.fetch(fetchRequest).first
                } catch {
                    os_log("Failed to fetch album with error: %@", type: .error, String(describing: error))
                }
            }
            return album
        }
    }

    func fetchAlbums(withType type: String) -> [Album]? {
        do {
            let fetchRequest = NSFetchRequest<Album>(entityName: "Album")
            fetchRequest.predicate = NSPredicate(format: "type == %@", type)
            var albums: [Album]?

            mainContext.performAndWait {
                do {
                    albums = try self.mainContext.fetch(fetchRequest)
                } catch {
                    os_log("Failed to fetch albums with error: %@", type: .error, String(describing: error))
                }
            }
            return albums
        }
    }

}
