//
//  BirdieCell.swift
//  birdie
//
//  Created by ZhongLiangHao on 2017/5/31.
//  Copyright © 2017年 ZhongLiangHao. All rights reserved.
//

import UIKit

class BirdieCell: UICollectionViewCell {
    
    var upView :UIView!;
    var downView : UIView!;
    let margin = 90;
    var islayout = false;

    override init(frame: CGRect) {
        
        super.init(frame: frame)
      
        upView = UIView.init();
        self.addSubview(upView);
        downView = UIView.init();
        self.addSubview(downView);
        
    }
    
    
    
    public func creatSubviews(){
    
    
        let relMargin = (arc4random_uniform(UInt32(margin))) + uint(margin) ;
        let upHeight = arc4random_uniform(UInt32(KSheight) - relMargin) + 10;
        
        upView.frame = CGRect.init(x: self.bounds.width - 80, y: 0, width: 50, height:CGFloat( upHeight));
        upView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "timg.jpeg")!);
        
        downView.frame = CGRect.init(x: self.bounds.width - 80, y: CGFloat( relMargin + upHeight), width: 50, height: KSheight - CGFloat( relMargin + upHeight));
        downView.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "timg.jpeg")!);
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    
}
