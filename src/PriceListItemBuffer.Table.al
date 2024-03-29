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
        field(53059; AvailableAsDropShip; Boolean)
        {

        }
        field(53300; AvailableToSellBaseQty; Decimal)
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
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced by enum';
        }

        field(53070; EstETA; Text[50])
        {
            ObsoleteState = Pending;
            ObsoleteReason = 'Replaced by date field';

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
        field(53107; QtyPendingDelivery; Decimal)
        {

        }
        field(53108; QtyOnNextDelivery; Decimal)
        {

        }
        field(53109; DatePlannedForNextDelivery; Date)
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
        field(35152; MaxProductsPerPallet; Integer)
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
        field(53250; "ReferenceForNextDelivery"; Text[100])
        {

        }
        field(53260; "NextDeliveryID"; GUID)
        {

        }
        field(53270; "NoEstimateAvailable"; Boolean)
        {

        }
        field(53310; "LastReceiptDate"; Date)
        {

        }
        field(53320; "LastReceiptQty"; Decimal)
        {

        }
        field(53330; "LastReceiptQtySold"; Decimal)
        {

        }

        field(53340; "MarketInsightType"; Enum "TFB Market Insight Type")
        {

        }
        field(53350; "LastSaleDateTime"; DateTime)
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

        If Item.FindSet(false) then
            repeat
                clear(Rec);
                Rec.CustomerID := CustomerIdFilter;
                Rec.MarketInsightType := Rec.MarketInsightType::" ";
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
                    Rec."Vendor No." := Item."TFB Item Manufacturer/Brand"
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
                Rec.SpecificationCDN := Text.CopyStr(CommonCU.GetSpecificationURL(Item), 1, 100);


                If Vendor.Get(Item."Vendor No.") then
                    Rec.DeliverySLA := Vendor."TFB Delivery SLA";


                Rec.MarketingCopy := GetMarketingCopy(Item);
                GetSalesListPricing(Customer."Customer Price Group", Item);
                GetAvailability(Item);
                GetRecentStockStatus(Item);
                GetTransportDetails(Item, Customer);
                FavouritedItem := GetFavouriteStatus(Item."No.", Customer."No.");
                QtyPendingDelivery := GetQtyPendingDelivery(Item."No.", Customer."No.");
                UpdateNextDeliveryDetails(Item."No.", Customer."No.");
                PerPallet := GetPerPallet(Item);
                DateLastDispatched := GetLastDispatchDate(Item."No.", Customer."No.");
                BookMarkedItem := GetBookmarkStatus(Item."No.", Customer."No.");


                Rec.Insert();
            until Item.Next() = 0;

    end;

    local procedure GetTransportDetails(Item: Record Item; Customer: Record Customer): Boolean

    var
        ShippingAgentServices: Record "Shipping Agent Services";
        Vendor: Record Vendor;
        Purchasing: Record Purchasing;
        CustomCalendarChange: Array[2] of Record "Customized Calendar Change";
        ShippingAgent: Record "Shipping Agent";
        Location: record Location;
        SalesCU: CodeUnit "TFB Sales Mgmt";
        CalendarMgmt: CodeUnit "Calendar Management";
        NewDate: Date;

        IntelligentLocationCode: Code[10];
        UseDropShipDateCalcs: Boolean;



    begin

        If Purchasing.Get(Item."Purchasing Code") and Purchasing."Drop Shipment" then begin
            ShippingAgentServices := SalesCU.GetShippingAgentDetailsForDropShipItem(Item, Customer);
            Rec.AgentCode := ShippingAgentServices."Shipping Agent Code";
            Rec.AgentServiceCode := ShippingAgentServices.Code;

            UseDropShipDateCalcs := true;
            Rec.AvailableAsDropShip := true;
        end;


        //Add in vendor lead times until dispatch
        case UseDropShipDateCalcs of
            true:
                begin
                    If not Vendor.Get(Item."Vendor No.") then begin
                        Rec.NoEstimateAvailable := true;
                        exit;
                    end;
                    Rec.MaxProductsPerPallet := Vendor."TFB Max Products Per Pallet";
                    Rec.DeliveryInNoDaysMin := CalcDate(Vendor."TFB Dispatch Lead Time", Today) - Today;

                    If format(Vendor."TFB Dispatch Lead Time Max") = '' then
                        Rec.DeliveryInNoDaysMax := Rec.DeliveryInNoDaysMin
                    else
                        Rec.DeliveryInNoDaysMax := CalcDate(Vendor."TFB Dispatch Lead Time Max", Today) - Today;
                end;

            false:
                begin
                    SalesCU.GetIntelligentLocation(Customer."No.", Customer."Ship-to Code", Item."No.", 0, IntelligentLocationCode);


                    if not Location.Get(IntelligentLocationCode) then begin
                        Rec.NoEstimateAvailable := true;
                        exit;
                    end;

                    ShippingAgentServices := SalesCU.GetShippingAgentDetailsForLocation(Location.Code, Customer.County, Customer."Shipment Method Code", Customer."TFB Override Location Shipping");
                    Rec.AgentCode := ShippingAgentServices."Shipping Agent Code";
                    Rec.AgentServiceCode := ShippingAgentServices.Code;
                    If Rec.MultiItemPalletOption = Rec.MultiItemPalletOption::Half then
                        Rec.MaxProductsPerPallet := 2;
                    //Add in outbound number of days for handling
                    CustomCalendarChange[1].SetSource(Enum::"Calendar Source Type"::Location, Location.Code, '', '');
                    If not (Rec.AvailabilityStatus = Rec.AvailabilityStatus::OutofStock) then
                        NewDate := CalcDate(Location."Outbound Whse. Handling Time", Today)
                    else
                        if Rec.NextAvailable > 0D then
                            NewDate := CalcDate(Location."Outbound Whse. Handling Time", NextAvailable)
                        else
                            Rec.NoEstimateAvailable := true;

                    if not Rec.NoEstimateAvailable then begin
                        Rec.DeliveryInNoDaysMin := CalendarMgmt.CalcDateBOC('', NewDate, CustomCalendarChange, false) - Today;
                        Rec.DeliveryInNoDaysMax := Rec.DeliveryInNoDaysMin;
                    end;
                end;
        end;



        Rec.DeliveryInNoDaysMin += CalcDate(ShippingAgentServices."Shipping Time", Today) - Today;

        If format(ShippingAgentServices."TFB Shipping Time Max") <> '' then
            Rec.DeliveryInNoDaysMax += CalcDate(ShippingAgentServices."TFB Shipping Time Max", Today) - Today
        else
            Rec.DeliveryInNoDaysMax := DeliveryInNoDaysMin;

        If ShippingAgent.Get(Rec.AgentCode) then
            Rec.TrackingAvailable := ShippingAgent."Internet Address" <> ''; //internet address assumed to be trackingis available

    end;

    local procedure GetSalesListPricing(CustomerPriceGroup: Code[20]; Item: Record Item): Boolean

    var
        PriceAsset: Record "Price Asset";
        PriceListLine: Record "Price List Line";
        OldPriceListLine: Record "Price List Line";
        TypeHelper: CodeUnit "Type Helper";

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


        SearchDate := DT2DATE(TypeHelper.GetCurrentDateTimeInUserTimeZone());
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
                    If DaysSincePriceChange < 7 then
                        MarketInsightType := MarketInsightType::PriceChange;
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

    local procedure GetRecentStockStatus(Item: Record Item)

    var
        ItemLedger: Record "Item Ledger Entry";
        Salesline: Record "Sales Line";
        Purchasing: Record Purchasing;

    begin

        ItemLedger.SetFilter("Posting Date", 't-7d..');
        ItemLedger.SetFilter("Entry Type", '%1|%2|%3', ItemLedger."Entry Type"::Purchase, ItemLedger."Entry Type"::Transfer, ItemLedger."Entry Type"::"Assembly Output");
        ItemLedger.SetFilter("Location Code", 'CS|MB|EFFLOG|BRS-3PL'); //TODO Add in a configure setting for warehouses included
        ItemLedger.SetRange("Drop Shipment", false);
        ItemLedger.SetRange("Item No.", Item."No.");
        ItemLedger.SetCurrentKey("Posting Date");
        ItemLedger.SetAscending("Posting Date", false);
        ItemLedger.SetLoadFields("Remaining Quantity", Quantity, "Posting Date", "Entry No.", "Purchasing Code");

        If not ItemLedger.FindFirst() then exit;



        LastReceiptDate := ItemLedger."Posting Date";
        LastReceiptQty := ItemLedger.Quantity;
        ItemLedger.CalcFields("Reserved Quantity");
        LastReceiptQtySold := ItemLedger."Reserved Quantity" + (ItemLedger.Quantity - ItemLedger."Remaining Quantity");

        Salesline.SetRange("Document Type", Salesline."Document Type"::Order);
        Salesline.SetRange("No.", Item."No.");
        Salesline.SetFilter("Outstanding Qty. (Base)", '>0');
        Salesline.SetCurrentKey(SystemCreatedAt);
        SalesLine.SetAscending(SystemCreatedAt, false);
        If salesline.FindFirst() then
            LastSaleDateTime := salesline.SystemCreatedAt;

        If not (Purchasing.get(ItemLedger."Purchasing Code") and Purchasing."Special Order") then
            MarketInsightType := MarketInsightType::NewStock;


    end;

    local procedure GetAvailability(Item: Record Item): Boolean
    var

        PurchasingCode: Record Purchasing;
        QtyRemaining: Decimal;

        NextQtyRemaining: Decimal;
        SafetyStock: Decimal;

        DropShip: Boolean;
        EstDateInt: Date;


    begin

        NextAvailable := 0D;
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

            Item.SetFilter("Drop Shipment Filter", '%1', false);
            Item.SetFilter("Location Filter", 'CS|MB|EFFLOG|BRS-3PL'); //TODO Add code to dynamically configure this;
            Item.CalcFields(Inventory, "Reserved Qty. on Inventory");

            QtyRemaining := Item.Inventory - Item."Reserved Qty. on Inventory";



            Case QtyRemaining of
                0:
                    begin
                        AvailabilityStatus := AvailabilityStatus::OutofStock;
                        If GetDateOfNextOrderOrTransfer(Item."No.", NextQtyRemaining, EstDateInt) then
                            NextAvailable := EstDateInt;
                    end;
                1 .. SafetyStock:
                    begin
                        AvailabilityStatus := AvailabilityStatus::Low;
                        If GetDateOfNextOrderOrTransfer(Item."No.", NextQtyRemaining, EstDateInt) then
                            NextAvailable := EstDateInt;
                    end;
                else
                    AvailabilityStatus := AvailabilityStatus::Okay;
            end;
        end;

        AvailableToSellBaseQty := QtyRemaining;
        If (AvailabilityStatus = AvailabilityStatus::Low) and (not DropShip) then
            MarketInsightType := MarketInsightType::LowStock;

        If (AvailabilityStatus = AvailabilityStatus::OutofStock) and (not DropShip) then

            //Check if item was recently sold-out in last three months
            If IsRecentlySoldOut(Item, Item."Reserved Qty. on Inventory", Rec.LastSaleDateTime) then
                MarketInsightType := MarketInsightType::OutOfStock;


    end;

    local procedure IsRecentlySoldOut(Item: Record Item; ReservedQtyOnInventory: Integer; var newLastSaleDateTime: DateTime): Boolean

    var
        ItemLedger: Record "Item Ledger Entry";
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        SalesHeader: Record "Sales Header";
        DurationToCheck: DateFormula;
        BeginPeriod: Date;

    begin

        Evaluate(DurationToCheck, '<-3M>');
        BeginPeriod := CalcDate(DurationToCheck, Today);

        If ReservedQtyOnInventory = 0 then begin
            ItemLedger.SetRange("Item No.", Item."No.");
            ItemLedger.SetRange("Posting Date", BeginPeriod, Today());
            ItemLedger.SetRange("Entry Type", ItemLedger."Entry Type"::Sale);
            ItemLedger.SetCurrentKey("Posting Date");
            ItemLedger.SetAscending("Posting Date", false);
            ItemLedger.SetLoadFields("Document No.", "Posting Date");

            If ItemLedger.FindFirst() then begin
                newLastSaleDateTime := ItemLedger.SystemCreatedAt;
                Exit(true);
            end
            else
                Exit(false);
        end
        else begin
            ReservationEntry.SetRange("Item No.", Item."No.");
            ReservationEntry.SetRange("Source Type", 32);
            ReservationEntry.SetRange(Positive, true);
            ReservationEntry.SetCurrentKey("Creation Date");
            ReservationEntry.SetAscending("Creation Date", false);

            If ReservationEntry.FindFirst() then begin
                ReservationEntry2.SetRange("Entry No.", ReservationEntry."Entry No.");
                ReservationEntry2.SetRange(Positive, false);
                ReservationEntry2.SetRange("Source Type", 37);

                If ReservationEntry2.FindFirst() then
                    If SalesHeader.Get(SalesHeader."Document Type"::Order, ReservationEntry2."Source ID") then
                        If SalesHeader."Order Date" > BeginPeriod then begin
                            newLastSaleDateTime := SalesHeader.SystemCreatedAt;
                            Exit(true);
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
        SalesLine.SetFilter(Quantity, '>0');
        SalesLine.SetCurrentKey("Document No.", "Line No.");



        If SalesLine.FindLast() then
            If not ((SalesLine."Outstanding Qty. (Base)" = 0) and (salesline."Qty. Shipped Not Invd. (Base)" = 0)) then
                Exit((SalesLine."Line Amount" / SalesLine.Quantity) / SalesLine."Qty. per Unit of Measure");

        SalesInvoiceLine.SetRange("No.", ItemNo);
        SalesInvoiceLine.SetRange("Sell-to Customer No.", CustNo);
        SalesInvoiceLine.SetFilter(Quantity, '>0');
        SalesInvoiceLine.SetCurrentKey("Document No.", "Line No.");

        If SalesInvoiceLine.FindLast() then
            Exit((SalesInvoiceLine."Line Amount" / SalesInvoiceLine.Quantity) / SalesInvoiceLine."Qty. per Unit of Measure");
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

    local procedure UpdateNextDeliveryDetails(ItemNo: Code[20]; CustNo: Code[20]): Decimal

    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";

    begin

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetFilter("Outstanding Qty. (Base)", '>0');
        SalesLine.SetRange("Sell-to Customer No.", CustNo);
        SalesLine.SetRange("No.", ItemNo);
        SalesLine.SetCurrentKey("Planned Shipment Date");
        SalesLine.SetAscending("Planned Shipment Date", true);

        If not SalesLine.FindFirst() then exit;

        SalesLine.CalcFields("TFB External Document No.");

        Rec.QtyOnNextDelivery := SalesLine."Outstanding Qty. (Base)";
        Rec.DatePlannedForNextDelivery := SalesLine."Planned Shipment Date";
        Rec.ReferenceForNextDelivery := SalesLine."Document No.";
        SalesHeader.SetLoadFields("External Document No.", SystemId);
        SalesHeader.Get(SalesHeader."Document Type"::Order, SalesLine."Document No.");

        Rec.NextDeliveryID := SalesHeader.SystemId;
        If SalesHeader."External Document No." <> '' then
            Rec.ReferenceForNextDelivery += '/ Your PO Ref ' + SalesHeader."External Document No.";

    end;



    local procedure GetPerPallet(ItemVar: Record Item): Integer

    var

        ItemUnitOfMeasure: Record "Item Unit of Measure";

    begin

        ItemUnitOfMeasure.SetRange("Item No.", ItemVar."No.");
        ItemUnitOfMeasure.SetRange(Code, 'PALLET');

        If ItemUnitOfMeasure.FindFirst() then
            Exit(ItemUnitOfMeasure."Qty. per Unit of Measure");
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

        If PurchaseLine.FindSet(false) then
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