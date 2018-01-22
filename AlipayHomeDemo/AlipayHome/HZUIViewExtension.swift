//
//  HZUIViewExtension.swift
//  WashingMachine
//
//  Created by zzh on 2017/9/12.
//  Copyright © 2017年 Eteclabeteclab. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public var hz_x:CGFloat {
        get {
            return frame.origin.x
        }
        set {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
    }
    
    public var hz_y:CGFloat {
        get {
            return frame.origin.y
        }
        set {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }
    
    public var hz_width:CGFloat {
        get {
            return frame.size.width
        }
        set {
            var rect = frame
            rect.size.width = newValue
            frame = rect
        }
    }
    
    public var hz_height:CGFloat {
        get {
            return frame.size.height
        }
        set {
            var rect = frame
            rect.size.height = newValue
            frame = rect
        }
    }
    
    public var hz_size:CGSize {
        get {
            return frame.size
        }
        set {
            var rect = frame
            rect.size = newValue
            frame = rect
        }
    }
    
    public var hz_origin:CGPoint {
        get {
            return frame.origin
        }
        set {
            var rect = frame
            rect.origin = newValue
            frame = rect
        }
    }
    
    public var hz_center:CGPoint {
        get {
            return self.center
        }
        set {
            self.center = newValue
        }
    }
    
    public var hz_centerX:CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center.x = newValue
        }
    }
    
    public var hz_centerY:CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center.y = newValue
        }
    }
    
    public func removeAllSubView() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
}
