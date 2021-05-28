//
//  MoviesCollectionViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 26.05.2021.
//

import UIKit

class MoviesCollectionViewController: UICollectionViewController {
    
    let viewModel = MoviewTBVViewModel()
    let viewModelMoreInfo = ImageDataFromURL()
    let imageDataFromURL = ImageDataFromURL()
    
    private var selectedData: DataResult?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getData { [weak self] in
            self?.collectionView.reloadData()
            
        }
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return viewModel.numberOfRows
    }
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if  indexPath.row == viewModel.numberOfRows - 1 {
            viewModel.startUnpagination()
            viewModel.getData { [weak self] in
                collectionView.reloadData()
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if  indexPath.row == viewModel.numberOfRows - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "activitiIndicatorCell", for: indexPath) as! MoviesCollectionViewCell
            cell.colletctionActivitiIndicator.startAnimating()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! MoviesCollectionViewCell
            
            if cell.collectionImage == nil {
                cell.collectionActctivitiIndicatorImageView.startAnimating()
            } else {
                
                let imageData = self.imageDataFromURL.imageTitle(self.viewModel.dataResult(at: indexPath).posterPath)
                cell.collectionImage.image = UIImage(data: imageData!)
                let title = viewModel.titleForRow(at: indexPath)
                cell.collectionTitle.text = title
            }
            return cell
        }
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedData = viewModel.dataResult(at: indexPath)
        performSegue(withIdentifier: "showMovie", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "showMovie" else { return }
        guard let moreVC = segue.destination as? MoreInfoViewController else {return}
        moreVC.currentDataForMoreInfo = selectedData
    }
}
extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let paddingWidth = 20 * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem * 2.5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
