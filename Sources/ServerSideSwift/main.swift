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
    print("Request body: \(request.body)")
    do {
        let movie = try request.read(as: Movie.self)
        response.send("Hello \(movie.title)!")
    } catch let error {
        response.send("Couldnt read movie: \(error)")
    }
    
    next()
}


Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
