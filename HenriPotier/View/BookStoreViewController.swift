//
//  ViewController.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 22/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import RxSwift

final class BookStoreViewController: UIViewController {
    @IBOutlet weak var booksTableView: UITableView!
    @IBOutlet weak var basket: UIBarButtonItem!
    
    var bookStoreViewModel: BookStoreViewModeling?
    var basketViewModel: BasketViewModeling?
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureDataSource()
        basketState()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let selectedBookVC = segue.destination as? SelectedBookViewController else { return }
        guard let indexPath = booksTableView.indexPathForSelectedRow else { return }
        guard let book = bookStoreViewModel?.booksCells.value[indexPath.row] else { return }
        
        selectedBookVC.bookViewModel = DependenciesManager
            .shared
            .container
            .resolve(BookViewModeling.self, name: Constant.initBookViewModelingWithISBN, argument: book.isbn.value)
        selectedBookVC.basketViewModel = basketViewModel
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
        bookStoreViewModel?.getBooksCells()
        
        bookStoreViewModel?.booksCells.asObservable().subscribe { [weak self] _ in
            self?.booksTableView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    private func basketState() {
        guard let basketVM = basketViewModel else { return }
        
        basketVM.basketIconName.asObservable().subscribe { [weak self] iconName in
            guard let iconName = iconName.element else { return }
            guard let strongSelf = self else { return }
            strongSelf.basket.image = UIImage(systemName: iconName)
        }.disposed(by: disposeBag)
    }
}

extension BookStoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookStoreViewModel?.booksCells.value.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCellView.identifier, for: indexPath) as! BookCellView
        cell.indexPath = indexPath
        cell.viewModel = bookStoreViewModel?.booksCells.value[indexPath.row]
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
