////
////  ImageView.swift
////  Reddit Viewer
////
////  Created by Duncan MacDonald on 9/19/17.
////
//
//import Foundation
//import UIKit
//
//class ImageSlideshowViewController: UIPageViewController, UIPageViewControllerDelegate {
//    var pageViewController : UIPageViewController?
//    var pageImages: [String] = ["nice", "cool", "wow"]
//    var currentIndex : Int = 0
//    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        
//        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        pageViewController!.dataSource = self as? UIPageViewControllerDataSource
//        
//        let startingViewController: SlideshowContentViewController = viewControllerAtIndex(index: 0)!
//        let viewControllers = [startingViewController]
//        pageViewController!.setViewControllers(viewControllers , direction: .forward, animated: false, completion: nil)
//        pageViewController!.view.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height);
//        
//        addChildViewController(pageViewController!)
//        view.addSubview(pageViewController!.view)
//        pageViewController!.didMove(toParentViewController: self)
//    }
//    
//    override func didReceiveMemoryWarning()
//    {
//        super.didReceiveMemoryWarning()
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
//    {
//        var index = (viewController as! SlideshowContentViewController).pageIndex
//        
//        if (index == 0) || (index == NSNotFound) {
//            return nil
//        }
//
//        index! -= 1
//        
//        return viewControllerAtIndex(index: index!)
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
//    {
//        var index = (viewController as! SlideshowContentViewController).pageIndex
//        
//        if index == NSNotFound {
//            return nil
//        }
//        
//        index! += 1
//        
//        return viewControllerAtIndex(index: index!)
//    }
//    
//    func viewControllerAtIndex(index: Int) -> SlideshowContentViewController?
//    {
//        
//        // Create a new view controller and pass suitable data.
//        let pageContentViewController = SlideshowContentViewController()
//        //pageContentViewController.imageView.image = pageImages[index]
//        pageContentViewController.pageIndex = index
//        currentIndex = index
//        
//        return pageContentViewController
//    }
//    
//    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
//    {
//        return self.pageImages.count
//    }
//    
//    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
//    {
//        return 0
//    }
//    
//}

