//
//  UICollectionView+sendPrivateEvent.swift
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/4/22.
//

import UIKit
import Combine

let orthogonalScrollViewDidScroll: PassthroughSubject<(AnyObject, UICollectionView, UIScrollView, AnyObject, NSMapTable<AnyObject, UIScrollView>), Never> = .init()
fileprivate var swizzledScrollViewDidScroll: Bool = false
fileprivate typealias ScrollViewDidScrollBlockType = @convention(c) (AnyObject, Selector, UIScrollView) -> Void

let configuredOrthogonalScrollView: PassthroughSubject<(AnyObject, UICollectionView, UIScrollView, CLong, NSMapTable<AnyObject, UIScrollView>), Never> = .init()
fileprivate var swizzledConfigureScrollView: Bool = false
fileprivate typealias ConfigureScrollViewBlockType = @convention(c) (AnyObject, Selector, UIScrollView, Int, UIEdgeInsets, UIEdgeInsets, Bool) -> Bool

extension UICollectionView {
    static func sendOrthogonalScrollViewDidScrollEvent() {
        guard !swizzledScrollViewDidScroll else { return }
        
        let orthogonalScrollerSectionControllerClass: AnyClass = NSClassFromString("_UICollectionViewOrthogonalScrollerSectionController")!
        let selector: Selector = #selector(UIScrollViewDelegate.scrollViewDidScroll(_:))
        let method: Method = class_getInstanceMethod(orthogonalScrollerSectionControllerClass, selector)!
        let originalImp: IMP = method_getImplementation(method)
        let original: ScrollViewDidScrollBlockType = unsafeBitCast(originalImp, to: ScrollViewDidScrollBlockType.self)
        let new: @convention(block) (AnyObject, UIScrollView) -> Void = { (me, scrollView) -> Void in
            original(me, selector, scrollView)
            let collectionView: UICollectionView = me.perform(Selector(("collectionView"))).takeUnretainedValue() as! UICollectionView
            let scrollViewFromSectionMap: NSMapTable<AnyObject, UIScrollView> = me.value(forKey: "scrollViewFromSectionMap") as! NSMapTable<AnyObject, UIScrollView>
            let scrollViewToSectionMap: NSMapTable<UIScrollView, AnyObject> = me.value(forKey: "scrollViewToSectionMap") as! NSMapTable<UIScrollView, AnyObject>
            let section: AnyObject = scrollViewToSectionMap.object(forKey: scrollView)!
            orthogonalScrollViewDidScroll.send((me, collectionView, scrollView, section, scrollViewFromSectionMap))
        }
        let newImp: IMP = imp_implementationWithBlock(new)
        method_setImplementation(method, newImp)
        
        swizzledScrollViewDidScroll = true
    }
    
    static func sendConfiguredOrthogonalScrollViewEvent() {
        guard !swizzledConfigureScrollView else { return }
        
        let orthogonalScrollerSectionControllerClass: AnyClass = NSClassFromString("_UICollectionViewOrthogonalScrollerSectionController")!
        let selector: Selector = .init(("_configureScrollView:forSection:baseContentInsets:frameInsets:isInitialConfiguration:"))
        let method: Method = class_getInstanceMethod(orthogonalScrollerSectionControllerClass, selector)!
        let originalImp: IMP = method_getImplementation(method)
        let original: ConfigureScrollViewBlockType = unsafeBitCast(originalImp, to: ConfigureScrollViewBlockType.self)
        let new: @convention(block) (AnyObject, UIScrollView, CLong, UIEdgeInsets, UIEdgeInsets, Bool) -> Bool = { (me, scrollView, section, baseContentInsets, frameInsets, isInitialConfiguration) -> Bool in
            let result: Bool = original(me, selector, scrollView, section, baseContentInsets, frameInsets, isInitialConfiguration)
            let collectionView: UICollectionView = me.perform(Selector(("collectionView"))).takeUnretainedValue() as! UICollectionView
            let scrollViewFromSectionMap: NSMapTable<AnyObject, UIScrollView> = me.value(forKey: "scrollViewFromSectionMap") as! NSMapTable<AnyObject, UIScrollView>
            
            configuredOrthogonalScrollView.send((me, collectionView, scrollView, section, scrollViewFromSectionMap))
            
            return result
        }
        let newImp: IMP = imp_implementationWithBlock(new)
        method_setImplementation(method, newImp)
        
        swizzledConfigureScrollView = true
    }
}
