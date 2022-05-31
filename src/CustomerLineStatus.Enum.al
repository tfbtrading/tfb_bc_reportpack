enum 53003 "TFB Customer Line Status"
{
    Extensible = true;
    Caption = 'Customer Line Status';

    value(0; " ")
    {
        Caption = 'NotAvailable';
    }
    value(1; "OnOrder")
    {
        Caption = 'OnOrder';
    }
    value(2; "Dispatched")
    {
        Caption = 'Dispatched';
    }
    value(3; "ReceiptAssumed")
    {
        Caption = 'DeliveryAssumed';
    }
    value(4; "ReceiptConfirmed")
    {
        Caption = 'DeliveryConfirmed';
    }
    value(5;"OnQuote")
    {
        Caption = 'OnQuote';
    }
}