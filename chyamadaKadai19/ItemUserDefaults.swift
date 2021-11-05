//
//  ItemUserDefaults.swift
//  chyamadaKadai17
//
//  Created by toaster on 2021/11/03.
//

import Foundation

private struct FruitDTO: Codable {
    var name: String
    var isChecked: Bool

    init(fruit: Fruit) {
        name = fruit.name
        isChecked = fruit.isChecked
    }
}

private extension Fruit {
    init?(dto: FruitDTO) {
        self.init(name: dto.name, isChecked: dto.isChecked)
    }
}

final class ItemUserDefaults {
    private let itemUserDefaultsKey = "ItemList"

    func save(item: [Fruit]) -> Bool {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        guard let data = try? jsonEncoder.encode(item.map(FruitDTO.init(fruit:))) else {
            return false
        }
        UserDefaults.standard.set(data, forKey: itemUserDefaultsKey)
        return true
    }

    func load() -> [Fruit]? {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = UserDefaults.standard.data(forKey: itemUserDefaultsKey),
              let dtos = try? jsonDecoder.decode([FruitDTO].self, from: data) else {
            return nil
        }
        return dtos.compactMap(Fruit.init(dto:))
    }
}
