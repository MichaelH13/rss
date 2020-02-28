//
//  Copyright © 2020 Objective Swift Inc. All rights reserved.
//

import Foundation

/// Client class to fetch data.
public class Client {

    // MARK: - Public

    /// Supported HTTP methods.
    public enum Method: String {
        case get = "GET"
    }

    /// Singleton instance.
    public static let shared = Client()

    public func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    /// Wrapper to serialize the response we receive.
    public func sendQuery(_ queryPath: String,
                          httpMethod: Method = .get,
                          parameters: JSON? = nil,
                          completion: @escaping ((Bool, JSON, Data?) -> Void)) {
        sendQuery(queryPath, httpMethod: httpMethod, parameters: parameters) { (responseData) in
            var response = JSON()
            let success = responseData != nil

            guard let data = responseData else {
                completion(success, response, responseData)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON {
                    response = json
                }
            } catch let error {
                completion(success, response, data)
                Logger.log(.error, message: "Couldn't convert data to json: \(error)")
                return
            }

            Logger.log(message: "JSON:\n" + response.description)
            completion(success, response, data)
        }
    }

    // MARK: - Private

    /// This is where the work in "networking" happens.
    /// If both the response and data are nil, the request completed with a failure,
    /// otherwise examine the data and response to determine the outcome.
    private func sendQuery(_ queryPath: String,
                           httpMethod: Method = .get,
                           parameters: JSON? = [:],
                           completion: @escaping ((Data?) -> Void)) {
        let session = URLSession.shared

        var urlString = queryPath

        if let parameters = parameters {
            urlString = appendUrlParameters(to: urlString, parameters: parameters)
        }

        guard let url = URL(string: urlString) else {
            Logger.log(message: urlString)
            Logger.log(message: "invalid query path")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let task = session.dataTask(with: request) { (data, response, error) in
            defer {
                completion(data)
                session.finishTasksAndInvalidate()
            }

            var success = true

            Logger.log(message: "Response from url - \(url.absoluteString): \(url.description)")

            if error != nil {
                Logger.log(.error, message: String(describing: error))
                success = false
            } else if response == nil {
                Logger.log(.warning, message: "nil response")
                success = false
            } else if response as? HTTPURLResponse != nil {
                Logger.log(.warning, message: "Not an HTTP response")
                success = false
            } else if let response = response as? HTTPURLResponse,
                response.statusCode == .ok {
                Logger.log(.warning, message: "Not a 200 (OK) response")
                success = false
            } else if data == nil {
                Logger.log(.warning, message: "no data returned")
                success = false
            }

            guard success else {
                Logger.log(.warning, message: "network request failed")
                return
            }

        }

        task.resume()
    }

    /// Enforce singleton.
    private init() {}
}

// MARK: - Query

extension Client {

    /// Queries top headlines for the current day.
    public func queryTopAlbums(_ completion: @escaping ((Bool, JSON, Data?) -> Void)) {
        Client.shared.sendQuery(Endpoint.Query.TopAlbums.All.hundred, httpMethod: .get, parameters: [:], completion: { (success, json, data) in
            completion(success, json, data)
        })
    }
}

// MARK: - Private Helpers

extension Client {

    /// Takes a host and a JSON structure of parameters and assembles the
    /// url string with percent encoding using the .alphaneumerics option.
    private func appendUrlParameters(to base: String, parameters: JSON) -> String {
        var urlString = base

        // Validate each pair and if it's valid add it to the url params.
        parameters.forEach({ (key, value) in
            let isValidKey = key.isEmpty == false
            let encodedValue = (value as? String ?? "").addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
            let isValidValue = encodedValue.isEmpty == false
            let isValidPair = isValidKey && isValidValue

            if isValidPair {
                urlString += "&\(key)=\(encodedValue)"
            }
        })
        return urlString
    }
}
