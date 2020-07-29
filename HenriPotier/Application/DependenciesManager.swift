//
//  DependenciesManager.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import Swinject
import SwinjectAutoregistration
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
        
        // Services
        container.autoregister(BookService.self, initializer: BookService.init)
        
        // ViewModels
        container.autoregister(BookStoreViewModeling.self, argument: BookService.self, initializer: BookStoreViewModel.init)
        container.autoregister(BookViewModeling.self, name: Constant.initBookViewModelingWithBook, argument: Book.self, initializer: BookViewModel.init)
        container.autoregister(BookViewModeling.self, name: Constant.initBookViewModelingWithISBN, argument: String.self, initializer: BookViewModel.init)
        container.autoregister(BasketViewModeling.self, argument: BookService.self, initializer: BasketViewModel.init)
        
        // Views
        container.storyboardInitCompleted(BookStoreViewController.self) { resolver, controller in
            controller.bookStoreViewModel = resolver ~> (
                BookStoreViewModeling.self,
                argument: resolver ~> BookService.self
            )
            controller.basketViewModel = resolver ~> (
                BasketViewModeling.self,
                argument: resolver ~> BookService.self
            )
        }
        container.storyboardInitCompleted(SelectedBookViewController.self) { resolver, controller in
            controller.bookViewModel = resolver ~> (
                BookViewModeling.self,
                name: Constant.initBookViewModelingWithISBN,
                argument: String()
            )
            controller.basketViewModel = resolver ~> (
                BasketViewModeling.self,
                argument: resolver ~> BookService.self
            )
        }
        container.storyboardInitCompleted(BasketViewController.self) { resolver, controller in
            controller.viewModel = resolver ~> (
                BasketViewModeling.self,
                argument: resolver ~> BookService.self
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
