//
//  ViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class ViewController: UIViewController {

    let fetchCurrent = NetworkMoviesManager()
    let fetchCurrentSearch = SearchManager.shared
    @IBOutlet weak var searchTF: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchCurrent.fetchCurrentJson()
        fetchCurrentSearch.fetchCurrentJSONSearch()
       
        // Do any additional setup after loading the view.
    }
    @IBAction func searchAction(_ sender: UIButton) {
            }
    @IBAction func tapButton(_ sender: UIButton) {
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "search" else {return}
        guard let nameStringTF = searchTF.text else {return}
        let tableVC = segue.destination as? SearchTableViewController
        tableVC?.nameString = nameStringTF
        print(nameStringTF)
    
    }
}



