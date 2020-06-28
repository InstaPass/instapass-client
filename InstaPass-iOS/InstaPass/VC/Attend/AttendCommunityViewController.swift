//
//  AttendCommunityViewController.swift
//  InstaPass
//
//  Created by 法好 on 2020/6/27.
//  Copyright © 2020 yuetsin. All rights reserved.
//

import UIKit

class AttendCommunityViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addTapView.isUserInteractionEnabled = true
        let tapViewTap = UITapGestureRecognizer(target: self, action: #selector(addButtonTapped))
        addTapView.addGestureRecognizer(tapViewTap)
        
        redrawPageShadow()
    }
    
    @IBOutlet weak var addTapView: UIVisualEffectView!
    
    @objc func addButtonTapped() {
        
    }
    
    func redrawPageShadow() {
        addTapView.layer.cornerRadius = 20
        addTapView.layer.shadowColor = UIColor.label.cgColor
        addTapView.layer.shadowOffset = CGSize(width: 0, height: 3)
        addTapView.layer.shadowRadius = 20
        addTapView.layer.shadowOpacity = 0.22
//        cardView.clipsToBounds = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        redrawPageShadow()
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
