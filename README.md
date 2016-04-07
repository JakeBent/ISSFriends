# ISSFriends

##Installation

1. Install xcode (this was built in Version 7.2 (7C68) with Swift version 2.1.1 (swiftlang-700.1.101.15 clang-700.1.81))

2. Install cocoapods: `gem install cocoapods -v 0.39.0`

3. Clone the repo: `git clone git@github.com:JakeBent/ISSFriends.git`

4. Install pods: `pod install`

5. Open `ISSFriends.xcworkspace` and run the project: `Cmd + r`

6. Run the tests: `Cmd + u`

If there are any issues installing, please check that you are running the same versions of xcode and cocoapods.

##Implemented Features 

Long press (~1 second) on a location in the map to add a friend. Tap the clock in the bottom left to see a list of added friends. You can tap on a friend's name to find out the next three times the ISS will pass them. Friends are currently not being stored between sessions. Tap the Satellite dish in the bottom right to center the map on the current location of the ISS. The bottom of the map view  displays the next time the ISS will pass over the user's current location

##Issues

The unit tests are very basic, and there was no more time to do any location based alerts. There is also a reuse issue in the friend's list when there are a lot of friends added.
