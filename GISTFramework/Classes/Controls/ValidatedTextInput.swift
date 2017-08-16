//
//  ValidatedTextInput.swift
//  GISTFramework
//
//  Created by Shoaib Abdul on 12/07/2017.
//  Copyright © 2017 Social Cubix. All rights reserved.
//

import UIKit

public protocol ValidatedTextInput {
    var validText: String? {get set}
    var isValid:Bool  {get}
    
    var paramKey:String? {get set}
} //P.E.
