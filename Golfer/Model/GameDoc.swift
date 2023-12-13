//
//  GameDoc.swift
//  Golfer
//
//  Created by Jeff Martin on 10/26/23.
//

import Foundation
import SwiftData

@Model
class GameDoc {
	var players: [Player]
	var previousGames: [Game]
	var courses: [Course]
	var currentGame: Game?
	
	init(
		players: [Player],
		previousGames: [Game],
		courses: [Course]
	) {
		self.players = players
		self.previousGames = previousGames
		self.courses = courses
	}
	
	/// Completes the current game
	func completeGame() {
		guard let current = currentGame else {
			return
		}
		current.endDate = Date()
		
		// This game is over so add it to the list of previous games
		previousGames.append(current)
		
		// After every game recalculate the players handicaps
		players(for: current.scoreCard.players).forEach { player in
			recalculateHandicap(for: player)
		}
		currentGame = nil
	}
	
	/// Deletes a specific course from the database
	/// - Parameter course: The course to delete
	func deleteCourse(course: Course) {
		guard let index = courses.firstIndex(of: course) else {
			return
		}
		courses.remove(at: index)
	}
	
	/// Returns a list of players that match the list of UUIDs passed in
	func players(for ids: [UUID]) -> [Player] {
		return ids.compactMap { playerId in
			return players.first { player in
				player.id == playerId
			}
		}
	}
	
	/// Finds a course based on a UUID
	/// - Parameter id: The UUID of the course
	/// - Returns: The course object matching that ID
	func course(for id: UUID) -> Course? {
		return courses.first(where: { $0.id == id })
	}
	
	/// Recalculates a given players handicap based on their best games
	/// - Parameter player: The player to calculate the handicap for
	func recalculateHandicap(for player: Player) {
		let scores: [Int] = previousGames.compactMap { game in
			guard
				let course = self.course(for: game.courseId),
				let score = game.currentScore(for: player, course: course)?.score else {
				return nil
			}
			return score - course.par
		}.sorted(by: { lhs, rhs in
			return lhs > rhs
		})
		
		if scores.count > 8 {
			let firstEightScores = Array(scores.prefix(8))
			player.handicap = firstEightScores.reduce(0, { partialResult, info in
				partialResult + info
			}) / 8
		} else if scores.count > 2 {
			player.handicap = scores.reduce(0, { partialResult, info in
				partialResult + info
			}) / scores.count
		} else {
			print("We don't want to update this players handicap")
		}
	}
}
