//
//  PlayerSelectionView.swift
//  Golfer
//
//  Created by Jeff Martin on 10/21/23.
//

import SwiftUI
import SwiftData

struct PlayerSelectionView: View {
	@Binding var players: [Player]
	@Binding var isPresented: Bool

	@Query var gameDocs: [GameDoc]
	var gameDoc: GameDoc! { gameDocs.first }
	
	@State private var multiSelection = Set<UUID>()
	@State private var selectedPlayers = Set<UUID>()
	
	@State private var searchText = ""
	@State private var isSearching = false
	
	@State private var isNewPlayer = false {
		didSet {
			print(self.isNewPlayer)
		}
	}
	@State private var playerToEdit: Player?
	
		
	var body: some View {
		VStack {
			SearchBar(text: $searchText)
				
			List(filteredPlayers()) { player in
				HStack {
					Text(player.name)
					Spacer()
					if selectedPlayers.contains(player.id) {
						Image(systemName: "checkmark.circle.fill")
							.foregroundColor(.blue)
					}
				}
				.contentShape(Rectangle())
				.onTapGesture {
					toggleSelection(player)
				}
			}
			.listStyle(PlainListStyle())
			.background(Color.clear)
			
			if selectedPlayers.count > 1 {
				Spacer()
				
				Button {
					let gamePlayers = selectedPlayers.compactMap { uuid in
						return gameDoc.players.first { player in
							return player.id == uuid
						}
					}

					players = gamePlayers
					isPresented = false
				} label: {
					Text("Start Game")
						.foregroundColor(.black)
						.bold()
						.padding(EdgeInsets(top: 18, leading: 52, bottom: 18, trailing: 52))
						.background(Color.init(red: 0.67, green: 0.99, blue: 0.97) )
						.cornerRadius(10)
				}
			}
		}
		.padding(.top)
	}
	
	func filteredPlayers() -> [Player] {
		if searchText.isEmpty {
			return gameDoc.players
		} else {
			return gameDoc.players.filter { player in
				return player.name.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
	
	func toggleSelection(_ player: Player) {
		if selectedPlayers.contains(player.id) {
			selectedPlayers.remove(player.id)
		} else if selectedPlayers.count < 4 {
			selectedPlayers.insert(player.id)
		}
	}
}

struct SearchBar: View {
	@Binding var text: String
	
	var body: some View {
		HStack {
			TextField("Search", text: $text)
				.padding(7)
				.padding(.horizontal, 8)
				.background(Color(.systemGray6))
				.cornerRadius(8)
			
			Button(action: {
				text = ""
			}) {
				Image(systemName: "xmark.circle.fill")
					.opacity(text.isEmpty ? 0 : 1)
			}
			.padding(.leading, -40)
		}
		.padding(.leading)
	}
}
