//
//  DependenciesManager.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import Swinject
import SwinjectStoryboard

public final class DependenciesManager {
    static let shared = DependenciesManager()
    
    var mainVC: UINavigationController!
    
    private init() {
        mainVC = getInitialVC(for: StoryboardScene.Main.storyboardName) as? UINavigationController
    }
    
    let container: Container = {
        let container = Container()
        
        container.storyboardInitCompleted(UINavigationController.self) { _, _ in }
        
        // ViewModels
        container.register(BookStoreViewModeling.self) { _ in BookStoreViewModel() }
        container.register(BookViewModeling.self) { _, book in BookViewModel(with: book) }
        container.register(BookViewModeling.self) { _, isbn, title, price, cover, synopsis in BookViewModel(isbn: isbn, title: title, price: price, cover: cover, synopsis: synopsis) }
        
        // Views
        container.storyboardInitCompleted(BookStoreViewController.self) { resolver, controller in
            controller.viewModel = resolver.resolve(BookStoreViewModeling.self)
        }
        container.storyboardInitCompleted(SelectedBookViewController.self) { resolver, controller in
            let emptyString: String? = String()
            controller.viewModel = resolver.resolve(
                BookViewModeling.self,
                arguments: "", "", 0.0, URL(string: ""), emptyString
            )
        }
        
        return container
    }()
    
    private func getInitialVC(for storyboardName: String) -> UIViewController? {
        return SwinjectStoryboard
            .create(name: storyboardName, bundle: nil, container: container)
            .instantiateInitialViewController()
    }
}
