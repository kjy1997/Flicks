//  MovieViewController.swift
//  Flicks
//
//  Created by Jiayi Kou on 1/9/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var movies: NSMutableArray?
    var filteredMovies = []
    
    @IBOutlet var networkView: UIView!
    @IBOutlet var searchbar: UISearchBar!
    
    func didRefresh() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchbar.delegate = self
        refreshControl = UIRefreshControl()
        self.tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: Selector("didRefresh"), forControlEvents: UIControlEvents.ValueChanged)

        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        self.networkView.hidden = true
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as! NSMutableArray
                            self.tableView.reloadData()
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                    }
                }else{
                    self.networkView.hidden = false
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                }
        });
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let movies = movies {
            if filteredMovies.count != 0{
                return filteredMovies.count
                    }else{
            return movies.count
        
            }
        }else{
            return 0
        }
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie : NSDictionary
        if (filteredMovies.count != 0) {
            movie = filteredMovies[indexPath.row] as! NSDictionary
        } else {
            movie = movies![indexPath.row] as! NSDictionary
        }
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterpath = movie["poster_path"] as! String
        
        //add fade in fade out
        cell.posterView.alpha = 0
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.TransitionCurlUp, animations: { () -> Void in
            cell.posterView.alpha = 1
            }, completion: nil)
        
        let urlbase = "http://image.tmdb.org/t/p/w500/"
        
        let imageUrl = NSURL(string: urlbase+posterpath)
        
        cell.posterView.setImageWithURL(imageUrl!)
        cell.title.text = title
        cell.overview.text = overview
        return cell
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let searchText = searchbar.text{
        let searchPredicate = NSPredicate(format: "title CONTAINS[c] %@", searchText)
        let filteredResults = (movies?.filteredArrayUsingPredicate(searchPredicate))!
            if filteredResults.count != 0 {
                filteredMovies = filteredResults
            }else{
                filteredMovies = []
            }
        }
        tableView.reloadData()
    }
    
    


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
