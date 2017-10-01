//
//  CityPageViewController.swift
//  Warp17ios
//
//  Created by Mac on 13.08.17.
//  Copyright © 2017 WarpTeam. All rights reserved.
//

import Foundation
import UIKit

class CityPageViewController: UIPageViewController {
    
    let pageControl = UIPageControl()
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [
            self.storyboard?.instantiateViewController(withIdentifier: "CityPopulationViewController"),
            self.storyboard?.instantiateViewController(withIdentifier: "CityFoodViewController"),
            self.storyboard?.instantiateViewController(withIdentifier: "CityBuildingsViewController")
        ]
    }() as! [UIViewController]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        UiUtils.debugPrint("city page view", "viewDidLoad")
        
        navigationItem.title = DataStorage.sharedDataStorage.getCurrentCity().name
        
        let appearance = UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
        appearance.backgroundColor = UIColor.darkGray
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
}

extension CityPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        // User is on the last view controller and swiped right to loop to
        // the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}
