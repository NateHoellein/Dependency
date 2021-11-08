//
//  APIHandler.swift
//  SampleApp
//
//  Created by Nathan Hoellein on 11/7/21.
//

import Foundation


public protocol APIProtocol {
    func searchApi(searchString: String)
    var responseHandler: ApiResponseDelegateProtocol? { get set }
}

public protocol ApiResponseDelegateProtocol {
    func receivesResponse(response: Response)
}

public struct Response: Codable {
    var results: [Result]
}

public struct Result: Codable {
    var trackId: Int
    var trackName: String
    var collectionName: String
}

public class APIHandler: APIProtocol {
    
    public var responseHandler: ApiResponseDelegateProtocol?
    
    public func searchApi(searchString: String){
        
        guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchString)&entity=song") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
       
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                 
                    DispatchQueue.main.async {
                        self.responseHandler?.receivesResponse(response: decodedResponse)
                    }
                    return
                }
            }
        }.resume()
    }
}
