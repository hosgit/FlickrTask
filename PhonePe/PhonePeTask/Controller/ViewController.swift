//
//  ViewController.swift
//  phonepeTask
//
//  Created by Hos on 27/03/18.
//  Copyright © 2018 hos.lbox.phonepeTask. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var flickrs = [Flickr]()
    var footerView:CustomFooterView?
    var isLoading:Bool = false
    var currentPage = 1
    var latestQuery = ""
    let footerViewReuseIdentifier = "RefreshFooterView"
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var noResultsLabel: UILabel!
    {
        didSet
        {
            noResultsLabel.isHidden = true
        }
    }
    @IBOutlet weak var searchTableView: UITableView!
    {
        didSet
        {
            searchTableView.isHidden = true
            searchTableView.dataSource = HistoryDataSource.sharedHistory
            searchTableView.delegate = HistoryDataSource.sharedHistory
            HistoryDataSource.sharedHistory.delegate = self
        }
    }
    
    var devieOreintationSize:CGSize
    {
        get
        {
            if UIDevice.current.orientation.isLandscape
            {
                return  CGSize(width: imagesCollectionView.frame.width / 3 - 15, height: (imagesCollectionView.frame.width / 3) / 1.5 )
            } else
            {
                return  CGSize(width: imagesCollectionView.frame.width / 2 - 15, height: (imagesCollectionView.frame.width / 2) / 1.5 )
            }
        }
    }

    @IBOutlet weak var imagesCollectionView: UICollectionView!
    {
        didSet
        {
           imagesCollectionView.delegate = self
           imagesCollectionView.dataSource = self
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    {
        didSet
        {
            searchTextField.delegate = self
            addButtonOntextField()
            searchTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

        self.imagesCollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
    }
    
    private func addButtonOntextField()
    {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "dismiss"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0)
        button.frame = CGRect(x: CGFloat(searchTextField.frame.size.width - 25), y: CGFloat(5), width: CGFloat(25), height: CGFloat(25))
        button.addTarget(self, action: #selector(self.dismissSearch), for: .touchUpInside)
        searchTextField.rightView = button
        searchTextField.rightViewMode = .whileEditing
    }
    
    @objc private func dismissSearch()
    {
        searchTableView.isHidden = true
        searchTextField.text = ""
        view.endEditing(true)
    }
    
    @objc func textFieldDidChange(textField: UITextField)
    {
        guard let text = textField.text else
        {
            print("returning")
            return
        }
        guard  text.trimmingCharacters(in: .whitespaces).count > 0 else {
            HistoryDataSource.sharedHistory.getSavedhistoryFromDB()
            return
        }
        HistoryDataSource.sharedHistory.getHistoryWithText(text:text)
    }
    
    @IBAction func searchAction(_ sender: UITextField)
    {
        self.noResultsLabel.isHidden =  true
        guard let text = sender.text else {
            return
        }
        guard text.trimmingCharacters(in: .whitespaces).count > 0 else {
            return
        }
        indicator.startAnimating()
        flickrs = [Flickr]()
        imagesCollectionView.reloadData()
        sender.resignFirstResponder()
        searchTableView.isHidden = true
        guard let  key = sender.text else
        {
            // pop error
            return
        }
        latestQuery = key
        getFlickrImages(Page: currentPage, text:latestQuery)
        self.saveToCoreData(text: latestQuery)
        sender.text = ""
        HistoryDataSource.sharedHistory.getSavedhistoryFromDB()
        searchTableView.reloadData()
    }
    
    func saveToCoreData(text:String)
    {
        let managedObjectContext = CoreDataManager.sharedManger.managedObjectContext
        _ =  History.createHistoryEntiryFrom(context: managedObjectContext, date: Date (), text: text)
         CoreDataManager.sharedManger.saveContext()
    }
    
    func getFlickrImages(Page:Int,text:String)
    {
        if  currentPage == 1
        {
            indicator.startAnimating()
        }
        NetworkManger.getFlickImages(page: currentPage,
                                           text:text )
        {[weak self] (result) in
            switch result
            {
            case .Success(let data):
                self?.populateFlickrs(photos: data)
            case .Error(let message):
                DispatchQueue.main.async
                    {
                        
                        Utility.showAlertWith(title: "Error", message: message,controller:self!)
                        self?.indicator.stopAnimating()
                }
            }
        }
    }
    
    func populateFlickrs(photos:Array<Dictionary<String,AnyObject>>)
    {
        indicator.stopAnimating()
        
        if photos.count == 0
        {
            self.noResultsLabel.isHidden =  false
            self.imagesCollectionView.isHidden = true
        }
        else
        {
            self.noResultsLabel.isHidden =  true
            self.imagesCollectionView.isHidden = false
            for photoDict in photos
            {
                let flickr = Flickr(dataDict: photoDict)
                flickrs.append(flickr)
            }
            currentPage = currentPage + 1
            self.imagesCollectionView.reloadData()
        }
    }
    
    @objc func rotated()
    {
        imagesCollectionView.reloadData()
    }
}

extension ViewController:UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return flickrs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let flickrCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIds.flickerImageCellId  , for: indexPath) as! ImageCollectionViewCell
        flickrCell.myFlickr = flickrs[indexPath.row]
        return flickrCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath) as! CustomFooterView
            self.footerView = aFooterView
            self.footerView?.backgroundColor = UIColor.clear
            return aFooterView
        } else {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
            return headerView
        }
    }
}

extension ViewController:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{
     func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath)
    {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.prepareInitialAnimation()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionElementKindSectionFooter {
            self.footerView?.stopAnimate()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isLoading {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.size.width, height: 55)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return devieOreintationSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
      return  UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    //compute the scroll value and play witht the threshold to get desired effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let threshold   = 100.0 ;
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold);
        triggerThreshold   =  min(triggerThreshold, 0.0)
        let pullRatio  = min(fabs(triggerThreshold),1.0);
        self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
        if pullRatio >= 1 {
            self.footerView?.animateFinal()
        }
        print("pullRation:\(pullRatio)")
    }
    
    //compute the offset and call the load method
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y;
        let contentHeight = scrollView.contentSize.height;
        let diffHeight = contentHeight - contentOffset;
        let frameHeight = scrollView.bounds.size.height;
        let pullHeight  = fabs(diffHeight - frameHeight);
        print("pullHeight:\(pullHeight)");
        if pullHeight == 0.0
        {
            if (self.footerView?.isAnimatingFinal)! {
                print("load more trigger")
                self.isLoading = true
                self.footerView?.startAnimate()
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer:Timer) in
                    self.getFlickrImages(Page: self.currentPage, text: self.latestQuery)
                    self.imagesCollectionView.reloadData()
                    self.isLoading = false
                })
            }
        }
    }
}


extension ViewController:UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        searchTableView.isHidden = false
        currentPage = 1
    }
}

extension ViewController:HistoryDataSourceEvents
{
    func beginDraging()
    {
        view.endEditing(true)
    }
    
    func didSelectQuery(text: String)
    {
        indicator.startAnimating()
        flickrs = [Flickr]()
        imagesCollectionView.reloadData()
        view.endEditing(true)
        getFlickrImages(Page:currentPage , text: text )
        searchTableView.isHidden = true
    }
    func dataRegenRated()
    {
        searchTableView.reloadData()
    }
}


