pageextension 53020 "TFB RP Customer List" extends "Customer List"
{
    layout
    {

    }

    actions
    {
        addafter(PaymentRegistration)
        {
            action(TFBShowPriceHistory)
            {
                Caption = 'Show Price History';
                Promoted = true;
                PromotedCategory = Process;
                Image = Price;
                ApplicationArea = All;

                ToolTip = 'Shows price history for a specific customer and item';

                trigger OnAction()

                var

                    PriceHistoryBuffer: Record "TFB Price History Buffer";
            
                    Item: Record Item;
                    ItemList: Page "Item List";
                  

                begin
                    ItemList.LookupMode := true;
                    If not (ItemList.RunModal() = Action::LookupOK) then exit;
                    ItemList.GetRecord(Item);
                    PriceHistoryBuffer.LoadDataFromFilters(Item.SystemId, Rec.SystemId);
                    Page.Run(Page::"TFB Customer Price History", PriceHistoryBuffer);

                end;

            }
            action(TFBSendPriceList)
            {
                Caption = 'Send Price List';

                Promoted = true;
                PromotedCategory = Process;
                Image = Price;
                ApplicationArea = All;

                ToolTip = 'Sends a full price list to a specific customer';


                trigger OnAction()

                var
                    ReportPackCU: CodeUnit "TFB Report Pack Mgmt";
                    Duration: DateFormula;
                    DateSel: Date;

                begin

                    Evaluate(Duration, '-3M');
                    case Dialog.StrMenu('Working Date,Start of this month,Start of next month', 1, 'Choose effective date for price list') of
                        1:
                            DateSel := WorkDate();
                        2:
                            DateSel := calcDate('<-D1>', Today());
                        3:
                            DateSel := calcDate('<D1>', Today());
                    end;
                    evaluate(Duration, '-6M');
                    ReportPackCU.SendOneCustomerPriceList(Rec."No.", 'Price List - as of today', DateSel, Duration);
                end;
            }

            action(TFBAllPriceLists)
            {
                Caption = 'Send All Price Lists';
                Image = Price;
                ApplicationArea = All;

                ToolTip = 'Sends a full price list to all customers';


                trigger OnAction()

                var
                    Customer: Record Customer;
                    SendCustomerPriceLists: CodeUnit "TFB Send Customer Price Lists";

                begin

                    CurrPage.SetSelectionFilter(Customer);
                    If Customer.Count() > 1 then begin
                        SendCustomerPriceLists.Setup(true);
                        SendCustomerPriceLists.SelectCustomers(Customer);
                    end
                    else
                        SendCustomerPriceLists.Setup(false);
                    SendCustomerPriceLists.Run();
                end;
            }
        }
    }
}