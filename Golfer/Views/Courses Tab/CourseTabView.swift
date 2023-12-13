//
//  CourseView.swift
//  Golfer
//
//  Created by Jeff Martin on 12/6/23.
//

import Foundation
import SwiftUI
import SwiftData

/// This is a view used in the tabview of the app
/// This view is to show all the course we have and have the ability to create courses
struct CourseTabView: View {
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
						CreateCourseView()
					} label: {
						Image(systemName: "plus.circle.fill")
							.font(.title)
							.foregroundColor(.blue)
					}
					.padding(.leading, -8)
					.padding(.trailing)
				}
				
				List(filteredCourses()) { course in
					Text(course.name)
				}
				.listStyle(PlainListStyle())
				.background(Color.clear)
			}
		}
	}
	
	/// Filters the courses based on the value in the searchbar
	/// - Returns: Array of courses that match the filters
	func filteredCourses() -> [Course] {
		if searchText.isEmpty {
			return gameDoc.courses
		} else {
			return gameDoc.courses.filter { course in
				return course.name.localizedCaseInsensitiveContains(searchText)
			}
		}
	}
}
