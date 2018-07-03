//
//  TableViewProvider.swift
//  swf-DFP-TableView-demo
//
//  Created by S.Emoto on 2018/07/04.
//  Copyright © 2018年 S.Emoto. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TableViewProvider: NSObject {

    //let itemList = ["0"]
    let firstAdsPositionInCells = 0
    let frequencyAdsInCells = 5
    
    var adLoader : GADAdLoader!
    var adView : GADNativeContentAdView!
    
    var table: UITableView!
    
    
    func setAdView(ad: GADNativeContentAdView) {
        self.adView = ad
    }
}

extension TableViewProvider: GADNativeContentAdLoaderDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeContentAd: GADNativeContentAd) {
        adView.nativeContentAd = nativeContentAd
        (adView.headlineView as! UILabel).text = nativeContentAd.headline
        (adView.bodyView as! UILabel).text = nativeContentAd.body
        if let nativeAdImage = nativeContentAd.images?.first as? GADNativeAdImage {
            (adView.imageView as! UIImageView).image = nativeAdImage.image
        }
        
        table.reloadData()
    }
    
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        
    }
}

extension TableViewProvider: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) 
        
        let isAdsPosition = (indexPath.row % frequencyAdsInCells - firstAdsPositionInCells) == 0
        
        if isAdsPosition && self.adView.nativeContentAd != nil {
            adView.frame = cell.contentView.frame
            cell.contentView.addSubview(adView)
        }else{
            if self.adView.isDescendant(of: cell.contentView) {
                adView.removeFromSuperview()
            }
            cell.textLabel?.text = indexPath.row.description
        }
        return cell
    }
}

extension TableViewProvider {
    
    func setupDFP(vc: UIViewController, tab: UITableView) {
        self.adLoader = GADAdLoader(adUnitID: "/6499/example/native",
                                    rootViewController: vc,
                                    adTypes: [GADAdLoaderAdType.nativeContent],
                                    options: [])
        self.adLoader.delegate = self
        let request = DFPRequest()
        request.testDevices = [ kGADSimulatorID ]
        self.adLoader.load(request)
        
        adView = UINib(nibName: "NativeContentAdView",
                                    bundle: nil).instantiate(withOwner: self,
                                                             options: nil)[0] as! GADNativeContentAdView
        //dataSource.setAdView(ad: nativeContentAdView)
        table = tab
    }
}
