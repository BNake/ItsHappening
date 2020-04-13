//
//  MVVMTableView.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/7/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias MultiViewPrediacate = (ViewModelProtocol) -> UIView.Type?

class MVVMTableView: UITableView {
    
    private let disposeBag = DisposeBag()
    let dataSourceMVVM = BehaviorRelay<[SectionViewModel]>(value: [])
    private var sectionHeadersContainer: [String: UIView.Type] = [:]
    private var sectionFootersContainer: [String: UIView.Type] = [:]
    private var multiSectionHeadersContainer: [String: MultiViewPrediacate] = [:]
    private var multiSectionFooterContainer: [String: MultiViewPrediacate] = [:]
    
    private let _currentRowViewModel = BehaviorRelay<RowViewModel?>(value: nil)
    var currentRowViewModel: Driver<RowViewModel?> {
        return _currentRowViewModel.asDriver(onErrorJustReturn: nil)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero, style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupParams()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupParams()
    }
    
    func setupParams() {
        self.rowHeight = UITableView.automaticDimension
        self.sectionHeaderHeight = UITableView.automaticDimension
        self.estimatedRowHeight = UITableView.automaticDimension
        self.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.sectionFooterHeight = 0.0
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = ColorManager.systemGroupedBackground
        dataSourceMVVM.subscribe(onNext: { [weak self] _ in
            self?.reloadData()
        }).disposed(by: disposeBag)
    }
    
    private var sections: [SectionViewModel] {
        return dataSourceMVVM.value
    }
    
    func registerMultiHeader(reuseIdentifier: String, predicate: @escaping MultiViewPrediacate) {
        multiSectionHeadersContainer[reuseIdentifier] = predicate
    }
    
    func registerMultiFooter(reuseIdentifier: String, predicate: @escaping MultiViewPrediacate) {
        multiSectionFooterContainer[reuseIdentifier] = predicate
    }
    
    func registerHeader(_ headerClass: UIView.Type, reuseIdentifier: String) {
        sectionHeadersContainer[reuseIdentifier] = headerClass
    }
    
    func registerFooter(_ footerClass: UIView.Type, reuseIdentifier: String) {
        sectionFootersContainer[reuseIdentifier] = footerClass
    }
}

extension MVVMTableView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].rowViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowViewModel = sections[indexPath.section].rowViewModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: rowViewModel.className, for: indexPath)
        if let cell = cell as? TableViewCellProtocol {
            cell.setup(viewModel: rowViewModel, tableView: self)
        }
        _currentRowViewModel.accept(rowViewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let rowViewModel = sections[indexPath.section].rowViewModels[indexPath.row]
        return rowViewModel.selection != nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let rowViewModel = sections[indexPath.section].rowViewModels[indexPath.row]
        rowViewModel.selectionExecute()
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionVM = sections[section]
        if let view = resolveView(from: sectionHeadersContainer, for: sectionVM.className) ??
            resolveMultiView(from: multiSectionHeadersContainer, for: sectionVM.className, with: sectionVM) {
            if let sectionView = view as? SectionViewProtocol {
                sectionView.setup(viewModel: sectionVM)
            }
            return view
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let sectionVM = sections[section]
        if let view = resolveView(from: sectionFootersContainer, for: sectionVM.className) {
            if let sectionView = view as? SectionViewProtocol {
                sectionView.setup(viewModel: sectionVM)
            }
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func resolveView(from container: [String: UIView.Type], for identifier: String) -> UIView? {
        if let type = container[identifier] {
            if let initable = type as? InitiableProtocol.Type {
                let instance = initable.init()
                return instance as? UIView
            }
        }
        return nil
    }
    
    private func resolveMultiView(from container: [String: MultiViewPrediacate], for identifier: String, with viewModel: ViewModelProtocol) -> UIView? {
        if let predicate = container[identifier] {
            if let type = predicate(viewModel) {
                if let initable = type as? InitiableProtocol.Type {
                    let instance = initable.init()
                    return instance as? UIView
                }
            }
        }
        return nil
    }
}

