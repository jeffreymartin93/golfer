//
//  CreateCourseView.swift
//  Golfer
//
//  Created by Jeff Martin on 10/21/23.
//

import SwiftUI
import SwiftData

let integerFormatter: NumberFormatter = {
	let formatter = NumberFormatter()
	formatter.allowsFloats = false
	return formatter
}()

struct CreateCourseView: View {
	@Query var gameDocs: [GameDoc]
	var gameDoc: GameDoc! { gameDocs.first }
	
	@Environment(\.dismiss) private var dismiss
	@FocusState private var isFocused: Bool
	
	@State var courseName: String = ""
	@State var slopeRating: Int = 0
	@State var courseRating: Int = 0
	@State var holes: [Hole] = []
	
	@State var showAlert: Bool = false

	var body: some View {
		Form {
			Section(header: Text("Name")) {
				TextField("Course Name", text: $courseName).focused($isFocused)
			}
			
			Section(header: Text("Slope Rating")) {
				TextField("0", value:$slopeRating, formatter: integerFormatter).keyboardType(.numberPad)
			}
			
			Section(header: Text("Course Rating")) {
				TextField("0", value:$courseRating, formatter: integerFormatter).keyboardType(.numberPad)
			}
			
			Section(
				header: Text("Holes"),
				footer: Button("Add Hole") {
					let new = Hole(index: holes.count, par: 3, handicap: 0)
					holes.append(new)
				}
			) {
				List($holes) { hole in
					HStack {
						Text("Par: ")
						TextField("0", value: hole.par, formatter: integerFormatter).keyboardType(.numberPad)
					}
					
					HStack {
						Text("Handicap: ")
						TextField("0", value: hole.handicap, formatter: integerFormatter).keyboardType(.numberPad)
					}
				}
			}
		}
		.padding()
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				Button(action: {
					if holes.count != 9 || holes.count != 18 {
						showAlert = true
						return
					}
					
					gameDoc.courses.append(Course(
						name: courseName,
						slopeRating: slopeRating,
						courseRating: courseRating,
						holes: holes
					))
					dismiss.callAsFunction()
				}) {
					Text("Save")
						.font(.body)
						.fontWeight(.semibold)
				}
			}
		}
		.alert("", isPresented: $showAlert, actions: {
			Button("OK", role: .destructive) {
				showAlert = false
			}
		}, message: {
			Text("You must create a 18 or 9 hole course")
		})

		.navigationTitle("New Course")
		.onAppear {
			isFocused = true
		}
	}
}


//struct CreateCourseView: View {
//	@Query var gameDocs: [GameDoc]
//	var gameDoc: GameDoc! { gameDocs.first }
//
//	@Environment(\.dismiss) private var dismiss
//	@State var course: Course
//	@FocusState private var isFocused: Bool
//
//	var body: some View {
//		VStack {
//			TextField("Course Name", text: $course.name)
//				.padding()
//
//			HStack {
//				TextField("Slope Rating", value:$course.slopeRating, formatter: NumberFormatter())
//					.padding()
//
//				TextField("Course Rating", value: $course.courseRating, formatter: NumberFormatter())
//					.padding()
//			}
//
//			List($course.holes) { hole in
//				HStack {
//					Text("Par: ")
//					TextField("Par", value: hole.par, formatter: NumberFormatter())
//				}
//			}
//			.padding()
//
//			.padding()
//		}
//	}
//}
