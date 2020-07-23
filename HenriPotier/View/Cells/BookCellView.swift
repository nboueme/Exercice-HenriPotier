//
//  BookCellView.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 22/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit
import RxSwift

final class BookCellView: UITableViewCell {
    static let identifier = "BookTableViewCell"

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var synopsis: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var cover: UIImageView!
    
    private let disposeBag = DisposeBag()
    
    var indexPath: IndexPath?
    
    var viewModel: BookViewModeling? {
        didSet {
            setBackgroundColor()
            initializeUI()
        }
    }
}

extension BookCellView {
    private func setBackgroundColor() {
        if let indexPath = indexPath {
            backgroundColor = indexPath.row % 2 == 0 ? .white : #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        }
    }
    
    private func initializeUI() {
        viewModel?.title.bind(to: title.rx.text).disposed(by: disposeBag)
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
