//
//  AppoitmentViewController.swift
//  tableViewExercise1_from_json
//
//  Created by Third Rock Techkno on 29/01/20.
//  Copyright © 2020 Third Rock Techkno. All rights reserved.
//

import UIKit

class AppoitmentViewController: UIViewController {

    var date:String = ""
    var time:String = ""
    
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        labelTime.text = time
        labelDate.text = date
//        labelTime.
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
