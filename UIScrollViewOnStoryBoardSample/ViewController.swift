//
//  ViewController.swift
//  UIScrollViewOnStoryBoardSample
//
//  Created by Kurose Nobuhito on 2015/03/12.
//  Copyright (c) 2015年 Nobuhito Kurose. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var developerNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var innerScrollView: UIScrollView!
    var invisibleScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    let appData = AppData.init()
    
    let imageViewSize = 280.0
    var imageOffset = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        iconImageView.image = appData.icon
        appNameLabel.text = appData.name
        developerNameLabel.text = appData.developer
        descriptionLabel.text = appData.description
        setScreenShotImages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setScreenShotImages(){
        
        imageOffset = (Double(self.view.frame.size.width) - imageViewSize) / 2.0
        
        innerScrollView.contentSize = CGSize(width: CGFloat(imageOffset + imageViewSize * Double(appData.screenShots.count)) , height: innerScrollView.frame.size.height)
        
        invisibleScrollView = UIScrollView(frame: CGRect(x: CGFloat(imageOffset), y: 0,
            width: CGFloat(imageViewSize), height: innerScrollView.frame.size.height))
        invisibleScrollView.userInteractionEnabled = false
        invisibleScrollView.pagingEnabled = true
        invisibleScrollView.showsHorizontalScrollIndicator = false
        invisibleScrollView.showsVerticalScrollIndicator = false
        invisibleScrollView.contentSize = CGSize(width: innerScrollView.contentSize.width - CGFloat(imageOffset), height:innerScrollView.contentSize.height)
        
        innerScrollView.addGestureRecognizer(invisibleScrollView.panGestureRecognizer);
        
        self.view.addSubview(invisibleScrollView)
        
        invisibleScrollView.delegate = self;
        
        self.pageControl.numberOfPages = appData.screenShots.count
      
        
        for index in 0 ..< appData.screenShots.count {
            var containerView = UIView(frame: CGRect(x: CGFloat(imageOffset + imageViewSize * Double(index)), y: 0,
                width: CGFloat(imageViewSize), height: innerScrollView.frame.size.height))
         
            innerScrollView.addSubview(containerView)
            
            var screenShot:UIImageView? = UIImageView(image: appData.screenShots[index])
            
            //for landscape image
            if (screenShot!.image?.size.height<screenShot!.image?.size.width){
                let degrees = CGFloat(90.0)
                let cgf180 = CGFloat(180)
                screenShot!.transform = CGAffineTransformMakeRotation(degrees * CGFloat(M_PI)/cgf180);
            }
            
            screenShot!.frame.size = CGSize(width: 360, height: 360)
            screenShot!.contentMode = UIViewContentMode.ScaleAspectFit
            screenShot!.center = CGPoint(x:containerView.frame.size.width/2, y:containerView.frame.size.height/2+10)
            
            containerView.addSubview(screenShot!)
            
        }
    }
    
    func scrollViewDidScroll(scrollview: UIScrollView) {
        
        var pageWidth : CGFloat = self.invisibleScrollView.frame.size.width
        var fractionalPage : Double = Double(self.invisibleScrollView.contentOffset.x / pageWidth)
        var page : NSInteger = lround(fractionalPage)
        self.pageControl.currentPage = page;
    
        self.innerScrollView.contentOffset = self.invisibleScrollView.contentOffset;
    }
}

