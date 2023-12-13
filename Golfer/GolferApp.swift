//
//  GolferApp.swift
//  Golfer
//
//  Created by Jeff Martin on 10/21/23.
//

import SwiftUI
import SwiftData

class AppDelegate: NSObject, UIApplicationDelegate {
		
	static var orientationLock = UIInterfaceOrientationMask.portrait

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return AppDelegate.orientationLock
	}
}

@main
struct GolferApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

	static var defaultPlayers: [Player] = [
		Player(id: UUID(), name: "Jeff Martin", handicap: 2),
		Player(id: UUID(), name: "Emmett Martin", handicap: 8),
		Player(id: UUID(), name: "Allie Martin", handicap: 8),
		Player(id: UUID(), name: "Bre Martin", handicap: 5),
	]
	
	static var defaultCourses: [Course] = [
		Course(
			name: "Augusta National Golf Club",
			slopeRating: 140,
			courseRating: 78,
			holes: [
				Hole(index: 0, par: 4, handicap: 9),
				Hole(index: 1, par: 5, handicap: 1),
				Hole(index: 2, par: 3, handicap: 13),
				Hole(index: 3, par: 3, handicap: 15),
				Hole(index: 4, par: 4, handicap: 5),
				Hole(index: 5, par: 3, handicap: 17),
				Hole(index: 6, par: 4, handicap: 11),
				Hole(index: 7, par: 5, handicap: 3),
				Hole(index: 8, par: 4, handicap: 7),
				Hole(index: 9, par: 4, handicap: 6),
				Hole(index: 10, par: 4, handicap: 8),
				Hole(index: 11, par: 3, handicap: 16),
				Hole(index: 12, par: 5, handicap: 4),
				Hole(index: 13, par: 4, handicap: 12),
				Hole(index: 14, par: 5, handicap: 2),
				Hole(index: 15, par: 3, handicap: 18),
				Hole(index: 16, par: 4, handicap: 4),
				Hole(index: 17, par: 4, handicap: 10)
			]
		),
		Course(
			name: "St. Andrews Links - The Old Course",
			slopeRating: 135,
			courseRating: 73,
			holes: [
				Hole(index: 0, par: 4, handicap: 10),
				Hole(index: 1, par: 4, handicap: 6),
				Hole(index: 2, par: 5, handicap: 16),
				Hole(index: 3, par: 4, handicap: 8),
				Hole(index: 4, par: 4, handicap: 2),
				Hole(index: 5, par: 3, handicap: 12),
				Hole(index: 6, par: 4, handicap: 4),
				Hole(index: 7, par: 5, handicap: 14),
				Hole(index: 8, par: 4, handicap: 18),
				Hole(index: 9, par: 4, handicap: 15),
				Hole(index: 10, par: 3, handicap: 7),
				Hole(index: 11, par: 4, handicap: 3),
				Hole(index: 12, par: 4, handicap: 11),
				Hole(index: 13, par: 5, handicap: 1),
				Hole(index: 14, par: 4, handicap: 9),
				Hole(index: 15, par: 3, handicap: 13),
				Hole(index: 16, par: 4, handicap: 5),
				Hole(index: 17, par: 4, handicap: 17)
			]
		),
		Course(
			name: "Pebble Beach Golf Links",
			slopeRating: 144,
			courseRating: 75,
			holes: [
				Hole(index: 0, par: 4, handicap: 6),
				Hole(index: 1, par: 4, handicap: 10),
				Hole(index: 2, par: 4, handicap: 12),
				Hole(index: 3, par: 4, handicap: 16),
				Hole(index: 4, par: 3, handicap: 14),
				Hole(index: 5, par: 5, handicap: 2),
				Hole(index: 6, par: 3, handicap: 18),
				Hole(index: 7, par: 4, handicap: 4),
				Hole(index: 8, par: 4, handicap: 8),
				Hole(index: 9, par: 4, handicap: 3),
				Hole(index: 10, par: 4, handicap: 9),
				Hole(index: 11, par: 3, handicap: 17),
				Hole(index: 12, par: 4, handicap: 7),
				Hole(index: 13, par: 5, handicap: 1),
				Hole(index: 14, par: 4, handicap: 13),
				Hole(index: 15, par: 4, handicap: 11),
				Hole(index: 16, par: 3, handicap: 15),
				Hole(index: 17, par: 5, handicap: 5)
			]
		)
	]
	
    static var sharedModelContainer: ModelContainer = {
        let schema = Schema([
			GameDoc.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
	   
    var body: some Scene {
        WindowGroup {
			ContentView()
        }
		.modelContainer(GolferApp.sharedModelContainer)
    }
}
