//
//  RefreshControl.swift
//  xinlangweibo
//
//  Created by 刘朝阳 on 16/3/10.
//  Copyright © 2016年 刘朝阳. All rights reserved.
//

import UIKit
/// 刷新控件的三种状态
///
/// - Normal:     默认
/// - Pulling:    松手就可以去刷新的状态
/// - Refreshing: 正在刷新的状态
enum RefreshContolState: Int {
    case Nomal = 0
    case Pulling = 1
    case Refreshing = 2
}

class RefreshControl: UIControl {
    
    //MARK: - 当前控件状态
    var refreshState: RefreshContolState = .Nomal{
        
        didSet{
            
            switch refreshState {
            case .Pulling:
                //松手就刷新状态❤️
                messageLabel.text = "松手就起飞ʚɞ"
                //调转箭头
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.arrowImage.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                })
                
            case .Nomal:
                //默认状态❤️
                // 0. 箭头显示,菊花隐藏
                arrowImage.hidden = false
                indicatorView.stopAnimating()
                // 1. 文字改变
                messageLabel.text = "带你装B 带你飞"
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    // 2. 箭头调头
                    self.arrowImage.transform = CGAffineTransformIdentity
                })
                
                if oldValue == .Refreshing {
                    // 判断上一次状态是刷新中状态,那么进入到Normal状态就需要去减去InsetTop
                    UIView.animateWithDuration(0.25, animations: { () -> Void in
                        self.scrollView?.contentInset.top -= self.refreshViewH
                    })
                }
            case .Refreshing:
                //刷新中状态❤️
                // 1. 隐藏箭头
                arrowImage.hidden = true
                // 2. 显示菊花转
                indicatorView.startAnimating()
                // 3. 更改文字
                messageLabel.text = "起飞中请耐心等待..."
                
                // 4. 更改 contentInsetTop,让其停留在界面上
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.scrollView?.contentInset.top += self.refreshViewH
                })
                
                //value值改变 发送通知 执行动作
                sendActionsForControlEvents(UIControlEvents.TouchCancel)
            }
        }
    }
    
    //MARK: - 刷新控件高度
    private let refreshViewH:CGFloat = 50
    //MARK: - 父控件
    private var scrollView: UIScrollView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - 设置视图
    private func setUpUI(){
        //设置自身属性
        
        backgroundColor = UIColor.clearColor()
        frame.size = CGSizeMake(UIScreen.mainScreen().bounds.size.width, refreshViewH)
        frame.origin.y = -refreshViewH
        
        //添加控件
        addSubview(arrowImage)
        addSubview(indicatorView)
        addSubview(messageLabel)
        
        //设置约束
        arrowImage.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(self)
            make.centerX.equalTo(self).offset(-35)
        }
        
        indicatorView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(arrowImage)
        }
        
        messageLabel.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(arrowImage.snp_trailing)
            make.centerY.equalTo(arrowImage)
        }

    }
    
    //MARK: - 结束刷新
    func endRefreshing(){
        refreshState = .Nomal
    }
    
    //MARK: - 将要移动到某个父控件上的时候,就会调用该方法
    override func willMoveToSuperview(newSuperview: UIView?) {
        
        super.willMoveToSuperview(newSuperview)
        
        //获取父控件
        let scrollView = newSuperview as! UIScrollView
        
        self.scrollView = scrollView
        
        //KVO监听滚动
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.Old, .New], context: nil)
        
        //设置宽度为父控件宽度
        frame.size.width = scrollView.frame.width
     
    }
    
    // 当当前控件观察的对象身上某个属性发生改变的时候会调用
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        //内边距顶部
        let contentInsetTop = scrollView!.contentInset.top
        let contentOffsetY = scrollView!.contentOffset.y
        
        //当前刷新控件在这种情况下完全显示出来的值
        let conditionValue = -contentInsetTop - refreshViewH
        
        // dragging 是代表是否在被用户拖动
        if scrollView!.dragging{
            //如果偏移量小于 完全显示值 并且 当前是nomal状态
            if contentOffsetY <= conditionValue && refreshState == .Nomal{
                //设置为pulling状态❤️
                refreshState = .Pulling
            }else if refreshState == .Pulling && contentOffsetY > conditionValue{
                //设置为nomal状态❤️
                refreshState = .Nomal
            }
        }else{//放手了
            if refreshState == .Pulling{
            //设置为刷新状态❤️
            refreshState = .Refreshing
            }
        
        }
    
    }
    
    //移除观察者
    deinit{
    
        scrollView?.removeObserver(self, forKeyPath: "contentOffset")
    }

    //MARK: - 懒加载控件
    //菊花
    private lazy var indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    //箭头
    private lazy var arrowImage: UIImageView = UIImageView(image: UIImage(named: "tableview_pull_refresh"))
    //文字
    private lazy var messageLabel: UILabel = {
        let label = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 12)
        label.text = "带你装B 带你飞"
        return label
    }()
    
}
