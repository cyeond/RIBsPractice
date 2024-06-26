//
//  AppsHomeViewController.swift
//  RIBsPractice
//
//  Created by YD on 5/14/24.
//

import RIBs
import RxSwift
import UIKit
import Entities
import ReuseableViews
import ResourcesLibrary

protocol AppsHomePresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func seeAllButtonDidTap(with sectionModel: CollectionViewSectionModel)
    func appPreviewActionButtonDidTap(with info: AppPreviewInfo)
    func appPreviewCellDidTap(with info: AppPreviewInfo)
}

final class AppsHomeViewController: UIViewController, AppsHomePresentable, AppsHomeViewControllable {
    weak var listener: AppsHomePresentableListener?
    
    private var collectionViewDataSource: UICollectionViewDiffableDataSource<CollectionViewSection, CollectionViewItem>?
    private var viewModel: [CollectionViewSectionModel] = []
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.backgroundColor = ColorProvider.background
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AppPreviewBasicCell.self, forCellWithReuseIdentifier: AppPreviewBasicCell.identifier)
        collectionView.register(AppPreviewBasicHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AppPreviewBasicHeaderView.identifier)
        collectionView.contentInset = .init(top: 10.0, left: 0, bottom: 10.0, right: 0)
        collectionView.setCollectionViewLayout(createCollectionViewLayout(), animated: true)
        return collectionView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setupViews()
        setupCollectionViewDataSource()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupViews()
        setupCollectionViewDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    private func setupViews() {
        title = "앱"
        tabBarItem = UITabBarItem(title: "앱", image: UIImage(systemName: "square.stack.3d.up.fill"), selectedImage: UIImage(systemName: "square.stack.3d.up.fill"))
        
        view.backgroundColor = ColorProvider.background
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - CollectionView Layout
extension AppsHomeViewController {
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20.0
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, environment in
            return self?.viewModel[safe: sectionIndex]?.layoutSection()
        }, configuration: config)
    }
}

//MARK: - CollectionView DataSource
extension AppsHomeViewController {
    private func setupCollectionViewDataSource() {
        collectionViewDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { [weak self] collectionView, indexPath, item in
            switch item.type {
            case .appPreviewBasic(let info):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppPreviewBasicCell.identifier, for: indexPath) as? AppPreviewBasicCell else { return UICollectionViewCell() }
                cell.update(with: AppPreviewBasicViewModel(previewInfo: info, tapHandler: {
                    self?.listener?.appPreviewActionButtonDidTap(with: info)
                }))
                return cell
            default:
                return UICollectionViewCell()
            }
        })
        
        collectionViewDataSource?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AppPreviewBasicHeaderView.identifier, for: indexPath) as? AppPreviewBasicHeaderView
            if let type = self?.viewModel[safe: indexPath.section]?.section.type {
                switch type {
                case .groupedThree(title: let title, subtitle: let subtitle):
                    header?.update(with: AppPreviewBasicHeaderViewModel(title: title, subtitle: subtitle, tapHandler: {
                        if let sectionModel = self?.viewModel[safe: indexPath.section] {
                            self?.listener?.seeAllButtonDidTap(with: sectionModel)
                        }
                    }))
                default:
                    return nil
                }
            }
            return header
        }
    }
    
    func update(with viewModel: [CollectionViewSectionModel]) {
        self.viewModel = viewModel
        
        var snapshot = NSDiffableDataSourceSnapshot<CollectionViewSection, CollectionViewItem>()
        
        viewModel.forEach { model in
            snapshot.appendSections([model.section])
            snapshot.appendItems(model.items, toSection: model.section)
        }
        
        collectionViewDataSource?.apply(snapshot)
    }
}

// MARK: - CollectionView Delegate
extension AppsHomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let info = viewModel[safe: indexPath.section]?.items[safe: indexPath.row] {
            switch info.type {
            case .appPreviewBasic(let info):
                listener?.appPreviewCellDidTap(with: info)
            default:
                return
            }
        }
    }
}
