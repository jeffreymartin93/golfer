//
//  Player.swift
//  Golfer
//
//  Created by Jeff Martin on 10/21/23.
//

import Foundation
import SwiftData

@Model
class Player: Identifiable {
	var id = UUID()
	/// Name of the player
	var name: String
	/// Average of best 8 scores from 20 most recent games
	var handicap: Int
	
	init(id: UUID = UUID(), name: String, handicap: Int = 0) {
		self.id = id
		self.name = name
		self.handicap = handicap
	}
}
