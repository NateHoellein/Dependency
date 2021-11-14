//
//  SearchViewModel.swift
//  SampleApp
//
//  Created by Nathan Hoellein on 11/7/21.
//

import Foundation
import UIKit

protocol SearchResultsDelegate {
    func receivesSearchResults(results: [Result])
}

class SearchViewModel: ApiResponseDelegateProtocol {
    
    var apiHandler: APIProtocol
    var resultHandler: SearchResultsDelegate?
    
    init() {
    
        self.apiHandler = try! DependencyContainer.shared.resolve(APIProtocol.self, label: "APIHandler")
        self.apiHandler.responseHandler = self
    }
    
    
    // Here you could unit test how the string might need to be formatted to be part of a URL
    // string.  The DependencyManager for unit tests could register a "fake" apiHandler class
    
    func search(searchString: String) {
        let encodedString = searchString.replacingOccurrences(of: " ", with: "+")
        self.apiHandler.searchApi(searchString: encodedString)
    }
}

extension SearchViewModel {
    
    func receivesResponse(response: Response) {
        
        let results = response.results
        self.resultHandler?.receivesSearchResults(results: results)
    }
}
