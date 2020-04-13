//
//  BaseTableViewCell.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/7/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift

enum SeparatorSide {
    case top, bottom
}

protocol TableViewCellProtocol {
    func setup(viewModel: ViewModelProtocol?, tableView: UITableView?)
}

class BaseTableViewCell<T: ViewModelProtocol>: UITableViewCell, TableViewCellProtocol {
    
    private(set) var disposeBag = DisposeBag()
    private(set) weak var tableView: UITableView?
    
    private(set) var viewModel: T! {
        didSet {
            disposeBag = DisposeBag()
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        self.contentView.add(view)
        view.makeLayout {
            $0.top.equalToSuperView()
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
            $0.bottom.lessThanSuperView()
        }
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = ColorManager.secondarySystemGroupedBackground
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(viewModel: ViewModelProtocol?, tableView: UITableView?) {
        self.viewModel = viewModel as? T
        self.tableView = tableView
        setupBinding()
    }

    func setupBinding() {
        
    }
    
    func setupUI() {
        
    }
    
    func hideSeparator() {
        self.layoutMargins = .zero
        self.separatorInset = .zero
    }
}

