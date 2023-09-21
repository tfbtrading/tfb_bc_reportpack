page 53015 "TFB Item Analysis"
{
    PageType = API;
    Caption = 'Item';
    APIPublisher = 'tfbtrading';
    APIGroup = 'priceAnalytics';
    APIVersion = 'v2.0';
    EntityName = 'item';
    EntitySetName = 'items';
    SourceTable = Item;
    DelayedInsert = true;
    Editable = false;
    DataAccessIntent = ReadOnly;
    SourceTableView = where(Type = const(Inventory));
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

                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(genericItemID; Rec."TFB Generic Item ID")
                {
                    Caption = 'Parent Generic Item Guid';
                }
                field(actAsGeneric; Rec."TFB Act As Generic")
                {
                    Caption = 'Act as Generic Item';
                }
                field(itemCategoryId; Rec."Item Category Id")
                {
                    Caption = 'Item Category Id';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
                field(blockReason; Rec."Block Reason")
                {
                    Caption = 'Block Reason';
                }
                field(netWeight; Rec."Net Weight")
                {
                    Caption = 'Net Weight';
                }
                field(baseUnitOfMeasure; Rec."Base Unit of Measure")
                {
                    Caption = 'Unit of Measure ID';
                }
                field(purchasingBlocked; Rec."Purchasing Blocked")
                {
                    Caption = 'Purchasing Blocked';
                }
                field(salesBlocked; Rec."Sales Blocked")
                {
                    Caption = 'Sales Blocked';
                }
                field(publishingBlock; Rec."TFB Publishing Block")
                {
                    Caption = 'Do Not Publish';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'System Modified At';
                }
            }
        }
    }
}