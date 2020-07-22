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

final class BookStoreViewController: UIViewController {

    @IBOutlet weak var booksTableView: UITableView!
    
    private var bookStoreDataSource = BookStore.bookStoreDataSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}

extension BookStoreViewController {
    private func configureTableView() {
        booksTableView.dataSource = self
        booksTableView.delegate = self
        booksTableView.emptyDataSetSource = self
        booksTableView.tableFooterView = UIView()
    }
}

extension BookStoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookStoreDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as! BookTableViewCell
        let book = bookStoreDataSource[indexPath.row]
        
        if let coverURL = book.cover {
            cell.cover.sd_setImage(with: URL(string: coverURL), placeholderImage: Asset.placeholder.image)
        }
        
        cell.title.text = book.title
        cell.synopsis.text = book.synopsis?.joined(separator: "\n\n")
        
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
