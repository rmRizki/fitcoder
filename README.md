# Fitcoder Watch App

<img src="https://developer.apple.com/health-fitness/works-with-apple-health/images/badge-standard_2x.png" alt="Fitcoder Watch App" width="200">  

Fitcoder is an Apple Watch application designed to encourage developers to maintain a healthy lifestyle by tracking their standing time. The unique feature of Fitcoder is that it converts the standing time into a commit for your GitHub contribution graph, making health tracking fun and rewarding for developers.

## Features

- Tracks how long a developer has been standing.
- Converts the stand time into a commit for your GitHub contribution graph.

## Project Setup

1. Clone the repository to your local machine:

```bash
git clone https://github.com/rmRizki/Fitcoder.git
```

2. Open the project in Xcode:

```bash
open Fitcoder.xcodeproj
```

3. Navigate to the `Constants.swift` file and fill in the necessary values:

```swift
enum Constants {
    static let standTimeThreshold = 10.0 // value used to determine when to commit
    static let userName = "userName" // your GitHub username without the @ symbol
    static let repoName = "repoName" // your GitHub repo name without the .git extension
    static let filePath = "filePath" // file path in the repo to commit
    static let token = "token" // your GitHub personal access token
    static let name = "name" // your name to put in the commit
    static let email = "email" // your email to put in the commit
    static let profileImageUrl = "profileImageUrl" // your profile image url
}
```

Please replace `userName`, `repoName`, `filePath`, `token`, `name`, `email`, and `profileImageUrl` with your actual GitHub username, repo name, file path in the repo to commit, personal access token, name, email, and profile image URL respectively. The `standTimeThreshold` is the value used to determine when to commit, you can adjust it as needed.

## Building the Project
To build the project, open Fitcoder.xcodeproj in Xcode and select Product > Build from the menu.

## Running the Project
To run the project, select the desired target device in Xcode and select Product > Run from the menu.

## Contributing
Contributions are welcome. Please open a pull request with your changes.
