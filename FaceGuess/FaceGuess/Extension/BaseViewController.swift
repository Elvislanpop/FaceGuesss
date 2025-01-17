//
//  BaseViewController.swift
//  FaceGuess
//
//  Created by hyd on 2023/10/20.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa
class BaseViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var titleStr:String
    private var isShowBack:Bool
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        // 隐藏系统导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // 添加右滑返回手势
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleEdgePan))
        edgePan.edges = .left
        self.view.addGestureRecognizer(edgePan)
 
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // 设置为你需要的样式
    }
    @objc func handleEdgePan(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .began || recognizer.state == .changed {
            // 获取滑动的距离
            let translationX = recognizer.translation(in: self.view).x
            print("滑动距离: \(translationX)")  // 调试输出
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            // 滑动结束，这里可以进行其他操作，比如 pop ViewController
            let translationX = recognizer.translation(in: self.view).x
            if translationX > self.view.bounds.width * 0.2 {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.viewControllers.count ?? 0 > 1{
            self.tabBarController?.tabBar.isHidden = true
        }else{
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    init(title:String,isShowBack:Bool = true) {
        self.titleStr = title
        self.isShowBack = isShowBack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //创建自定义导航栏
    /// <#Description#>
    /// - Returns: <#description#>
    lazy var customNavBar: UIView = {
        let customNavBar = UIView()
        customNavBar.backgroundColor = UIColor.colorWithHexString("#000000")
        self.view.addSubview(customNavBar)

        // 添加到视图
        customNavBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(kNavBarAndStatusBarHeight)
        }
        

        let backButton = UIButton.init()
        customNavBar.addSubview(backButton)
        backButton.rx.tap.withUnretained(self).subscribe(onNext: { _ in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        backButton.setImage(UIImage(named: "backArrow"), for: .normal)

        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(kStatusBarHeight)
            make.leading.equalToSuperview().offset(12)
            make.width.height.equalTo(30)
        }
        backButton.isHidden = !isShowBack 
        
        let titleLab = UILabel.labelLayout(text: titleStr, font: UIFont.boldSystemFont(ofSize: 18), textColor: .white, ali: .center, isPriority: true, tag: 0)
        customNavBar.addSubview(titleLab)
        titleLab.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
        }
        
        return customNavBar
    }()

}
