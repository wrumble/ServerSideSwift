# ServerSideSwift

## To build and run

### Requirements

You need `Swift`, and `CouchDB` only to the run the latest version of the app. To deploy to Heroku you will need `Heroku` and `Docker` too.

Swift can be installed using:

`brew install swift`

Couchdb can be installed using:

`brew install couchdb`

Heroku can be installed using:

`brew tap heroku/brew && brew install heroku`

Docker can be installed using:

`brew cask install docker`

### Running the app

To run the app, after you have installed the above and logged into `Heroku` and `Docker` you need to run:

Download the app:

`git clone git@github.com:wrumble/ServerSideSwift.git`

`cd ServerSideSwift`

Build the app package:

`swift build`

`swift package generate-xcodeproj`

Start couchdb:

`brew services start couchdb`

Run the App:

`swift run` note: this wont work on Catalina beta, if so run `xed .` then `Command + R` after xcode opens.

### Runnig the app on a Docker container

Currently the database doesnt work in docker but to run the app for the first time use:

`docker-compose up --build`

if no changes have been made to the image you can run just ``docker-compose up` after this.

## Steps to re-create app

## Create the app

### Create app root directory

`mkdir YourAppName`

`cd YourAppName`

### Autogenerate package files

`git init`

`swift package init --type executable`

### Add packages(optional)

`open Package.swift`

In `Package.swift` in the empty `depenendencies` array add a package using its repo url and version number

```swift
dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.7.0")
    ],
```

Then add the package name to the `target` you will use in, in this case the main app

```swift
    targets: [
        .target(
            name: "YourAppName",
            dependencies: ["Kitura"]),
```

### Build the app

`swift build`

### Write some code

Add code to `Sources/YourAppName/main.swift` in this case Kitura is used to setup the app routes like so

```swift
import Kitura
import Foundation

// Create a simple, "User" model that conforms to "Codable" ready to be translated from a post request with the path "/user"
struct User: Codable {
    let name: String
}

let router = Router()

// Create a get request endpoint on the home path "/" that responds with "Hello world"
router.get("/") { request, response, next in
    response.send("Hello world!")

    // Signal this middleware is done with its work
    next()
}

// Creat post request endpoint on the "/user" path that when given a User in the form of json the return "Hello UsersNameFromJson!"
// On failure of reading the given json return message containing the error 
router.post("/user") { request, response, next in
    var message: String
    do {
        let user = try request.read(as: User.self)
        message = "Hello \(user.name)!"
    } catch let error {
        message = "Could not read user json: \(error)"
    }
    response.send(message)
    next()
}

// Set the port the router will use to the current Environments port or YourPortNumber. This isn't required but was the only way i could get the port set properly, trying to set it in the docker file did not work, nor did just setting "port" variable to "YourPortNumber"
let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "YourPortNumber") ?? YourPortNumber

// Run the server
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()
```

### Make app executable from Xcode(optional)

`swift package generate-xcodeproj`

### Run the app

`swift run` note: currently doesnt work on Catalina MacOs

alternatively run it in Xcode by pressing play, this will require you to have run `swift package generate-xcodeproj` before hand though.

### View the app

To see the app go to `http://localhost:<YourPortNumber>` in this case our port number is `8080`

## Setup app as Docker container

### Create `Dockerfile`

Still in app root directory

`touch Dockerfile`

`open Dockerfile`

In `Dockerfile` add

```swift
# This could be "FROM swift:latest" but then you would have to install other packages via the "RUN" command to prepare the app for Kitura. 
FROM ibmcom/swift-ubuntu:5.0.2

# Set the root direct for the app
WORKDIR /YourAppName

# Paste the apps files across to the image container
COPY . .

# Build the app as a release version on the image container, this could also be just "RUN swift build"
RUN swift build -c release

# Run the app on the container, if you used "RUN swift build" in the step above this would be "CMD .build/debug/YourAppName"
CMD .build/release/YourAppName
```

### Create the docker container

Once registered with Docker and Docker installed

`docker build -t your-container-name .` note: container name must be lowercase

### Test run the app in the new container

`docker run --rm -it -p YourPortNumber:YourPortNumber your-container-name`

You can view it again at `http://localhost:<YourPortNumber>`

## Push new container to Heroku

Once registered with Heroku and Heroku installed

### Add all files and commit to git

This prepares the app to be pushed to Heroku as a repo

`git add .`

`git commit -m "Initial Commit"`

### Login

Login to Heroku

`heroku login`

Login into the Heroku container

`heroku container:login`

Follow prompts to login

### Create app on Heroku

`heroku create HerokuAppName`

### Push Docker contatiner to Heroku

`heroku container:push web --app HerokuAppName`

### Release app on Heroku

`heroku container:release web -a HerokuAppName`

### View running app on Heroku

`heroku open`

### View logs of Heroku app

`heroku logs --tail`

### Test App on Heroku

Make get request on homepage

`curl -X GET https://HerokuAppName.herokuapp.com/`

Post a User to the Heroku app

`curl -X POST https://HerokuAppName.herokuapp.com/user -H 'content-type: application/json' -d '{"name": "Wayne"}'`

## Adding a database using Couchdb

Next i followed the RayWenderlich tutorial on Kitura and Couchdb found [here](https://www.raywenderlich.com/1079484-kitura-tutorial-getting-started-with-server-side-swift) but i carried on using a `User` instead of `Acronymys` in the tutorial

