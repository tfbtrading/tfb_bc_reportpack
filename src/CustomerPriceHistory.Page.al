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
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Type field.';
                }
                field(effectiveFromOrOn; Rec.Dated)
                {
                    Caption = 'Dated';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Dated field.';
                }
                field(priceSourceNo; Rec."Price Source No.")
                {
                    Caption = 'Price Source No';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Source No field.';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Price Per Unit';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Per Unit field.';
                }
                field(pricePerKg; Rec."Price Per Kg")
                {
                    Caption = 'Price Per Kg';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Per Kg field.';
                }
                field(customerPriceGroup; Rec."Customer Price Group")
                {
                    Caption = 'Pricing Group Code';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pricing Group Code field.';
                }
            }
        }
    }



}
