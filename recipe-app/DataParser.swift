//
//  DataParser.swift
//  recipe-app
//
//  Created by User on 22/04/2024.
//

import Foundation

class DataParser: NSObject, XMLParserDelegate {
    var recipeTypes = [String]()
    var currentType: String?

    func parseXML() {
        if let path = Bundle.main.path(forResource: "recipetype", ofType: "xml") {
            if let parser = XMLParser(contentsOf: URL(fileURLWithPath: path)) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "type" {
            currentType = String()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentType? += string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "type", let type = currentType {
            recipeTypes.append(type)
            currentType = nil
        }
    }
    
    func saveRecipes(_ recipes: [Recipe]) {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(recipes)
            UserDefaults.standard.set(encodedData, forKey: "recipes")
        } catch {
            print("Error encoding recipes: \(error)")
        }
    }
    
    func loadRecipes() -> [Recipe]? {
        guard let encodedData = UserDefaults.standard.data(forKey: "recipes") else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let recipes = try decoder.decode([Recipe].self, from: encodedData)
            return recipes
        } catch {
            print("Error decoding recipes: \(error)")
            return nil
        }
    }
    
    func createRecipeList(recipeName: String, recipeDirections: String, recipeCategory: String) -> Recipe {
        

        return Recipe(recipeName: recipeName, recipeDirections: recipeDirections, recipeCategory: recipeCategory)
    
    }
    
    func convertToJSON(recipes: [Recipe]) -> Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        do {
            let jsonData = try encoder.encode(recipes)
            return jsonData
        } catch {
            print("Error encoding recipes to JSON: \(error)")
            return nil
        }
    }
}
