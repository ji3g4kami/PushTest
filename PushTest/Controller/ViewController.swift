//
//  ViewController.swift
//  PushTest
//
//  Created by udn on 2019/8/8.
//  Copyright © 2019 dengli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBAction func presentPressed(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "present")
    present(vc, animated: true, completion: nil)
  }
  
}

