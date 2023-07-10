import Foundation

struct FixtureLoader {
    let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func loadJSONData(named basename: String) -> Data {
        guard let path = bundle.path(forResource: basename, ofType: "json"),
              let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("\(basename).json is not found")
        }
        return jsonData
    }

    func decodeObject<T: Decodable>(fromJSONNamed basename: String) -> T {
        let jsonData = loadJSONData(named: basename)
        return decodeObject(from: jsonData)
    }

    func decodeObject<T: Decodable>(from jsonData: Data) -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try! decoder.decode(T.self, from: jsonData)
    }
}
