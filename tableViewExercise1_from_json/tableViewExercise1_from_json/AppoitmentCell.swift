//
//  AppoitmentCell.swift
//  tableViewExercise1_from_json
//
//  Created by Third Rock Techkno on 29/01/20.
//  Copyright © 2020 Third Rock Techkno. All rights reserved.
//

import UIKit

//protocol SelectionDelegate: class {
//    func selectionChanged(with value: Bool, at indexPath: IndexPath)
//}

class AppoitmentCell: UITableViewCell {
    
    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var questionAnswerLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    var indexPath: IndexPath?
//    weak var selectionDelegate: SelectionDelegate?
    var onSelectionChange: ((Bool, IndexPath)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        newLabel.layer.cornerRadius = newLabel.frame.height/2
        newLabel.layer.masksToBounds = true
        self.selectionStyle = .none
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func checkAction(_ sender: UIButton!) {
        guard let indexPath = indexPath else { return }
        if checkButton.state == .highlighted{
            checkButton.isSelected = true
            onSelectionChange?(true, indexPath)
//            selectionDelegate?.selectionChanged(with: true, at: indexPath)
        }
        else{
            checkButton.isSelected = false
            onSelectionChange?(false, indexPath)
//            selectionDelegate?.selectionChanged(with: false, at: indexPath)
        }
    }
    
}
