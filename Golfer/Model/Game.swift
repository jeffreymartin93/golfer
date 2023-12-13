//
//  Round.swift
//  Golfer
//
//  Created by Jeff Martin on 10/21/23.
//

import Foundation
import SwiftData

@Model
class Game {
	/// The Id that represents the game
	var id = UUID()
	/// The start date for the game
	var startDate: Date = Date()
	/// The score card for the game
	var scoreCard: ScoreCard
	/// The course this game is being played on
	var courseId: UUID
	/// Is the game marked as finished
	var endDate: Date?
	/// The current hole the players are playing on
	var currentHole: Int = 0
	
	init(
		players: [Player],
		course: Course
	) {
		self.courseId = course.id
		self.scoreCard = ScoreCard(players: players, course: course)
	}
	
	func currentScore(for player: Player, at hole: Int, course: Course) -> Int {
		guard let scoring = scoreCard.playerScores[player.id] else {
			return 0
		}
		
		return scoring[hole] ?? 0
	}
	
	func currentScore(for player: Player, course: Course) -> ScoringInfo? {
		guard let scoring = scoreCard.playerScores[player.id] else {
			return nil
		}
		
		let totalScore = scoring.values.reduce(0) { partialResult, score in
			return partialResult + score
		}
		
		return ScoringInfo(
			totalStrokes: totalScore,
			score: course.currentScore(for: player, score: scoreCard)
		)
	}
}


struct ScoringInfo {
	var totalStrokes: Int
	var score: Int
}
