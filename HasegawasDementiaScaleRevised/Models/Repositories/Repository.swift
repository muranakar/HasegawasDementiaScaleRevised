//
//  Repository.swift
//  TimerAssessment
//
//  Created by Takehito Koshimizu on 2022/02/21.
//

import Foundation
import RealmSwift

// MARK: -
typealias ResultHandler<T> = (Result<T, Error>) throws -> Void

// MARK: - Repository
class Repository<Value: Entity, ParentValue> where Value.Object.Value == Value {
    let realm: Realm
    let observingQueue: DispatchQueue

    required init(realm: Realm, observingQueue: DispatchQueue) {
        self.realm = realm
        self.observingQueue = observingQueue
    }
}

// MARK: -
extension Repository {
    func load(id: Value.ID) -> Value? {
        realm.object(ofType: Value.Object.self, forPrimaryKey: id.rawValue.uuidString)
            .flatMap(Value.init(object:))
    }

    func update(value: Value) {
        try? realm.write {
            realm.object(ofType: Value.Object.self, forPrimaryKey: value.id.rawValue.uuidString)?
                .update(value: value)
        }
    }

    func remove(id: Value.ID) {
        guard let object = realm.object(ofType: Value.Object.self, forPrimaryKey: id.rawValue.uuidString) else {
            return
        }
        try? realm.write {
            realm.delete(object)
        }
    }
}

// MARK: - non parent extensions
extension Repository where ParentValue == Never {
    func load() -> [Value] {
        realm.objects(Value.Object.self).compactMap(Value.init(object:))
    }

    func add(value: Value) {
        try? realm.write {
            realm.add(Value.Object(value: value))
        }
    }

    func observe(callBack: @escaping ResultHandler<[Value]>) -> NotificationToken {
        realm.objects(Value.Object.self).observe(on: observingQueue) { changes in
            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                try? callBack(.success(results.compactMap(Value.init(object:))))
            case .error(let error):
                try? callBack(.failure(error))
            }
        }
    }
}

// MARK: - parent extensions
extension Repository where ParentValue: Entity,
                           ParentValue.Object: RealmEntityParent,
                           ParentValue.Object.Child == Value.Object {
    func load(id: ParentValue.ID) -> [Value] {
        realm.object(ofType: ParentValue.Object.self, forPrimaryKey: id.rawValue.uuidString)?
            .childlen
            .compactMap(Value.init(object:)) ?? []
    }

    func load(id: ParentValue.ID, sortKey: String, ascending: Bool) -> [Value] {
        realm.object(ofType: ParentValue.Object.self, forPrimaryKey: id.rawValue.uuidString)?
            .childlen
            .sorted(byKeyPath: sortKey, ascending: ascending)
            .compactMap(Value.init(object:)) ?? []
    }

    func add(value: Value, id: ParentValue.ID) {
        guard let parent = realm.object(ofType: ParentValue.Object.self, forPrimaryKey: id.rawValue.uuidString) else {
            return
        }
        try? realm.write {
            parent.childlen.append(Value.Object(value: value))
        }
    }

    func observe(id: ParentValue.ID, callBack: @escaping ResultHandler<[Value]>) -> NotificationToken {
        observeObjects(id: id) { result in
            try? callBack(result.map { list in
                list.compactMap(Value.init(object:))
            })
        }
    }

    func observe(
        id: ParentValue.ID,
        sortKey: String,
        ascending: @escaping () -> Bool?,
        callBack: @escaping ResultHandler<[Value]>
    ) -> NotificationToken {
        observeObjects(id: id) { result in
            try? callBack(result.map { list in
                list.sorted(byKeyPath: sortKey, ascending: ascending() ?? true)
                    .compactMap(Value.init(object:))
            })
        }
    }

    private func observeObjects(
        id: ParentValue.ID,
        callBack: @escaping ResultHandler<List<Value.Object>>
    ) -> NotificationToken {
        realm.objects(ParentValue.Object.self).observe(on: observingQueue) { changes in
            switch changes {
            case .initial(let results), .update(let results, _, _, _):
                let parent = results
                    .filter(NSPredicate(format: "uuidString = %@", argumentArray: [id.rawValue.uuidString]))
                    .first
                if let persons = parent?.childlen {
                    try? callBack(.success(persons))
                }
            case .error(let error):
                try? callBack(.failure(error))
            }
        }
    }
}
