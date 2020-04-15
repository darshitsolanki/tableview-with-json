//
//  ViewControllerWithButtons.swift
//  tableViewExercise1_from_json
//
//  Created by Third Rock Techkno on 15/04/20.
//  Copyright © 2020 Third Rock Techkno. All rights reserved.
//

import UIKit

class ViewControllerWithButtons: UIViewController {


    @IBAction func switchValueChanged(_ sender: UISwitch) {
        
    }
    @IBAction func centerButtonAction(_ sender: UIButton) {
        print("center button clicked")
    }
    @IBAction func bottomButtonAction(_ sender: UIButton) {
        print("bottom button clicked")
    }
    

    @IBOutlet weak var topBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

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
