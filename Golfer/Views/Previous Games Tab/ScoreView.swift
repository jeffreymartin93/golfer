//
//  ScoreView.swift
//  Golfer
//
//  Created by Jeff Martin on 12/6/23.
//

import Foundation
import SwiftUI
import SwiftData

/// This is a view used in the tabview of the app
/// This view is to show the scorecard of a single game that was played
struct ScoreView: View {
	var game: Game
	var gameDoc: GameDoc
	
	var body: some View {
		let course = gameDoc.course(for: game.courseId)!
		ScrollView([.horizontal, .vertical]) {
			Grid(
				alignment: .topLeading,
				horizontalSpacing: 4,
				verticalSpacing: 4
			) {
				GridRow {
					HStack {
						Text("Hole")
						Spacer()
						Divider()
					}
					ForEach(0..<game.scoreCard.numberOfHoles) { hole in
						HStack {
							Text("\(hole + 1)")
							Spacer()
							Divider()
						}
					}
					HStack {
						Text("Out")
						Spacer()
						Divider()
					}
					Text("Net")
				}
				
				Divider()
					
				GridRow {
					HStack {
						Text("Par")
						Spacer()
						Divider()
					}
					ForEach(course.sortedHoles) { hole in
						HStack {
							Text("\(hole.par)")
							Spacer()
							Divider()
						}
					}
					HStack {
						Text("\(course.par)")
						Spacer()
						Divider()
					}
					Text("")
				}
					
				Divider()
				
				GridRow {
					HStack {
						Text("SI")
						Spacer()
						Divider()
					}
					ForEach(course.sortedHoles) { hole in
						HStack {
							Text("\(hole.handicap)")
							Spacer()
							Divider()
						}
					}
					HStack {
						Text("")
						Spacer()
						Divider()
					}
					Text("")
				}
					
				Divider()

				
				let players = gameDoc.players(for: game.scoreCard.players)
				ForEach(players) { player in
					// Row for each player
					GridRow {
						// Now need a column for each hole and the total and name
						HStack {
							Text(player.name)
							Spacer()
							Divider()
						}

						ForEach(0..<game.scoreCard.numberOfHoles) { hole in
							let score = game.scoreCard.playerScores[player.id]?[hole] ?? 0
							HStack {
								Text("\(score)")
								Spacer()
								Divider()
							}
						}
						
						HStack {
							Text("\(course.currentScore(for: player, score: game.scoreCard))")
							Spacer()
							Divider()
						}
						Text("\(course.netScore(for: player, score: game.scoreCard))")
					}
					
					Divider()
				}
			}
		}.padding()
	}
}
