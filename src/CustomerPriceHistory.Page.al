page 53007 "TFB Customer Price History"
{

    PageType = List;
    SourceTable = "TFB Price History Buffer";
    Caption = 'Customer Price History';

    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {


                field(priceType; Rec."Price Type")
                {
                    Caption = 'Price Type';
                }
                field(effectiveFromOrOn; Rec.Dated)
                {
                    Caption = 'Dated';
                }
                field(priceSourceNo; Rec."Price Source No.")
                {
                    Caption = 'Price Source No';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Price Per Unit';
                }
                field(pricePerKg; Rec."Price Per Kg")
                {
                    Caption = 'Price Per Kg';
                }
                field(customerPriceGroup; Rec."Customer Price Group")
                {
                    Caption = 'Pricing Group Code';
                }
            }
        }
    }



}
