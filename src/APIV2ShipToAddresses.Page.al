page 53010 "TFB APIV2 - ShipTo Addresses"
{
    APIVersion = 'v2.0';
    EntityCaption = 'ShipTo Address';
    EntitySetCaption = 'ShipTo Addresses';
    DelayedInsert = true;
    EntityName = 'shipToAddress';
    EntitySetName = 'shipToAddresses';
    ODataKeyFields = "ShipTo AddressId";
    APIPublisher = 'tfb';
    APIGroup = 'inreach';
    PageType = API;
    SourceTable = "TFB Ship-to Address Buffer";
    SourceTableTemporary = true;
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
                field(addressId; Rec."ShipTo AddressId")
                {
                    Caption = 'Contact Id';
                }
                field(standard; Rec."Standard Address")
                {
                    Caption = 'Contact No.';
                }
                field(default; Rec."Default Address")
                {
                    Caption = 'Contact Name';
                }
                field(code; Rec.Code)
                {
                    Caption = 'Contact Type';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Related Id';
                }
                field(contact;Rec.Contact)
                {
                    Caption = 'Contact';
                }
                field(addressLine1; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(addressLine2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(state; Rec.County)
                {
                    Caption = 'State';
                }
                field(country; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(postCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }


            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        RelatedIdFilter: Text;
        FilterView: Text;
    begin
        RelatedIdFilter := Rec.GetFilter("Related Id");

        if RelatedIdFilter = '' then begin
            Rec.FilterGroup(4);
            RelatedIdFilter := Rec.GetFilter("Related Id");
            Rec.FilterGroup(0);
            if (RelatedIdFilter = '') then
                Error(FiltersNotSpecifiedErrorLbl);
        end;
        if RecordsLoaded then
            exit(true);
        FilterView := Rec.GetView();
        Rec.LoadDataFromFilters(RelatedIdFilter);
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