//
//  ContactViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/27/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//
import UIKit

class ContactViewController: BaseViewController<ContactViewModel> {
    
    private let safeAreaTopHeight = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
    
    private var searchBar: UISearchBar = {
        let s = UISearchBar()
        return s
    }()
    
    private var segmentedControllHeight: OMOffsetConstraintChanger?
    private let segmentControlView: SegmentControlContainerView = {
        let control = UISegmentedControl(items: ["All", "Friends"])
        control.tintColor = UIColor.init(hexrgb: 0x1b1b1b)
        control.selectedSegmentIndex = 0
        let view = SegmentControlContainerView(segmentControl: control)
        view.backgroundColor = ColorManager.systemBackground
        return view
    }()
    
    private(set) lazy var tableView: MVVMTableView = {
        let table = MVVMTableView(frame: .zero, style: .grouped)

        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.showsVerticalScrollIndicator = false
        table.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

        table.registerHeader(ZeroSectionHeaderView.self, reuseIdentifier: SectionViewModel.className)
        table.register(ContactCell.self, forCellReuseIdentifier: ContactCellViewModel.className)
        return table
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        self.view.add(searchBar, segmentControlView, tableView)
        let size = UIScreen.main.bounds
        
        searchBar.makeLayout {
            $0.top.equalToSuperView().offset(safeAreaTopHeight)
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
            $0.height.equalTo(size.height * 0.08)
        }
        
        segmentControlView.makeLayout {
            $0.top.equalTo(searchBar.sl.bottom)
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
            segmentedControllHeight = $0.height.equalTo(size.height * 0.08) as? OMOffsetConstraintChanger
        }
        
        tableView.makeLayout {
            $0.top.equalTo(segmentControlView.sl.bottom)
            $0.bottom.equalToSuperView()
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
        }
    }
    
    override func setupBinding() {
        viewModel.sectionViewModelsDriver.drive(tableView.dataSourceMVVM).disposed(by: disposeBag)
        searchBar.rx.text.orEmpty.asDriver().drive(viewModel.searchText).disposed(by: disposeBag)
        
        segmentControlView.controlView.rx.value.asDriver()
            .map { (status) -> ContactViewModel.SegmentControl in
                switch status {
                case 0:
                    return .all
                case 1:
                    return .friends
                default:
                    return .all
                }
            }.drive(viewModel.segmentControlChanged).disposed(by: disposeBag)
        
        FirebaseAuthService.sharedInstance.loggedInUser.bind { [weak self] (loggedInUser) in
            guard let self = self else { return }
            guard loggedInUser != nil else {
                self.viewModel.segmentControlChanged.accept(.all)
                self.hideSegmentedControl()
                return
            }
            self.showSegmentedControl()
        }.disposed(by: disposeBag)
    }
    
    private func hideSegmentedControl() {
        
        self.segmentControlView.isHidden = true
        self.segmentedControllHeight?.offset(0)
        
    }
    
    private func showSegmentedControl() {
        
        let size = UIScreen.main.bounds
        self.segmentControlView.isHidden = false
        self.segmentedControllHeight?.offset(size.height * 0.08)
    }
}
