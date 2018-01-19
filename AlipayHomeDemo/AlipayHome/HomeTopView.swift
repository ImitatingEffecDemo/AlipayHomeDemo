//
//  HomeTopView.swift
//  AlipayHomeDemo
//
//  Created by Harious on 2018/1/19.
//  Copyright © 2018年 zzh. All rights reserved.
//

import UIKit

extension HomeTopView {
    static let topViewTopMargin: CGFloat = 20
    static let miniMenuHeight: CGFloat = 44
    static let maxMenuHeight: CGFloat = 70
    static let topViewHieght: CGFloat = miniMenuHeight
    static let menuMargin: CGFloat = 20
    static let maxMenuBottomMargin: CGFloat = 20
    
    static let minHieght: CGFloat = miniMenuHeight
    static let maxHeight: CGFloat = topViewTopMargin + miniMenuHeight + menuMargin + maxMenuHeight + maxMenuBottomMargin
}

extension HomeTopView {
    fileprivate var topViewTopMargin: CGFloat {
        return HomeTopView.topViewTopMargin
    }
    fileprivate var miniMenuHeight: CGFloat {
        return HomeTopView.miniMenuHeight
    }
    fileprivate var maxMenuHeight: CGFloat {
        return HomeTopView.maxMenuHeight
    }
    fileprivate var topViewHieght: CGFloat {
        return HomeTopView.topViewHieght
    }
    fileprivate var menuMargin: CGFloat {
        return HomeTopView.menuMargin
    }
    fileprivate var maxMenuBottomMargin: CGFloat {
        return HomeTopView.maxMenuBottomMargin
    }
    fileprivate var minHieght: CGFloat {
        return HomeTopView.minHieght
    }
    fileprivate var maxHeight: CGFloat {
        return HomeTopView.maxHeight
    }
}



class HomeTopView: UIView {

    fileprivate(set) lazy var miniMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.orange
        return view
    }()
    
    fileprivate(set) lazy var maxMenuView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        return view
    }()
    
    fileprivate(set) lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.brown
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.green
        
        self.addSubview(miniMenuView)
        self.addSubview(maxMenuView)
        self.addSubview(topView)
        
        self.miniMenuView.isHidden = true
        
        self.topView.snp.makeConstraints { (make) in
            make.top.equalTo(topViewTopMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(miniMenuHeight)
        }
        self.miniMenuView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(miniMenuHeight)
        }
        self.maxMenuView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(menuMargin)
            make.left.right.equalToSuperview()
            make.height.equalTo(maxMenuHeight)
            make.bottom.equalTo(-maxMenuBottomMargin)
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
