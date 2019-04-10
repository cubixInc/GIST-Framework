//
//  BaseUINavigationItem.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/07/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUINavigationItem is a subclass of UINavigationItem and implements BaseView. It has some extra proporties and support for SyncEngine.
open class BaseUINavigationItem: UINavigationItem, BaseView {
    
    //MARK: - Properties
    
    private var _titleKey:String?;
    
    /// Overriden title property to set title from SyncEngine (Hint '#' prefix).
    override open var title: String? {
        get {
            return super.title;
        }
        
        set {
            if let key:String = newValue , key.hasPrefix("#") == true {
                _titleKey = key;  // holding key for using later
                
                super.title = SyncedText.text(forKey: key);
            } else {
                super.title = newValue;
            }
        }
    } //P.E.
    
    //MARK: - Constructors
    
    /// Overridden constructor to setup/ initialize components.
    ///
    /// - Parameter title: Title of Navigation Item
    public override init(title: String) {
        super.init(title: title);
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    //MARK: - Overridden Methods
    
    /// Overridden method to setup/ initialize components.
    open override func awakeFromNib() {
        super.awakeFromNib();
         
        self.updateView();
    }
    
    //MARK: - Methods
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        if let txt:String = self.title , txt.hasPrefix("#") == true {
            self.title = txt; // Assigning again to set value from synced data
        } else if _titleKey != nil {
            self.title = _titleKey;
        }
    } //F.E.
} //CLS END
