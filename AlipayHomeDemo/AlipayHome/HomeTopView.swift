//
//  HomeTopView.swift
//  AlipayHomeDemo
//
//  Created by Harious on 2018/1/19.
//  Copyright © 2018年 zzh. All rights reserved.
//

import UIKit

let screenWidth: CGFloat = UIScreen.main.bounds.size.width
let screenHeight: CGFloat = UIScreen.main.bounds.size.height
let is_iPhone_X : Bool = ((screenHeight == 812 && screenWidth == 375) || (screenHeight == 372 && screenWidth == 812))

extension HomeTopView {
    /// 初始时小菜单里顶部的间距
    static let topViewTopMargin: CGFloat = 20 + (is_iPhone_X ? 14 : 0)
    /// 初始时小菜单高度
    static let miniMenuHeight: CGFloat = 44
    /// 初始时大菜单高度
    static let maxMenuHeight: CGFloat = 60
    /// 初始时大小菜单之间的间距
    static let middleMargin: CGFloat = 10
    /// 初始时大菜单离底部的间隙
    static let maxMenuBottomMargin: CGFloat = 8
    
    /// 整个视图允许的最小高度
    static let minHieght: CGFloat = miniMenuHeight + topViewTopMargin
    /// 整个视图允许的最大高度
    static let maxHeight: CGFloat = minHieght + middleMargin + maxMenuHeight + maxMenuBottomMargin
    /// 整个视图允许的最大最小高度差
    static let maxHegithDiffer: CGFloat = maxHeight - minHieght
}

//MARK: --------------- 拓展计算属性，方便本文件访问类属性 ------------------
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

    fileprivate var maxMenuBottomMargin: CGFloat {
        return HomeTopView.maxMenuBottomMargin
    }
    fileprivate var minHieght: CGFloat {
        return HomeTopView.minHieght
    }
    fileprivate var maxHeight: CGFloat {
        return HomeTopView.maxHeight
    }
    fileprivate var maxHegithDiffer: CGFloat {
        return HomeTopView.maxHegithDiffer
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
        
        self.clipsToBounds = true
        
        self.backgroundColor = UIColor.green.withAlphaComponent(0.4)
        
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
            make.top.equalTo(self.topView)
            make.left.right.equalToSuperview()
            make.height.equalTo(miniMenuHeight)
        }
        self.maxMenuView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(maxMenuHeight)
            make.bottom.equalTo(-maxMenuBottomMargin)
        }
        
    }
    
    /// 根据自身高度调节子视图
    func adjustContent() {
        
        if hz_height >= maxHeight {
            
            showTopView(1)
            maxMenuView.alpha = 1
            maxMenuView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(-maxMenuBottomMargin)
            })
            
            layoutIfNeeded()
        } else if hz_height <= minHieght {
            
            showMiniView(1)
            maxMenuView.alpha = 0
            maxMenuView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(-maxMenuBottomMargin+maxHegithDiffer*0.5)
            })
            
            layoutIfNeeded()
        } else {
            
            let differ = maxHeight - hz_height
            
            if differ < maxHegithDiffer*0.3 {
                showTopView(1-differ/(maxHegithDiffer*0.3))
            } else {
                showMiniView((differ-maxHegithDiffer*0.3)/(maxHegithDiffer*0.7))
            }
            
            maxMenuView.alpha = 1 - (differ / (maxHegithDiffer * 0.5))
            maxMenuView.snp.updateConstraints({ (make) in
                make.bottom.equalTo(-maxMenuBottomMargin+differ*0.5)
            })
            
            layoutIfNeeded()
        }
    }
    
    func showWholeTopView() {
        showTopView(1)

        maxMenuView.alpha = 1
        
        maxMenuView.snp.updateConstraints({ (make) in
            make.bottom.equalTo(-maxMenuBottomMargin)
        })
        
        layoutIfNeeded()
    }
    
    func showTopView(_ alpha: CGFloat) {
        topView.isHidden = false
        topView.alpha = alpha
        
        miniMenuView.isHidden = true
        miniMenuView.alpha = 0
    }
    
    func showWholeMiniView() {
        showMiniView(1)
        
        maxMenuView.alpha = 0
        
        maxMenuView.snp.updateConstraints({ (make) in
            make.bottom.equalTo(-maxMenuBottomMargin+maxHegithDiffer*0.5)
        })
        
        layoutIfNeeded()
    }
    
    func showMiniView(_ alpha: CGFloat) {
        miniMenuView.isHidden = false
        miniMenuView.alpha = alpha
        
        topView.isHidden = true
        topView.alpha = 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
