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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        viewModel.onDataUpdated = {
            self.reloadData()
        }
        viewModel.refresh()
        
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
        performSegue(withIdentifier: "showMovie2", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "showMovie2" else { return }
        guard let moreVC = segue.destination as? MoreInfoCompositionLayout else {return}
        moreVC.sectionDataForMoreInfo = MoreTextInfo(currentMoview: selectedData!)
        moreVC.posterPhoto = PosterPhotoData(currentMoview: selectedData!)
        moreVC.movieId = selectedData!.id
    }
}
