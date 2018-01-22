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
    
    fileprivate var isCodeAdjustScroll: Bool = false
    
    var topView: HomeTopView!
    var tableView: UITableView!
    var auxiliaryScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.makeUI()
    }
    
    fileprivate func makeUI() {
        
        auxiliaryScrollView = UIScrollView()
        auxiliaryScrollView.tag = auxiliaryScrollViewTag
        auxiliaryScrollView.showsVerticalScrollIndicator = false
        auxiliaryScrollView.delegate = self
        
        self.view.addSubview(auxiliaryScrollView)
        auxiliaryScrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        topView = HomeTopView()
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalTo(self.auxiliaryScrollView)
            make.height.equalTo(HomeTopView.maxHeight)
        }
    
        self.view.layoutIfNeeded()
        
        tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(UITableViewCell.classForCoder(),
                           forCellReuseIdentifier: NSStringFromClass(UITableViewCell.classForCoder()))
        auxiliaryScrollView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalTo(self.topView)

            make.height.equalTo(screenHieght-self.topView.hz_height)
        }

        self.view.layoutIfNeeded()
        auxiliaryScrollView.contentSize = CGSize(width: 0, height: tableView.contentSize.height+HomeTopView.maxHeight)
        
        
        tableView.mj_header = MJRefreshStateHeader(refreshingBlock: { [unowned self] in
            print("✅  ✅  ✅  ✅  ✅  正在刷新")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                
                print("✅  ✅  ✅  ✅  ✅  刷新结束")
                
                self.tableView.mj_header.endRefreshing()
                self.auxiliaryScrollView.contentOffset = CGPoint.zero
            })
        })

    }
    
}


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
            tableView.snp.updateConstraints({ (make) in
                make.height.equalTo(screenHieght - HomeTopView.maxHeight)
            })
            view.layoutIfNeeded()
            
        } else if offectY <= HomeTopView.maxHegithDiffer {
            
            /// 处于显示大菜单状态和小菜单之间的状态
            
            topView.snp.updateConstraints({ (make) in
                make.height.equalTo(HomeTopView.maxHeight - offectY)
            })
            view.layoutIfNeeded()
            tableView.snp.updateConstraints({ (make) in
                make.height.equalTo(screenHieght - self.topView.hz_height)
            })
            view.layoutIfNeeded()
            
        } else {
            
            /// 处于显示小菜单之间的状态
            
            topView.snp.updateConstraints({ (make) in
                make.height.equalTo(HomeTopView.minHieght)
            })
            
            tableView.snp.updateConstraints({ (make) in
                make.height.equalTo(screenHieght - HomeTopView.minHieght)
            })
            view.layoutIfNeeded()
            tableView.contentOffset = CGPoint(x: 0, y: offectY-HomeTopView.maxHegithDiffer)
            
        }

        topView.adjustContent()
        
        self.isCodeAdjustScroll = false
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let offectY = scrollView.contentOffset.y
        
        if offectY < -MJRefreshHeaderHeight  {
            
//            self.isCodeAdjustScroll = true
            
//            self.tableViewRefreshing()
            self.tableView.mj_header.beginRefreshing()
            self.auxiliaryScrollView.contentOffset = CGPoint(x: 0, y: 95)
//            self.tableView.mj_header.state = MJRefreshState.refreshing
            
            
//            self.isCodeAdjustScroll = false
        }
    
//        /** 普通闲置状态 */
//        MJRefreshStateIdle = 1,
//        /** 松开就可以进行刷新的状态 */
//        MJRefreshStatePulling,
//        /** 正在刷新中的状态 */
//        MJRefreshStateRefreshing,
//        /** 即将刷新的状态 */
//        MJRefreshStateWillRefresh,
//        /** 所有数据加载完毕，没有更多的数据了 */
//        MJRefreshStateNoMoreData
        
        if fabs(velocity.y) <= 0.1 {
            scrollViewEndScrollAdjust()
        }

    }
    
    func tableViewRefreshing() {

        self.tableView.mj_insetT = MJRefreshHeaderHeight
        self.auxiliaryScrollView.mj_insetT = MJRefreshHeaderHeight
        
//        self.tableView.mj_header.
//        self.insetTDelta = _scrollViewOriginalInset.top - insetT;
//        self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: MJRefreshHeaderHeight, left: 0, bottom: 0, right: 0)
//        self.auxiliaryScrollView.scrollIndicatorInsets = UIEdgeInsets(top: MJRefreshHeaderHeight, left: 0, bottom: 0, right: 0)
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






