page 53006 "TFB APIV2 - Price History"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Price Tracking Entry';
    EntitySetCaption = 'Price Tracking Entries';
    DelayedInsert = true;
    EntityName = 'priceTrackingEntry';
    EntitySetName = 'priceTrackingEntries';
    ODataKeyFields = "Price Type", Dated;

    PageType = API;
    SourceTable = "TFB Price History Buffer";

    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    APIPublisher = 'tfb';
    APIGroup = 'inreach';
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

    trigger OnFindRecord(Which: Text): Boolean
    var
        RelatedItemIdFilter: Text;
        RelatedCustomerIdFilter: Text;
        FilterView: Text;
    begin
        RelatedItemIdFilter := Rec.GetFilter("Item ID");
        RelatedCustomerIdFilter := Rec.GetFilter("Customer ID");

        if (RelatedItemIdFilter = '') and (RelatedCustomerIdFilter = '') then begin
            Rec.FilterGroup(4);
            RelatedItemIdFilter := Rec.GetFilter("Item ID");
            RelatedCustomerIdFilter := Rec.GetFilter("Customer ID");
            Rec.FilterGroup(0);
            if (RelatedItemIdFilter = '') and (RelatedCustomerIdFilter = '') then
                Error(FiltersNotSpecifiedErrorLbl);
        end;
        if RecordsLoaded then
            exit(true);
        FilterView := Rec.GetView();
        Rec.LoadDataFromFilters(RelatedItemIdFilter, RelatedCustomerIdFilter);
        Rec.SetView(FilterView);
        if not Rec.FindFirst() then
            exit(false);
        RecordsLoaded := true;
        exit(true);
    end;

    var
        RecordsLoaded: Boolean;
        FiltersNotSpecifiedErrorLbl: Label 'id type not specified.';
}
