//
//  CreatePlayerView.swift
//  Golfer
//
//  Created by Jeff Martin on 10/21/23.
//

import SwiftUI
import SwiftData

struct CreatePlayerView: View {
	@Query var gameDocs: [GameDoc]
	var gameDoc: GameDoc! { gameDocs.first }
	
	@Environment(\.dismiss) private var dismiss
	@State var player: Player
	@FocusState private var isFocused: Bool
	var isNewPerson: Bool
	var title: String {
		return isNewPerson ? "Add Person" : "Edit Person"
	}
	
	
	var body: some View {
		Form {
			Section(header: Text("Name")) {
				TextField("", text: $player.name).focused($isFocused)
			}
			Section(header: Text("Starting Handicap")) {
				TextField("0", value:$player.handicap, formatter: integerFormatter).keyboardType(.numberPad)
			}
		}
		.padding()
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(action: {
					if isNewPerson {
						gameDoc.players.append(player)
					}
					dismiss.callAsFunction()
				}) {
					Text(isNewPerson ? "Save" : "Update")
						.font(.body)
						.fontWeight(.semibold)
				}
			}
		}
		.navigationTitle(isNewPerson ? "New Player" : "Edit Player")
		.onAppear {
			isFocused = true
		}
	}
}

#Preview {
	CreatePlayerView(player: Player(id: UUID(), name: ""), isNewPerson: true)
}


