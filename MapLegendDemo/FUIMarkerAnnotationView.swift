//
//  FUIMarkerAnnotationView.swift
//  MapLegendDemo
//
//  Created by Barton, Tricia on 8/10/17.
//  Copyright © 2017 Takahashi, Alex. All rights reserved.
//

import Foundation
import MapKit

class FUIMarkerAnnotationView : MKMarkerAnnotationView
{
    let priorityIconView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 17, height: 17))
    let profileIconView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
    
    public var priorityIcon:UIImage? = nil {

        didSet {
            //print("setting priority icon: \(self.priorityIcon)")
            priorityIconView.image = self.priorityIcon
            
            priorityIconView.image = priorityIcon
            priorityIconView.center.x = 22
            priorityIconView.center.y = 2
            priorityIconView.layer.zPosition = 100
            
            self.addSubview(priorityIconView)
            self.bringSubview(toFront: priorityIconView)
        }
    }
    
    public var profileIcon:UIImage? = nil {
        didSet  {
            //print("setting profile icon: \(self.profileIcon)")
            self.glyphImage = self.profileIcon
            self.selectedGlyphImage = self.profileIcon
            
            profileIconView.image = self.profileIcon
            
            self.addSubview(profileIconView)
            self.bringSubview(toFront: profileIconView)
        }
    }
    
    override public init(annotation: MKAnnotation?, reuseIdentifier: String?){
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        
        self.markerTintColor = UIColor(hexString: "#2E4A62")

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        if(selected)
        {
            if priorityIcon != nil {
                priorityIconView.image = priorityIcon
                priorityIconView.center.x = 34
                priorityIconView.center.y = -34
            
                self.bringSubview(toFront: priorityIconView)
            }
            if profileIcon != nil {
                self.selectedGlyphImage = profileIcon
            }
        }
        else
        {
            if priorityIcon != nil
            {
                priorityIconView.image = priorityIcon
                priorityIconView.center.x = 22
                priorityIconView.center.y = 2
            
                self.bringSubview(toFront: priorityIconView)
            }
            if profileIcon != nil {
                self.glyphImage = profileIcon
            }
        }
    }
}
