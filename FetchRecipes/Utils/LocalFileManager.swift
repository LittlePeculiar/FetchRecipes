//
//  LocalFileManager.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/17/24.
//

import Foundation

/*
 for creating and fetching data to local
 currently used for images
 */

class LocalFileManager {
    static let shared = LocalFileManager()
    private let fileManager = FileManager.default
    
    private init() {}
    
    func save(data: Data, urlPath: String) {
        guard let filePath = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask).first?.appendingPathComponent(urlPath) else {
            print("Error creating path: \(urlPath)")
            return
        }
        let path = filePath.path
        
        if !fileManager.fileExists(atPath: path) {
            fileManager.createFile(atPath: path, contents: data)
        } else {
            do {
                try data.write(to: filePath)
            } catch let error {
                print("error saving path: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchData(urlPath: String) -> Data? {
        guard let filePath = fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask).first?.appendingPathComponent(urlPath) else {
            print("Error creating path: \(urlPath)")
            return nil
        }
        let path = filePath.path
        
        if fileManager.fileExists(atPath: path) {
            do {
                return try Data(contentsOf: filePath)
            } catch let error {
                print("error fetching path: \(error.localizedDescription)")
            }
        }
        
        return nil
    }
}
