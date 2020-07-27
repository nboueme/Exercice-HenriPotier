//
//  BasketLineCellView.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 26/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit
import RxSwift

protocol BasketLineDelegate: class {
    func deleteLine(for isbn: String)
}

final class BasketLineCellView: UITableViewCell {
    static let identifier = "BasketLineTableViewCell"

    weak var delegate: BasketLineDelegate?
    
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
    
    @IBAction func didTapOnDeleteButton(_ sender: Any) {
        guard let viewModel = viewModel else { return }
        viewModel.deleteBasketLine(for: 0, isbn: viewModel.isbn.value)
        delegate?.deleteLine(for: viewModel.isbn.value)
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
