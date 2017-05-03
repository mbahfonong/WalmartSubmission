//
//  MovieSearchTableViewController.swift
//  tmdbApp
//
//  Created by iOS on 4/21/17.
//  Copyright © 2017 Mbah Fonong. All rights reserved.
//

import UIKit

class MovieSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MovieInfoDelegate {

    var movieSearchController:UISearchController!
    let tmdb = TMDBJson()
    var movieManager = MovieManager.sharedInstance.movieResults

    let cellID = "CustomTableViewCell"
    var useFiltered:Bool = false
    var searchObject:MovieObjects?
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var loadMoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        movieSearchController = UISearchController(searchResultsController: nil)
        movieSearchController.dimsBackgroundDuringPresentation = false
        self.tableView.tableHeaderView = self.movieSearchController.searchBar
        loadMoreButton.isHidden = true
        self.tableView.reloadData()
        let alert = UIAlertController(title: "Search For Movies", message: "Type in the search bar and click submit", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func getMovieInfo(movies: [MovieObjects]) {
        movieManager = movies
        tableView.reloadData()
    }
    
    @IBAction func loadMore(_ sender: UIButton) {
        if movieManager.count > 0
        {
        MovieManager.sharedInstance.currentPage += 1
        let currentCriteria = MovieManager.sharedInstance.currentSearch
        let loadMore = Load()
        loadMore.addDelegate = self
        loadMore.getMoreMovies(criteria: currentCriteria)
        }
    }
    
    func addMovieInfo(movies: [MovieObjects]) {
        movieManager = movieManager + movies
        tableView.reloadData()
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sumbit(_ sender: UIButton) {
        //Test search criteria
        if self.presentedViewController == movieSearchController
        {
            self.dismiss(animated: true, completion: nil)
        }
        var searchCriteria = movieSearchController.searchBar.text
        var newString = searchCriteria?.components(separatedBy: " ")
        var holder:[String] = []
        //Make sure the input is legitimate and display appropriate warnings
        if (searchCriteria?.trimmingCharacters(in: .whitespaces).isEmpty)!
        {
            let alert = UIAlertController(title: "Empty Search Bar", message: "Please Enter Some Text", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default , handler: nil)
            alert.addAction(action)
            self.dismiss(animated: true, completion: nil)
            self.present(alert, animated: true, completion: nil)
            return
        }
        else
        {
        for x in 0...(newString?.count)! - 1
        {
            if newString?[x] != ""
            {holder.append((newString?[x])!)}
            }
      searchCriteria?.removeAll(keepingCapacity: false)
       for str in holder
        {
        if str != holder.last
        {searchCriteria = searchCriteria?.appending(str + "+")}
        else if str == holder.last
        {searchCriteria = searchCriteria?.appending(str)}
        }
        }

        MovieManager.sharedInstance.currentSearch = searchCriteria!
        MovieManager.sharedInstance.currentPage = 1
        movieManager.removeAll(keepingCapacity: false)
      
       let adapter = TMDBJson()
        adapter.movieDelegate = self
       adapter.tmdbRequest(searchCriteria: searchCriteria!)
        guard loadMoreButton.isHidden == true else {return}
        loadMoreButton.isHidden = false
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movieManager.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CustomTableViewCell
    
        cell.movieName.text = movieManager[indexPath.row].title
        cell.releaseDate.text = "Released: \(movieManager[indexPath.row].releaseDate ?? "N/A")"
        cell.moviePoster.image =  movieManager[indexPath.row].image
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? DetailViewController else { return }
        destination.movieID = searchObject
    }

   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if self.presentedViewController == movieSearchController
    {
        self.dismiss(animated: true, completion: nil)
    }
        searchObject = movieManager[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: Any?.self)
        tableView.deselectRow(at: indexPath, animated: true)
    
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 79
    }
    
    

}
