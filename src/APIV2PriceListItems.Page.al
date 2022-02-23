page 53002 "TFB APIV2 - Price List Items"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Price List Item';
    EntitySetCaption = 'Price List Items';
    DelayedInsert = true;
    EntityName = 'priceListItem';
    EntitySetName = 'priceListItems';
    ODataKeyFields = ItemID, "No.", "Item Category ID", "Vendor Id";
    DataAccessIntent = ReadOnly;

    PageType = API;
    SourceTable = "TFB Price List Item Buffer";
    SourceTableTemporary = true;
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    Editable = false;
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
                field(marketingCopy; Rec.MarketingCopy)
                {
                    Caption = 'Marketing Copy';
                }
                field(marketInsightType; Rec.MarketInsightType)
                {

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
                field(dateOfLastPriceChange; Rec.PriceChangeDate)
                {
                    Caption = 'Date of Last Price Change';
                }

                field(oldUnitPrice; Rec.OldUnitPrice)
                {
                    Caption = 'Old Unit Price';
                }
                field(oldKgPrice; Rec.OldKgPrice)
                {
                    Caption = 'Old Kg Price';
                }
                field(lastPaidKgPrice; Rec.LastPaidKgPrice)
                {
                    Caption = 'Last Paid Kg Price';
                }
                field(lastPaidUnitPrice; Rec.LastPaidUnitPrice)
                {
                    Caption = 'Last Paid Unit Price';
                }
                field(availabilityStatus; Rec.AvailabilityStatus)
                {
                    Caption = 'Availability Status';

                }
                field(availableToSellBaseQty; Rec.AvailableToSellBaseQty)
                {
                    Caption = 'Available To Sell Base Qty';
                }
                field(nextAvailable; Rec.NextAvailable)
                {
                    Caption = 'Next Availability Date';
                }
                field(lastReceiptDate; Rec.LastReceiptDate)
                {
                    Caption = 'Last Receipt Date';
                }
                field(lastReceiptQty; Rec.LastReceiptQty)
                {
                    Caption = 'Last Receipt Quantity';
                }
                field(lastReceiptQtySold; Rec.LastReceiptQtySold)
                {
                    Caption = 'Last Receipt Quantity Sold';
                }
                field(lastSaleTimeStamp; Rec.LastSaleDateTime)
                {
                    Caption = 'Last Sale TimeStamp';
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
                field(nextDeliveryQtyOutstanding; Rec.QtyOnNextDelivery)
                {
                    Caption = 'Qty On Next Delivery';
                }
                field(nextDeliveryPlannedShipmentDate; Rec.DatePlannedForNextDelivery)
                {
                    Caption = 'Next Delivery Planned Shipment Date';
                }
                field(nextDeliverySalesOrderID; Rec.NextDeliveryID)
                {
                    Caption = 'Next Delivery Sales Order ID';
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
                field(multiItemPalletOption; Rec.MultiItemPalletOption)
                {
                    Caption = 'Multi-Item pallet option';
                }
                field(maxItemsPerPallet; Rec.MaxProductsPerPallet)
                {
                    Caption = 'Max items per pallet';
                }
                field(qtyPerPalletLayer; Rec.QtyPerLayer)
                {
                    Caption = 'Qty per pallet layer';
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
                field(countryOfOriginName; CountryOfOriginName)
                {

                }
                field(deliverySLA; Rec.DeliverySLA)
                {

                }
                field(isEstimateAvailable; Rec.NoEstimateAvailable)
                {

                }
                field(deliveryInNoDaysMin; Rec.DeliveryInNoDaysMin)
                {

                }
                field(deliveryInNoDaysMax; Rec.DeliveryInNoDaysMax)
                {

                }
                field(transportCompany; ShippingAgentName)
                {

                }
                field(trackingAvailable; Rec.TrackingAvailable)
                {

                }
                field(imageCDN; ImageCDN)
                {

                }
                field(specificationCDN; Rec.SpecificationCDN)
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
                    SubPageLink = Id = Field(ItemID), "Parent Type" = const(Item);
                }
                part(priceTrackingEntry; "TFB APIV2 - Price History")
                {
                    Caption = 'Price History';
                    EntityName = 'priceTrackingEntry';
                    EntitySetName = 'priceTrackingEntries';
                    SubPageLink = "Item ID" = Field(ItemID), "Customer ID" = Field(CustomerID);
                }
                part(itemMarketSegment; "TFB APIV2 - Item Market Seg.")
                {
                    Caption = 'Price List Item Categories';
                    EntityName = 'itemMarketSegment';
                    EntitySetName = 'itemMarketSegments';
                    SubPageLink = "Item ID" = Field(ItemID);
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


    trigger OnAfterGetRecord()
    var


    begin

        ImageCDN := StrSubstNo(SalesSetup."TFB Image URL Pattern", Rec."No.");
        If CountryRegion.Get(Rec."Country/Region of Origin Code") then
            CountryOfOriginName := CountryRegion.Name
        else
            CountryOfOriginName := '';

        If ShippingAgent.Get(Rec.AgentCode) then
            ShippingAgentName := ShippingAgent.Name

        else
            ShippingAgentName := '';


    end;

    trigger OnOpenPage()

    begin
        SalesSetup.Get();
    end;

    var
        ShippingAgent: Record "Shipping Agent";

        CountryRegion: Record "Country/Region";
        SalesSetup: Record "Sales & Receivables Setup";
        ShippingAgentName: Text;
        RecordsLoaded: Boolean;

        ImageCDN: Text;
        FiltersNotSpecifiedErrorLbl: Label 'id type not specified.';

        CountryOfOriginName: Text;
}