//
//  ViewController.swift
//  recipe-app
//
//  Created by User on 20/04/2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var recipeTableView: UITableView!
    var recipes: [Recipe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Recipe App", comment: "")
        
        recipeTableView.dataSource = self
        recipeTableView.delegate = self
        recipeTableView.reloadData()
        recipeTableView.register(RecipeTableViewCell.nib(), forCellReuseIdentifier: RecipeTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadRecipes()
        recipeTableView.reloadData()
    }
    
    func loadRecipes() {
        let dataParser = DataParser()
        if let loadedRecipes = dataParser.loadRecipes() {
            recipes = loadedRecipes
        } else {
            recipes = []
        }
    }
    
    @IBAction func onAddRecipeButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddRecipeViewController") as! AddRecipeViewController
        vc.isAddRecipe = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier, for: indexPath) as! RecipeTableViewCell
        
        let recipe = recipes[indexPath.row]
        cell.recipeNameLabel.text = recipe.recipeName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "AddRecipeViewController") as! AddRecipeViewController
        let selectedRecipe = recipes[indexPath.row]
        vc.selectedRecipe = selectedRecipe
        vc.editIndex = indexPath.row
        vc.isReadOnly = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

