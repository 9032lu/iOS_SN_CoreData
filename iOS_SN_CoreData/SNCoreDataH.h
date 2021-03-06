//
//  TBCoreDataH.h
//  iSchool
//
//  Created by mac on 15/11/2.
//  Copyright © 2015年 iiSchool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// 本地文件存储的路径
#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/sqliteTest.db"]

#define MODEL_NAME @"CoreDataTest"

@interface SNCoreDataH : NSObject
{
    // 1.数据模型对象
    NSManagedObjectModel *_managedObjectModel;
    
    // 2.创建本地持久文件对象
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    
    // 3.管理数据对象
    NSManagedObjectContext *_managedObjectContext;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


// 设计成单例模式
+ (SNCoreDataH *)shareCoreDataDBHelper;

// 添加数据的方法
- (BOOL)insertDataWithModelName:(NSString *)modelName
             setAttributWithDic:(NSDictionary *)params;

// 查看
/*
 modelName           :实体对象类的名字
 predicateString     :谓词条件
 identifers          :排序字段集合
 ascending           :是否升序
 */
- (NSArray *)selectDataWithModelName:(NSString *)modelName
                     predicateString:(NSString *)predicateString
                                sort:(NSArray *)identifers
                           ascending:(BOOL)ascending;

// 修改
- (BOOL)updateDataWithModelName:(NSString *)modelName
                predicateString:(NSString *)predicateString
             setAttributWithDic:(NSDictionary *)params;

// 删除
- (BOOL)deleteDataWithModelName:(NSString *)modelName
                predicateString:(NSString *)predicateString;


@end
