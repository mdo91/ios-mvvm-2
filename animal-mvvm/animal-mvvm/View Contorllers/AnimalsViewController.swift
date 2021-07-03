//
//  AnimalsViewController.swift
//  animal-mvvm
//
//  Created by Mdo on 19/05/2021.
//

import Foundation
import UIKit

final class AnimalsViewController:UIViewController{
    
    enum CellIdentifier:String{
        case animalCell = "AnimalCell"
    }
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    
    
    private lazy var viewModel = AnimalsViewModel()
    private lazy var dataSource = makeDataSource()
    
    //MARK: - view life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.shouldPresentLoginViewController{
            performSegue(withIdentifier: LoginViewController.identifier, sender: self)
        }
        
        if let indexPath = tableView.indexPathForSelectedRow{
            tableView.deselectRow(at: indexPath, animated: animated)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let controller = segue.destination as? AnimalDetailViewController,
              let indexPath = tableView.indexPathForSelectedRow else {
            return
        }
        
        let animalName = viewModel.animalNames[indexPath.row]
        controller.animalName = animalName
        
       // let animalName = viewModel.animalNames[indexPath.row]
    }
    
    @IBAction func getAnimalNames(_ sender: UIBarButtonItem){
        
        viewModel.getAnimalNames { [weak self] result  in
            guard let self = self else {return}
            
            switch result{
            case .success:
                self.update()
            case .failure(let message):
                
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
                
            }
        }
        
    }
    
}

//MARK: - UITableViewDiffableDataSource


extension AnimalsViewController{
    
    enum Section{
        case main
    }
    
    private func makeDataSource() -> UITableViewDiffableDataSource<Section,
                                                                   String>{
        UITableViewDiffableDataSource(tableView: tableView) { (tableView, indexPath, name)  in
            
            let cell  = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.animalCell.rawValue)
            cell?.textLabel?.text = name
            return cell
        }
    }
    
    private func update(){
        
        activityIndicator.stopAnimating()
        
        var snapShot = NSDiffableDataSourceSnapshot<Section,String>()
        snapShot.appendSections([.main])
        dataSource.apply(snapShot, animatingDifferences: false)
        snapShot.appendItems(viewModel.animalNames)
        dataSource.apply(snapShot, animatingDifferences: true)
        
    }
}
