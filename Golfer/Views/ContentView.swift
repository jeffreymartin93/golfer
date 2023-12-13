//
//  ContentView.swift
//  Golfer
//
//  Created by Jeff Martin on 10/21/23.
//

import SwiftUI
import SwiftData

/// Main Content View
struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	@Query var gameDocs: [GameDoc]
	
	/// The current tab selection
	@State var tabSelection: Int = 0
	
	var body: some View {
		TabView(selection: $tabSelection) {
			GameTabView(tabSelection: $tabSelection).tabItem {
				Text("Game")
				Image(systemName: "flag.2.crossed.fill")
			}.tag(0)
			
			PlayerTabView().tabItem {
				Text("Players")
				Image(systemName: "person.3.fill")
			}.tag(1)
			
			CourseTabView().tabItem {
				Text("Courses")
				Image(systemName: "globe.americas.fill")
			}.tag(2)
			
			PreviousGamesTabView().tabItem {
				Text("Previous Games")
				Image(systemName: "externaldrive.fill.badge.timemachine")
			}.tag(3)
		}
	}
}

/// Background view that has our app colors and logo
public struct BackgroundView <Content : View> : View {
	public var content : Content
	public var imageName: String
	public var opacity: Double
	public init(imageName: String, opacity: Double=1,@ViewBuilder content: () -> Content) {
		self.content = content()
		self.imageName = imageName
		self.opacity = opacity
	}
	
	public var body: some View {
		GeometryReader { geo in
			ZStack {
				Image(imageName)
					.resizable()
					.scaledToFill()
					.edgesIgnoringSafeArea(.all)
					.frame(width: geo.size.width, height: geo.size.height + 25, alignment: .center)
					.opacity(opacity)
				content
			}
		}
	}
}

