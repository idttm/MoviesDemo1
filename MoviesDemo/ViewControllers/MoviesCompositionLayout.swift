//
//  MoviesCompositionLayout.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 28.06.2021.
//

import UIKit

enum SectionMovies: Int {
    case movie
}


class MoviesCompositionLayout: UIViewController {
    
    var viewModel = MoviewTBVViewModel()
    private var selectedData: DataResult?
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<SectionMovies, AnyHashable>! = nil
    fileprivate var currentAnimationTransition: UIViewControllerAnimatedTransitioning? = nil
    fileprivate var lastSelectedIndexPath: IndexPath? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.onDataUpdated = {
            self.reloadData()
        }
        viewModel.refresh()
        navigationController?.delegate = self
    }
    
    func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(CompositionalLayoutMovieCell.self, forCellWithReuseIdentifier: CompositionalLayoutMovieCell.reusedId)
        collectionView.delegate = self
        setupDataSourse()
        reloadData()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout { [unowned self] (sectionIndex, layoutEnvirnment) -> NSCollectionLayoutSection? in
            let section = SectionMovies(rawValue: sectionIndex)!
            switch section {
            case .movie:
                return self.moviesSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    private func setupDataSourse() {
        dataSource = UICollectionViewDiffableDataSource<SectionMovies, AnyHashable>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard self != nil else { return nil }
            let section = SectionMovies(rawValue: indexPath.section)!
            
            switch section {
            case .movie:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalLayoutMovieCell.reusedId, for: indexPath) as! CompositionalLayoutMovieCell
                cell.label.text = self?.viewModel.data[indexPath.row].title
                cell.photoMovie.setImage(secondPartURL: (self?.viewModel.data[indexPath.row].posterPath)!)
                return cell
            }
        })
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionMovies, AnyHashable>()
        snapshot.appendSections([.movie])
        snapshot.appendItems(viewModel.data, toSection: .movie)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func moviesSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        return section
    }
    
}
extension MoviesCompositionLayout: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if  indexPath.row == viewModel.numberOfRows - 1 {
            viewModel.getNextPage()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedData = viewModel.dataResult(at: indexPath)
        self.lastSelectedIndexPath = indexPath
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(identifier: "myVCID") as? MoreInfoCompositionLayout else { return }
        vc.sectionDataForMoreInfo = MoreTextInfo(currentMoview: selectedData!)
        vc.posterPhoto = PosterPhotoData(currentMoview: selectedData!)
        vc.movieId = selectedData!.id
        self.navigationController?.pushViewController(vc, animated: true)
     
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CompositionalLayoutMovieCell
        cell.setHighlighted(true)
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CompositionalLayoutMovieCell
        cell.setHighlighted(false)
    }
}

extension MoviesCompositionLayout: DetailTransitionAnimatorDelegate {
    func transitionWillStart() {
        guard let lastSelected = self.lastSelectedIndexPath else { return }
        self.collectionView.cellForItem(at: lastSelected)?.isHidden = true
    }

    func transitionDidEnd() {
        guard let lastSelected = self.lastSelectedIndexPath else { return }
        self.collectionView.cellForItem(at: lastSelected)?.isHidden = false
    }

    func referenceImage() -> UIImage? {
        guard
            let lastSelected = self.lastSelectedIndexPath,
            let cell = self.collectionView.cellForItem(at: lastSelected) as? CompositionalLayoutMovieCell
        else {
            return nil
        }

        return cell.photoMovie.image
    }

    func imageFrame() -> CGRect? {
        guard
            let lastSelected = self.lastSelectedIndexPath,
            let cell = self.collectionView.cellForItem(at: lastSelected) as? CompositionalLayoutMovieCell
        
        else {
            return nil
        }

        return self.collectionView.convert(CGRect(x: cell.frame.minX + 5, y: cell.frame.minY + 5, width: cell.photoMovie.frame.width, height: cell.photoMovie.frame.height), to: self.view)
        
        
    }
}

extension MoviesCompositionLayout: UINavigationControllerDelegate {

    public func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        
        let result: UIViewControllerAnimatedTransitioning?
        if
            let photoDetailVC = toVC as? MoreInfoCompositionLayout,
            operation == .push
        {
            result = DetailPushTransition(fromDelegate: fromVC, toPhotoDetailVC: photoDetailVC)
        } else if
            let photoDetailVC = fromVC as? MoreInfoCompositionLayout,
            operation == .pop
        {
                result = DetailPopTransition(toDelegate: toVC, fromPhotoDetailVC: photoDetailVC)
        } else {
            result = nil
        }
        self.currentAnimationTransition = result
        return result
    }
    public func navigationController(
        _ navigationController: UINavigationController,
        interactionControllerFor animationController: UIViewControllerAnimatedTransitioning
    ) -> UIViewControllerInteractiveTransitioning? {
        return self.currentAnimationTransition as? UIViewControllerInteractiveTransitioning
    }
    
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        self.currentAnimationTransition = nil
    }
}

