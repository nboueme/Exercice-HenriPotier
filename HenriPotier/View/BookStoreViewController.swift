//
//  ViewController.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 22/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import SDWebImage
import RxSwift

final class BookStoreViewController: UIViewController {
    @IBOutlet weak var booksTableView: UITableView!
    
    var viewModel: BookStoreViewModeling?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedBookVC = segue.destination as? SelectedBookViewController else { return }
        guard let indexPath = booksTableView.indexPathForSelectedRow else { return }
        guard let book = viewModel?.booksCells.value[indexPath.row] else { return }
        
        selectedBookVC.viewModel = DependenciesManager.shared.container.resolve(
            BookViewModeling.self,
            name: "cell",
            arguments: book.isbn.value, book.title.value, book.price.value, book.cover.value, book.synopsis.value)
    }
}

extension BookStoreViewController {
    private func configureTableView() {
        booksTableView.dataSource = self
        booksTableView.delegate = self
        booksTableView.emptyDataSetSource = self
        booksTableView.tableFooterView = UIView()
    }
    
    private func configureDataSource() {
        viewModel?.getBooksCells()
        
        viewModel?.booksCells.asObservable().subscribe { [weak self] _ in
            self?.booksTableView.reloadData()
        }.disposed(by: disposeBag)
    }
}

extension BookStoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.booksCells.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCellView.identifier, for: indexPath) as! BookCellView
        cell.indexPath = indexPath
        cell.viewModel = viewModel?.booksCells.value[indexPath.row]
        return cell
    }
}

extension BookStoreViewController: DZNEmptyDataSetSource {
    public func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let title = L10n.BookStore.hasNotElements
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.darkGray,
            .font: UIFont.systemFont(ofSize: 22, weight: .medium)]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
}
