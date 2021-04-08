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

    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext, backgroundContext: NSManagedObjectContext = CoreDataStack.shared.backgroundContext ) {
        self.mainContext = mainContext
        self.backgroundContext = backgroundContext
    }

    // MARK: - CREATE

    func createTrack(track: SimplifiedTrack) {
        backgroundContext.performAndWait {
            let newTrack = Track(context: backgroundContext)
            newTrack.durationMs = Int64(track.durationMs)
            newTrack.href = track.href
            newTrack.id = track.id
            newTrack.name = track.name
            newTrack.popularity = Int16(track.popularity)
            newTrack.uri = track.uri

            do {
                try self.backgroundContext.save()
                os_log("Track '%@' created", type: .info, String(describing: track.name))
            } catch {
                os_log("Failed to create new track with error: %@", type: .error, String(describing: error))
            }
        }
    }

    // MARK: - UPDATE

    func updateTrack(track: Track) {
        backgroundContext.performAndWait {

            do {
                try self.backgroundContext.save()
                os_log("Track '%@' updated", type: .info, String(describing: track.name))
            } catch {
                os_log("Failed to update track with error: %@", type: .error, String(describing: error))
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
