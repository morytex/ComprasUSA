//
//  UIViewController+CoreData.swift
//  RafaelAlessandro
//
//  Created by Usuário Convidado on 21/10/17.
//  Copyright © 2017 FIAP. All rights reserved.
//

import CoreData
import UIKit

extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    var context: NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
}
