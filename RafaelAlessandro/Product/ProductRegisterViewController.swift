//
//  ProductRegisterViewController.swift
//  RafaelAlessandro
//
//  Created by Usuário Convidado on 21/10/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import UIKit
import CoreData

class ProductRegisterViewController: UIViewController {
    
    var product: Product!
    
    @IBOutlet weak var lbName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
