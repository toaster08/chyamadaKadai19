//
//  AddItemViewController.swift
//  chyamadaKadai13
//
//  Created by toaster on 2021/10/05.
//

import UIKit

class NextViewController: UIViewController {
    override func viewDidLoad() {
    }
}

final class EditItemViewController: UIViewController {
    enum Mode {
        case input, edit(Fruit)
    }

    var mode: Mode?
    private(set) var itemName: String?

    @IBOutlet private weak var itemNameTextField: UITextField!
    @IBOutlet private weak var saveBarButtonItem: UIBarButtonItem!

    override func viewDidLoad() {
        saveBarButtonItem.isEnabled = false
        itemNameTextField.addTarget(self,
                                    action: #selector(itemNameTextFieldEditingChanged),
                                    for: .editingChanged)

        itemNameTextField.text = {
            switch mode {
            case .input:
                return ""
            case let .edit(fruit):
                return fruit.name
            default:
                return ""
            }
        }()
    }

    @objc private func itemNameTextFieldEditingChanged() {
        saveBarButtonItem.isEnabled = isValid(itemName: itemNameTextField.text ?? "")
        itemName = itemNameTextField.text
    }

    private func isValid(itemName: String) -> Bool {
        !itemName
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty
    }
}
