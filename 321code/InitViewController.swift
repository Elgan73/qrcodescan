//
//  InitViewController.swift
//  321code
//
//  Created by Dev Apps4Selling on 22/01/2019.
//  Copyright © 2019 Dev Apps4Selling. All rights reserved.
//

import UIKit

class InitViewController: UIViewController {
//    static func storyboardInstance() -> InitViewController? {
//        let storyboard = UIStoryboard(name: "InitViewController", bundle: nil)
//        return storyboard.instantiateInitialViewController() as? InitViewController
//    }
    
    @IBOutlet var textLabel: UILabel!
    @IBAction func didTapHomeButton(_ sender: AnyObject) {
        
        if let nextViewController = ViewController.storyboardInstance() {
//            present(nextViewController, animated: true, completion: nil)
            navigationController?.pushViewController(nextViewController, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        let nextViewController = ViewController.storyboardInstance()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        textLabel.text = ViewController.scanCode
    }
        
    
    
}
