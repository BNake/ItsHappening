//
//  File.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/4/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController<HomeViewModel> {
    

    private(set) lazy var tableView: MVVMTableView = {
        let table = MVVMTableView(frame: .zero, style: .grouped)

        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.showsVerticalScrollIndicator = false

        table.register(SimpleTextCell.self, forCellReuseIdentifier: SimpleTextViewModel.className)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorManager.systemBackground
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func setupUI() {
        self.view.add(tableView)
        
        tableView.makeLayout {
            $0.top.equalToSuperView()
            $0.bottom.equalToSuperView()
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
        }

    }
    
    override func setupBinding() {
        viewModel.sectionViewModelsDriver.drive(tableView.dataSourceMVVM).disposed(by: disposeBag)
    }
}
