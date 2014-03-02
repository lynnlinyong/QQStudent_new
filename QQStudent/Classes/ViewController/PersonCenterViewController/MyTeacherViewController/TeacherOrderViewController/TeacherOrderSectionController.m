//
//  TeacherOrderSectionController.m
//  QQStudent
//
//  Created by lynn on 14-2-12.
//  Copyright (c) 2014年 lynn. All rights reserved.
//

#import "TeacherOrderSectionController.h"

@interface TeacherOrderSectionController ()
@property (nonatomic, retain) NSArray *ordersArr;
@end

@implementation TeacherOrderSectionController
@synthesize ordersArr;
@synthesize teacherOrderDic;
@synthesize parentView;

//- (NSString *)title {
//    return NSLocalizedString(@"Simple exemple",);
//}
//
//- (NSString *)titleContentForRow:(NSUInteger)row {
//    return [self.colors objectAtIndex:row];
//}

- (NSUInteger)contentNumberOfRow
{
    self.ordersArr = [[teacherOrderDic objectForKey:@"orders"] copy];
    return [self.ordersArr count];
}

- (void)didSelectContentCellAtRow:(NSUInteger)row
{
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (UITableViewCell *) cellForRow:(NSUInteger)row
{
    static NSString *idString    = @"idString";
    if (row == 0)   //代表老师
    {        
        NSDictionary *teacherDic = [teacherOrderDic objectForKey:@"teacher"];
        
        Teacher *tObj = [Teacher setTeacherProperty:teacherDic];
        tObj.expense  = ((NSNumber *)[teacherDic objectForKey:@"teacher_expense"]).intValue;
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        tObj.headUrl  = [NSString stringWithFormat:@"%@%@",webAdd,[teacherDic objectForKey:@"teacher_icon"]];
        tObj.idNums   = [(NSString *)[teacherDic objectForKey:@"teacher_idnumber"] copy];
        tObj.info     = [(NSString *)[teacherDic objectForKey:@"teacher_info"] copy];
        tObj.name     = [[teacherDic objectForKey:@"teacher_name"]  copy];
        tObj.phoneNums= [[teacherDic objectForKey:@"teacher_phone"] copy];
        tObj.comment  = ((NSNumber *)[teacherDic objectForKey:@"teacher_stars"]).intValue;
        tObj.pf       = [[teacherDic objectForKey:@"teacher_subjectText"] copy];
        
        CLog(@"gender:%d", tObj.sex);
        
        //获得最近订单
        NSDictionary *orderDic = [self.ordersArr objectAtIndex:0];
        Order *order  = [Order setOrderProperty:orderDic];
        order.teacher = tObj;
        
        MyTeacherCell *cell = [[[MyTeacherCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:idString]autorelease];
        cell.order    = order;
        CLog(@"order>gender%d",order.teacher.sex);
        return cell;
    }
    else            //代表订单
    {
        NSDictionary *orderDic = [self.ordersArr objectAtIndex:row-1];
        Order *order  = [Order setOrderProperty:orderDic];
    
        NSDictionary *teacherDic = [teacherOrderDic objectForKey:@"teacher"];
        order.teacher = [Teacher setTeacherProperty:teacherDic];
        order.teacher.expense  = ((NSNumber *)[teacherDic objectForKey:@"teacher_expense"]).intValue;
        NSString *webAdd = [[NSUserDefaults standardUserDefaults] objectForKey:WEBADDRESS];
        order.teacher.headUrl  = [NSString stringWithFormat:@"%@%@",webAdd,[teacherDic objectForKey:@"teacher_icon"]];
        order.teacher.idNums   = [[teacherDic objectForKey:@"teacher_idnumber"] copy];
        order.teacher.info     = [[teacherDic objectForKey:@"teacher_info"] copy];
        order.teacher.name     = [[teacherDic objectForKey:@"teacher_name"]  copy];
        order.teacher.phoneNums= [[teacherDic objectForKey:@"teacher_phone"] copy];
        order.teacher.comment  = ((NSNumber *)[teacherDic objectForKey:@"teacher_stars"]).intValue;
        order.teacher.pf       = [[teacherDic objectForKey:@"teacher_subjectText"] copy];

        TeacherOrderCell *cell = [[[TeacherOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idString] autorelease];
        cell.delegate = self;
        cell.order    = order;

        return cell;
    }
    
    return nil;
}

#pragma mark -
#pragma mark Getters
- (void)dealloc
{
    [self.ordersArr release];
    [super dealloc];
}

#pragma mark -
#pragma mark - CommentViewDelegate
- (void) commentView:(CommentView *)commentView ClickedIndex:(int) index
{
    NSDictionary *noticeDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"Index",commentView.orderId,@"OrderID",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"commentOrderNotice"
                                                        object:nil
                                                      userInfo:noticeDic];
}

#pragma mark -
#pragma mark - TeacherOrderCellDelegate
- (void) cell:(TeacherOrderCell *)cell buttonTag:(int)tag
{
    CustomNavigationViewController *nav = (CustomNavigationViewController *)[MainViewController getNavigationViewController];
    switch (tag)
    {
        case 0:      //免费辅教
        {
            FreeBookViewController *fbVctr = [[FreeBookViewController alloc]init];
            fbVctr.orderId = cell.order.orderId;
            [nav pushViewController:fbVctr animated:YES];
            [fbVctr release];
            break;
        }
        case 1:      //评价
        {
            CommentView *cmmView = [[CommentView alloc]initWithFrame:[UIView fitCGRect:CGRectMake(0, 0, 320, 480) isBackView:NO]];
            cmmView.delegate = self;
            cmmView.orderId  = cell.order.orderId;
            
            CGRect rect = [cell convertRect:cell.commentBtn.frame toView:parentView];
            [cmmView showView:[UIView fitCGRect:CGRectMake(rect.origin.x-20,
                                                           rect.origin.y-80, 220, 100) isBackView:NO]];
            [parentView addSubview:cmmView];
            [cmmView release];
            
            break;
        }
        case 2:      //修改订单
        {
            UpdateOrderViewController *uoVctr = [[UpdateOrderViewController alloc]init];
            uoVctr.isEmploy = NO;
            uoVctr.order    = [cell.order copy];
            [nav pushViewController:uoVctr animated:YES];
            [uoVctr release];
            break;
        }
        case 3:      //结算审批
        {
            OrderFinishViewController *ofVctr = [[OrderFinishViewController alloc]init];
            ofVctr.order = cell.order;
            [nav pushViewController:ofVctr animated:YES];
            [ofVctr release];
            break;
        }
        default:
            break;
    }
}
@end
