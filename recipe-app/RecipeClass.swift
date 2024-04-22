//
//  RecipeClass.swift
//  recipe-app
//
//  Created by User on 22/04/2024.
//

class Recipe: Codable {
    var recipeName: String
    var recipeDirections: String
    var recipeCategory: String

    init(recipeName: String, recipeDirections: String, recipeCategory: String) {
        self.recipeName = recipeName
        self.recipeDirections = recipeDirections
        self.recipeCategory = recipeCategory
    }
}
