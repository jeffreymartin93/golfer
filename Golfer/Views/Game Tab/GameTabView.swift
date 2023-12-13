//
//  GameTabView.swift
//  Golfer
//
//  Created by Jeff Martin on 12/6/23.
//

import Foundation
import SwiftUI
import SwiftData

struct GameTabView: View {
	@Environment(\.modelContext) private var modelContext
	@Binding var tabSelection: Int
	
	@Query var gameDocs: [GameDoc]
	var gameDoc: GameDoc! { gameDocs.first }

	@State private var pickingCourse: Bool = false
	@State private var pickingPlayers: Bool = false
	@State private var players: [Player] = []
	@State private var course: Course = Course.default
	
	var body: some View {
		if gameDocs.isEmpty {
			BackgroundView(imageName: "MainScreen") {}.onAppear {
				preload()
			}
		} else if let _ = gameDoc.currentGame {
			GameView(tabSelection: $tabSelection)
		} else {
			BackgroundView(imageName: "MainScreen") {
				VStack {
					Spacer()
					Button {
						pickingCourse = true
					} label: {
						Text("Get Started")
							.foregroundColor(.black)
							.bold()
							.padding(EdgeInsets(top: 18, leading: 52, bottom: 18, trailing: 52))
							.background(Color.white)
							.cornerRadius(10)
					}
					.padding(.bottom, 35)
				}
			}
			.sheet(isPresented: $pickingCourse, onDismiss: {
				if course.name != "" {
					pickingPlayers = true
				}
			}, content: {
				CourseSelectionView(selectedCourse: $course, isPresented: $pickingCourse)
			})
			.sheet(isPresented: $pickingPlayers, onDismiss: {
				if players.isEmpty {
					course = Course.default
					return
				}
				gameDoc.currentGame = Game(players: players, course: course)
			}, content: {
				PlayerSelectionView(players: $players, isPresented: $pickingPlayers)
			})
		}
	}
	
	func preload() {
		modelContext.insert(
			GameDoc(
				players: GolferApp.defaultPlayers,
				previousGames: [],
				courses: GolferApp.defaultCourses
			)
		)
	}
}
