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
            backgroundColor = indexPath.row % 2 == 0 ? .systemBackground : .systemGray6
        }
    }
    
    private func initializeUI() {
        viewModel?.title.bind(to: title.rx.text).disposed(by: disposeBag)
        viewModel?.synopsis.bind(to: synopsis.rx.attributedText).disposed(by: disposeBag)
        viewModel?.price.bind(to: price.rx.text).disposed(by: disposeBag)
        
        viewModel?.cover.asObservable().subscribe { [weak self] data in
            guard let strongSelf = self else { return }
            guard let data = data.element, let image = data else { return }
            
            strongSelf.cover.image = UIImage(data: image)
        }.disposed(by: disposeBag)
    }
}
