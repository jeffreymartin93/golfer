//
//  Course.swift
//  Golfer
//
//  Created by Jeff Martin on 10/21/23.
//

import Foundation
import SwiftData

@Model
class Course {
	
	static var `default`: Course {
		return Course(
			id: UUID(),
			name: "",
			slopeRating: 0,
			courseRating: 0,
			holes: []
		)
	}
	// MARK: - Variables
	
	/// The unquie ID for this golf course
	var id: UUID
	/// The name of the course
	var name: String
	/// The slope rating for the course
	var slopeRating: Int
	/// The course rating for the cours
	var courseRating: Int
	private var holes: [Hole]
	/// Each hole that is on this course sorted on index
	var sortedHoles: [Hole] {
		holes.sorted { $0.index < $1.index }
	}
		
	// MARK: - Convience Variables
	
	/// The total number of pars for each hole normally 72 for 18 hole course
	var par: Int {
		return sortedHoles.reduce(0) { partialResult, hole in
			return partialResult + hole.par
		}
	}
	
	/// The number of holes for this course
	var numberOfHoles: Int {
		return sortedHoles.count
	}
	
	init(
		id: UUID = UUID(),
		name: String,
		slopeRating: Int,
		courseRating: Int,
		holes: [Hole]
	) {
		self.id = id
		self.name = name
		self.slopeRating = slopeRating
		self.courseRating = courseRating
		self.holes = holes
	}
	
	// MARK: - Helper Functions
	
	/// Calculates the handicap for a given player on this course.
	/// The formula for the calculation is Persons Handicap index x (slope rating / 113) + (course rating - par)
	/// There is a max of 3 handicap shots per hole
	/// - Parameter player: The player we want to calculate the handicap for
	/// - Returns: The handicap for this player on this course
	func handicap(for player: Player) -> Int {
		if numberOfHoles > 9 {
			let calculation = (player.handicap * (slopeRating / 113)) + (courseRating - par)
			let max = numberOfHoles * 3
			// Take the min, either the calculated handicap or the max value of 3 * par
			return min(calculation, max)
		} else {
			let calculation = ((player.handicap / 2) * ((slopeRating / 2) / 113)) + ((courseRating / 2) - par)
			let max = numberOfHoles * 3
			// Take the min, either the calculated handicap or the max value of 3 * par
			return min(calculation, max)
		}
	}
		
	func currentScore(for player: Player, score: ScoreCard) -> Int {
		let scores = score.playerScores[player.id]
		var final: Int = 0
		sortedHoles.forEach { hole in
			let score = scores?[hole.index] ?? 0
			if score != 0 {
				final += score
			}
		}
		
		return final
	}
	
	func netScore(for player: Player, score: ScoreCard) -> Int {
		return currentScore(for: player, score: score) - player.handicap
	}
}
