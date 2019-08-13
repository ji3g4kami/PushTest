//
//  ViewController.swift
//  PushTest
//
//  Created by udn on 2019/8/8.
//  Copyright © 2019 dengli. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var customImage: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func presentPressed(_ sender: Any) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "present")
    present(vc, animated: true, completion: nil)
  }
  
  func chaneCustomImage(imageUrl: URL) {
    self.customImage.image = try? UIImage(withContentsOfUrl: imageUrl)
  }
  
}

extension UIImage {
  
  convenience init?(withContentsOfUrl url: URL) throws {
    let imageData = try Data(contentsOf: url)
    
    self.init(data: imageData)
  }
  
}
