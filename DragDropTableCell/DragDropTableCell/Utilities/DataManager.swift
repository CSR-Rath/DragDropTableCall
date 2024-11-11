//
//  DataManager.swift
//  DragDropTableCell
//
//  Created by Rath! on 11/11/24.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    func saveDragDropMenu(data: [[String]]) {
        UserDefaults.standard.saveObject(object: data, forKey: "saveDataList")
    }
    
    func getDragDropMenu() -> [[String]]? {
        return UserDefaults.standard.getObject([[String]].self, with: "saveDataList") ?? []
    }
    
}

extension UserDefaults{

    //MARK: get object
    public func getObject<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    
    //MARK: Save object
    public func saveObject<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
