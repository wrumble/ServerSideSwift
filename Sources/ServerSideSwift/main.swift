import Kitura

struct User: Codable {
    let name: String
}

let router = Router()

router.get("/") { request, response, next in
    response.send("Hello Waynes world!")
    next()
}

router.post("/hello") { request, response, next in
    var message: String
    do {
        let user = try request.read(as: User.self)
        message = "Hello \(user.name)!"
    } catch let error {
        message = "Couldnt read movie: \(error)"
    }
    response.send(message)
    next()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
