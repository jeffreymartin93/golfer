//
//  ScoreCard.swift
//  Golfer
//
//  Created by Jeff Martin on 10/21/23.
//

import Foundation
import SwiftData

@Model
class ScoreCard {
	/// Number of holes on the score card
	var numberOfHoles: Int
	/// Each individual players scores keyed off of the players Id
	var playerScores: [UUID: [Int: Int]]
	/// The players on the score card
	var players: [UUID]
	
	
	init(players: [Player], course: Course) {
		self.players = players.map { $0.id }
		self.numberOfHoles = course.numberOfHoles
		var scores = [UUID: [Int: Int]]()
		players.forEach {
			scores[$0.id] = [:]
		}
		self.playerScores = scores
	}
	
	/// Updates the score for a give player in the game
	/// - Parameters:
	///   - player: The player who we need to update their score
	///   - hole: The hole number for the score
	///   - finalScore: The final score for that hold
	func updateScore(
		for player: Player,
		hole: Int,
		finalScore: Int
	) {
		assert(playerScores[player.id] != nil, "A unknown player is attempting to score")
		playerScores[player.id]?[hole] = finalScore
	}
}
