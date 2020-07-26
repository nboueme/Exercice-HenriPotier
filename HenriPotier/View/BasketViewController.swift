//
//  BasketViewController.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 24/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

final class BasketViewController: UIViewController {
    @IBOutlet weak var linesTableView: UITableView!
    
    var viewModel: BasketViewModeling?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
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
