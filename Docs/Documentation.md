# Golfer

## Architecture
The architecture of the Golfer app is made up of two components, the UI portion and the data model portion. From a high level the UI is built on a tab view consisting of four different tabs, game, players, courses, and previous games. The data model is built with a document based approach.

### Data Model

#### Game Doc
The `GameDoc` is the main document that holds all the data for the application. This is the main data structure holding things like the current game being played, all of the previous games, players, courses, etc...

```
@Model
class GameDoc {
	var players: [Player]
	var previousGames: [Game]
	var courses: [Course]
	var currentGame: Game?
}
```

This game doc is loaded using SwiftData accross the application and there is only one document for the application. 

- TODO: Future versions should modify the loading and saving of the game doc to not rely on a query in SwiftUI which forces us to force unwrap the first value from the query. Instead we should be able to load just the document model and move forward.  

#### Game
The `Game` is another model object that is represented in different ways from within the `GameDoc`. Specifically this holds all of the game data for a specfic game. 

```
	/// The Id that represents the game
	var id = UUID()
	/// The start date for the game
	var startDate: Date = Date()
	/// The score card for the game
	var scoreCard: ScoreCard
	/// The course this game is being played on
	var courseId: UUID
	/// Is the game marked as finished
	var endDate: Date?
	/// The current hole the players are playing on
	var currentHole: Int = 0
```

#### Player
The `Player` is another model object that is represented in different ways from within the `GameDoc`. Specifically this holds all of the data for a specfic player. Players are only saved within the `GameDoc` and referenced in other model objects like the `Game` object by UUID. The `GameDoc` provides lookup functionality for players. This was done to keep a single source of truth instead of multiple copies of the same object.

```
	/// Returns a list of players that match the list of UUIDs passed in
	func players(for ids: [UUID]) -> [Player] {
		return ids.compactMap { playerId in
			return players.first { player in
				player.id == playerId
			}
		}
	}
```

#### Course
Similar to the player object the course object represents all the data for a single course. Courses are only saved within the `GameDoc` and referenced in other model objects like the `Game` object by UUID. The `GameDoc` provides lookup functionality for courses. This was done to keep a single source of truth instead of multiple copies of the same object.

```
	/// Finds a course based on a UUID
	/// - Parameter id: The UUID of the course
	/// - Returns: The course object matching that ID
	func course(for id: UUID) -> Course? {
		return courses.first(where: { $0.id == id })
	}
```

___

### SwiftUI
This application takes advantage of SwiftUI as the primary framework for building out the user interface.

#### Tab View
The `ContentView.swift` is the main UI file for the application and holds the setup of the tab view. The tab view is currently four different tabs, the game tab, the players tab, the courses tab, and the previous games tab.

#### Game Tab
The game tab is the main function of the application which allows the user to play a round of golf. 

#### Players Tab
The players tab is a view that contains a table of all of the players that have previously been created but also allows you to edit and create players.

#### Course Tab
The courses tab is very similar to the players tab but instead of players it's courses.

#### Previous Games Tab
The previous games tab is a table view showing all of the previously played games. 

___

## Functionality

The applications main function is to keep scores related to a round of golf between mutliple players. There are many functions within the application but the main ones are found in the `GameDoc` itself.

#### Handicap
```
	/// Recalculates a given players handicap based on their best games
	/// - Parameter player: The player to calculate the handicap for
	func recalculateHandicap(for player: Player) { }
```

This function allows the game doc the ability to recalculate a users given handicap index based on their best games within the application. This will help a user know their general handicap index. 

```
	/// Calculates the handicap for a given player on this course.
	/// The formula for the calculation is Persons Handicap index x (slope rating / 113) + (course rating - par)
	/// There is a max of 3 handicap shots per hole
	/// - Parameter player: The player we want to calculate the handicap for
	/// - Returns: The handicap for this player on this course
	func handicap(for player: Player) -> Int { }
```
This function is a main function of a course object that takes into account the properties of the course that a player is about to play on. It uses the handicap formula to be able to make the calculation and works for both 18 & 9 hole courses.

___

## Known Issues

* As of now there are no currently known issues.


## Improvement Oppertunities 
* Remove the dependency on SwiftData and instead use a cloud based system.
* Change the design to be user based where a user would login and could sync with others to play.