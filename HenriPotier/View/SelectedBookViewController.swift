//
//  SelectedBookViewController.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 23/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit
import RxSwift

class SelectedBookViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var synopsis: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cover: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: BookViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
    }
}

extension SelectedBookViewController {
    private func initializeUI() {
        viewModel?.title.bind(to: name.rx.text).disposed(by: disposeBag)
        viewModel?.synopsis.bind(to: synopsis.rx.text).disposed(by: disposeBag)
        
        viewModel?.price.asObservable().subscribe { [weak self] price in
            guard let strongSelf = self else { return }
            guard let price = price.element else { return }
            
            strongSelf.price.text = L10n.SelectedBook.price(Int(price))
        }.disposed(by: disposeBag)
        
        viewModel?.cover.asObservable().subscribe { [weak self] url in
            guard let strongSelf = self else { return }
            guard let url = url.element else { return }
            
            strongSelf.cover.sd_setImage(with: url, placeholderImage: Asset.placeholder.image)
        }.disposed(by: disposeBag)
    }
}
