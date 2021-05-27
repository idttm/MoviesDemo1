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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK: UICollectionViewDataSource
    
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
            DispatchQueue.main.async {
                self.viewModel.startUnpagination()
                self.viewModel.getData { [weak self] in
                    self?.collectionView.reloadData()
                }
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
            let imageData = imageDataFromURL.imageTitle(viewModel.dataResult(at: indexPath).posterPath)
            cell.collectionImage.image = UIImage(data: imageData!)
            let title = viewModel.titleForRow(at: indexPath)
            cell.collectionTitle.text = title
            return cell
        }
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
