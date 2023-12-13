//
//  PlayerView.swift
//  Golfer
//
//  Created by Jeff Martin on 12/6/23.
//

import Foundation
import SwiftUI
import SwiftData

/// This is a view used in the tabview of the app
/// This view is to show all the players we have and have the ability to create players
struct PlayerTabView: View {
	@Query var gameDocs: [GameDoc]
	var gameDoc: GameDoc! { gameDocs.first }
	
	/// The current search text in the search bar
	@State private var searchText = ""
	/// Flag where if true we are in the process of searching
	@State private var isSearching = false

	var body: some View {
		NavigationStack {
			VStack {
				HStack {
					SearchBar(text: $searchText)
					
					NavigationLink {
						CreatePlayerView(player: Player(name: ""), isNewPerson: true)
					} label: {
						Image(systemName: "plus.circle.fill")
							.font(.title)
							.foregroundColor(.blue)
					}
					.padding(.leading, -8)
					.padding(.trailing)
				}
				
				List(filteredPlayers()) { player in
					HStack {
						Text(player.name)
						Spacer()
					}
					.contentShape(Rectangle())
					.swipeActions(edge: .trailing) {
						NavigationLink {
							CreatePlayerView(player: player, isNewPerson: false)
						} label: {
							Label(
								"Edit",
								systemImage: "pencil"
							)
						}
					}
				}
				.listStyle(PlainListStyle())
				.background(Color.clear)
			}
		}
	}
	
	/// Filters the players based on the value in the searchbar
	/// - Returns: Array of players that match the filters
	func filteredPlayers() -> [Player] {
		if searchText.isEmpty {
			return gameDoc.players
		} else {
			return gameDoc.players.filter { player in
				return player.name.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
}
