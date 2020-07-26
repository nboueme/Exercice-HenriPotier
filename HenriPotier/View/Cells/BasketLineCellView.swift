//
//  BasketLineCellView.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 26/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit
import RxSwift

final class BasketLineCellView: UITableViewCell {
    static let identifier = "BasketLineTableViewCell"

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var cover: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: BasketLineViewModeling? {
        didSet {
            initializeUI()
        }
    }
}

extension BasketLineCellView {
    private func initializeUI() {
        viewModel?.title.bind(to: title.rx.text).disposed(by: disposeBag)
        viewModel?.price.bind(to: price.rx.text).disposed(by: disposeBag)
        viewModel?.quantity.bind(to: quantity.rx.text).disposed(by: disposeBag)
        
        viewModel?.cover.asObservable().subscribe { [weak self] data in
            guard let strongSelf = self else { return }
            guard let data = data.element, let image = data else { return }
            
            strongSelf.cover.image = UIImage(data: image)
        }.disposed(by: disposeBag)
    }
}
