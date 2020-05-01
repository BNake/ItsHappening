//
//  ContactViewController.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/27/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//
import UIKit

class ContactViewController: BaseViewController<ContactViewModel> {
    
    private var textField: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    private(set) lazy var tableView: MVVMTableView = {
        let table = MVVMTableView(frame: .zero, style: .grouped)

        table.backgroundColor = .clear
        table.separatorStyle = .singleLine
        table.showsVerticalScrollIndicator = false

        table.register(ContactCell.self, forCellReuseIdentifier: ContactCellViewModel.className)
        return table
    }()
    
    override func setupUI() {
        self.view.add(textField, tableView)
        
        textField.makeLayout {
            $0.top.equalToSuperView()
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
            $0.height.equalTo(200)
        }
        tableView.makeLayout {
            $0.top.equalTo(textField.sl.bottom)
            $0.bottom.equalToSuperView()
            $0.leading.equalToSuperView()
            $0.trailing.equalToSuperView()
        }
    }
    
    override func setupBinding() {
        viewModel.sectionViewModelsDriver.drive(tableView.dataSourceMVVM).disposed(by: disposeBag)
        textField.rx.text.orEmpty.asDriver().drive(viewModel.searchText).disposed(by: disposeBag)

    }
}
