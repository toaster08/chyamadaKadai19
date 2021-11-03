//
//  TableViewCell.swift
//  chyamadaKadai13
//
//  Created by 山田　天星 on 2021/09/28.
//

import UIKit

final class ItemListTableViewCell: UITableViewCell {
    static let nibName = UINib(nibName: "TableViewCell", bundle: nil)
    static let nibID = "Cell"

    @IBOutlet private weak var checkImageView: UIImageView!
    @IBOutlet private weak var itemNameLabel: UILabel!

    func configure(fruit: Fruit) {
        itemNameLabel.text = fruit.name
        checkImageView.image = fruit.isChecked ? UIImage(systemName: "checkmark") : nil
    }
}
