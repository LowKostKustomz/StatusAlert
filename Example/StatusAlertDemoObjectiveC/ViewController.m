//
//  StatusAlert
//  Copyright © 2018 LowKostKustomz. All rights reserved.
//

#import "ViewController.h"
@import StatusAlert;

@interface TableViewCellModel : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, copy, nonnull) void (^action)(void);

@end

@implementation TableViewCellModel

@end

@interface Section : NSObject

@property (nonatomic, strong) NSString* header;
@property (nonatomic, strong) NSArray<TableViewCellModel*>* models;
@property (nonatomic, strong) NSString* footer;

@end

@implementation Section

@end

@interface ViewController ()

@property (nonatomic, weak) UITableView* tableView;

@end

@implementation ViewController
{
    NSArray<Section*>* sections;
    NSString* cellReuseIdentifier;
    StatusAlertVerticalPosition preferredVerticalPosition;
    BOOL isPickable;
}

- (instancetype)instantiate {
    ViewController* controller = [[ViewController alloc] init];
    controller.title = @"StatusAlert";
    return controller;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    cellReuseIdentifier = @"reuseIdentifier";
    preferredVerticalPosition = StatusAlertVerticalPositionCenter;
    isPickable = true;
    
    [self setupNavigationItems];
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                          style:UITableViewStyleGrouped];
    self.tableView = tableView;
    [self.view addSubview:self.tableView];
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor] setActive:YES];
    [[self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:YES];
    [[self.tableView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:YES];
    [[self.tableView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifier];
    
    __weak ViewController* weakSelf = self;
    
    TableViewCellModel* imageTitleMessage = [[TableViewCellModel alloc] init];
    imageTitleMessage.title = @"With image, title and message";
    imageTitleMessage.action = ^{
        [weakSelf showStatusAlertWithImageNamed:@"Success image"
                                          title:@"StatusAlert"
                                        message:@"With image, title and message"];
    };
    
    TableViewCellModel* imageTitle = [[TableViewCellModel alloc] init];
    imageTitle.title = @"With image and title only";
    imageTitle.action = ^{
        [weakSelf showStatusAlertWithImageNamed:@"Success image"
                                          title:@"StatusAlert with image and title"
                                        message:NULL];
    };
    
    TableViewCellModel* imageMessage = [[TableViewCellModel alloc] init];
    imageMessage.title = @"With image and message only";
    imageMessage.action = ^{
        [weakSelf showStatusAlertWithImageNamed:@"Success image"
                                          title:NULL
                                        message:@"StatusAlert with image and message"];
    };
    
    TableViewCellModel* titleMessage = [[TableViewCellModel alloc] init];
    titleMessage.title = @"With title and message only";
    titleMessage.action = ^{
        [weakSelf showStatusAlertWithImageNamed:NULL
                                          title:@"StatusAlert"
                                        message:@"With title and message"];
    };
    
    TableViewCellModel* image = [[TableViewCellModel alloc] init];
    image.title = @"Only with image";
    image.action = ^{
        [weakSelf showStatusAlertWithImageNamed:@"Success image"
                                          title:NULL
                                        message:NULL];
    };
    
    TableViewCellModel* title = [[TableViewCellModel alloc] init];
    title.title = @"Only with title";
    title.action = ^{
        [weakSelf showStatusAlertWithImageNamed:NULL
                                          title:@"StatusAlert with title"
                                        message:NULL];
    };
    
    TableViewCellModel* message = [[TableViewCellModel alloc] init];
    message.title = @"Only with message";
    message.action = ^{
        [weakSelf showStatusAlertWithImageNamed:NULL
                                          title:NULL
                                        message:@"StatusAlert with message"];
    };
    
    NSArray<TableViewCellModel*>* differentContentSectionModels = @[imageTitleMessage,
                                                                    imageTitle,
                                                                    imageMessage,
                                                                    titleMessage,
                                                                    image,
                                                                    title,
                                                                    message];
    
    Section* differentContentSection = [[Section alloc] init];
    differentContentSection.header = @"Different content";
    differentContentSection.models = differentContentSectionModels;
    differentContentSection.footer = @"See these to find out how many opportunities to use StatusAlert there is.\nYou can also try different modes with navigation bar buttons";
    
    TableViewCellModel* fromAppleMusic = [[TableViewCellModel alloc] init];
    fromAppleMusic.title = @"From the Apple Music app";
    fromAppleMusic.action = ^{
        [weakSelf showStatusAlertWithImageNamed:@"Loved icon"
                                          title:@"Loved"
                                        message:@"We’ll recommend more like this in For You."];
    };

    TableViewCellModel* fromPodcasts = [[TableViewCellModel alloc] init];
    fromPodcasts.title = @"From the Podcasts app";
    fromPodcasts.action = ^{
        [weakSelf showStatusAlertWithImageNamed:@"Success icon"
                                          title:@"С подпиской"
                                        message:NULL];
    };
    
    TableViewCellModel* fromNews = [[TableViewCellModel alloc] init];
    fromNews.title = @"From the News app";
    fromNews.action = ^{
        [weakSelf showStatusAlertWithImageNamed:@"Loved icon"
                                          title:@"Loved"
                                        message:@"We’ll show more stories about this in For You."];
    };
    
    NSArray<TableViewCellModel*>* fromAppsSectionModels = @[fromAppleMusic,
                                                            fromPodcasts,
                                                            fromNews];
    
    Section* fromAppsSection = [[Section alloc] init];
    fromAppsSection.header = @"From the Apple apps";
    fromAppsSection.models = fromAppsSectionModels;
    fromAppsSection.footer = @"See these to be sure that everything looks similar to the Apple apps";
    
    sections = @[differentContentSection,
                 fromAppsSection];
    
    tableView.dataSource = self;
    tableView.delegate = self;
}

- (void)showStatusAlertWithImageNamed:(NSString*)imageName title:(NSString*)title message:(NSString*)message {
    StatusAlert* statusAlert = [[StatusAlert alloc] init];
    [statusAlert setImage: [UIImage imageNamed:imageName]];
    [statusAlert setTitle:title];
    [statusAlert setMessage:message];
    [statusAlert setCanBePickedOrDismissed:isPickable];
    
    if (title) {
        if (message) {
            statusAlert.accessibilityAnnouncement = [[title stringByAppendingString:@", "] stringByAppendingString:message];
        } else {
            statusAlert.accessibilityAnnouncement = title;
        }
    } else if (message) {
        statusAlert.accessibilityAnnouncement = message;
    }
    
    [statusAlert showInView:self.view withVerticalPosition:preferredVerticalPosition];
}

- (void)setupNavigationItems {
    NSString* verticalPositionTitle;
    switch (preferredVerticalPosition) {
        case StatusAlertVerticalPositionTop:
            verticalPositionTitle = @"Top";
            break;
        case StatusAlertVerticalPositionCenter:
            verticalPositionTitle = @"Center";
            break;
        case StatusAlertVerticalPositionBottom:
            verticalPositionTitle = @"Bottom";
            break;
    }
    UIBarButtonItem* verticalPositionItem = [[UIBarButtonItem alloc] initWithTitle:verticalPositionTitle
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(selectVerticalPosition)];

    NSString* presentationsBehaviorTitle;
    switch (StatusAlert.multiplePresentationsBehavior) {
        case StatusAlertMultiplePresentationsBehaviorIgnoreIfAlreadyPresenting:
            presentationsBehaviorTitle = @"Only one";
            break;
        case StatusAlertMultiplePresentationsBehaviorDismissCurrentlyPresented:
            presentationsBehaviorTitle = @"Dismiss current";
            break;
        case StatusAlertMultiplePresentationsBehaviorShowMultiple:
            presentationsBehaviorTitle = @"Display all";
            break;
    }
    UIBarButtonItem* multiplePresentationsItem = [[UIBarButtonItem alloc] initWithTitle:presentationsBehaviorTitle
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(selectPresentationsBehavior)];
    
    [self.navigationItem setLeftBarButtonItems:@[verticalPositionItem, multiplePresentationsItem]];
    
    NSString* rightTitle;
    if (isPickable) {
        rightTitle = @"Pickable";
    } else {
        rightTitle = @"Not pickable";
    }
    
    [self.navigationItem setRightBarButtonItems:@[[[UIBarButtonItem alloc] initWithTitle:rightTitle
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(selectPickable)]]];
}

- (void)selectVerticalPosition {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:@"Pickable"
                                                                         message:@"If the StatusAlert can be picked or dismissed by tap"
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    __weak ViewController* weakSelf = self;
    UIAlertAction* topAction = [UIAlertAction actionWithTitle:@"Top"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          self->preferredVerticalPosition = StatusAlertVerticalPositionTop;
                                                          [weakSelf setupNavigationItems];
                                                      }];
    UIAlertAction* centerAction = [UIAlertAction actionWithTitle:@"Center"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             self->preferredVerticalPosition = StatusAlertVerticalPositionCenter;
                                                             [weakSelf setupNavigationItems];
                                                         }];
    UIAlertAction* bottomAction = [UIAlertAction actionWithTitle:@"Bottom"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             self->preferredVerticalPosition = StatusAlertVerticalPositionBottom;
                                                             [weakSelf setupNavigationItems];
                                                         }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];
    
    [actionSheet addAction:topAction];
    [actionSheet addAction:centerAction];
    [actionSheet addAction:bottomAction];
    [actionSheet addAction:cancelAction];
    
    [actionSheet.popoverPresentationController setBarButtonItem:self.navigationItem.leftBarButtonItems.firstObject];
    [self presentViewController:actionSheet
                       animated:YES
                     completion:NULL];
}

- (void)selectPresentationsBehavior {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:@"Pickable"
                                                                         message:@"If the StatusAlert can be picked or dismissed by tap"
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    __weak ViewController* weakSelf = self;
    UIAlertAction* topAction = [UIAlertAction actionWithTitle:@"Only one"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          StatusAlert.multiplePresentationsBehavior = StatusAlertMultiplePresentationsBehaviorIgnoreIfAlreadyPresenting;
                                                          [weakSelf setupNavigationItems];
                                                      }];
    UIAlertAction* centerAction = [UIAlertAction actionWithTitle:@"Dismiss current"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             StatusAlert.multiplePresentationsBehavior = StatusAlertMultiplePresentationsBehaviorDismissCurrentlyPresented;
                                                             [weakSelf setupNavigationItems];
                                                         }];
    UIAlertAction* bottomAction = [UIAlertAction actionWithTitle:@"Display all"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             StatusAlert.multiplePresentationsBehavior = StatusAlertMultiplePresentationsBehaviorShowMultiple;
                                                             [weakSelf setupNavigationItems];
                                                         }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];

    [actionSheet addAction:topAction];
    [actionSheet addAction:centerAction];
    [actionSheet addAction:bottomAction];
    [actionSheet addAction:cancelAction];

    [actionSheet.popoverPresentationController setBarButtonItem:self.navigationItem.leftBarButtonItems.firstObject];
    [self presentViewController:actionSheet
                       animated:YES
                     completion:NULL];
}

- (void)selectPickable {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:@"Pickable"
                                                                         message:@"If the StatusAlert can be picked or dismissed by tap"
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    __weak ViewController* weakSelf = self;
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                          self->isPickable = true;
                                                          [weakSelf setupNavigationItems];
                                                      }];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         self->isPickable = false;
                                                         [weakSelf setupNavigationItems];
                                                     }];
    
    [actionSheet addAction:yesAction];
    [actionSheet addAction:noAction];
    
    [actionSheet.popoverPresentationController setBarButtonItem:self.navigationItem.rightBarButtonItems.firstObject];
    [self presentViewController:actionSheet
                       animated:YES
                     completion:NULL];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[sections objectAtIndex:indexPath.section].models objectAtIndex:indexPath.row].action();
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

#pragma mark UITableViewDataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier
                                                            forIndexPath:indexPath];
    NSString* title = [[sections objectAtIndex:indexPath.section].models objectAtIndex:indexPath.row].title;
    [cell.textLabel setText:title];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [sections count];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[sections objectAtIndex:section].models count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [sections objectAtIndex:section].header;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [sections objectAtIndex:section].footer;
}

@end
