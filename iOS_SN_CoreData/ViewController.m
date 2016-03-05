//
//  ViewController.m
//  iOS_SN_CoreData
//
//  Created by TRACEBoard on 16/3/2.
//  Copyright © 2016年 zzq. All rights reserved.
//

#import "ViewController.h"
#import "SNCoreDataH.h"
#import "CoreTest.h"


@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>

@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)NSMutableArray *dataList;
//查询结果
@property (nonatomic,strong)NSFetchedResultsController *queryData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataList = [[NSMutableArray alloc] init];
    [self.queryData performFetch:NULL];
    self.dataList = self.queryData.fetchedObjects.mutableCopy;

    [self creatView];

}

- (void)creatView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 400)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
  
}

/**
 *  CoreData查询结果
 *
 */
- (NSFetchedResultsController *)queryData
{
    if (!_queryData) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"CoreTest"];
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:NO];
        request.sortDescriptors = @[sort];
        _queryData = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[SNCoreDataH shareCoreDataDBHelper].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _queryData.delegate = self;
        
    }
    return _queryData;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.queryData sections] count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if ([[self.queryData sections] count] > 0) {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.queryData sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    } else
        return 0;
}



//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return self.dataList.count;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *inde = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inde];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:inde];
        
    }
    
    CoreTest *CoreModal = self.dataList[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@",CoreModal.age];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"LSN%@",CoreModal.name];
    
    return cell;
    
}


#pragma mark - 查询结果控制器代理方法
/**
 *  CoreData数据改变
 *
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    self.dataList = self.queryData.fetchedObjects.mutableCopy;
    NSLog(@"%@",self.dataList);
    [self.tableView endUpdates];
}


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}



//增加
- (IBAction)addAction:(id)sender {
    
   NSInteger num = arc4random_uniform(100);
    
    NSDictionary *dic = @{
                          @"age":@(num),
                          @"name":@"zhang"
                          };
    
    [[SNCoreDataH shareCoreDataDBHelper] insertDataWithModelName:@"CoreTest" setAttributWithDic:dic];
    
}


//删除
- (IBAction)removeAction:(id)sender {
    
    NSString *str = @"age < '50'";
    
    [[SNCoreDataH shareCoreDataDBHelper] deleteDataWithModelName:@"CoreTest" predicateString:str];
    
}

//更新
- (IBAction)changeAction:(id)sender {
    
    NSDictionary *dic = @{
                          @"age":@(11),
                          @"name":@"zhang"
                          };
    
    NSString *str = @"name CONTAINS 'zha'";
    
    [[SNCoreDataH shareCoreDataDBHelper] updateDataWithModelName:@"CoreTest" predicateString:str setAttributWithDic:dic];
    
}


//查询
- (IBAction)queryAction:(id)sender {
    
    NSString *str = @"age > '50'";

    
    NSArray *arr = [[SNCoreDataH shareCoreDataDBHelper] selectDataWithModelName:@"CoreTest" predicateString:str sort:nil ascending:nil];
    
    
    self.dataList = [NSMutableArray arrayWithArray:arr];
    
    
    [self.tableView reloadData];
    
    NSLog(@"%@",arr);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
