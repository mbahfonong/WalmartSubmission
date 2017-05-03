//
//  RetrievedMovies.swift
//  tmdbApp
//
//  Created by iOS on 4/21/17.
//  Copyright © 2017 Mbah Fonong. All rights reserved.
//

import Foundation
import UIKit
class MovieManager
{
    static let sharedInstance = MovieManager()
    private init(){}
    
    var movieResults:[MovieObjects] = []
    var currentSearch:String = ""
    var currentPage:Int = 1
 }


class MovieObjects
{
    var title:String?
    var imageURL:String?
    var movieID:Int?
    var releaseDate:String?
    var image:UIImage?
    init(title:String, movieID:Int, imageURL: String?, releaseDate: String) {
        self.title = title
        self.imageURL = imageURL
        self.movieID = movieID
        self.releaseDate = releaseDate
    }
}

protocol MovieInfoDelegate {
    func getMovieInfo(movies: [MovieObjects])
    func addMovieInfo(movies: [MovieObjects])
}

