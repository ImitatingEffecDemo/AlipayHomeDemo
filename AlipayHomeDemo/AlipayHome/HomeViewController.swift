//
//  HomeViewController.swift
//  AlipayHomeDemo
//
//  Created by Harious on 2018/1/19.
//  Copyright © 2018年 zzh. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    fileprivate let auxiliaryScrollViewTag = 23745
    
    var topView: HomeTopView!
    var tableView: UITableView!
    var auxiliaryScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.makeUI()
    }
    
    fileprivate func makeUI() {
        topView = HomeTopView()
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.classForCoder(),
                           forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        let upSwipeGes = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
        upSwipeGes.direction = .up
        self.view.addGestureRecognizer(upSwipeGes)
        let downSwipeGes = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        downSwipeGes.direction = .down
        self.view.addGestureRecognizer(downSwipeGes)
        
        
//        auxiliaryScrollView = UIScrollView()
//        auxiliaryScrollView.tag = auxiliaryScrollViewTag
//        self.view.addSubview(auxiliaryScrollView)
//        auxiliaryScrollView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
//        }
    }
    
    @objc fileprivate func swipeUp(_ swipeGes: UISwipeGestureRecognizer) {
        print("up up up")
    }
    @objc fileprivate func swipeDown(_ swipeGes: UISwipeGestureRecognizer) {
        print("down down down")
    }
    
}


extension HomeViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollViewDidScroll")
        guard scrollView.tag == auxiliaryScrollViewTag else {
            return
        }
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))!
        cell.textLabel?.text = "你好呀   ，    我很好"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了第 \(indexPath.row) 个cell")
    }
}






