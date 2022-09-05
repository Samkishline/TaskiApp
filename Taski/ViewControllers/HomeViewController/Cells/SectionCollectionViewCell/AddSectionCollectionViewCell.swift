//
//  AddSectionCollectionViewCell.swift
//  Taski
//
//  Created by Sam Kishline
//

import UIKit

protocol AddSectionDelegate {
    func addCategoryButtonClicked()
}
class AddSectionCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addCategoryButton: UIButton!
    var delegate: AddSectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

// MARK: - Action Methods
extension AddSectionCollectionViewCell {
    
    @IBAction func addCategoryButtonClicked(_ sender: UIButton) {
        self.delegate?.addCategoryButtonClicked()
    }
}
