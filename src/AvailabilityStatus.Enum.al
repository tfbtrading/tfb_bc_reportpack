enum 53000 "TFB Availability Status"
{
    Extensible = true;

    value(0; Okay)
    {
    }
    value(10; Low)
    {

    }
    value(20; Restricted)
    {

    }
    value(30; OutofStock)
    {
        Caption = 'Out of Stock';
    }
}