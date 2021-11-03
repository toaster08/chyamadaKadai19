//
//  ItemUserDefaults.swift
//  chyamadaKadai17
//
//  Created by toaster on 2021/11/03.
//

import Foundation

final class ItemUserDefaults {
    private let itemUserDefaultsKey = "ItemList"

    func save(item: [Fruit]) {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(item) else {
            return
        }
        UserDefaults.standard.set(data, forKey: itemUserDefaultsKey)
    }

    func load() -> [Fruit] {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: itemUserDefaultsKey),
              let item = try? jsonDecoder.decode([Fruit].self, from: data) else {
            return [Fruit(name: "りんご", isChecked: false),
                    Fruit(name: "みかん", isChecked: true),
                    Fruit(name: "バナナ", isChecked: false),
                    Fruit(name: "パイナップル", isChecked: true)].compactMap { $0 }
        }
        return item
    }
}
