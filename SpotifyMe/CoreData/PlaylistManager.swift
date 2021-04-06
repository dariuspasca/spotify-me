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

    func createPlaylist(playlist: SimplifiedPlaylist, userProfileId:NSManagedObjectID?) {
        backgroundContext.performAndWait {
            let newPlaylist = Playlist(context: backgroundContext)
            newPlaylist.id = playlist.id
            newPlaylist.name = playlist.name
            newPlaylist.desc = playlist.description
            newPlaylist.snapshotId = playlist.snapshotId
            newPlaylist.owner = playlist.owner.displayName
            newPlaylist.type = playlist.type

            if let coverImage = playlist.images {
                newPlaylist.coverImage = coverImage[0].url
            }

            if userProfileId != nil {
                let userProfile = backgroundContext.object(with: userProfileId!) as? UserProfile
                newPlaylist.users = NSSet.init(array: [userProfile!])
            }

            do {
                try self.backgroundContext.save()
                os_log("Playlist '%@' created", type: .info, String(describing: playlist.name))
            } catch {
                os_log("Failed to create new Playlist with error: %@", type: .error, String(describing: error))
            }
        }
    }

    // MARK: - UPDATE

    func updatePlaylist(playlist: Playlist) {
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

    func fetchPlaylist(withId id: String) -> Playlist? {
        do {
            let fetchRequest = NSFetchRequest<Playlist>(entityName: "Playlist")
            fetchRequest.predicate = NSPredicate(format: "id == %@", id)

            var playlist: Playlist?
            mainContext.performAndWait {
                do {
                    os_log("Fetching Playlist", type: .info)
                    playlist = try self.mainContext.fetch(fetchRequest).first
                } catch {
                    os_log("Failed to fetch Playlist", type: .info)
                }
            }

            return playlist
        }
    }

}
