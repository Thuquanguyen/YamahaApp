//
//  AdsDetailVC.swift
//  CreateUI
//
//  Created by ThuNQ on 10/14/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import UIKit

class AdsDetailVC: UIViewController {

    @IBOutlet weak var naviBar: CustomNaviBar!{
        didSet{
            naviBar.title = "Campaign Detail"
        }
    }
    @IBOutlet weak var basePageView: UIView!
    
    var tiktok = ProductModel()
    var page: UIPageViewController!
    var imageNames: [String] = ["capsac_1","capsac_2","capsac_3"]
    var imageLines: [String] = ["icon_line_1","icon_line_2","icon_line_3"]
    var titleNames:[String] = ["Discover\nyour Business","Optimization\nyour system","Increase sales\nin the most optimal way"]
    var indexPage = 0
    static var timer: Timer?
  
    // MARK: - ViewController's life cycles
    deinit {
        WelcomeVC.timer?.invalidate()
        WelcomeVC.timer = nil
        print("Deinit \(self.name)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.buttonBack.didTap = {
            self.pop()
        }
        
        setupPage()
        setupTimer()
    }
    
    func setupPage(){
        page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        page.dataSource = self
        page.delegate = self
        if let view = page.view {
            basePageView.addSubview(view)
        }
        page.view.frame = CGRect(x: 0, y: 0, width: basePageView.width, height: basePageView.height)
        page.setViewControllers([getPage(index: 0) ?? UIViewController()], direction: .forward, animated: false, completion: nil)
    }
    
    func setupTimer(){
        WelcomeVC.timer?.invalidate()
        WelcomeVC.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { [weak self] (timer) in
            var index = (self?.indexPage ?? 0) + 1
            var direction = UIPageViewController.NavigationDirection.forward
            direction = index >= 3 ? .reverse : .forward
            index = index >= 3 ? 0 : index
            self?.page.setViewControllers([self?.getPage(index: index) ?? UIViewController()], direction: direction, animated: true, completion: nil)
            self?.indexPage = index
        })
    }
}

// MARK: - UIPageViewController Delegate
extension AdsDetailVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func getPage(index: Int) -> WelcomePageVC? {
        if index == -1 || index == imageNames.count {
            return nil
        }
        let vc = WelcomePageVC()
        vc.index = index
        if imageNames.count > index {
            vc.image = UIImage(imageNames[index])
            vc.titleSplat = titleNames[index]
            vc.line = imageLines[index]
        }
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let vc = (viewController as? WelcomePageVC) {
            return getPage(index: vc.index - 1)
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let vc = (viewController as? WelcomePageVC) {
            return getPage(index: vc.index + 1)
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if let vc = pageViewController.viewControllers?.first {
                if let index = (vc as? WelcomePageVC)?.index {
                    setupTimer()
                    indexPage = index
                }
            }
        }
    }
}

