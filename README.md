# LandmarkRemark


## Requirements

- [x] As a user (of the application) I can see my current location on a map
- [x] As a user I can save a short note at my current location
- [x] As a user I can see notes that I have saved at the location they were saved on the map
- [x] As a user I can see the location, text, and user-name of notes other users have saved
- [x] As a user I have the ability to search for a note based on contained text or user-name

## Assumptions

- No CACHING OR LOCAL STORAGE required

## Implicit Requirements Identified

- Authentication is necessary for the app to function properly and securely
-  Email must be unique
- Back end persistence is required for landmark remarks to be stored by users.
- Login, Signup, Already logged in check and Logout should be added.

## Build instructions

- Install [Xcode](https://itunes.apple.com/au/app/xcode/id497799835) 
- Install [CocoaPods](https://guides.cocoapods.org/using/getting-started.html)
- `cd` into repo
- Install dependencies using `pod install`
- Open `LandmarkRemark.xcworkspace`

## Dependencies

### Cocoapods

- Firebase
- MBProgressHUD

## Architecture

I prefer to apply MVVM. I've used SOLID design principals to make app testable

## Model-View-ViewModel
MVVM adds more encapsulation on top of MVC. Each View has a dedicated ViewModel that handles all the updates to View. View and View Model can be binded using reactive frameworks such as RxSwift but I choose to use protocols. The View does not contain any logic, thus we avoid testing it.

### Pros
- Mediocre complexity.
- Scalable.
- Easier to write unit tests. 
### Cons
- If not careful you can still end up creating Massive View Model.


## BAAS

[Firebase](https://firebase.google.com/docs/ios/setup) 

# Time spent 
- Understand requirements & setup initial project: 1.0 hour
- Setup & integrate Firebase: 1.0 hour
- Login and Sign up: 2.0 hour
- Show user location and display annotation on map: 3.0 hours 
- Adding a remark note: 1.0 hour 
- Implement search/filter remarks: 1.0 hour
- Restructuring the code - custom cell and view model for search list view: 1.0 hour
- Other implicit functionalities: 1.0 hours
- Code clean up and minor improvements: 2.0 hours 
- Readme/Documentation: 1.5 hour

- Total time: 14.5 hours 

# Limitations 

- Firestore SDK build time( takes noticeable amount of time)
- Firestore limitation for querying/searching contained text for any field(it only supports exact keyword match for now)
- Because of cloud firestore's limitation, I had to fetch all landmark remark records and serach filter remark keywords records locally (using swift higher order function)

