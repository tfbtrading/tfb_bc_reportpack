page 53018 "TFB Item Category Analysis"
{
    PageType = API;
    Caption = 'Item';
    APIPublisher = 'tfbtrading';
    APIGroup = 'priceAnalytics';
    APIVersion = 'v2.0';
    EntityName = 'itemCategory';
    EntitySetName = 'itemCategories';
    SourceTable = "Item Category";
    DelayedInsert = true;
    Editable = false;
    DataAccessIntent = ReadOnly;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(hasChildren; Rec."Has Children")
                {
                    Caption = 'Has Children';
                }
                field(indentation; Rec.Indentation)
                {
                    Caption = 'Indentation';
                }
                field(parentCategory; Rec."Parent Category")
                {
                    Caption = 'Parent Category';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }

            }
        }
    }
}