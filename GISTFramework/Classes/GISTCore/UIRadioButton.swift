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

open class UIRadioButton: CustomUIButton {

    var _groupId:Int?
    
    @IBInspectable open var groupId:Int {
        get {
            return _groupId!;
        }
        
        set {
            _groupId = newValue;
        }
    } //P.E.
    
    @IBInspectable open var initiallySelected:Bool = false {
        didSet {
            self.isSelected = initiallySelected;
        }
    } //P.E.
    
    /// Unimplemented method. Should not be called.
    ///
    /// - Parameter frame: View Frame
    override private init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented, call init(frame: radioGroupId:)")
    } //F.E.

    public init(frame: CGRect, radioGroupId:Int) {
        super.init(frame: frame);
        //--
        self.groupId = radioGroupId;
        //--
        self.commonInit();
    } //F.E.
    
    /// Required constructor implemented.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    } //F.E.
    
    /// Overridden method to setup/ initialize components.
    override open func awakeFromNib() {
        super.awakeFromNib();
        //--
        self.commonInit();
    } //F.E.
    
    /// A common initializer to setup/initialize sub components.
    private func commonInit() {
        assert((_groupId != nil), "Group Id must be defined");
        //--
        UIRadioButtonManager.sharedInstance.addButton(self);
    } //F.E.
    
    class open func getSelectedButton(_ radioGroupId:Int) -> UIRadioButton? {
        return UIRadioButtonManager.sharedInstance.getSelectedButton(radioGroupId);
    }//F.E.
    
    deinit {
        UIRadioButtonManager.sharedInstance.removeButton(self);
    } //D.E.

} //CLS END

internal class UIRadioButtonManager:NSObject {
    
    static var sharedInstance: UIRadioButtonManager = UIRadioButtonManager();
    
    private var _mainBtnsDict:NSMutableDictionary = NSMutableDictionary();
    
    //MARK - Adding Radio Buttons
    func addButton(_ radioButton:UIRadioButton) {
        
        radioButton.addTarget(self, action: #selector(buttonsTapHandler), for: UIControlEvents.touchUpInside);
        //--
        var hashTable:NSHashTable<WeakRef<UIRadioButton>>? = _mainBtnsDict[radioButton.groupId] as? NSHashTable
        
        if (hashTable == nil) {
            hashTable = NSHashTable();
            //--
            _mainBtnsDict[radioButton.groupId] = hashTable! as Any?;
        }
        
        hashTable!.add(WeakRef<UIRadioButton>(value: radioButton));
    } //F.E.
    
    func removeButton(_ radioButton:UIRadioButton) {
        
        radioButton.removeTarget(self, action: #selector(buttonsTapHandler), for: UIControlEvents.touchUpInside);
        
        if let hashTable:NSHashTable<WeakRef<UIRadioButton>> = _mainBtnsDict[radioButton.groupId] as? NSHashTable<WeakRef<UIRadioButton>> {
            let enumerator:NSEnumerator = hashTable.objectEnumerator();
            
            while let iRadioButtonWeak:WeakRef<UIRadioButton> = enumerator.nextObject() as? WeakRef<UIRadioButton> {
                
                if iRadioButtonWeak.value == nil || iRadioButtonWeak.value == radioButton {
                        hashTable.remove(iRadioButtonWeak);
                        //--
                        if (hashTable.count == 0) {
                            _mainBtnsDict.removeObject(forKey: radioButton.groupId);
                        }
                        //--
                        break;
                }
            }
        }
    } //F.E.
    
    func buttonsTapHandler(_ radioButton:UIRadioButton) {
        if let hashTable:NSHashTable<WeakRef<UIRadioButton>> = _mainBtnsDict[radioButton.groupId] as? NSHashTable<WeakRef<UIRadioButton>> {
            let enumerator:NSEnumerator = hashTable.objectEnumerator();
            
            while let iRadioButtonWeak:WeakRef<UIRadioButton> = enumerator.nextObject() as? WeakRef<UIRadioButton> {
                if let iRadioButton:UIRadioButton = iRadioButtonWeak.value {
                    iRadioButton.isSelected = (iRadioButton == radioButton);
                }
            }
        }
    }//F.E.
    
    func getSelectedButton(_ radioGroupId:Int) -> UIRadioButton? {
        if let hashTable:NSHashTable<WeakRef<UIRadioButton>> = _mainBtnsDict[radioGroupId] as? NSHashTable<WeakRef<UIRadioButton>> {
            let enumerator:NSEnumerator = hashTable.objectEnumerator();
            
            while let iRadioButtonWeak:WeakRef<UIRadioButton> = enumerator.nextObject() as? WeakRef<UIRadioButton> {
                if let iRadioButton:UIRadioButton = iRadioButtonWeak.value {
                    if (iRadioButton.isSelected == true) {
                        return iRadioButton;
                    }
                }
            }
        }
        
        //No button is selected
        return nil;
    } //F.E.
    
} //CLS END

