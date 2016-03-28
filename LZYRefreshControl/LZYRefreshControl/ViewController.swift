//
//  ViewController.swift
//  LZYRefreshControl
//
//  Created by 刘朝阳 on 16/3/28.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //添加控件
        self.tableView.addSubview(refreshingControl)
        
        refreshingControl.addTarget(self, action: #selector(ViewController.loadData), forControlEvents: .TouchCancel)

    }
    
    @objc private func loadData(){
        
        print("加载数据");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64((2 * Double(NSEC_PER_SEC)))), dispatch_get_main_queue(), {
            //结束刷新
            self.refreshingControl.endRefreshing()
        });
        
    }
    //下拉刷新控件
    private lazy var refreshingControl: RefreshControl = RefreshControl()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

