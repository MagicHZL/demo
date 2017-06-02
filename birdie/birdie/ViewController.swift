//
//  ViewController.swift
//  birdie
//
//  Created by ZhongLiangHao on 2017/5/31.
//  Copyright © 2017年 ZhongLiangHao. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    var collectionView : UICollectionView!;
    var birdieView : UIImageView!;
    var offsetX :CGFloat!;
    var birdieY = KSheight/2;
    var leve :CGFloat!;
    
    var cellWidth : CGFloat = 350;
    
    var gameTime : Timer!;
    
    var animator : UIDynamicAnimator!;
    var behavior : UICollisionBehavior!;
    
    var isFly = false;
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
    
        self.creatViews();
        self.beginGameView();
        
    }
    
    
    func beginGameView() {
        
        let bgView = UIView.init(frame: self.view.bounds);
        bgView.backgroundColor = UIColor.init(white: 0.3, alpha: 0.8);
        self.view.addSubview(bgView);
        let but = UIButton.init(type: UIButtonType.custom);
        but.frame = CGRect.init(x: 0, y: 0, width: 150, height: 60);
        but.center = bgView.center;
        but.setImage(UIImage.init(named: "play.png"), for: UIControlState.normal);
        but.addTarget(self, action: #selector(ViewController.beginAction(but:)), for: UIControlEvents.touchUpInside);
        bgView.addSubview(but);
        
        
    }
    
    func beginAction(but :UIButton ){
        
        but.superview?.removeFromSuperview();
        offsetX = 0;
        leve = 5.0;
        birdieY = KSheight/2;
        self.collectionView.contentOffset = CGPoint.zero;

        birdieView.center = CGPoint.init(x: KSwidth/2.5, y: birdieY);
        
        gameTime = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(ViewController.gameTimeAction(time:)), userInfo: nil, repeats: true);
        
    }
    
    func endAction() {
        
        self.beginGameView();
       
        
    }
    
    
    func gameTimeAction(time:Timer) {
        
        
        offsetX = leve + offsetX;
        UIView.animate(withDuration: 0.1) {
        
            self.collectionView?.contentOffset = CGPoint.init(x: self.offsetX, y: 0.0);
            
        };
        if isFly {
            
            birdieY = birdieY - (CGFloat(leve) * (KSheight - 80) / (cellWidth - 50));
            
            
        }else{
            
            birdieY = birdieY + (CGFloat(leve) * (KSheight - 80) / (cellWidth - 50));
            
        }

        
        if birdieY<=15 {
            birdieY = 15;
        }else if birdieY>=(KSheight-15.0) {
        
            birdieY = KSheight - 15.0;
        }
        
        
        let pointArry : [CGPoint] = [CGPoint.init(x:(KSwidth/2.5)-25, y: birdieY-15),
                                     CGPoint.init(x: (KSwidth/2.5)-25, y: birdieY+15),
                                     CGPoint.init(x:(KSwidth/2.5)+25, y: birdieY+11),
                                     CGPoint.init(x: (KSwidth/2.5)+25, y: birdieY-15)
                                        ];

        
        let index = self.calculateCellIndex();
        
        var upP :CGRect? = nil;
        var downP : CGRect? = nil
        ;
        
        if (index != nil) {
            
            let cell = self.collectionView.cellForItem(at: index!) as? BirdieCell;
            
            upP = (cell?.convert((cell?.upView.frame)!, to: self.view!))!;
            downP = (cell?.convert((cell?.downView.frame)!, to: self.view!))!;
            
        }
    
        UIView.animate(withDuration: 0.1, animations: {
        
            self.birdieView.center = CGPoint.init(x: KSwidth/2.5, y: self.birdieY);
        });
    
        for point :CGPoint in pointArry{
            
            let upB = upP?.contains(point);
            let downB = downP?.contains(point);
            
            if upB == true || downB == true{
                
                gameTime.invalidate();
//                bgTime.invalidate();
                gameTime = nil;
//                bgTime = nil;
    
                self.endAction();
                return;
                
            }
            
        }
        
        if (index != nil) {
        
            let l = (index?.row)!/2 + 1 ;
            if l > Int(leve) {
                
                leve  = leve + 0.2;
                
            }
        
        }
   
       
    }
    
    func creatViews() {
        
        birdieView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 40));
 
        birdieView.image = UIImage.init(named: "bir.png");

        birdieView.center = CGPoint.init(x: KSwidth/2.5, y: birdieY);
        
        self.view.addSubview(birdieView);
        let layout = UICollectionViewFlowLayout.init();
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal;
        layout.itemSize = CGSize.init(width: cellWidth, height: self.view.bounds.size.height);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSize.init(width: KSwidth/2, height: KSheight);
        collectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout);
        collectionView!.register(BirdieCell.classForCoder(), forCellWithReuseIdentifier: "123");
        collectionView!.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "123")
        collectionView!.delegate = self;
        collectionView!.dataSource = self;
        collectionView!.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "bg.jpeg")!);
        collectionView.isUserInteractionEnabled = false;
        
        self.view.addSubview(collectionView!);
        
        self.view.bringSubview(toFront: birdieView);
     
        
    }
    
    
    func calculateCellIndex() -> IndexPath?{
        
        
        let left = KSwidth/2.5 - 15 ;
        
        var relrow =  (CGFloat(offsetX) + left - KSwidth * (2.0/3.0)) / cellWidth;

        if relrow<0 {
            
            return nil;
        }else{
        
            relrow = CGFloat(floorf(Float(relrow)));
        }
        
        return IndexPath.init(row: Int(relrow), section: 0);
    }

    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        
        return 50;
    }
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"123", for: indexPath)  as! BirdieCell;
        
        cell.creatSubviews();
        return cell;
        
    }
    
    
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
    
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "123", for: indexPath);
    
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isFly = true;
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        isFly = false;
    }

}

