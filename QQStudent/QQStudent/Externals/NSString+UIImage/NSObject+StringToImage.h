//
//  NSString+StringToImage.h
//  QQStudent
//
//  Created by lynn on 14-2-15.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (StringToImage)
-(UIImage *)imageFromText:(NSString *)text
                    width:(float)width
                   height:(float)height;
@end
