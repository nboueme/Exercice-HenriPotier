//
//  SelectedBookViewController.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectedBookViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var synopsis: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cover: UIImageView!
    @IBOutlet weak var basket: UIBarButtonItem!
    @IBOutlet weak var addToBasket: UIBarButtonItem!
    
    private let disposeBag = DisposeBag()
    
    var bookViewModel: BookViewModeling?
    var basketViewModel: BasketViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        basketState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationC = segue.destination as? UINavigationController else { return }
        guard let basketVC = navigationC.viewControllers.first as? BasketViewController else { return }
        basketVC.viewModel = basketViewModel
    }
    
    @IBAction func didTapOnAddToBasketButton(_ sender: Any) {
        guard let bookVM = bookViewModel else { return }
        basketViewModel?.addBasketLine(for: 0, isbn: bookVM.isbn.value)
    }
}

extension SelectedBookViewController {
    private func initializeUI() {
        addToBasket.title = L10n.Button.addToBasket
        
        bookViewModel?.title.bind(to: name.rx.text).disposed(by: disposeBag)
        bookViewModel?.synopsis.bind(to: synopsis.rx.attributedText).disposed(by: disposeBag)
        bookViewModel?.price.bind(to: price.rx.text).disposed(by: disposeBag)
        
        bookViewModel?.cover.asObservable().subscribe { [weak self] data in
            guard let strongSelf = self else { return }
            guard let data = data.element, let image = data else { return }
            
            strongSelf.cover.image = UIImage(data: image)
        }.disposed(by: disposeBag)
    }
    
    private func basketState() {
        guard let bookVM = bookViewModel else { return }
        guard let basketVM = basketViewModel else { return }
        
        basketVM.searchBasketLine(for: bookVM.isbn.value)
        basketVM.bookIsNotAlreadyInBasket.asObservable().bind(to: addToBasket.rx.isEnabled).disposed(by: disposeBag)
        
        basketVM.basketIconName.asObservable().subscribe { [weak self] iconName in
            guard let iconName = iconName.element else { return }
            guard let strongSelf = self else { return }
            strongSelf.basket.image = UIImage(systemName: iconName)
        }.disposed(by: disposeBag)
    }
}
