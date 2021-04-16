//
//  PlaylistManager.swift
//  SpotifyMe
//
//  Created by Darius Pasca on 19/03/21.
//

import Foundation
import CoreData
import os.log

class PlaylistManager {
    let mainContext: NSManagedObjectContext // Reading
    let backgroundContext: NSManagedObjectContext // Writing

    // MARK: - INIT

    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext ) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }

    // MARK: - CREATE

    func createPlaylist(playlist: SimplifiedPlaylist, type: String = "private", userProfileId:NSManagedObjectID?) {
        backgroundContext.performAndWait {
            let newPlaylist = Playlist(context: backgroundContext)
            newPlaylist.id = playlist.id
            newPlaylist.name = playlist.name
            newPlaylist.desc = playlist.description
            newPlaylist.snapshotId = playlist.snapshotId
            newPlaylist.owner = playlist.owner.displayName
            newPlaylist.type = type

            if let coverImage = playlist.images {
                newPlaylist.coverImage = coverImage[0].url
            }

            if userProfileId != nil {
                let userProfile = backgroundContext.object(with: userProfileId!) as? UserProfile
                newPlaylist.users = NSSet.init(array: [userProfile!])
            }

            do {
                try self.backgroundContext.save()
            } catch {
                os_log("Failed to create new playlist with error: %@", type: .error, String(describing: error))
            }
        }
    }

    func upsertPlaylist(playlist: SimplifiedPlaylist, type: String = "private", userProfileId:NSManagedObjectID?) {
        if let currentPlaylist = self.fetchPlaylist(withId: playlist.id) {
            currentPlaylist.id = playlist.id
            currentPlaylist.name = playlist.name
            currentPlaylist.desc = playlist.description
            currentPlaylist.snapshotId = playlist.snapshotId
            currentPlaylist.owner = playlist.owner.displayName

            if currentPlaylist.type != type {
                currentPlaylist.type = "\(currentPlaylist.type!) \(type)"
            }

            if let coverImage = playlist.images {
                currentPlaylist.coverImage = coverImage[0].url
            }

            self.updatePlaylist(playlist: currentPlaylist)

        } else {
            self.createPlaylist(playlist: playlist, type: type, userProfileId: userProfileId)
        }

    }

    // MARK: - UPDATE

    func updatePlaylist(playlist: Playlist) {
        backgroundContext.performAndWait {

            do {
                try self.backgroundContext.save()
            } catch {
                os_log("Failed to update playlist with error: %@", type: .error, String(describing: error))
            }
        }
    }

    // MARK: - Fetch

    func fetchPlaylist(withId id: String) -> Playlist? {
        do {
            let fetchRequest = NSFetchRequest<Playlist>(entityName: "Playlist")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)

            var playlist: Playlist?
            mainContext.performAndWait {
                do {
                    playlist = try self.mainContext.fetch(fetchRequest).first
                } catch {
                    os_log("Failed to fetch playlist with error: %@", type: .error, String(describing: error))
                }
            }

            return playlist
        }
    }

    func fetchPlaylists(withType type: String) -> [Playlist]? {
        do {
            let fetchRequest = NSFetchRequest<Playlist>(entityName: "Playlist")
            fetchRequest.predicate = NSPredicate(format: "type == %@", type)

            var playlists: [Playlist]?
            mainContext.performAndWait {
                do {
                    playlists = try self.mainContext.fetch(fetchRequest)
                } catch {
                    os_log("Failed to fetch playlist with error: %@", type: .error, String(describing: error))
                }
            }

            return playlists
        }
    }

}
