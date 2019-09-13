import Kitura
import Foundation

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
let port = Int(ProcessInfo.processInfo.environment["PORT"] ?? "8080") ?? 8080

Kitura.addHTTPServer(onPort: port, with: router)
Kitura.run()
