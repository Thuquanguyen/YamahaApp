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
    @IBOutlet weak var labelContent: UITextView!
    
    var tiktok = ProductModel()
    var page: UIPageViewController!
    var imageNames: [String] = []
    var indexPage = 0
    static var timer: Timer?
    var index: Int = 0
    var product = ProductModel()
    var highlightModel = HighlightModel()
    var newsEventModel = NewsEventModel()
    
    // MARK: - ViewController's life cycles
    deinit {
        WelcomeVC.timer?.invalidate()
        WelcomeVC.timer = nil
        print("Deinit \(self.name)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch index {
        case 0:
            imageNames.append(product.image)
            labelContent.text = product.content
        case 1:
            imageNames.append(highlightModel.image ?? "")
            labelContent.text = highlightModel.content
        default:
            imageNames.append(newsEventModel.image ?? "")
            labelContent.text = newsEventModel.content
        }
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
            index = index >= 1 ? 0 : index
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

