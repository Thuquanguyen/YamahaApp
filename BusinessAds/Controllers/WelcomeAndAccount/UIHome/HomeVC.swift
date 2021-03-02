//
//  HomeVC.swift
//  CreateUI
//
//  Created by ThuNQ on 10/13/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var viewError: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var naviBar: CustomNaviBar!
    {
        didSet{
            naviBar.title = "Campaign list"
            naviBar.buttonBack.isHidden = true
            naviBar.rightButtonFirst.isHidden = false
            naviBar.rightButtonFirst.iconImage = UIImage("icon_signout")
        }
    }
    var removeView: (() -> Void)?
    var listData = [ProductModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
//        getData()
        naviBar.rightButtonFirst.didTap = {
            let defaults = UserDefaults.standard
            defaults.set([], forKey: "data_tiktok")
            defaults.set(false, forKey: "login_check")
            defaults.synchronize()
            let vc = SignInWithAccountVC()
            self.push(vc)
        }
    }
    
    @IBAction func actionAdd(_ sender: Any) {
        let vc = AddAdsVC()
        vc.updateData = {
            self.listData.removeAll()
            self.getData()
            self.collectionView.reloadData()
        }
        self.push(vc)
    }
    
    private func setupCollectionView(){
        collectionView.registerNibCellFor(type: ProductCell.self)
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
                layout.minimumLineSpacing = 10
                layout.minimumInteritemSpacing = 10
                layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
                let size = CGSize(width:(collectionView!.bounds.width-30)/2, height: 250)
                layout.itemSize = size
        }
    }
    
    private func getData(){
        if let placeData = UserDefaults.standard.data(forKey: "data_tiktok"){
            let placeArray = try! JSONDecoder().decode([ProductModel].self, from: placeData)
            self.listData = placeArray
            if self.listData.count == 0 {
                viewError.isHidden = false
            }else{
                viewError.isHidden = true
            }
        }else{
            viewError.isHidden = false
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(with: ProductCell.self, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AdsDetailVC()
        self.push(vc)
    }
}
