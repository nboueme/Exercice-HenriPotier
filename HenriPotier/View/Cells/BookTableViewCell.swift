//
//  BookTableViewCell.swift
//  HenriPotier
//
//  Created by Nicolas Bouème on 22/07/2020.
//  Copyright © 2020 Nicolas Bouème. All rights reserved.
//

import UIKit

final class BookTableViewCell: UITableViewCell {
    static let identifier = "BookTableViewCell"
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var synopsis: UILabel!
    @IBOutlet weak var cover: UIImageView!
    
    private var indexPath: IndexPath?
    
    private func setBackgroundColor() {
        if let indexPath = indexPath {
            backgroundColor = indexPath.row % 2 == 0 ? .white : .lightGray
        }
    }
}
