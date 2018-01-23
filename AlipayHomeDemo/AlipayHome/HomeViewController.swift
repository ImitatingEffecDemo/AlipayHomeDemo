//
//  HomeViewController.swift
//  AlipayHomeDemo
//
//  Created by Harious on 2018/1/19.
//  Copyright © 2018年 zzh. All rights reserved.
//

import UIKit
import SnapKit
import MJRefresh

class HomeViewController: UIViewController {
    
    fileprivate let auxiliaryScrollViewTag = 23745
    /// 是否是代码引起的滑动，而不是手拖动引起的滑动
    fileprivate var isCodeAdjustScroll: Bool = false
    
    /// 除了tableview外，上面的视图
    var topView: HomeTopView!
    var tableView: UITableView!
    /// 辅助联动效果的scrollview
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
            make.height.equalTo(HomeTopView.maxHeight)
        }
    
        auxiliaryScrollView = UIScrollView()
        auxiliaryScrollView.tag = auxiliaryScrollViewTag
        auxiliaryScrollView.showsVerticalScrollIndicator = false
        auxiliaryScrollView.delegate = self
        self.view.addSubview(auxiliaryScrollView)
        auxiliaryScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        auxiliaryScrollView.clipsToBounds = true
        
        self.view.layoutIfNeeded()
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.classForCoder(),
                           forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        auxiliaryScrollView.addSubview(tableView)
        tableView.backgroundColor = UIColor.clear
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            // ⚠️⚠️⚠️这里很重要，让tableview的顶部挨着topView的底部，而不是与辅助scrollview的顶部持平
            make.top.equalTo(self.topView.snp.bottom)
            make.left.equalToSuperview()
            make.width.height.equalTo(self.auxiliaryScrollView)
        }

        self.view.layoutIfNeeded()
        
        if tableView.contentSize.height <= screenHeight-HomeTopView.minHieght {
            /// 解决tableview内容少的问题，后面的额外加的100可适当调整
            auxiliaryScrollView.contentSize = CGSize(width: 0, height: screenHeight-HomeTopView.minHieght+100)
        } else {
            auxiliaryScrollView.contentSize = CGSize(width: 0, height: tableView.contentSize.height + HomeTopView.maxHegithDiffer)
        }
        
        /// ⚠️⚠️⚠️注意：上拉加载和下拉刷新谁放在辅助scrollview视图上的
        auxiliaryScrollView.mj_header =  MJRefreshStateHeader(refreshingBlock: { [unowned self] in
            print("✅  ✅  ✅  ✅  ✅  正在刷新")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                
                print("✅  ✅  ✅  ✅  ✅  刷新结束")
                
                self.auxiliaryScrollView.mj_header.endRefreshing()
            })
        })
        
        auxiliaryScrollView.mj_footer = MJRefreshBackStateFooter(refreshingBlock: { [unowned self] in
            print("✅  ✅  ✅  ✅  ✅  正在加载更多")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                
                print("✅  ✅  ✅  ✅  ✅  加载更多结束")
                
                self.auxiliaryScrollView.mj_footer.endRefreshing()
            })
        })

    }
    
}

//MARK: --------------- UIScrollViewDelegate ------------------
extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView.tag == auxiliaryScrollViewTag else { return }
        if isCodeAdjustScroll { return }
        
        self.isCodeAdjustScroll = true
        
        let offectY = scrollView.contentOffset.y
        
        if offectY <= 0 {
            
            /// 处于显示大菜单状态
            tableView.contentOffset = scrollView.contentOffset
            
            topView.snp.updateConstraints({ (make) in
                make.height.equalTo(HomeTopView.maxHeight)
            })
            
            view.layoutIfNeeded()
            
        } else if offectY <= HomeTopView.maxHegithDiffer {
            
            /// 处于显示大菜单状态和小菜单之间的状态
            
            topView.snp.updateConstraints({ (make) in
                make.height.equalTo(HomeTopView.maxHeight - offectY)
            })
            view.layoutIfNeeded()
        } else {
            
            /// 处于显示小菜单之间的状态
            
            topView.snp.updateConstraints({ (make) in
                make.height.equalTo(HomeTopView.minHieght)
            })

            view.layoutIfNeeded()
            tableView.contentOffset = CGPoint(x: 0, y: offectY-HomeTopView.maxHegithDiffer)

        }
        
        /// 去调整上面视图内容视图
        topView.adjustContent()
        
        self.isCodeAdjustScroll = false
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if fabs(velocity.y) <= 0.1 {
            scrollViewEndScrollAdjust()
        }

    }

    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        scrollViewEndScrollAdjust()
    }

    /// scrollView 结束滑动时的调整
    fileprivate func scrollViewEndScrollAdjust() {
        isCodeAdjustScroll = true
        
        let topHieght = self.topView.hz_height
        
        if topHieght <= HomeTopView.minHieght {
            
            isCodeAdjustScroll = false
        } else if topHieght >= HomeTopView.maxHeight {
            
            isCodeAdjustScroll = false
        } else {
            let differ = HomeTopView.maxHeight - topHieght
            
            
            if differ < HomeTopView.maxHegithDiffer*0.4 {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.contentOffset = CGPoint.zero
                    self.topView.snp.updateConstraints({ (make) in
                        make.height.equalTo(HomeTopView.maxHeight)
                    })
                    self.topView.showWholeTopView()
                    self.view.layoutIfNeeded()
                }, completion: { (_) in
                    self.auxiliaryScrollView.contentOffset = CGPoint.zero
                    self.isCodeAdjustScroll = false
                })
                
            } else {
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.tableView.contentOffset = CGPoint.zero
                    self.topView.snp.updateConstraints({ (make) in
                        make.height.equalTo(HomeTopView.minHieght)
                    })
                    self.topView.showWholeMiniView()
                    self.view.layoutIfNeeded()
                }, completion: { (_) in
                    
                    self.auxiliaryScrollView.contentOffset = CGPoint(x: 0, y: HomeTopView.maxHegithDiffer)
                    self.isCodeAdjustScroll = false
                })
            }
            
        }
    }
}

//MARK: --------------- UITableViewDelegate, UITableViewDataSource ------------------
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





