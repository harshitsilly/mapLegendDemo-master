//
//  FUIMapCornerViewController.swift
//  MapLegendDemo
//
//  Created by Takahashi, Alex on 8/4/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import UIKit

class FUIMapCornerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let navigationController = UINavigationController(rootViewController: DummmyVC())
        let btnDone = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissNav))
        navigationController.isNavigationBarHidden = true
        self.view.addSubview(navigationController.view)
    }
    
    @objc func dismissNav() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class DummmyVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
    }
}
