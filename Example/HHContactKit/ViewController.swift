//
//  ViewController.swift
//  HHContactKit
//
//  Created by chinafengjun@gmail.com on 06/27/2019.
//  Copyright (c) 2019 chinafengjun@gmail.com. All rights reserved.
//

import UIKit
import HHContactKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            ContactKit.query { (contacts) in
                print(contacts.count)
            }
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

