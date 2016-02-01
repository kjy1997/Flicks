//
//  DetailViewController.swift
//  Flicks
//
//  Created by Jiayi Kou on 1/26/16.
//  Copyright © 2016 Jiayi Kou. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var movie : NSDictionary!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    @IBOutlet var posterView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var infoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let title = movie["title"] as! String
        titleLabel.text = title
        
        let overview = movie["overview"] as! String
        overviewLabel.text = overview
        
        overviewLabel.sizeToFit()
        infoView.sizeToFit()
        if let posterpath = movie["poster_path"] as? String {
            let urlbase = "http://image.tmdb.org/t/p/w500/"
            let url = NSURL(string: urlbase+posterpath)
            posterView.setImageWithURL(url!)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.height)
        
        print(movie)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
