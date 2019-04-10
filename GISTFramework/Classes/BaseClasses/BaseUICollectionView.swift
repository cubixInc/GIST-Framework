//
//  BaseCollectionView.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 14/06/2016.
//  Copyright © 2016 Social Cubix. All rights reserved.
//

import UIKit

/// BaseUICollectionView is a subclass of UICollectionView and implements BaseView. This class is made for furture use. right now it is doing nothing.
open class BaseUICollectionView: UICollectionView, BaseView {

    //MARK: - Methods
    
    /// Updates layout and contents from SyncEngine. this is a protocol method BaseView that is called when the view is refreshed.
    func updateView() {
        //DOING NOTHING FOR NOW
    } //F.E.

} //CLS END
