//
//  MoreInfoCompositionLayout.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 28.06.2021.
//

import UIKit

enum Section: Int, CaseIterable {
    case posterPhoto
    case title
    case overview
    case rating
    case similarsMovies
}

class MoreInfoCompositionLayout: UIViewController {
    
    var viewModel = MoviewTBVViewModel()
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>! = nil
    var movieId: Int?
    var posterPhoto: PosterPhotoData?
    var sectionDataForMoreInfo: MoreTextInfo?
    var selectedData: ResultSimilar?
    static let sectionHeaderElementKind = "section-header-element-kind"
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.getDataLayout(movieId: movieId!) { [weak self] in
                self?.reloadData()
        }
    }

    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(PosterPhoto.self, forCellWithReuseIdentifier: PosterPhoto.reusedId)
        collectionView.register(MoreInfoMovie.self, forCellWithReuseIdentifier: MoreInfoMovie.reusedId)
        collectionView.register(Similar.self, forCellWithReuseIdentifier: Similar.reusedId)
        collectionView.register(
          HeaderView.self,
          forSupplementaryViewOfKind: MoreInfoCompositionLayout.sectionHeaderElementKind,
          withReuseIdentifier: HeaderView.reuseIdentifier)
        collectionView.delegate = self
        setupDataSourse()
        
    }

    private func createLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex, layoutEnvirnment) -> NSCollectionLayoutSection? in
            let section = Section(rawValue: sectionIndex)!
            switch section {
            case .posterPhoto:
                return self.posterSection()
            case .similarsMovies:
                return self.similarSection()
            case .title, .rating, .overview:
                return self.moreInfoSection()
            }
        }
        
        return layout
    }
    
    private func setupDataSourse() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let self = self else { return nil }
            let section = Section(rawValue: indexPath.section)!
            switch section {
            case .posterPhoto:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterPhoto.reusedId, for: indexPath) as! PosterPhoto
                cell.posterPhoto.setImage(secondPartURL: self.posterPhoto!.posterPath)
                return cell
            case .title:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoMovie.reusedId, for: indexPath) as! MoreInfoMovie
                cell.label.text = self.sectionDataForMoreInfo?.title
                return cell
            case .overview:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoMovie.reusedId, for: indexPath) as! MoreInfoMovie
                cell.label.text = "OverView \n\(self.sectionDataForMoreInfo?.overview)"
                return cell
            case .rating:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MoreInfoMovie.reusedId, for: indexPath) as! MoreInfoMovie
                guard let rating = self.sectionDataForMoreInfo?.rating else { return cell }
                cell.label.text = String("Rating \(rating)")
                return cell
            case .similarsMovies:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Similar.reusedId, for: indexPath) as! Similar
                cell.photoMovie.setImage(secondPartURL: self.viewModel.similarMovies[indexPath.row].posterPath)
                cell.label.text = self.viewModel.similarMovies[indexPath.row].title
                return cell
            }
        })
        
        dataSource.supplementaryViewProvider = { (
          collectionView: UICollectionView,
          kind: String,
          indexPath: IndexPath) -> UICollectionReusableView? in

          guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }

            supplementaryView.label.text = String(Section.allCases[indexPath.section].rawValue)
          return supplementaryView
        }

        let snapshot = reloadData()
        dataSource.apply(snapshot, animatingDifferences: false)
        

    }
    
    
    func reloadData() -> NSDiffableDataSourceSnapshot<Section, AnyHashable> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.posterPhoto, .title, .rating, .overview, .similarsMovies])
        snapshot.appendItems([posterPhoto?.posterPath], toSection: .posterPhoto)
        snapshot.appendItems([sectionDataForMoreInfo?.title], toSection: .title)
        snapshot.appendItems([sectionDataForMoreInfo?.rating], toSection: .rating)
        snapshot.appendItems([sectionDataForMoreInfo?.overview], toSection: .overview)
        snapshot.appendItems(viewModel.similarMovies, toSection: .similarsMovies)
        
        return snapshot
        
    }
    
    private func posterSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(600))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        return section
    }
    
    private func moreInfoSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(5), top: NSCollectionLayoutSpacing.fixed(5), trailing: NSCollectionLayoutSpacing.fixed(5), bottom: NSCollectionLayoutSpacing.fixed(5))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        return section
    }
    
    private func similarSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 10)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.4),
            heightDimension: .fractionalWidth(0.6))
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: "Section" , alignment: .top)

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        return section
        
    }
}

extension MoreInfoCompositionLayout: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedData = viewModel.similarMovies[indexPath.row]
        performSegue(withIdentifier: "detailInfoSimilar", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "detailInfoSimilar" else { return }
        guard let moreVC = segue.destination as? DetailInfoSimalrMovi else {return}
        moreVC.data = selectedData
    }
}
