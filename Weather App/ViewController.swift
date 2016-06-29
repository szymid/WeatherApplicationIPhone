//
//  ViewController.swift
//  Weather App
//
//  Created by Boguslaw Dawidow on 27.06.2016.
//  Copyright © 2016 Szymon Dawidow. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, WeatherMapViewDelegate {
    
    
    var pageViewController: UIPageViewController!
    var pageTitles: [String]!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageTitles = ["1","2","3"]
        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        reloadPageViewController()
    }

    
    //MARK: - Page View Controller Data Source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound  {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let vc = viewController as! ContentViewController
        var index = vc.pageIndex as Int
        if  index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == self.pageTitles.count {
            return nil
        }
        return self.viewControllerAtIndex(index)
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //MARK: - IBActions
    
    @IBAction func addNewCityButtonTapped(sender: UIButton) {
        //self.pageTitles.append("Nowy")
        print(self.pageTitles)
        reloadPageViewController()
        loadMap()
    }
    
    
    //MARK: - View Controller Methods

    func reloadPageViewController() {
        
        let startVC = self.viewControllerAtIndex(0) as ContentViewController
        let viewControllers = NSArray(objects: startVC)
        self.pageViewController.setViewControllers(viewControllers as? [UIViewController], direction: .Forward, animated: true, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, 30, self.view.frame.width, self.view.frame.height-60)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
    }
    
    func viewControllerAtIndex(index: Int) -> ContentViewController {
        
        if self.pageTitles.count == 0 || index >= self.pageTitles.count{
            return ContentViewController()
        }
        
        let vc:ContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ContentViewController") as! ContentViewController
        
        vc.titleText = self.pageTitles[index]
        vc.pageIndex = index
        
        return vc
    }
    
    func loadMap()  {
        performSegueWithIdentifier("mapSegue", sender: nil)
        
    }
    
    
    //MARK: - Weather Map View Delegate
    
    func didSelectedCoordinates(latitude: Double, longitude: Double) {
        print("____#####_____\(latitude)    \(longitude)")
        self.pageTitles.append("lat: \(latitude)  long: \(longitude)")
        reloadPageViewController()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "mapSegue" {
            
            if segue.destinationViewController.isKindOfClass(MapViewController) {
                
                let mapViewController = segue.destinationViewController as! MapViewController
                mapViewController.delegate = self
            }
        }
    }
    
}

