page 53017 "TFB Sales Price Analysis"
{
    PageType = API;
    Caption = 'Item';
    APIPublisher = 'tfbtrading';
    APIGroup = 'priceAnalytics';
    APIVersion = 'v2.0';
    EntityName = 'salesprice';
    EntitySetName = 'salesprices';
    SourceTable = "Price List Line";
    DelayedInsert = true;
    Editable = false;
    DataAccessIntent = ReadOnly;
    SourceTableView = where("Asset Type" = const(Item), "Amount Type" = const(Price), "Price Type" = const(Sale), "Source Type" = const("Customer Price Group"));
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
                field(assignToNo; Rec."Assign-to No.")
                {
                    Caption = 'Assign-to No.';
                }

                field(assetID; Rec."Asset ID")
                {
                    Caption = 'Asset ID';
                }
                field(assetNo; Rec."Asset No.")
                {
                    Caption = 'Product No. (custom)';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(startingDate; Rec."Starting Date")
                {
                    Caption = 'Starting Date';
                }
                field(endingDate; Rec."Ending Date")
                {
                    Caption = 'Ending Date';
                }

                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code (custom)';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(systemModifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'SystemModifiedAt';
                }
            }
        }
    }
}