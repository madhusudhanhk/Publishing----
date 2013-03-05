

typedef enum
{
    ePBTableViewOrientationVertical = 0,
    ePBTableViewOrientationHorizontal
} PBTableViewOrientation;


@interface PBOrientedTableView : UITableView <UITableViewDataSource>
{

@private
    id<UITableViewDataSource> _orientedTableViewDataSource;
    PBTableViewOrientation _tableViewOrientation;
}

@property (nonatomic, assign) PBTableViewOrientation tableViewOrientation;
@property (nonatomic, assign) id<UITableViewDataSource> orientedTableViewDataSource;

@end
