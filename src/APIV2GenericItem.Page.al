page 53016 "TFB Generic Item Analysis"
{
    PageType = API;
    Caption = 'Item';
    APIPublisher = 'tfbtrading';
    APIGroup = 'priceAnalytics';
    APIVersion = 'v2.0';
    EntityName = 'genericItem';
    EntitySetName = 'genericItems';
    SourceTable = "TFB Generic Item";
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

                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(alternativeNames; Rec."Alternative Names")
                {
                    Caption = 'Alternative Names';
                }
                field(externalID; Rec."External ID")
                {
                    Caption = 'External ID';
                }
                field(itemCategoryId; Rec."Item Category Id")
                {
                    Caption = 'Item Category Id';
                }
                field(itemCategoryCode; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }

                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
            }
        }
    }
}