//
//  UICollectionView+Private.m
//  InfinityCollectionView
//
//  Created by Jinwoo Kim on 7/4/22.
//

#import "UICollectionView+Private.h"
#import <objc/message.h>

@implementation UICollectionView (Private)

- (void)orthogonalScrollToItemAtIndexPath:(NSIndexPath *)arg1 atScrollPosition:(UICollectionViewScrollPosition)arg2 animated:(BOOL)arg3 {
    id orthogonalScrollerSectionController = ((id (*)(id, SEL))objc_msgSend)(self, NSSelectorFromString(@"_orthogonalScrollerController"));
    ((void (*)(id, SEL, NSIndexPath *, UICollectionViewScrollPosition, BOOL))objc_msgSend)(orthogonalScrollerSectionController, NSSelectorFromString(@"_scrollToItemAtIndexPath:atScrollPosition:animated:"), arg1, arg2, arg3);
}

@end
