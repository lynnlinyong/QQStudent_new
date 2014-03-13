//
//  Site.m
//  QQStudent
//
//  Created by lynn on 14-2-20.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "Site.h"

@implementation Site
@synthesize address;
@synthesize cityCode;
@synthesize cityName;
@synthesize districtName;
@synthesize emptyNumber;
@synthesize expense;
@synthesize icon;
@synthesize imgArray;
@synthesize latitude;
@synthesize longitude;
@synthesize name;
@synthesize proviceName;
@synthesize sid;
@synthesize tel;

- (id) init
{
    self = [super init];
    if (self)
    {
        address  = [[NSString alloc]init];
        cityCode = [[NSString alloc]init];
        cityName = [[NSString alloc]init];
        districtName = [[NSString alloc]init];
        emptyNumber  = [[NSString alloc]init];
        expense  = [[NSString alloc]init];
        icon     = [[NSString alloc]init];
        imgArray = [[NSArray alloc]init];
        latitude = [[NSString alloc]init];
        longitude= [[NSString alloc]init];
        name     = [[NSString alloc]init];
        proviceName  = [[NSString alloc]init];
        sid      = [[NSString alloc]init];
        tel      = [[NSString alloc]init];
    }
    
    return self;
}

- (void) dealloc
{
    [address release];
    [cityName release];
    [cityCode release];
    [districtName release];
    [emptyNumber release];
    [expense release];
    [icon release];
    [imgArray release];
    [latitude release];
    [longitude release];
    [name release];
    [proviceName release];
    [sid release];
    [tel release];
    
    [super dealloc];
}

- (id) copyWithZone:(NSZone *)zone
{
    Site *sObj = NSCopyObject(self, 0, zone);
    if (sObj)
    {
        sObj.address = [address copy];
        sObj.cityCode= [cityCode copy];
        sObj.cityName= [cityName copy];
        sObj.districtName = [districtName copy];
        sObj.emptyNumber  = [emptyNumber copy];
        sObj.expense = [expense copy];
        sObj.icon    = [icon copy];
        sObj.imgArray= [imgArray copy];
        sObj.latitude= [latitude copy];
        sObj.longitude= [longitude copy];
        sObj.name     = [name copy];
        sObj.proviceName = [proviceName copy];
        sObj.sid = [sid copy];
        sObj.tel = [tel copy];
    }
    
    return sObj;
}

- (id) mutableCopyWithZone:(NSZone *)zone
{
    Site *sObj = NSCopyObject(self, 0, zone);
    if (sObj)
    {
        sObj.address = [address copy];
        sObj.cityCode= [cityCode copy];
        sObj.cityName= [cityName copy];
        sObj.districtName = [districtName copy];
        sObj.emptyNumber  = [emptyNumber copy];
        sObj.expense = [expense copy];
        sObj.icon    = [icon copy];
        sObj.imgArray= [imgArray copy];
        sObj.latitude= [latitude copy];
        sObj.longitude= [longitude copy];
        sObj.name     = [name copy];
        sObj.proviceName = [proviceName copy];
        sObj.sid = [sid copy];
        sObj.tel = [tel copy];
    }
    
    return sObj;
}

+ (Site *) setSiteProperty:(NSDictionary *) item
{
    Site *site = [[[Site alloc]init]autorelease];
    
    site.address = [[item objectForKey:@"address"] copy];
    site.cityCode= [[item objectForKey:@"cityCode"] copy];
    site.cityName= [[item objectForKey:@"cityName"] copy];
    site.districtName = [[item objectForKey:@"districtName"] copy];
    site.emptyNumber  = [[item objectForKey:@"emptyNumber"] copy];
    site.expense = [[item objectForKey:@"expense"] copy];
    site.icon    = [[item objectForKey:@"icon"] copy];
    site.imgArray= [[item objectForKey:@"images"] copy];
    site.latitude= [[item objectForKey:@"latitude"] copy];
    site.longitude= [[item objectForKey:@"longitude"] copy];
    site.name    = [[item objectForKey:@"name"] copy];
    site.proviceName = [[item objectForKey:@"provinceName"] copy];
    site.sid = [[item objectForKey:@"sid"] copy];
    site.tel = [[item objectForKey:@"tel"] copy];
    
    return site;
}

@end
