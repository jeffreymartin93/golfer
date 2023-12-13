//
//  PreviousGamesTabView.swift
//  Golfer
//
//  Created by Jeff Martin on 12/6/23.
//

import Foundation
import SwiftUI
import SwiftData

struct PreviousGamesTabView: View {
	@Query var gameDocs: [GameDoc]
	var gameDoc: GameDoc! { gameDocs.first }

	var body: some View {
		NavigationStack {
			let games = gameDoc.previousGames.sorted { $0.endDate! > $1.endDate! }
			List(games) { game in
				let coursName = gameDoc.course(for: game.courseId)?.name ?? ""
				NavigationLink {
					ScoreView(game: game, gameDoc: gameDoc)
				} label: {
					VStack(alignment: .leading) {
						Text("\(coursName)").lineLimit(1)
						Text("\(formattedDate(date: game.endDate!))").lineLimit(1)
						let players = gameDoc.players(for: game.scoreCard.players).map { $0.name }.joined(separator:
						", ")
						Text("\(players)").lineLimit(1)
					}
				}
			}
		}
	}
	
	func formattedDate(date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "E, d MMM y"
		return dateFormatter.string(from: date)
	}

}

