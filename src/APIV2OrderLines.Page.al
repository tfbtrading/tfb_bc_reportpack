page 53008 "TFB APIV2 - Order Lines"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Order Lines';
    EntitySetCaption = 'Order Lines';
    DelayedInsert = true;
    EntityName = 'orderLine';
    EntitySetName = 'orderLines';
    APIPublisher = 'tfb';
    APIGroup = 'inreach';
    ODataKeyFields = DocumentType, DocumentID, CustomerLineStatus, "No.";
    DataAccessIntent = ReadOnly;
    Editable = false;
    PageType = API;
    SourceTable = "TFB Customer Lines Buffer";

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
                field(id; Rec.ItemID)
                {
                    Caption = 'Id';

                }
                field(customerID; Rec.CustomerID)
                {
                    Caption = 'CustomerId';
                }
                field(documentType; Rec.DocumentType)
                {
                    Caption = 'Document Type';

                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(documentID; Rec.DocumentID)
                {
                    Caption = 'Document ID';

                }
                field(orderLineStatus; Rec.CustomerLineStatus)
                {
                    Caption = 'Order Line Status';
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


                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }



                field(qtyPerPallet; Rec.PerPallet)
                {
                    Caption = 'Quantity Per Pallet';
                }


                field(qtyOutstanding; Rec.QtyPendingDelivery)
                {
                    Caption = 'Qty Outstanding';
                }

                field(unitOfMeasureId; Rec."Unit of Measure Id")
                {
                    Caption = 'Base Unit Of Measure Id';
                }
                field(baseUnitOfMeasureCode; Rec."Base Unit of Measure")
                {
                    Caption = 'Base Unit Of Measure Code';
                }
                field(kgPrice; Rec.KgPrice)
                {
                    Caption = 'kg price';
                }
                field(unitPrice; Rec.UnitPrice)
                {
                    Caption = 'UnitPrice';
                }
                field(discountPerKg; Rec.discountPerKg)
                {
                    Caption = 'DiscountPerKg';
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

                field(transportCompany; ShippingAgentName)
                {

                }
                field(trackingAvailable; Rec.TrackingAvailable)
                {

                }
                field(imageCDN; ImageCDN)
                {

                }
                field(customerReference; Rec."External Document No.")
                {

                }
                field(packageTrackingNo; Rec.PackageTrackingNo)
                {

                }
                field(qtyShipped; Rec.QtyShipped)
                {

                }
                field(warehouseShipmentNo; Rec."Related Warehouse Shipment No.")
                {
                    Caption = 'Related Warehouse Shipment No.';
                }
                field(relatedShipmentLineID; Rec."Related Shipment Line ID")
                {
                    Caption = 'Related Shipment Line ID';
                }
                field(relatedInvoiceDocNo; Rec."Related Invoice Doc. No.")
                {
                    Caption = 'Related Invoice Doc. No.';
                }
                field(relatedInvoiceID; Rec."Related Invoice ID")
                {
                    Caption = 'Related Invoice ID';
                }
                field(noOfNonConformances; Rec."No. Of Non-Conformances")
                {
                    Caption = 'No. Of Non Conformances';
                }
                field(orderDate; Rec.OrderDate)
                {
                    Caption = 'OrderDate';
                }
                field(quoteValidToDate; Rec.QuoteValidToDate)
                {
                    Caption = 'QuoteValidToDate';
                }
                field(requestedDeliveryDate; Rec.RequestedDeliveryDate)
                {
                    Caption = 'RequestedDeliveryDate';
                }
                field(plannedShipmentDate; Rec.PlannedShipmentDate)
                {
                    Caption = 'PlannedShipmentDate';
                }
                field(estDeliveryDateMin; Rec.EstDeliveryDateMin)
                {

                }
                field(estDeliveryDateMax; Rec.EstDeliveryDateMax)
                {
                    Caption = 'EstDeliveryDateMax';
                }
                field(actualShipmentDate; Rec.ActualShipmentDate)
                {
                    Caption = 'ActualShipmentDate';
                }
                field(actDeliveryDateTime; Rec.ActualDeliveryDateTime)
                {

                }
                field(markedReceivedByCustomer; Rec.MarkedAsReceivedByCustomer)
                {

                }
                field(podEnabled; Rec.PODEnabled)
                {

                }
                field(podReceived; Rec.PODReceived)
                {

                }
                field(podUrl; Rec.PODUrl)
                {

                }
                field(agentCode; Rec.AgentCode)
                {
                    Caption = 'AgentCode';
                }
                field(agentServiceCode; Rec.AgentServiceCode)
                {
                    Caption = 'AgentServiceCode';
                }

                field(shipToAddress; Rec."Ship-to Address")
                {
                    Caption = 'Ship-to Address';
                }
                field(shipToAddress2; Rec."Ship-to Address 2")
                {
                    Caption = 'Ship-to Address 2';
                }
                field(shipToCity; Rec."Ship-to City")
                {
                    Caption = 'Ship-to City';
                }
                field(shipToCode; Rec."Ship-to Code")
                {
                    Caption = 'Ship-to Code';
                }
                field(shipToContact; Rec."Ship-to Contact")
                {
                    Caption = 'Ship-to Contact';
                }
                field(shipToCountryRegionCode; Rec."Ship-to Country/Region Code")
                {
                    Caption = 'Ship-to Country/Region Code';
                }
                field(shipToCounty; Rec."Ship-to County")
                {
                    Caption = 'Ship-to County';
                }
                field(shipToName; Rec."Ship-to Name")
                {
                    Caption = 'Ship-to Name';
                }
                field(shipToPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Ship-to Post Code';
                }

                field(genericItemID; Rec.GenericItemID)
                {
                    Caption = 'GenericItemID';
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



            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        RelatedIdFilter: Text;

        FilterView: Text;
    begin
        RelatedIdFilter := Rec.GetFilter(CustomerID);

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
        Rec.LoadDataFromFilters(RelatedIdFilter);
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

        ImageCDN := StrSubstNo(CoreSetup."Image URL Pattern", Rec."No.");
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
        CoreSetup.Get();
    end;

    var
        ShippingAgent: Record "Shipping Agent";

        CountryRegion: Record "Country/Region";
        CoreSetup: Record "TFB Core Setup";
        ShippingAgentName: Text;
        RecordsLoaded: Boolean;

        ImageCDN: Text;
        FiltersNotSpecifiedErrorLbl: Label 'id type not specified.';

        CountryOfOriginName: Text;
}