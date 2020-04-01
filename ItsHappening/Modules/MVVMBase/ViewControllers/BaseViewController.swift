//
//  BaseViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 3/21/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import FirebaseUI

protocol ViewModelEqualityProtocol {
    func compareViewModel(with: ViewModelProtocol) -> Bool
    func compareViewModel(withType: ViewModelProtocol.Type) -> Bool
}

protocol ViewControllerProtocol: MirrorProtocol, ViewModelEqualityProtocol {
    associatedtype T: ViewModelProtocol
    func setup(viewModel: T)
    var viewModel: T! { get }
}

extension ViewControllerProtocol {
    func compareViewModel(with: ViewModelProtocol) -> Bool {
        guard let vm = with as? T else { return false }
        return self.viewModel === vm
    }
    
    func compareViewModel(withType type: ViewModelProtocol.Type) -> Bool {
        return self.viewModel?.className ?? "" == type.className
    }
}

extension UIViewController {
    var isPresented: Bool {
        return self.presentingViewController?.presentedViewController == self
            || (self.navigationController != nil
                && self.navigationController?.presentingViewController?.presentedViewController == self.navigationController
                && self.navigationController?.viewControllers.count ?? 0 == 1)
            || self.tabBarController?.presentingViewController is UITabBarController
    }
}

extension UIViewController: MirrorProtocol {}

class BaseViewController<T: ViewModelProtocol>: UIViewController, ViewControllerProtocol {
    
    lazy private(set) var disposeBag = DisposeBag()
    private(set) var viewModel: T!
    
    deinit {
        debugPrint("deinit \(self)")
    }
    
    let closeBarButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(named: "x")!.withRenderingMode(.alwaysTemplate), for: .normal)
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .white
        indicator.isHidden = true
        return indicator
    }()
    
    lazy var closeBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(customView: self.closeBarButton)
        barButtonItem.customView?.makeLayout {
            $0.height.equalTo(25)
            $0.width.equalTo(25)
        }
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.systemBackground
        setupActivityIndicator()
        createCloseButton()
        setupUI()
        setupBinding()
        bindingDisplayError()
        bindInfoError()
        bindingDisplaySystemDialog()
    }
    
    func setup(viewModel: T) {
        self.viewModel = viewModel
    }
    
    func createCloseButton() {
        if isPresented {
            self.navigationItem.leftBarButtonItem = closeBarButtonItem
        }
    }
    
    func forceSetupCloseButton(onNavigationBar: Bool = true, color: UIColor = .white) {
        if self.navigationController == nil || !onNavigationBar {
            view.add(closeBarButton)
            
            closeBarButton.makeLayout {
                $0.top.equalToSafeArea().offset(10)
                $0.left.equalToSuperView().offset(15)
                $0.height.equalTo(25)
                $0.width.equalTo(25)
            }
        } else {
            self.navigationItem.leftBarButtonItem = closeBarButtonItem
        }
        closeBarButton.tintColor = color
    }
    
    func setupActivityIndicator(ignorePreviousRightItem: Bool = false) {
        if !ignorePreviousRightItem {
             guard navigationItem.rightBarButtonItem == nil else { return }
        }
        let navigatoinActivityItem = UIBarButtonItem.init(customView: activityIndicator)
        navigationItem.rightBarButtonItem = navigatoinActivityItem
    }
    
    func setupUI() {
        
    }
    
    func setupBinding() {
        
    }
    
    func bindingDisplayError() {
        viewModel.blockedErrorDriver
            .throttle(RxTimeInterval.seconds(1), latest: true)
            .drive(onNext: { [weak self] (error) in
                let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
                self?.logScreenError(with: error)
            })
            .disposed(by: disposeBag)
    }
    
    func bindInfoError() {
        viewModel.infoErrorDriver
            .throttle(RxTimeInterval.seconds(1), latest: true)
            .drive(onNext: { [weak self] (error) in
                guard let self = self else { return }
//                let infoView = InfoErrorView(message: error.message)
//                infoView.show(in: self.view)
                self.logScreenError(with: error)
            })
            .disposed(by: disposeBag)
    }
    
    private func logScreenError(with error: DisplayError) {
//        Event.displayError.log(with: ["error_screen": self.className, "error_title": error.title ?? "", "error_message": error.message])
    }
    
    func bindingDisplaySystemDialog() {
        viewModel.systemDialogDriver
            .drive(onNext: { [weak self] (dialog) in
                let alert = UIAlertController(title: dialog.title,
                                              message: dialog.message,
                                              preferredStyle: dialog.style == DialogObject.Style.alert ? .alert : .actionSheet)
                
                dialog.actions.map {UIAlertAction(title: $0.title, style: $0.style, action: $0.action)}.forEach {alert.addAction($0)}
                self?.present(alert, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

class BasePageViewController<T: ViewModelProtocol>: UIPageViewController, ViewControllerProtocol {
    
    lazy private(set) var disposeBag = DisposeBag()
    private(set) var viewModel: T!
    
    deinit {
        debugPrint("deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    func setup(viewModel: T) {
        self.viewModel = viewModel
    }
    
    func setupUI() {
        
    }
    
    func setupBinding() {
        
    }
}

class BaseTabBarViewController<T: ViewModelProtocol>: HappeningTabBarController, ViewControllerProtocol {
    
    lazy private(set) var disposeBag = DisposeBag()
    private(set) var viewModel: T!
    
    deinit {
        debugPrint("deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    func setup(viewModel: T) {
        self.viewModel = viewModel
    }
    
    func setupUI() {
        
    }
    
    func setupBinding() {
        
    }
}

class BaseTableViewController<T: ViewModelProtocol>: UITableViewController, ViewControllerProtocol {
    
    lazy private(set) var disposeBag = DisposeBag()
    private(set) var viewModel: T!
    
    deinit {
        debugPrint("deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    func setup(viewModel: T) {
        self.viewModel = viewModel
    }
    
    func setupUI() {
        
    }
    
    func setupBinding() {
    }
}

class BaseGoogleLoginOptionsViewController<T: ViewModelProtocol>: FUIAuthPickerViewController, ViewControllerProtocol {
    
    lazy private(set) var disposeBag = DisposeBag()
    private(set) var viewModel: T!
    
    deinit {
        debugPrint("deinit \(self)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    func setup(viewModel: T) {
        self.viewModel = viewModel
    }
    
    func setupUI() {
        
    }
    
    func setupBinding() {
        
    }
}

