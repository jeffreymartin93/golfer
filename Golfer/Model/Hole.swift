//
//  Hole.swift
//  Golfer
//
//  Created by Jeff Martin on 10/27/23.
//

import Foundation
import SwiftData

@Model
class Hole {
	/// The id that represents this hole
	let id: UUID
	/// The index for this give hole
	let index: Int
	/// The number of shots it should take to get the ball into the hole
	var par: Int
	/// The handicap for this hole
	var handicap: Int
	
	init(index: Int, par: Int, handicap: Int) {
		self.id = UUID()
		self.index = index
		self.par = par
		self.handicap = handicap
	}
}
