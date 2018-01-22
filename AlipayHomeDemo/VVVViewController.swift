//
//  VVVViewController.swift
//  AlipayHomeDemo
//
//  Created by Harious on 2018/1/22.
//  Copyright © 2018年 zzh. All rights reserved.
//

import UIKit

class VVVViewController: UIViewController {
    
    var vvvOne: UIView!
    var vvvTwo: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        vvvOne = UIView()
        vvvOne.backgroundColor = UIColor.orange
        self.view.addSubview(vvvOne)
        vvvOne.snp.makeConstraints { (make) in
            make.left.top.equalTo(100)
            make.width.height.equalTo(200)
        }
        
        vvvTwo = UIView()
        vvvTwo.backgroundColor = UIColor.green
        vvvOne.addSubview(vvvTwo)
        vvvTwo.snp.makeConstraints { (make) in
            make.top.left.equalTo(50)
            make.width.height.equalTo(self.vvvOne)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }

    deinit {
        print("12345678987654345678")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
