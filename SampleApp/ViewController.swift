//
//  ViewController.swift
//  SampleApp
//
//  Created by Nathan Hoellein on 11/7/21.
//

import UIKit

class ViewController: UIViewController {

    var viewModel: SearchViewModel
    var fillerView: UIView
    
    required init?(coder: NSCoder) {
        
        
        self.viewModel = try! DependencyContainer.shared.resolve(SearchViewModel.self, label: "searchViewModel")
        
        fillerView = UIView(frame: .zero)
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        super.init(coder: coder)
        self.viewModel.resultHandler = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillerView.backgroundColor = UIColor.black
        let searchBox = UITextField(frame: .zero)
        searchBox.translatesAutoresizingMaskIntoConstraints = false
        searchBox.placeholder = "What are you looking for?"
        
        
        let searchButton = UIButton(type: .system, primaryAction: UIAction(title: "Search", handler: { Action in
            self.viewModel.search(searchString: searchBox.text!)
        }))
        searchButton.translatesAutoresizingMaskIntoConstraints = false
       
        let searchStackView = UIStackView(arrangedSubviews: [searchBox, searchButton])
        searchStackView.translatesAutoresizingMaskIntoConstraints = false
        searchStackView.axis = .horizontal
        searchStackView.distribution = .fillProportionally
        
        self.view.addSubview(searchStackView)
        self.view.addSubview(fillerView)
        
        self.view.addConstraints([
            searchStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchStackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchStackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            fillerView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 5),
            fillerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            fillerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            fillerView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}

extension ViewController: SearchResultsDelegate {
    func receivesSearchResults(results: [Result]) {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        results.forEach { result in
            let quickView = QuickView(text: "\(result.collectionName)")
            stackView.addArrangedSubview(quickView)
        }
        
        self.view.addSubview(stackView)
        self.view.addConstraints([
            stackView.topAnchor.constraint(equalTo: fillerView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            stackView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -2)
        ])
    }
}

