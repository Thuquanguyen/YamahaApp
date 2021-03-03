//
//  HomeVC.swift
//  CreateUI
//
//  Created by ThuNQ on 10/13/20.
//  Copyright © 2020 ThuNQ. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var collectionViewProduct: BaseCollectionView!
    @IBOutlet weak var collectionViewHighlight: BaseCollectionView!
    @IBOutlet weak var tableViewEvent: BaseTableView!
    @IBOutlet weak var heightProduct: NSLayoutConstraint!
    @IBOutlet weak var heightHeighlight: NSLayoutConstraint!
    @IBOutlet weak var heightEvent: NSLayoutConstraint!
    
    @IBOutlet weak var naviBar: CustomNaviBar!
    {
        didSet{
            naviBar.viewContent.backgroundColor = .white
            naviBar.buttonBack.isHidden = true
            naviBar.imageCenterView.isHidden = false
            naviBar.rightButtonFirst.isHidden = false
            naviBar.rightButtonFirst.iconImage = UIImage("icon_user")
            
        }
    }
    
    var removeView: (() -> Void)?
    
    var dataSourcProduct = CollectionDataSource<ProductModel,ProductCell>()
    var dataSourcHighlight = CollectionDataSource<HighlightModel,HighlightCell>()
    var dataSourcNewsEvent = TableDataSource<NewsEventModel,NewsEventCell>()
    
    var listProduct: [ProductModel] = [ProductModel(title: "Pianos", image: "product_1"),
                                       ProductModel(title: "Keyboard Instruments", image: "product_2"),
                                       ProductModel(title: "Guitars, Basses & Amps", image: "product_3"),
                                       ProductModel(title: "Drums", image: "product_4"),
                                       ProductModel(title: "Brass & Woodwinds", image: "product_5"),
                                       ProductModel(title: "Strings", image: "product_6"),
                                       ProductModel(title: "Percussion", image: "product_7"),
                                       ProductModel(title: "Marching Instrucments", image: "product_8")]
    var listHighlight: [HighlightModel] = [HighlightModel(title: "Stay True", image: "highlight_1"),
                                           HighlightModel(title: "New Genos Digital\nWorkstation", image: "highlight_2"),
                                           HighlightModel(title: "TF Series Digital Mixing\nConsole", image: "highlight_3"),
                                           HighlightModel(title: "Emerging Artists", image: "highlight_4"),
                                           HighlightModel(title: "New DTX402 Series", image: "highlight_5"),
                                           HighlightModel(title: "New HW3 Advanced Lightweight Hardware Set", image: "highlight_6")]
    var listEvents: [NewsEventModel] = [NewsEventModel(title: "Ten U.S. Schools Named 'Yamaha Institutions of Excellence'", subTitle: "Yamaha has named 10 distinguished colleges and universities to its inaugural Yamaha Institution of Excellence program, recognizing extraordinary commitment to innovation in the study of music.", image: "highlight_6", startDate: "22/03/2021"),
                                        NewsEventModel(title: "Yamaha DGX-670 Digital Piano Brings Modern Aesthetic, Color Display and Simplified User Interface to Hugely Popular Series", subTitle: "Yamaha today unveiled the DGX-670, a stylish digital piano featuring a modern, attractive aesthetic and a simplified user interface.", image: "highlight_6", startDate: "25/03/2021")]
    
    let popup = PopupConnectVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        initViewProduct()
        initViewHighlight()
        initViewNewsEvent()
        naviBar.rightButtonFirst.didTap = {
//            let defaults = UserDefaults.standard
//            defaults.set([], forKey: "data_tiktok")
//            defaults.set(false, forKey: "login_check")
//            defaults.synchronize()
            let vc = ProfileVC()
            self.push(vc)
        }
        naviBar.buttonBack.didTap = {
            self.pop()
        }
        let checkLogin = UserDefaults.standard.bool(forKey: "login_check")
        if !checkLogin{
            showPopup()
        }
        
    }
    private func setupCollectionView(){
        collectionViewProduct.registerNibCellFor(type: ProductCell.self)
        collectionViewHighlight.registerNibCellFor(type: HighlightCell.self)
        tableViewEvent.registerNibCellFor(type: NewsEventCell.self)
    }
    
    private func showPopup(){
        popup.willMove(toParent: self)
        self.addChild(popup)
        self.view.addSubview(popup.view)
        popup.didMove(toParent: self)
        popup.connectFB = {
            print("connect")
            let vc = FBLoginVC()
            self.push(vc)
        }
        popup.closeAction = {
            print("close")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.showPopup()
            }
        }
    }
}

extension HomeVC {
    private func initViewProduct(){
        collectionViewProduct.didChangeContentSize = { [weak self] contentSize in
            self?.heightProduct.constant = contentSize.height + 10
        }
        collectionViewProduct.setup(dataSourcProduct, cells: ProductCell.self)
        let widthItem = (SystemInfo.screenWidth) / 2
        dataSourcProduct.sizeColumn = CGSize(width: widthItem, height: widthItem)
        dataSourcProduct.minimumLineSpacing = 16
        dataSourcProduct.bindingCell = { cell, data, row in
            cell.configCell(data: data)
        }
        dataSourcProduct.didSelectRowAt = { [weak self] data, row in
            let vc = AdsDetailVC()
            self?.push(vc)
        }
        dataSourcProduct.setupData(listProduct)
    }
    
    private func initViewHighlight(){
        collectionViewHighlight.didChangeContentSize = { [weak self] contentSize in
            self?.heightHeighlight.constant = contentSize.height + 10
        }
        collectionViewHighlight.setup(dataSourcHighlight, cells: HighlightCell.self)
        let widthItem = (SystemInfo.screenWidth) / 2
        dataSourcHighlight.sizeColumn = CGSize(width: widthItem, height: widthItem)
        dataSourcHighlight.minimumLineSpacing = 16
        dataSourcHighlight.bindingCell = { cell, data, row in
            cell.configCell(data: data)
        }
        dataSourcHighlight.didSelectRowAt = { [weak self] data, row in
            let vc = AdsDetailVC()
            self?.push(vc)
        }
        dataSourcHighlight.setupData(listHighlight)
    }
    
    private func initViewNewsEvent(){
        tableViewEvent.didChangeContentSize = { [weak self] contentSize in
            self?.heightEvent.constant = contentSize.height + 10
        }
        dataSourcNewsEvent.bindingCell = { cell,data, row in
            cell.selectionStyle = .none
            cell.configCell(data: data)
        }
        dataSourcNewsEvent.didSelectRowAt = { [weak self] data,row in
            let vc = AdsDetailVC()
            self?.push(vc)
        }
        tableViewEvent.setup(source: dataSourcNewsEvent, registerNibCells: [NewsEventCell.self])
        dataSourcNewsEvent.setupData(listEvents)
    }
}
