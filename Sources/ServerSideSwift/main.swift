import Kitura

struct Movie: Codable {
    let title: String
}

let router = Router()

router.get("/") { request, response, next in
    response.send("Hello Waynes world!")
    next()
}

router.post("/hello") { request, response, next in
    var message: String
    do {
        let movie = try request.read(as: Movie.self)
        message = "Hello \(movie.title)!"
    } catch let error {
        message = "Couldnt read movie: \(error)"
    }
    response.send(message)
    next()
}


Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
