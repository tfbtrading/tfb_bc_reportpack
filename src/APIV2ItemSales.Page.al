page 53019 "TFB Item Sales Analysis"
{
    PageType = API;
    Caption = 'Item';
    APIPublisher = 'tfbtrading';
    APIGroup = 'priceAnalytics';
    APIVersion = 'v2.0';
    EntityName = 'itemSalesEntry';
    EntitySetName = 'itemSalesEntries';
    SourceTable = "Item Ledger Entry";
    DelayedInsert = true;
    Editable = false;
    DataAccessIntent = ReadOnly;
    SourceTableView = where("Entry Type" = const(Sale));
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
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(positive; Rec.Positive)
                {
                    Caption = 'Positive';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }


            }
        }
    }
}