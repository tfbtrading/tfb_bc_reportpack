table 53120 "TFB Price List Item Buffer"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; CustomerID; GUID)
        {

        }
        field(2; ItemID; GUID)
        {

        }

        field(4; "No."; Code[20])
        {
            TableRelation = Item;
            ValidateTableRelation = true;

        }
        field(5; "Description"; Text[255])
        {
            Caption = 'Description';
        }

        field(6; "Item Category ID"; GUID)
        {
            Caption = 'Item Category ID';
            TableRelation = "Item Category".SystemId;
        }

        field(7; "Unit of Measure ID"; GUID)
        {
            Caption = 'Base Unit of Measure ID';
        }
        field(8; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
        field(10; Type; Enum "Item Type")
        {
            Caption = 'Type';

        }
        field(11; "Alternative Names"; Text[255])
        {
            Caption = 'Alternative Names';
        }
        field(30; "Vendor Id"; GUID)
        {
            Caption = 'Vendor ID';
        }

        field(31; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;
        }
        field(42; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(43; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(49; "Country/Region Purchased Code"; Code[10])
        {
            Caption = 'Country/Region Purchased Code';
            TableRelation = "Country/Region";
        }
        field(95; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            TableRelation = "Country/Region";
        }

        field(54; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(92; Picture; MediaSet)
        {
            Caption = 'Picture';
        }
        field(5413; "Safety Stock Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Safety Stock Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5702; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(53010; KgPrice; Decimal)
        {

        }
        field(53020; UnitPrice; Decimal)
        {

        }

        field(53030; OldKgPrice; Decimal)
        {
        }

        field(53040; OldUnitPrice; Decimal)
        {
        }
        field(53050; PriceChangeDate; Date)
        {

        }
        field(53055; DaysSincePriceChange; Integer)
        {

        }
        field(53056; AvailabilityStatus; Enum "TFB Availability Status")
        {

        }
        field(53057; LastPaidKgPrice; Decimal)
        {

        }
        field(53058; LastPaidUnitPrice; Decimal)
        {

        }

        field(53060; Availability; Text[100])
        {
        }

        field(53070; EstETA; Text[50])
        {

        }
        field(53075; "NextAvailable"; Date)
        {

        }
        field(53080; AQISFactors; Text[50])
        {

        }
        field(53090; UnitType; Text[50])
        {
        }
        field(53100; PerPallet; Integer)
        {

        }
        field(53105; DateLastDispatched; Date)
        {

        }
        field(53107; QtyPendingDelivery; Integer)
        {

        }


        field(53110; BookMarkedItem; Boolean)
        {

        }
        field(53120; BookmarkHTML; Text[512])
        {

        }
        field(53130; flagHTML; Text[512])
        {

        }
        field(53140; FavouritedItem; Boolean)
        {

        }
        field(53150; MultiItemPalletOption; Enum "TFB Multi-item Pallet Option")
        {

        }
        field(53160; QtyPerLayer; Integer)
        {

        }
        field(53200; DeliverySLA; Text[256])
        {

        }
        field(53202; AgentCode; Code[10])
        {

        }
        field(53204; AgentServiceCode; Code[10])
        {

        }

        field(53192; "DeliveryInNoDaysMin"; Integer)
        {

        }
        field(53194; "DeliveryInNoDaysMax"; Integer)
        {

        }

        field(53170; TrackingAvailable; Boolean)
        {

        }
        field(53180; GenericItemID; GUID)
        {

        }
        field(53210; "MarketingCopy"; Text[2048])
        {

        }
        field(53220; "SpecificationCDN"; Text[512])
        {

        }
    }

    keys
    {
        key(PK; CustomerID, "No.")
        {
            Clustered = true;
        }
    }

    var


    procedure LoadDataFromFilters(CustomerIdFilter: Text; EffectiveDate: Date)
    var
        Item: Record Item;
        Customer: Record Customer;
        Vendor: Record Vendor;
        PriceCU: CodeUnit "TFB Pricing Calculations";
        CommonCU: CodeUnit "TFB Common Library";

    begin

        Customer.GetBySystemId(CustomerIdFilter);

        Item.SetCurrentKey("Item Category Code", Description);
        Item.SetRange(Type, Type::Inventory);
        Item.SetRange("Sales Blocked", false);
        Item.SetRange("TFB Publishing Block", false);
        Item.SetAscending("Item Category Code", false);

        If Item.FindSet(false, false) then
            repeat
                clear(Rec);
                Rec.CustomerID := CustomerIdFilter;
                Rec."No." := Item."No.";
                Rec.ItemID := Item.SystemId;
                Rec.Description := Item.Description;
                Rec."Net Weight" := Item."Net Weight";
                Rec."Alternative Names" := Item."TFB Alt. Names";
                Rec."Item Category ID" := Item."Item Category Id";
                Rec."Item Category Code" := Item."Item Category Code";
                Rec.Blocked := Item.Blocked;
                Rec."Base Unit of Measure" := Item."Base Unit of Measure";
                Rec."Unit of Measure ID" := Item."Unit of Measure Id";
                If Item."TFB Vendor is Agent" then
                    Rec."Vendor No." := Item."TFB Manufacturer Vendor No."
                else
                    Rec."Vendor No." := Item."Vendor No.";

                If Vendor.Get(Rec."Vendor No.") then
                    Rec."Vendor Id" := Vendor.SystemId;

                Rec.MultiItemPalletOption := Item."TFB Multi-item Pallet Option";
                Rec.QtyPerLayer := Item."TFB No. Of Bags Per Layer";
                Rec.GenericItemID := Item."TFB Generic Item ID";
                Rec.LastPaidUnitPrice := GetLastPricePaid(Item."No.", Customer."No.");
                Rec.LastPaidKgPrice := PriceCU.CalcPerKgFromUnit(Rec.LastPaidUnitPrice, Rec."Net Weight");

                Rec."Country/Region of Origin Code" := Item."Country/Region of Origin Code";
                Rec.SpecificationCDN := CommonCU.GetSpecificationURL(Item);


                If Vendor.Get(Item."Vendor No.") then begin
                    Rec.DeliverySLA := Vendor."TFB Delivery SLA";
                end;

                Rec.MarketingCopy := GetMarketingCopy(Item);
                GetSalesListPricing(Customer."No.", Customer."Customer Price Group", Item);
                GetTransportDetails(Item, Customer);
                GetAvailability(Item);
                FavouritedItem := GetFavouriteStatus(Item."No.", Customer."No.");
                QtyPendingDelivery := GetQtyPendingDelivery(Item."No.", Customer."No.");
                PerPallet := GetPerPallet(Item);
                DateLastDispatched := GetLastDispatchDate(Item."No.", Customer."No.");
                BookMarkedItem := GetBookmarkStatus(Item."No.", Customer."No.");


                Rec.Insert();
            until Item.Next() = 0;

    end;

    local procedure GetTransportDetails(Item: Record Item; Customer: Record Customer): Boolean

    var
        ShippingAgentServices: Record "Shipping Agent Services";
        Purchasing: Record Purchasing;
        ShippingAgent: Record "Shipping Agent";
        SalesCU: CodeUnit "TFB Sales Mgmt";


    begin

        If Purchasing.Get(Item."Purchasing Code") then
            If Purchasing."Drop Shipment" then
                ShippingAgentServices := SalesCU.GetShippingAgentDetailsForDropShipItem(Item, Customer)
            else
                ShippingAgentServices := SalesCU.GetShippingAgentDetailsForLocation(SalesCU.GetIntelligentLocation(Customer."No.", Item."No.", 0), Customer.County, Customer."Shipment Method Code");

        Rec.AgentCode := ShippingAgentServices."Shipping Agent Code";
        Rec.AgentServiceCode := ShippingAgentServices.Code;
        Rec.DeliveryInNoDaysMin := CalcDate(ShippingAgentServices."Shipping Time", Today) - Today;
        If format(ShippingAgentServices."TFB Shipping Time Max") <> '' then
            Rec.DeliveryInNoDaysMax := CalcDate(ShippingAgentServices."TFB Shipping Time Max", Today) - Today
        else
            Rec.DeliveryInNoDaysMax := DeliveryInNoDaysMin;

        If ShippingAgent.Get(Rec.AgentCode) then
            Rec.TrackingAvailable := ShippingAgent."Internet Address" <> ''; //internet address assumed to be trackingis available

    end;

    local procedure GetSalesListPricing(CustNo: Code[20]; CustomerPriceGroup: Code[20]; Item: Record Item): Boolean

    var
        PriceAsset: Record "Price Asset";
        PriceListLine: Record "Price List Line";
        OldPriceListLine: Record "Price List Line";

        _PriceHistory: DateFormula;
        SearchDate: Date;
        OldStartDate: Date;
        CutOffDate: Date;
    begin

        KgPrice := 0;
        UnitPrice := 0;
        OldKgPrice := 0;
        OldUnitPrice := 0;
        PriceChangeDate := 0D;
        DaysSincePriceChange := 0;


        SearchDate := Today();
        Evaluate(_PriceHistory, '-1Y');


        AsPriceAsset(Item."No.", PriceAsset);
        FilterPriceListLine(CustomerPriceGroup, PriceAsset, PriceListLine, SearchDate, '');

        If PriceListLine.FindLast() then begin
            UnitPrice := PriceListLine."Unit Price";
            KgPrice := PriceListLine.GetPriceAltPriceFromUnitPrice();

            OldStartDate := CalcDate('<-2D>', PriceListLine."Starting Date");
            CutOffDate := CalcDate(_PriceHistory, Today());
            If OldStartDate > CutOffDate then
                FilterPriceListLine(CustomerPriceGroup, PriceAsset, OldPriceListLine, OldStartDate, '');

            If (OldStartDate > CutOffDate) and OldPriceListLine.FindLast() then begin

                OldUnitPrice := OldPriceListLine."Unit Price";
                OldKgPrice := OldPriceListLine.GetPriceAltPriceFromUnitPrice();

                If OldKgPrice <> KgPrice then begin
                    PriceChangeDate := PriceListLine."Starting Date";
                    DaysSincePriceChange := SearchDate - PriceListLine."Starting Date";
                end;
            end
            else begin
                OldKgPrice := KgPrice;
                OldUnitPrice := UnitPrice;
            end;

        end;

    end;

    local procedure FilterPriceListLine(CustomerPriceGroup: Code[20]; PriceAsset: Record "Price Asset"; var PriceListLine: Record "Price List Line"; EffectiveDate: Date; CurrencyCode: Code[10])

    begin
        PriceListLine.SetRange("Asset Type", PriceAsset."Asset Type");
        PriceListLine.SetRange("Asset No.", PriceAsset."Asset No.");
        PriceListLine.SetFilter("Variant Code", '%1|%2', PriceAsset."Variant Code", '');
        PriceListLine.SetRange(Status, PriceListLine.Status::Active);
        PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Sale);
        PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::"Customer Price Group");
        PriceListLine.SetRange("Source No.", CustomerPriceGroup);
        PriceListLine.SetFilter("Amount Type", '%1|%2', PriceListLine."Amount Type"::Price, PriceListLine."Amount Type"::Any);
        PriceListLine.SetRange("Starting Date", 0D, EffectiveDate);
        PriceListLine.SetFilter("Ending Date", '%1|>=%2', 0D, EffectiveDate);
        PriceListLine.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');



    end;


    local procedure AsPriceAsset(ItemNo: Code[20]; var PriceAsset: Record "Price Asset")

    begin
        PriceAsset.Init();
        PriceAsset."Asset Type" := PriceAsset."Asset Type"::Item;
        PriceAsset."Asset No." := ItemNo;


    end;

    local procedure GetAvailability(Item: Record Item): Boolean
    var

        ItemLedger: Record "Item Ledger Entry";
        PurchasingCode: Record Purchasing;
        ResEntry: Record "Reservation Entry";
        QtyReserved: Decimal;
        QtyRemaining: Decimal;
        NextQtyRemaining: Decimal;
        SafetyStock: Decimal;

        DropShip: Boolean;
        EstDateInt: Date;


    begin

        EstETA := '';
        NextAvailable := 0D;
        Availability := '';
        NextQtyRemaining := 0;
        If Item."Safety Stock Quantity" = 0 then
            SafetyStock := 200 else
            SafetyStock := Item."Safety Stock Quantity";

        If PurchasingCode.Get(Item."Purchasing Code") then
            If PurchasingCode."Drop Shipment" then
                DropShip := true;


        //Item is not set as a drop ship item
        If DropShip then
            case Item."TFB DropShip Avail." of
                Item."TFB DropShip Avail."::"Out of Stock":
                    begin
                        AvailabilityStatus := AvailabilityStatus::OutofStock;

                        If Item."TFB DropShip ETA" <> 0D then
                            NextAvailable := Item."TFB DropShip ETA";

                    end;
                Item."TFB DropShip Avail."::Restricted:
                    AvailabilityStatus := AvailabilityStatus::Low;

                Item."TFB DropShip Avail."::Available:
                    AvailabilityStatus := AvailabilityStatus::Okay;

            end
        else begin
            Clear(ItemLedger);
            ItemLedger.SetRange("Item No.", Item."No.");
            ItemLedger.SetFilter("Entry Type", '%1|%2|%3|%4', ItemLedger."Entry Type"::Purchase, ItemLedger."Entry Type"::"Positive Adjmt.", ItemLedger."Entry Type"::Transfer, ItemLedger."Entry Type"::"Assembly Output");
            ItemLedger.SetRange(Open, true);


            If ItemLedger.CalcSums("Remaining Quantity") then begin

                ResEntry.SetRange("Source Type", 32);
                ResEntry.SetRange("Item No.", Item."No.");
                ResEntry.SetRange("Reservation Status", ResEntry."Reservation Status"::Reservation);
                ResEntry.SetRange(Positive, true);
                ResEntry.CalcSums("Qty. to Handle (Base)");
                QtyReserved := ResEntry."Qty. to Handle (Base)";
                QtyRemaining := ItemLedger."Remaining Quantity" - QtyReserved;


                Case QtyRemaining of
                    0:
                        begin
                            AvailabilityStatus := AvailabilityStatus::OutofStock;
                            If GetDateOfNextOrderOrTransfer(Item."No.", NextQtyRemaining, EstDateInt) then
                                NextAvailable := EstDateInt;
                        end;
                    1 .. SafetyStock:
                        AvailabilityStatus := AvailabilityStatus::Low;
                    else
                        AvailabilityStatus := AvailabilityStatus::Okay;
                end;
            end;

        end;
    end;

    local procedure GetFavouriteStatus(ItemNo: Code[20]; CustNo: Code[20]): Boolean

    var
        TFBCustFavItem: Record "TFB Cust. Fav. Item";


    begin

        Exit(TFBCustFavItem.Get(CustNo, 'DEFAULT', ItemNo));

    end;

    local procedure GetLastDispatchDate(ItemNo: Code[20]; CustNo: Code[20]): Date

    var
        ItemLedgerEntry: Record "Item Ledger Entry";


    begin

        Clear(ItemLedgerEntry);

        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Source Type", ItemLedgerEntry."Source Type"::Customer);
        ItemLedgerEntry.SetRange("Source No.", CustNo);
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
        ItemLedgerEntry.SetFilter(Quantity, '<>0');
        ItemLedgerEntry.SetCurrentKey("Posting Date");
        ItemLedgerEntry.SetAscending("Posting Date", false);
        If ItemLedgerEntry.FindFirst() then
            Exit(ItemLedgerEntry."Posting Date");


    end;

    local procedure GetLastPricePaid(ItemNo: Code[20]; CustNo: Code[20]): Decimal

    var
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Invoice Line";

    begin
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetRange("Sell-to Customer No.", CustNo);
        SalesLine.SetCurrentKey("Document No.", "Line No.");

        If SalesLine.FindLast() then
            If not ((SalesLine."Outstanding Qty. (Base)" = 0) and (salesline."Qty. Shipped Not Invd. (Base)" = 0)) then
                Exit(SalesLine."Unit Price" / SalesLine."Qty. per Unit of Measure");

        SalesInvoiceLine.SetRange("No.", ItemNo);
        SalesInvoiceLine.SetRange("Sell-to Customer No.", CustNo);
        SalesLine.SetCurrentKey("Document No.", "Line No.");

        If SalesInvoiceLine.FindLast() then
            Exit(SalesInvoiceLine."Unit Price" / SalesInvoiceLine."Qty. per Unit of Measure");
    end;

    local procedure GetQtyPendingDelivery(ItemNo: Code[20]; CustNo: Code[20]): Decimal

    var
        SalesLine: Record "Sales Line";

    begin

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetFilter("Outstanding Qty. (Base)", '>0');
        SalesLine.SetRange("Sell-to Customer No.", CustNo);
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.CalcSums("Outstanding Qty. (Base)");
        Exit(SalesLine."Outstanding Qty. (Base)");
    end;

    local procedure GetUnitType(var Item: Record Item): Text

    var

        UnitOfMeasure: Record "Unit of Measure";


    begin

        If UnitOfMeasure.Get(Item."Base Unit of Measure") then
            Exit(Format(Item."Net Weight") + 'kg net ' + UnitOfMeasure.Description);
    end;

    local procedure GetPerPallet(var ItemVar: Record Item): Integer

    var

        ItemUnitOfMeasure: Record "Item Unit of Measure";

    begin

        ItemUnitOfMeasure.SetRange("Item No.", ItemVar."No.");
        ItemUnitOfMeasure.SetRange(Code, 'PALLET');

        If ItemUnitOfMeasure.FindFirst() then
            Exit(ItemUnitOfMeasure."Qty. per Unit of Measure");
    end;

    local procedure GetAQISFactors(var ItemVar: Record Item): Text
    var

        ReturnText: TextBuilder;
    begin


        If ItemVar."TFB Fumigation" then
            ReturnText.Append('F');

        If ItemVar."TFB Inspection" then
            if ReturnText.Length() > 0 then
                ReturnText.Append(',I')
            else
                ReturnText.Append('I');

        exit(ReturnText.ToText()); // Added an exit to reset the global var when function cannot find a result
    end;

    local procedure GetBookmarkStatus(ItemNo: Code[20]; CustNo: Code[20]): Boolean

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        DateFormula: DateFormula;

    begin

        Clear(ItemLedgerEntry);
        Evaluate(DateFormula, '-6M');
        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Source Type", ItemLedgerEntry."Source Type"::Customer);
        ItemLedgerEntry.SetRange("Source No.", CustNo);
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
        ItemLedgerEntry.SetFilter(Quantity, '<>0');
        ItemLedgerEntry.SetFilter("Posting Date", '>%1', CalcDate(DateFormula, Today()));
        ItemLedgerEntry.CalcSums(Quantity);

        If ABS(ItemLedgerEntry.Quantity) > 20 then
            Exit(True)
        else
            Exit(false);


    end;

    local procedure GetDateOfNextOrderOrTransfer(ItemNo: Code[20]; "Remaining Qty. (Base)": Decimal; var NextDate: Date): Boolean

    var
        TransferLine: Record "Transfer Line";
        PurchaseLine: Record "Purchase Line";

        TransferSupplyFound: Boolean;
        OrderSupplyFound: Boolean;

    begin




        //Assume there is a transfer line set up related to a container

        TransferLine.SetRange("Item No.", ItemNo);
        TransferLine.SetFilter("Outstanding Qty. (Base)", '>0');
        TransferLine.SetCurrentKey("Receipt Date");
        If TransferLine.FindFirst() then begin
            TransferLine.CalcFields("Reserved Qty. Shipped (Base)");
            "Remaining Qty. (Base)" := TransferLine."Qty. Shipped (Base)" - TransferLine."Reserved Qty. Shipped (Base)";
            If "Remaining Qty. (Base)" > 0 then begin
                NextDate := TransferLine."Receipt Date";
                TransferSupplyFound := true;
            end;
        end;


        //Check for a local purchase order coming to the warehouse
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange("No.", ItemNo);
        PurchaseLine.SetRange("Drop Shipment", false);
        PurchaseLine.SetFilter("Outstanding Qty. (Base)", '>0');
        PurchaseLine.SetCurrentKey("Expected Receipt Date");

        If PurchaseLine.FindSet(false, false) then
            repeat
                If (not TransferSupplyFound) or (TransferSupplyFound and (PurchaseLine."Expected Receipt Date" < TransferLine."Receipt Date")) then begin
                    PurchaseLine.CalcFields("Reserved Qty. (Base)");
                    "Remaining Qty. (Base)" := PurchaseLine."Quantity (Base)" - PurchaseLine."Reserved Qty. (Base)";
                    If "Remaining Qty. (Base)" > 0 then begin
                        NextDate := PurchaseLine."Expected Receipt Date";
                        OrderSupplyFound := true;
                    end;
                end;
            // process record  
            until ((PurchaseLine.Next() = 0) or (OrderSupplyFound = true));

        If TransferSupplyFound or OrderSupplyFound then Exit(true) else Exit(False);


    end;

    local procedure GetMarketingCopy(Item: Record Item): Text[2048]

    var
        GenericItem: Record "TFB Generic Item";
    begin

        If GenericItem.GetBySystemId(Item."TFB Generic Item ID") then
            Exit(GenericItem."Rich Description");



    end;
}