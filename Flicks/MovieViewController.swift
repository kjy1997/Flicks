//
//  MovieViewController.swift
//  Flicks
//
//  Created by Jiayi Kou on 1/9/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit
import AFNetworking

class MovieViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    @IBOutlet var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var movies: [NSDictionary]?
    var filteredMovies: [NSDictionary]?
    
    @IBOutlet var loadingAcitivity: UIActivityIndicatorView!
    
    func didRefresh() {
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()

    }
    override func viewWillAppear(animated: Bool) {
        loadingAcitivity.startAnimating()
        loadingAcitivity.hidden = false
    }
    override func viewDidAppear(animated: Bool) {
        loadingAcitivity.stopAnimating()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAcitivity.hidden = true
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
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            NSLog("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                    }
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
//            if tableView == self.searchDisplayController?.searchResultsTableView {
//                filteredMovies?.count
//            }else{
            return movies.count
//            }
        }else{
            return 0
        }
        
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterpath = movie["poster_path"] as! String
        let urlbase = "http://image.tmdb.org/t/p/w500/"
        
        let imageUrl = NSURL(string: urlbase+posterpath)
        
        cell.posterView.setImageWithURL(imageUrl!)
        cell.title.text = title
        cell.overview.text = overview
        return cell
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
