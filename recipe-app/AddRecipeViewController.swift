//
//  AddRecipeViewController.swift
//  recipe-app
//
//  Created by User on 20/04/2024.
//

import UIKit

class AddRecipeViewController: UIViewController {
   
    @IBOutlet weak var recipeTextView: UITextView!
    @IBOutlet weak var recipeNameField: UITextField!
    @IBOutlet weak var recipePicker: UIPickerView!
    @IBOutlet weak var AddRecipeButton: UIButton!
    @IBOutlet weak var DeleteRecipeButton: UIButton!
    
    let recipePlaceholder = "Add Recipe here..."
    var recipeTypes = [String]()
    var recipeDirections = ""
    var recipeCategory = ""
    
    var selectedRecipe: Recipe?
    var editIndex: Int?
    var isAddRecipe = false
    var isReadOnly = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = NSLocalizedString("Add Recipe", comment: "")
        self.view.isUserInteractionEnabled = true
        setupPickerView()
        setupRecipeTextView()
        configureUI()
        loadData()
    }
    
    func setupRecipeTextView() {
        self.recipeTextView.textColor = .lightGray
        self.recipeTextView.text = recipePlaceholder
        self.recipeTextView.layer.borderWidth = 1.0
        self.recipeTextView.layer.borderColor = UIColor.lightGray.cgColor
        self.recipeTextView.layer.cornerRadius = 5.0
        self.recipeTextView.delegate = self
    }
    
    func setupPickerView(){
        let parser = DataParser()
        parser.parseXML()
        recipeTypes = parser.recipeTypes
        recipeCategory = recipeTypes[0]
        
        recipePicker.dataSource = self
        recipePicker.delegate = self
    }
    
    func configureUI() {
        recipeNameField.isEnabled = !isReadOnly
        recipeTextView.isEditable = !isReadOnly
        recipePicker.isUserInteractionEnabled = !isReadOnly
       
        if isReadOnly {
            recipeNameField.textColor = .lightGray
            recipeTextView.textColor = .lightGray
            AddRecipeButton.setTitle("Edit", for: .normal)
        } else if isAddRecipe {
            setupRecipeTextView()
            DeleteRecipeButton.isHidden = true
        }
        else {
            recipeNameField.textColor = .black
            recipeTextView.textColor = .black
            AddRecipeButton.setTitle("Save", for: .normal)
        }
    }
    
    func loadData() {
            guard let selectedRecipe = selectedRecipe else { return }
            recipeNameField.text = selectedRecipe.recipeName
            recipeTextView.text = selectedRecipe.recipeDirections
            recipeCategory = selectedRecipe.recipeCategory
            
           
            if let index = recipeTypes.firstIndex(of: recipeCategory) {
                recipePicker.selectRow(index, inComponent: 0, animated: false)
            }
        }
    
    @objc func editButtonTapped() {
       
        recipeNameField.isEnabled = true
        recipeTextView.isEditable = true
        recipePicker.isUserInteractionEnabled = true
        
        AddRecipeButton.setTitle("Save", for: .normal)
        AddRecipeButton.removeTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        AddRecipeButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        let dataParser = DataParser()
        var recipeList = dataParser.loadRecipes() ?? []
        
        if let editIndex = editIndex, editIndex < recipeList.count {
           
            recipeList[editIndex].recipeName = recipeNameField.text ?? ""
            recipeList[editIndex].recipeDirections = recipeDirections
            recipeList[editIndex].recipeCategory = recipeCategory
        } else {
           
            let newRecipe = Recipe(recipeName: recipeNameField.text ?? "",
                                   recipeDirections: recipeDirections,
                                   recipeCategory: recipeCategory)
            recipeList.append(newRecipe)
        }
        
        dataParser.saveRecipes(recipeList)
        
        navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func onAddRecipeButtonTapped(_ sender: Any) {
        if(isReadOnly){
            isReadOnly = false
            configureUI()
            recipeTextView.becomeFirstResponder()
        } else {
            recipeTextView.resignFirstResponder()
            let dataParser = DataParser()
            var recipeList = dataParser.loadRecipes() ?? []
            
            if let editIndex = editIndex, editIndex < recipeList.count {
                recipeList[editIndex].recipeName = recipeNameField.text ?? ""
                recipeList[editIndex].recipeDirections = recipeDirections
                recipeList[editIndex].recipeCategory = recipeCategory
            } else {
                let newRecipe = Recipe(recipeName: recipeNameField.text ?? "",
                                       recipeDirections: recipeDirections,
                                       recipeCategory: recipeCategory)
                recipeList.append(newRecipe)
            }
            
            dataParser.saveRecipes(recipeList)
            
            // for testing purpose
            if let jsonData = dataParser.convertToJSON(recipes: recipeList) {
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                   
                    print(jsonString)
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onDeleteButtonTapped(_ sender: Any) {
        guard let editIndex = editIndex else { return }
        var recipeList = DataParser().loadRecipes() ?? []
            
        if editIndex < recipeList.count {
            recipeList.remove(at: editIndex)
            DataParser().saveRecipes(recipeList)
            
            navigationController?.popViewController(animated: true)
        }
    }
}

extension AddRecipeViewController: UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray && textView.text == recipePlaceholder{
            textView.text = nil
            textView.textColor = .black
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""  {
            textView.text = recipePlaceholder
            textView.textColor = .lightGray
            recipeDirections = ""
        } else {
            recipeDirections = textView.text
        }
        textView.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedType = recipeTypes[row]
        recipeCategory = selectedType
    }
}
