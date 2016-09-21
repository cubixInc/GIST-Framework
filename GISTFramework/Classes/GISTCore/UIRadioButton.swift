//
//  UIRadioButton.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

//Defining here so that the class be independent
private class WeakRef<T: AnyObject> {
    weak var value : T?
    init (value: T) {
        self.value = value
    }
} //CLS END

public class UIRadioButton: CustomUIButton {

    var _groupId:Int?
    
    @IBInspectable public var groupId:Int {
        get {
            return _groupId!;
        }
        
        set {
            _groupId = newValue;
        }
    } //P.E.
    
    @IBInspectable public var initiallySelected:Bool = false {
        didSet {
            self.selected = initiallySelected;
        }
    } //P.E.
    
    override public init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented, call init(frame: radioGroupId:)")
    } //F.E.

    public init(frame: CGRect, radioGroupId:Int) {
        super.init(frame: frame);
        //--
        self.groupId = radioGroupId;
        //--
        self.commonInitialization();
    } //F.E.
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    override public func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commonInitialization();
    } //F.E.
    
    private func commonInitialization() {
        assert((_groupId != nil), "Group Id must be defined");
        //--
        UIRadioButtonManager.sharedInstance.addButton(self);
    } //F.E.
    
    class public func getSelectedButton(radioGroupId:Int) -> UIRadioButton? {
        return UIRadioButtonManager.sharedInstance.getSelectedButton(radioGroupId);
    }//F.E.
    
    deinit {
        UIRadioButtonManager.sharedInstance.removeButton(self);
    } //D.E.

} //CLS END

internal class UIRadioButtonManager:NSObject {
    
    class var sharedInstance: UIRadioButtonManager {
        struct Static {
            static var instance: UIRadioButtonManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = UIRadioButtonManager()
        }
        
        return Static.instance!
    } //P.E.
    
    private var _mainBtnsDict:NSMutableDictionary = NSMutableDictionary();
    
    private var _mayHasmap:NSHashTable = NSHashTable();
    
    //MARK - Adding Radio Buttons
    func addButton(radioButton:UIRadioButton) {
        
        radioButton.addTarget(self, action: #selector(buttonsTapHandler), forControlEvents: UIControlEvents.TouchUpInside);
        //--
        var hashTable:NSHashTable? = _mainBtnsDict[radioButton.groupId] as? NSHashTable
        
        if (hashTable == nil) {
            hashTable = NSHashTable();
            //--
            _mainBtnsDict[radioButton.groupId] = hashTable!;
        }
        
        hashTable!.addObject(WeakRef<UIRadioButton>(value: radioButton));
    } //F.E.
    
    func removeButton(radioButton:UIRadioButton) {
        
        radioButton.removeTarget(self, action: #selector(buttonsTapHandler), forControlEvents: UIControlEvents.TouchUpInside);
        
        if let hashTable:NSHashTable = _mainBtnsDict[radioButton.groupId] as? NSHashTable {
            let enumerator:NSEnumerator = hashTable.objectEnumerator();
            
            while let iRadioButtonWeak:WeakRef<UIRadioButton> = enumerator.nextObject() as? WeakRef<UIRadioButton> {
                
                if iRadioButtonWeak.value == nil || iRadioButtonWeak.value == radioButton {
                        hashTable.removeObject(iRadioButtonWeak);
                        //--
                        if (hashTable.count == 0) {
                            _mainBtnsDict.removeObjectForKey(radioButton.groupId);
                        }
                        //--
                        break;
                }
            }
        }
    } //F.E.
    
    func buttonsTapHandler(radioButton:UIRadioButton) {
        if let hashTable:NSHashTable = _mainBtnsDict[radioButton.groupId] as? NSHashTable {
            let enumerator:NSEnumerator = hashTable.objectEnumerator();
            
            while let iRadioButtonWeak:WeakRef<UIRadioButton> = enumerator.nextObject() as? WeakRef<UIRadioButton> {
                if let iRadioButton:UIRadioButton = iRadioButtonWeak.value {
                    iRadioButton.selected = (iRadioButton == radioButton);
                }
            }
        }
    }//F.E.
    
    func getSelectedButton(radioGroupId:Int) -> UIRadioButton? {
        if let hashTable:NSHashTable = _mainBtnsDict[radioGroupId] as? NSHashTable {
            let enumerator:NSEnumerator = hashTable.objectEnumerator();
            
            while let iRadioButtonWeak:WeakRef<UIRadioButton> = enumerator.nextObject() as? WeakRef<UIRadioButton> {
                if let iRadioButton:UIRadioButton = iRadioButtonWeak.value {
                    if (iRadioButton.selected == true) {
                        return iRadioButton;
                    }
                }
            }
        }
        
        //No button is selected
        return nil;
    } //F.E.
    
} //CLS END

