//
//  GameView.swift
//  Golfer
//
//  Created by Jeff Martin on 10/22/23.
//

import SwiftUI
import SwiftData

struct GameView: View {
	@Binding var tabSelection: Int

	@Query var gameDocs: [GameDoc]
	var gameDoc: GameDoc! { gameDocs.first }
	var currentGame: Game? {
		gameDoc.currentGame
	}
	
	@State var currentHoleText: String = "Hole"
	@State var currentHolePar: String = "Par 1"
	@State var currentHoleHandicap: String = ""
	
	/// Bool that if true we can go back to a previous hole or false if we are on the first hole
	@State var isPreviousHoleAvailable: Bool = false
	@State var showExitAlert: Bool = false
	@State var showCompleteAlert: Bool = false

	var body: some View {
		NavigationView {
			VStack {
				// Image View
				Image("Logo")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(height: 200)
					.safeAreaPadding(.top)
					.padding(.top)
				
				Text(currentHoleText)
					.font(.title)
				
				// Text Fields for "par 4"
				HStack(alignment: .center) {
					Text(currentHolePar)
						.font(.headline)
					Text(currentHoleHandicap)
						.font(.headline)
				}
				.padding(.leading)
				.padding(.trailing)
				
				// Table View
				List(gameDoc.players(for: currentGame?.scoreCard.players ?? [])) { player in
					let currentCourse = gameDoc.course(for: currentGame!.courseId)!
					let handicap = currentCourse.handicap(for: player)
					let scoreCard = currentGame!.currentScore(for: player, course: currentCourse)!
					let holeScore = currentGame!.currentScore(
						for: player,
						at: currentGame!.currentHole,
						course: currentCourse
					)
					
					VStack {
						HStack {
							VStack(alignment: .leading) {
								Text(player.name)
									.font(.headline)
								Text("Course Handicap \(handicap)")
									.font(.subheadline)
								Text("\(scoreCard.totalStrokes) (\(scoreCard.score))")
									.font(.subheadline)
							}
							
							Spacer()
							
							Text("\(holeScore)").font(.largeTitle)
						}
						
						PlayerScorePicker(
							player: player,
							currentHole: currentGame!.currentHole,
							holeScore: holeScore,
							game: currentGame!
						)
					}
					.listRowBackground(Color.clear)
				}
				.listStyle(PlainListStyle())
			}
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					let currentHole = currentGame?.currentHole ?? -1
					let numberOfHoles = currentGame?.scoreCard.numberOfHoles ?? -1
					let text = currentHole == (numberOfHoles - 1) ? "Finish Game" : "Next Hole"
					Button(text) {
						if currentHole == (numberOfHoles - 1) {
							// finish game
							showCompleteAlert = true
						} else {
							// Handle Next Hole button action
							currentGame?.currentHole += 1
							isPreviousHoleAvailable = true
							updateUI()
						}
					}
				}
				
				ToolbarItem(placement: .navigationBarLeading) {
					let text = isPreviousHoleAvailable ? "Previous Hole" : ""
					Button(text) {
						if isPreviousHoleAvailable {
							currentGame?.currentHole -= 1
							isPreviousHoleAvailable = currentGame?.currentHole != 0
							updateUI()
						}
					}
				}
				
				ToolbarItem(placement: .navigationBarLeading) {
					Button("Quit") {
						showExitAlert = true
					}
				}
			}
			.background(Color(red: 0.67, green: 0.96, blue: 0.95))
		}
		.alert("", isPresented: $showExitAlert, actions: {
			Button("OK", role: .destructive) {
				gameDoc.currentGame = nil
				showExitAlert = false
			}
			Button("Cancel", role: .cancel) {
				showExitAlert = false
			}
		}, message: {
			Text("If you exit the game all data will be lost")
		})
		.alert("", isPresented: $showCompleteAlert, actions: {
			Button("Continue") {
				showCompleteAlert = false
				tabSelection = 3
				gameDoc.completeGame()
			}
			Button("Cancel", role: .cancel) {
				showCompleteAlert = false
			}
		}, message: {
			Text("Are you sure you are ready to complete the game?")
		})
		.onAppear {
			updateUI()
		}
	}
	
	private func updateUI() {
		guard let game = currentGame, let currentCourse = gameDoc.course(for: game.courseId) else {
			currentHoleText = "Error"
			currentHolePar = ""
			currentHoleHandicap = ""
			gameDoc.completeGame()
			return
		}
		
		let currentHole = currentCourse.sortedHoles[game.currentHole]
		currentHoleText = "Hole \(currentHole.index + 1)"
		currentHolePar = "Par \(currentHole.par)"
		currentHoleHandicap = "Handicap \(currentHole.handicap)"
	}
}

fileprivate struct ScoreRowItem {
	let player: Player
	let course: Course
	let currentGame: Game
}


struct PlayerScorePicker: View {
	var player: Player
	var currentHole: Int
	var holeScore: Int
	var game: Game
	
	@State private var selectedCategoryIndex: Int = -1

	var body: some View {
		Picker("", selection: $selectedCategoryIndex) {
			if holeScore > 0 {
				Image(systemName: "minus.circle.fill").tag(0)
				Image(systemName: "0.circle.fill").tag(1)
			}
			Image(systemName: "plus.circle.fill").tag(2)
		}
		.pickerStyle(SegmentedPickerStyle())
		.selectionDisabled(true)
		.onChange(of: selectedCategoryIndex) { oldValue, newValue in
			if selectedCategoryIndex != -1 {
				let newScore: Int = {
					switch selectedCategoryIndex {
					case 0:
						return holeScore - 1
					case 1:
						return 0
					case 2:
						return holeScore + 1
					default:
						return holeScore
					}
				}()
				
				game.scoreCard.updateScore(
					for: player,
					hole: currentHole,
					finalScore: newScore
				)

				selectedCategoryIndex = -1
			}
		}
	}
}
