//
//  RecipeTableCellTableViewCell.swift
//  recipe-app
//
//  Created by User on 22/04/2024.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeNameLabel: UILabel!
    
    static let identifier = "RecipeTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "RecipeTableViewCell", bundle: nil)
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
