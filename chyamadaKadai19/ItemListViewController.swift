//
//  ViewController.swift
//  chyamadaKadai13
//
//  Created by 山田　天星 on 2021/09/28.
//

import UIKit

struct Fruit {
    private(set) var name: String
    var isChecked: Bool

    init?(name: String, isChecked: Bool) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            return nil
        }

        self.name = name
        self.isChecked = isChecked
    }
}

final class ItemListViewController: UIViewController {
    private let itemUserDefaults = ItemUserDefaults()

    private var fruitsList: [Fruit] = [Fruit(name: "りんご", isChecked: false),
                                       Fruit(name: "みかん", isChecked: true),
                                       Fruit(name: "バナナ", isChecked: false),
                                       Fruit(name: "パイナップル", isChecked: true)
    ].compactMap { $0 }

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(ItemListTableViewCell.nibName,
                               forCellReuseIdentifier: ItemListTableViewCell.nibID)
            tableView.delegate = self
            tableView.dataSource = self
        }
    }

    private var editingAtIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()

        let defaultItems: [Fruit] = [
            Fruit(name: "りんご", isChecked: false),
            Fruit(name: "みかん", isChecked: true),
            Fruit(name: "バナナ", isChecked: false),
            Fruit(name: "パイナップル", isChecked: true)
        ].compactMap { $0 }

        let item = itemUserDefaults.load() ?? defaultItems
        fruitsList = item
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let inputVC = (segue.destination as? UINavigationController)?.topViewController as? InputItemViewController {
            switch segue.identifier ?? "" {
            case "AddItemSegue":
                inputVC.mode = .add
            case "EditItemSegue":
                guard let editingAtIndexPath = editingAtIndexPath else { return }
                inputVC.mode = .edit(fruitsList[editingAtIndexPath.row])
            default:
                break
            }
        }
    }
}

extension ItemListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 40 }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        editingAtIndexPath = indexPath
        performSegue(withIdentifier: "EditItemSegue", sender: nil)
    }
}

extension ItemListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fruitsList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemListTableViewCell.nibID, for: indexPath)
                as? ItemListTableViewCell else {
            fatalError("The dequeued cell is not instance")
        }

        let fruit = fruitsList[indexPath.row]
        cell.configure(fruit: fruit)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        fruitsList[indexPath.row].isChecked.toggle()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        save()
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        fruitsList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        save()
    }
}

extension ItemListViewController {
    @IBAction private func didTapCancelButton(segue: UIStoryboardSegue) { }

    @IBAction private func addItem(segue: UIStoryboardSegue) {
        guard let sourceViewController = segue.source as? InputItemViewController,
              let fruit = sourceViewController.result else {
            return
        }

        fruitsList.append(fruit)
        tableView.reloadData()
        save()
    }

    @IBAction private func editItem(segue: UIStoryboardSegue) {
        guard let sourceViewController = segue.source as? InputItemViewController,
              let fruit = sourceViewController.result,
              let editingAtIndexPath = editingAtIndexPath else {
            return
        }

        fruitsList[editingAtIndexPath.row] = fruit
        tableView.reloadRows(at: [editingAtIndexPath], with: .automatic)
        save()
    }

    private func save() {
        _ = itemUserDefaults.save(item: fruitsList)
    }
}
