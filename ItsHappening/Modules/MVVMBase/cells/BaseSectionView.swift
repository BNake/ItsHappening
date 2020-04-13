//
//  BaseSectionView.swift
//  ItsHappening
//
//  Created by Oleg McNamara on 4/7/20.
//  Copyright © 2020 Oleg McNamara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SectionViewProtocol {
    func setup(viewModel: ViewModelProtocol?)
}

class BaseSectionView<T: ViewModelProtocol>: UIView, SectionViewProtocol {
    let disposeBag = DisposeBag()
    
    private(set) var viewModel: T?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(viewModel: ViewModelProtocol?) {
        self.viewModel = viewModel as? T
        setupBinding()
    }
    
    func setupBinding() {
        
    }
    
    func setupUI() {
        
    }
    
    func addSeparator(for side: SeparatorSide) {
        let separatorView = UIView()
        separatorView.backgroundColor = ColorManager.separator
        add(separatorView)
        
        separatorView.makeLayout {
            $0.left.equalToSuperView()
            $0.right.equalToSuperView()
            $0.height.equalTo(1)
        }
        switch side {
        case .top:
            separatorView.makeLayout { $0.top.equalToSuperView() }
        case .bottom:
            separatorView.makeLayout {$0.bottom.equalToSuperView()}
        }
    }
}

