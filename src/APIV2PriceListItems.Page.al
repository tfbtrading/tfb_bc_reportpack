page 53002 "TFB APIV2 - Price List Items"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Price List Item';
    EntitySetCaption = 'Price List Items';
    DelayedInsert = true;
    EntityName = 'priceListItem';
    EntitySetName = 'priceListItems';
    ODataKeyFields = ItemID;

    PageType = API;
    SourceTable = "TFB Price List Item Buffer";
    SourceTableTemporary = true;
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
                field(id; Rec.ItemID)
                {
                    Caption = 'Id';

                }
                field(customerID; Rec.CustomerID)
                {
                    Caption = 'CustomerId';
                }
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(displayName; Rec.Description)
                {
                    Caption = 'DisplayName';
                }
                field(netWeight; Rec."Net Weight")
                {
                    Caption = 'Net Weight';
                }

                field(alternativeNames; Rec."Alternative Names")
                {
                    Caption = 'Alternative Names';
                }

                field(itemCategoryId; Rec."Item Category Id")
                {
                    Caption = 'Item Category Id';
                }
                field(itemCategoryCode; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }

                field(unitPrice; Rec.UnitPrice)
                {
                    Caption = 'Unit Price';

                }

                field(kgPrice; Rec.KgPrice)
                {
                    Caption = 'Kg Price';
                }
                field(noDaysFromPriceChange; rec.DaysSincePriceChange)
                {
                    Caption = 'No. Days since price changes';
                }

                field(oldUnitPrice; Rec.OldUnitPrice)
                {
                    Caption = 'Old Unit Price';
                }
                field(oldKgPrice; Rec.OldKgPrice)
                {
                    Caption = 'Old Kg Price';
                }
                field(lastPricePaid; Rec.LastPricePaid)
                {
                    Caption = 'Last Price Paid';
                }
                field(availabilityStatus; Rec.AvailabilityStatus)
                {
                    Caption = 'Availability Status';

                }
                field(nextAvailable; Rec.NextAvailable)
                {
                    Caption = 'Next Availability Date';
                }
                field(qtyPerPallet; Rec.PerPallet)
                {
                    Caption = 'Quantity Per Pallet';
                }
                field(dateLastDispatched; Rec.DateLastDispatched)
                {
                    Caption = 'Date Last Dispatched';
                }


                field(qtyOutstanding; Rec.QtyPendingDelivery)
                {
                    Caption = 'Qty Outstanding';
                }
                field(favourateItem; Rec.FavouritedItem)
                {
                    Caption = 'Favourate Item';
                }

                field(unitOfMeasureId; Rec."Unit of Measure Id")
                {
                    Caption = 'Base Unit Of Measure Id';
                }
                field(baseUnitOfMeasureCode; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit Of Measure Code';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(vendorId; Rec."Vendor Id")
                {
                    Caption = 'Vendor Id';
                }
                field(countryOfOriginISO2; Rec."Country/Region of Origin Code")
                {

                }
                field(deliverySLA; Rec.DeliverySLA)
                {

                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                    Editable = false;
                }
                part(baseUnitOfMeasure; "APIV2 - Units of Measure")
                {
                    Caption = 'Unit Of Measure';
                    Multiplicity = ZeroOrOne;
                    EntityName = 'unitOfMeasure';
                    EntitySetName = 'unitsOfMeasure';
                    SubPageLink = SystemId = Field("Unit of Measure Id");
                }
                part(vendor; "APIV2 - Vendors")
                {
                    Caption = 'Vendor';
                    Multiplicity = ZeroOrOne;
                    EntityName = 'vendor';
                    EntitySetName = 'vendors';
                    SubPageLink = SystemId = Field("Vendor Id");
                }
                part(picture; "APIV2 - Pictures")
                {
                    Caption = 'Picture';
                    Multiplicity = ZeroOrOne;
                    EntityName = 'picture';
                    EntitySetName = 'pictures';
                    SubPageLink = Id = Field(ItemID), "Parent Type" = const(2);
                }

            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        RelatedIdFilter: Text;

        FilterView: Text;
    begin
        RelatedIdFilter := Rec.GetFilter(CustomerID);
        // RelatedTypeFilter := Rec.GetFilter("Related Type");
        if RelatedIdFilter = '' then begin
            Rec.FilterGroup(4);
            RelatedIdFilter := Rec.GetFilter(CustomerID);
            Rec.FilterGroup(0);
            if (RelatedIdFilter = '') then
                Error(FiltersNotSpecifiedErrorLbl);
        end;
        if RecordsLoaded then
            exit(true);
        FilterView := Rec.GetView();
        Rec.LoadDataFromFilters(RelatedIdFilter, Today);
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