//
//  ViewController.swift
//  MoviesDemo
//
//  Created by Andrew Cheberyako on 12.05.2021.
//

import UIKit

class ViewController: UIViewController {

    let fetchCurrent = NetworkMoviesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrent.fetchCurrentJson()
        // Do any additional setup after loading the view.
    }
    @IBAction func tapButton(_ sender: UIButton) {
        
        
    }
    

}

