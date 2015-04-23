//
//  UICollectionViewExtensions.swift
//  Roomguru
//
//  Created by Patryk Kaczmarek on 23/04/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import Foundation

extension UICollectionView {
    
    enum Type {
        case Cell, Header, Footer
    }
    
    func registerClass<T where T: UICollectionReusableView, T: Reusable>(aClass: T.Type, type: Type) {
        
        switch(type) {
        case .Cell:
            registerClass(aClass, forCellWithReuseIdentifier: T.reuseIdentifier())
        case .Header:
            registerClass(aClass, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: T.reuseIdentifier())
        case .Footer:
            registerClass(aClass, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: T.reuseIdentifier())
        }
    }
}
