# ServerSideSwift

## Steps to re-create app: 

Install Swift, Heroku and Docker on your machine

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

```
dependencies: [
        .package(url: "https://github.com/IBM-Swift/Kitura", from: "2.7.0")
    ],
```

Then add the package name to the `target` you will use in, in this case the main app

```
    targets: [
        .target(
            name: "YourAppName",
            dependencies: ["Kitura"]),
```

### Build the app
`swift build`

### Write some code

Add code to `Sources/YourAppName/main.swift` in this case Kitura is used to setup the app routes like so

```
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

// Set the port the router will use to the current Environments port or 8080. This isn't required but was the only way i could get the port set properly, trying to set it in the docker file did not work, nor did just setting "port" variable to "YourPortNumber"
let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "YourPortNumber") ?? YourPortNumber

// Run the server
Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()
```

### Make app executable from Xcode(optional)
`swift package generate-xcodeproj`

### Run the app
`swift run` note: currently doesnt work on Catalina MacOs

alternatively run it in Xcode by pressing play

### View the app
To see the app go to `http://localhost:<YourPortNumber>` in this case our port number is `8080`

## Setup app as Docker container

### Create `Dockerfile`
Still in app root directory

`touch Dockerfile`

`open Dockerfile`

In `Dockerfile` add
```
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

`docker build -t YourContainerName .`

### Test run the app in the new container
`docker run --rm -it -p YourPortNumber:YourPortNumber YourAppName`

You can view it again at `http://localhost:<YourPortNumber>` 

## Push new container to Heroku
Once registered with Heroku and Heroku installed

### Add all files and commit to git
This prepares the app to be pushed to Heroku as a repo

`git add .`

`git commit -m "Initial Commit"`

### Login
`heroku login`

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

###  Test App on Heroku
Make get request on homepage

`curl -X GET https://HerokuAppName.herokuapp.com/`

Post a User to the Heroku app

`curl -X POST https://HerokuAppName.herokuapp.com/user -H 'content-type: application/json' -d '{"name": "Wayne"}'`


