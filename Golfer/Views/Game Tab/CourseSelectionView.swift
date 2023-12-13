//
//  CourseSelectionView.swift
//  Golfer
//
//  Created by Jeff Martin on 10/27/23.
//

import SwiftUI
import SwiftData

struct CourseSelectionView: View {
	@Binding var selectedCourse: Course
	@Binding var isPresented: Bool

	@Query var gameDocs: [GameDoc]
	var gameDoc: GameDoc! { gameDocs.first }
	@State private var createNewCourse: Bool = false
	@State private var searchText = ""
	@State private var isSearching = false

	var body: some View {
		VStack {
			SearchBar(text: $searchText)

			List(filteredCourses()) { course in
				Text(course.name)
				.swipeActions(edge: .trailing) {
					Button {
						gameDoc.deleteCourse(course: course)
					} label: {
						Label(
							"Delete",
							systemImage: "trash"
						)
						.tint(.red)
					}
				}.onTapGesture {
					selectedCourse = course
					isPresented = false
				}
			}
			.listStyle(PlainListStyle())
			.background(Color.clear)
		}
		.padding(.top)
	}
	
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
