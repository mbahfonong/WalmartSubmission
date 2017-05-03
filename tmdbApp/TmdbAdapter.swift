//
//  tmdbAdapter.swift
//  tmdbApp
//
//  Created by iOS on 4/21/17.
//  Copyright © 2017 Mbah Fonong. All rights reserved.
//

import Foundation
import UIKit

class TMDBJson:NSObject
{
    
     var movieDelegate:MovieInfoDelegate?
    
    func tmdbRequest(searchCriteria:String)
    {
        var movieResult:[MovieObjects] = []
        let searchURL = "https://api.themoviedb.org/3/search/movie?api_key=92b2328a15665c351a28093f906857fc&language=en&page=1&query=\(searchCriteria)"
        let url = URL(string: searchURL)
        let configurations = URLSessionConfiguration.default
        let requestURL = URLRequest(url: (url!))
        let session = URLSession(configuration: configurations)
        
        session.dataTask(with: requestURL) { (data, response, error) in
            do{
                
                if error == nil
                {
                  //  print("Successful")
                    let rootDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String:AnyObject]
                   // print("Successfully obtained root")
                    let resultsArray = rootDictionary?["results"] as? [AnyObject]
                   // print("successfully obtained results")
                    if resultsArray?.count == 0
                    {
                        print("No movie results")
                        return
                    }
                    for x in 0...(resultsArray?.count)! - 1
                    {
                        let movieDict = resultsArray?[x] as! [String:AnyObject]
                        let mID = movieDict["id"] as! Int
                        let title = movieDict["title"] as! String
                        let image = movieDict["poster_path"] as? String ?? ""
                 
                        let releaseDate = movieDict["release_date"] as! String
                        let movieObj = MovieObjects(title: title, movieID: mID, imageURL: image, releaseDate: releaseDate)
                        movieResult.append(movieObj)
                        
                    }
                 
                    self.getImages(movieResults: movieResult)
                }
                
                else
                {
                    print("Error in search \(String(describing: error?.localizedDescription))")
                    return
                }
                
            }
            catch
            {
               print("Error \(error)")
               
            }
        }.resume()

    }


func getImages(movieResults:[MovieObjects])
{
    if movieResults.count > 0
    {
        for x in 0...movieResults.count - 1
        {
            if movieResults[x].imageURL != ""
            {
            
            let url = URL(string: "https://image.tmdb.org/t/p/w500" + "\(movieResults[x].imageURL!)" )
           
                let configurations = URLSessionConfiguration.default
                let session = URLSession(configuration: configurations)
            _ = session.dataTask(with: url!) {(data, response, error) in
                
                if error == nil
                {
                        movieResults[x].image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        self.movieDelegate?.getMovieInfo(movies: movieResults)
                        
                    }
                    
                }
                    
                else
                {
                    print("Issue With Session \(String(describing: error))")
                }
                

                }.resume()
            }
            else
            {
                movieResults[x].image = #imageLiteral(resourceName: "sorry-image-not-available") as UIImage
                DispatchQueue.main.async {
                self.movieDelegate?.getMovieInfo(movies: movieResults)
                    
                }
            }
    
    }
       
}
    else
    {
        print("No Images Here")
    }
}

}
