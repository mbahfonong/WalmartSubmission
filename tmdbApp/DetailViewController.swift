//
//  DetailViewController.swift
//  tmdbApp
//
//  Created by iOS on 4/23/17.
//  Copyright © 2017 Mbah Fonong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var movieDescription: UILabel!
    
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieRuntime: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    var manager = MovieManager.sharedInstance
    var movieID:MovieObjects?
    var synopsis:String?
    var runtime:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let movieID = movieID else {return}
        movieTitle.text = movieID.title
        movieImage.image = movieID.image
       getDetailResults(movieObj: movieID)
    }
    
    
    func getDetailResults(movieObj: MovieObjects)
    {
        
        let urlSessionShared = URLSession.shared
        guard let movieSearch = movieObj.movieID else {return}

        let detailSearch = "https://api.themoviedb.org/3/movie/\(movieSearch)?api_key=92b2328a15665c351a28093f906857fc"
        let urlSearch = URL(string: detailSearch)

        let task = urlSessionShared.dataTask(with: urlSearch!, completionHandler: {data, response, error in
            if error == nil {
                
                do {
                     let rootDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject]
                 
                    self.synopsis = rootDictionary?["overview"] as? String ?? ""
                    self.runtime = rootDictionary?["runtime"] as? Int ?? 0
                    
                    DispatchQueue.main.async {
                        self.movieRuntime.text = String(describing: self.runtime!) + " Minutes"
                        self.movieDescription.text = self.synopsis
                        
                    }
                    
                }
                    
                catch {
                    print("Error found: \(error.localizedDescription)")
                }
                
            }
            else {
                print("Error found: \(error?.localizedDescription ?? "" )")
            }
        })
        task.resume()
    }

}
