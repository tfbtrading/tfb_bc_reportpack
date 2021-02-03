pageextension 53020 "TFB RP Customer List" extends "Customer List"
{
    layout
    {

    }

    actions
    {
        addafter(PaymentRegistration)
        {
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
        }
    }
}