//
//  BasketViewController.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 24/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RxSwift

final class BasketViewController: UIViewController {
    @IBOutlet weak var linesTableView: UITableView!
    @IBOutlet weak var sumBeforeOffer: UILabel!
    @IBOutlet weak var sumAfterOffer: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: BasketViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        initializeUI()
    }
    
    @IBAction func didTapOnOKButton(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension BasketViewController {
    private func configureTableView() {
        linesTableView.dataSource = self
        linesTableView.delegate = self
        linesTableView.emptyDataSetSource = self
        linesTableView.tableFooterView = UIView()
    }
    
    private func initializeUI() {
        guard let basketVM = viewModel,
            basketVM.basketLineCells.value.count > 0 else {
            sumBeforeOffer.isHidden = true
            sumAfterOffer.isHidden = true
            return
        }
        
        basketVM.finalPriceWithoutOffer.asObservable().bind(to: sumBeforeOffer.rx.attributedText).disposed(by: disposeBag)
        
        basketVM.finalPriceWithOffer.asObservable().bind(to: sumAfterOffer.rx.attributedText).disposed(by: disposeBag)
    }
}

extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.basketLineCells.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BasketLineCellView.identifier, for: indexPath) as! BasketLineCellView
        cell.viewModel = viewModel?.basketLineCells.value[indexPath.row]
        return cell
    }
}

extension BasketViewController: DZNEmptyDataSetSource {
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = L10n.Basket.hasNotElements
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray,
            .font: UIFont.systemFont(ofSize: 22, weight: .medium)]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
}
