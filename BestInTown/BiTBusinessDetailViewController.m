//
//  BiTBusinessDetailViewController.m
//  BestInTown
//
//  Created by Justin Marrington on 15/04/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "BiTBusinessDetailViewController.h"
#import "BiTCategory.h"
#import "UIImageView+AFNetworking.h"
#import "BiTYelpWebViewControllerViewController.h"
#import "BiTTodo.h"

@interface BiTBusinessDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *businessPhoto;
@property (weak, nonatomic) IBOutlet UILabel *businessNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *yelpRatingImage;
@property (weak, nonatomic) IBOutlet UIButton *todoButton;

@end

@implementation BiTBusinessDetailViewController
@synthesize businessPhoto = _businessPhoto;
@synthesize businessNameLabel = _businessNameLabel;
@synthesize yelpRatingImage = _yelpRatingImage;
@synthesize todoButton = _todoButton;
@synthesize business = _business;

- (void)setBusiness:(BiTBusiness *)business {
    if(business != _business) {
        _business = business;
        NSLog(@"%@", business);
        [self.tableView reloadData];
        self.title = business.businessName;
        self.businessNameLabel.text = business.businessName;
        [self.businessPhoto setImageWithURL:business.imageUrl];
    }
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setBusinessPhoto:nil];
    [self setYelpRatingImage:nil];
    [self setBusinessNameLabel:nil];
    [self setTodoButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Show Yelp Mobile"]) {
        
    }
}

#pragma mark Actions
- (IBAction)addTodoButtonTouched:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int userId = [(NSNumber *)[defaults objectForKey:@"userId"] intValue]; 
    
    [BiTTodo addTodoForBusiness:self.business.businessId user:userId onSuccess:^(BiTTodo *visit) {
        NSLog(@"Todo Added");
    } failure:^(NSError *error) {
        NSLog(@"Todo Failed %@", error);        
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // FIXME: Need as many sections as we need
    return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case kContactSectionIndex:
            return 2;
        case kReviewSectionIndex:
            return 2;
        case kOpeningTimesSectionIndex:
            return 1;
        case kCategoryRanksSectionIndex:
            return [self.business.categories count];
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case kCategoryRanksSectionIndex:
            return @"Rankings";
        case kContactSectionIndex:
            return @"Contact";
        case kReviewSectionIndex:
            return @"Reviews";
        case kOpeningTimesSectionIndex:
            return @"Opening Hours";
        default:
            return @"";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DetailCellIdentifier = @"Detail Cell";
    static NSString *ReviewCellIdentifier = @"Review Cell";
    static NSString *MoreReviewsCellIdentifier = @"More Reviews Cell";
    static NSString *OpeningsCellIdentifier = @"Opening Cell";
    static NSString *RankCellIdentifier = @"Rank Cell";
    UITableViewCell *cell;
    
    if (indexPath.section == kContactSectionIndex) {
        cell = [tableView dequeueReusableCellWithIdentifier:DetailCellIdentifier];
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Address";
            cell.detailTextLabel.text = self.business.address;
        } else {
            cell.textLabel.text = @"Phone";
            cell.detailTextLabel.text = self.business.phone;
        }
    } else if (indexPath.section == kReviewSectionIndex) {
        if(indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:ReviewCellIdentifier];
//            cell.textLabel.text = self.business.reviewSnippet;
            /*[cell.imageView setFrame:CGRectMake(10.0, 10.0, 24.0, 24.0)];
            [cell.imageView setImageWithURL:self.business.reviewUserImageUrl];*/
        } else if(indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:MoreReviewsCellIdentifier];
        }
    } else if (indexPath.section == kOpeningTimesSectionIndex) {
        cell = [tableView dequeueReusableCellWithIdentifier:OpeningsCellIdentifier];
    } else if (indexPath.section == kCategoryRanksSectionIndex) {
        cell = [tableView dequeueReusableCellWithIdentifier:RankCellIdentifier];
        
        BiTCategory *category = [self.business.categories objectAtIndex:indexPath.row];
        cell.textLabel.text =  [NSString stringWithFormat:@"#%d", category.rank];
        cell.detailTextLabel.text = category.categoryName;
    }
    return cell;
}

#define kDefaultCellHeight 43.0
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *labelText = @"";
    if (indexPath.section == kContactSectionIndex) {
        if (indexPath.row == 0) {
//            labelText = [self.business addressString];
        } else {
            return kDefaultCellHeight;
        }
    } else if (indexPath.section == kReviewSectionIndex) {
        if (indexPath.row == 0) {
//            labelText = self.business.reviewSnippet;
        } else {
            return kDefaultCellHeight;
        }
        
    } else {
        return kDefaultCellHeight;
    }
    
    return [self heightOfCellForLabelWithString:labelText andWidth:237.0];
}

- (CGFloat)heightOfCellForLabelWithString:(NSString *)string andWidth:(CGFloat)width
{
    CGSize constraint = CGSizeMake(width - (10.0 * 2), 20000.0f);
    
    CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:17.0] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + (10.0 * 2);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
