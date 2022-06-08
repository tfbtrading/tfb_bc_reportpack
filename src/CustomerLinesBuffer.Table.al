table 53140 "TFB Customer Lines Buffer"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; CustomerID; GUID)
        {

        }
        field(2; DocumentType; Enum "Sales Applies-to Document Type")
        {

        }
        field(3; DocumentID; GUID)
        {

        }
        field(4; ItemID; GUID)
        {

        }

        field(5; "No."; Code[20])
        {
            TableRelation = Item;
            ValidateTableRelation = true;

        }
        field(6; "Description"; Text[255])
        {
            Caption = 'Description';
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

        field(11; "Alternative Names"; Text[255])
        {
            Caption = 'Alternative Names';
        }
        field(12; CustomerLineStatus; Enum "TFB Customer Line Status")
        {

        }
        field(13; "Line No."; Integer)
        {

        }
        field(30; "Vendor Id"; GUID)
        {
            Caption = 'Vendor ID';
        }

        field(31; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;

        }
        field(40; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }

        field(50; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            TableRelation = "Country/Region";
        }

        field(60; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }


        field(90; AQISFactors; Text[50])
        {

        }
        field(100; UnitType; Text[50])
        {
        }
        field(110; PerPallet; Integer)
        {

        }

        field(120; QtyPendingDelivery; Decimal)
        {

        }
        field(137; OrderDate; Date)
        {

        }

        field(138; "PlannedShipmentDate"; Date)
        {

        }
        field(140; "ActualShipmentDate"; Date)
        {

        }
        field(150; "QtyShipped"; Decimal)
        {

        }

        field(160; "RequestedDeliveryDate"; Date)
        {

        }
        field(165; QuoteValidToDate; Date)
        {

        }
        field(170; AgentCode; Code[10])
        {

        }
        field(180; AgentServiceCode; Code[10])
        {

        }

        field(190; "EstDeliveryDateMin"; Date)
        {

        }
        field(200; "EstDeliveryDateMax"; Date)
        {

        }
        field(202; ActualDeliveryDateTime; DateTime)
        {


        }
        field(204; "PODEnabled"; Boolean)
        {

        }
        field(206; "PODReceived"; Boolean)
        {

        }
        field(208; "PODUrl"; Text[100])
        {

        }
        field(209; "MarkedAsReceivedByCustomer"; Boolean)
        {

        }

        field(210; TrackingAvailable; Boolean)
        {

        }
        field(220; PackageTrackingNo; Text[50])
        {

        }
        field(222; PackageTrackingURL; Text[100])
        {

        }
        field(230; GenericItemID; GUID)
        {

        }
        field(300; KgPrice; Decimal)
        {

        }
        field(310; UnitPrice; Decimal)
        {

        }
        field(240; "Ship-to Code"; Text[100])
        {

        }
        field(241; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }

        field(242; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(243; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(244; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';

        }
        field(239; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }

        field(245; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';

        }
        field(246; "Ship-to County"; Text[30])
        {
            CaptionClass = '5,1,' + "Ship-to Country/Region Code";
            Caption = 'Ship-to County';
        }
        field(247; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(249; "Document No."; Code[20])
        {

        }
        field(250; "External Document No."; Text[50])
        {

        }
        field(260; "Related Invoice Doc. No."; Code[20])
        {

        }
        field(270; "Related Invoice ID"; GUID)
        {

        }
        field(275; "Related Shipment Line ID"; GUID)
        {

        }
        field(276; "Related Warehouse Shipment No."; Code[20])
        {

        }
        field(280; "No. Of Non-Conformances"; Integer)
        {

        }
    }

    keys
    {
        key(PK; CustomerID, DocumentType, DocumentID, "Line No.", "No.")
        {
            Clustered = true;
        }
    }

    var


    procedure LoadDataFromFilters(CustomerIdFilter: Text)
    var
        Item: Record Item;
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        LineUnitOfMeasure: Record "Item Unit of Measure";
        UnitOfMeasure: Record "Unit of Measure";
        SalesHeader: Record "Sales Header";
        ShipmentLine: Record "Sales Shipment Line";
        ShipmentHeader: Record "Sales Shipment Header";
        TempSalesInvLine: Record "Sales Invoice Line" temporary;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        WhseShipline: Record "Posted Whse. Shipment Line";
        Vendor: Record Vendor;


    begin

        Customer.GetBySystemId(CustomerIdFilter);

        //Get by sales order lines
        SalesLine.SetRange("Sell-to Customer No.", Customer."No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Outstanding Quantity", '>0');
        SalesLine.SetFilter("Planned Shipment Date", '<=t+2m');

        If SalesLine.FindSet(false, false) then
            repeat
                clear(Rec);
                Item.Get(SalesLine."No.");
                Rec.CustomerLineStatus := Rec.CustomerLineStatus::OnOrder;
                Rec.CustomerID := CustomerIdFilter;
                Rec."Document No." := SalesLine."Document No.";
                Rec."No." := Item."No.";
                Rec.ItemID := Item.SystemId;
                Rec."Line No." := SalesLine."Line No.";
                Rec.Description := Item.Description;
                Rec."Net Weight" := Item."Net Weight";
                Rec."Alternative Names" := Item."TFB Alt. Names";
                Rec.Blocked := Item.Blocked;
                Rec."Base Unit of Measure" := Item."Base Unit of Measure";
                Rec."Unit of Measure ID" := Item."Unit of Measure Id";
                Rec.UnitPrice := salesline."Unit Price";
                Rec.KgPrice := TFBPricingLogic.CalculatePriceUnitByUnitPrice(Item."No.", salesLine."Unit of Measure Code", Enum::"TFB Price Unit"::KG, SalesLine."Unit Price");
                If Item."TFB Vendor is Agent" then
                    Rec."Vendor No." := Item."TFB Item Manufacturer/Brand"
                else
                    Rec."Vendor No." := Item."Vendor No.";

                If Vendor.Get(Rec."Vendor No.") then
                    Rec."Vendor Id" := Vendor.SystemId;

                Rec.GenericItemID := Item."TFB Generic Item ID";
                Rec."Country/Region of Origin Code" := Item."Country/Region of Origin Code";


                GetTransportDetails(SalesLine."Sell-to Customer No.", SalesLine."Shipping Agent Code", SalesLine."Shipping Agent Service Code", SalesLine."Planned Shipment Date", '');
                Rec.PackageTrackingNo := '';
                PerPallet := GetPerPallet(Item);

                SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");


                LineUnitOfMeasure.Get(Item."No.", SalesLine."Unit of Measure Code");
                UnitOfMeasure.Get(LineUnitOfMeasure.Code);
                Rec."Unit of Measure ID" := UnitOfMeasure.SystemId;

                Rec.DocumentID := SalesHeader.SystemId;
                Rec.DocumentType := Rec.DocumentType::Order;
                Rec.OrderDate := SalesHeader."Order Date";
                Rec.QtyPendingDelivery := SalesLine."Outstanding Qty. (Base)";
                Rec.PlannedShipmentDate := SalesLine."Planned Shipment Date";
                Rec.RequestedDeliveryDate := SalesLine."Requested Delivery Date";
                Rec."External Document No." := SalesHeader."External Document No.";
                Rec."Ship-to Code" := SalesHeader."Ship-to Code";
                Rec."Ship-to Name" := SalesHeader."Ship-to Name";
                Rec."Ship-to Contact" := SalesHeader."Ship-to Contact";
                Rec."Ship-to Address" := SalesHeader."Ship-to Address";
                Rec."Ship-to Address 2" := SalesHeader."Ship-to Address 2";
                Rec."Ship-to City" := SalesHeader."Ship-to City";
                Rec."Ship-to County" := SalesHeader."Ship-to County";
                Rec."Ship-to Post Code" := SalesHeader."Ship-to Post Code";
                Rec."Ship-to Country/Region Code" := SalesHeader."Ship-to Country/Region Code";

                Rec.Insert();
            until SalesLine.Next() = 0;



        //Get by sales quote lines
        SalesLine.SetRange("Sell-to Customer No.", Customer."No.");
        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Quote);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        SalesLine.SetFilter("Quantity (Base)", '>0');


        If SalesLine.FindSet(false, false) then
            repeat
                clear(Rec);
                Item.Get(SalesLine."No.");
                Rec.CustomerLineStatus := Rec.CustomerLineStatus::OnQuote;
                Rec.CustomerID := CustomerIdFilter;
                Rec."Document No." := SalesLine."Document No.";
                Rec."No." := Item."No.";
                Rec.ItemID := Item.SystemId;
                Rec."Line No." := SalesLine."Line No.";
                Rec.Description := Item.Description;
                Rec."Net Weight" := Item."Net Weight";
                Rec."Alternative Names" := Item."TFB Alt. Names";
                Rec.Blocked := Item.Blocked;
                Rec."Base Unit of Measure" := Item."Base Unit of Measure";
                Rec."Unit of Measure ID" := Item."Unit of Measure Id";
                Rec.UnitPrice := salesline."Unit Price";
                Rec.KgPrice := TFBPricingLogic.CalculatePriceUnitByUnitPrice(Item."No.", salesLine."Unit of Measure Code", Enum::"TFB Price Unit"::KG, SalesLine."Unit Price");

                If Item."TFB Vendor is Agent" then
                    Rec."Vendor No." := Item."TFB Item Manufacturer/Brand"
                else
                    Rec."Vendor No." := Item."Vendor No.";

                If Vendor.Get(Rec."Vendor No.") then
                    Rec."Vendor Id" := Vendor.SystemId;

                Rec.GenericItemID := Item."TFB Generic Item ID";
                Rec."Country/Region of Origin Code" := Item."Country/Region of Origin Code";


                GetTransportDetails(SalesLine."Sell-to Customer No.", SalesLine."Shipping Agent Code", SalesLine."Shipping Agent Service Code", SalesLine."Planned Shipment Date", '');
                Rec.PackageTrackingNo := '';
                PerPallet := GetPerPallet(Item);

                SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");


                LineUnitOfMeasure.Get(Item."No.", SalesLine."Unit of Measure Code");
                UnitOfMeasure.Get(LineUnitOfMeasure.Code);
                Rec."Unit of Measure ID" := UnitOfMeasure.SystemId;

                Rec.DocumentID := SalesHeader.SystemId;
                Rec.DocumentType := Rec.DocumentType::Quote;
                Rec.OrderDate := SalesHeader."Order Date";
                Rec.QuoteValidToDate := SalesHeader."Quote Valid Until Date";
                Rec.QtyPendingDelivery := SalesLine."Outstanding Qty. (Base)";
                Rec.PlannedShipmentDate := SalesLine."Planned Shipment Date";
                Rec.RequestedDeliveryDate := SalesLine."Requested Delivery Date";
                Rec."External Document No." := SalesHeader."External Document No.";
                Rec."Ship-to Code" := SalesHeader."Ship-to Code";
                Rec."Ship-to Name" := SalesHeader."Ship-to Name";
                Rec."Ship-to Contact" := SalesHeader."Ship-to Contact";
                Rec."Ship-to Address" := SalesHeader."Ship-to Address";
                Rec."Ship-to Address 2" := SalesHeader."Ship-to Address 2";
                Rec."Ship-to City" := SalesHeader."Ship-to City";
                Rec."Ship-to County" := SalesHeader."Ship-to County";
                Rec."Ship-to Post Code" := SalesHeader."Ship-to Post Code";
                Rec."Ship-to Country/Region Code" := SalesHeader."Ship-to Country/Region Code";

                Rec.Insert();
            until SalesLine.Next() = 0;

        ShipmentLine.SetRange("Sell-to Customer No.", Customer."No.");
        ShipmentLine.SetRange(Type, ShipmentLine.Type::Item);
        ShipmentLine.SetFilter(Quantity, '>0');
        ShipmentLine.SetFilter("Posting Date", '>t-1m'); //Set for previous two weeks


        If ShipmentLine.FindSet(false, false) then
            repeat
                clear(Rec);
                Item.Get(ShipmentLine."No.");
                Rec.CustomerID := CustomerIdFilter;
                Rec.CustomerLineStatus := Rec.CustomerLineStatus::Dispatched;
                Rec.DocumentType := Rec.DocumentType::Shipment;
                Rec."No." := Item."No.";
                Rec.ItemID := Item.SystemId;
                Rec."Line No." := ShipmentLine."Line No.";
                Rec.Description := Item.Description;
                Rec."Net Weight" := Item."Net Weight";
                Rec."Alternative Names" := Item."TFB Alt. Names";
                Rec.Blocked := Item.Blocked;
                Rec."Base Unit of Measure" := Item."Base Unit of Measure";
                Rec."Unit of Measure ID" := Item."Unit of Measure Id";
                Rec.UnitPrice := salesline."Unit Price";
                Rec.KgPrice := TFBPricingLogic.CalculatePriceUnitByUnitPrice(Item."No.", salesLine."Unit of Measure Code", Enum::"TFB Price Unit"::KG, SalesLine."Unit Price");

                If Item."TFB Vendor is Agent" then
                    Rec."Vendor No." := Item."TFB Item Manufacturer/Brand"
                else
                    Rec."Vendor No." := Item."Vendor No.";

                If Vendor.Get(Rec."Vendor No.") then
                    Rec."Vendor Id" := Vendor.SystemId;

                Rec.GenericItemID := Item."TFB Generic Item ID";
                Rec."Country/Region of Origin Code" := Item."Country/Region of Origin Code";



                ShipmentHeader.Get(ShipmentLine."Document No.");
                Rec."Document No." := ShipmentHeader."Order No.";
                Rec."External Document No." := ShipmentHeader."External Document No.";
                Rec.DocumentID := ShipmentHeader.SystemId;
                Rec."Related Shipment Line ID" := ShipmentLine.SystemId;
                Rec.OrderDate := ShipmentHeader."Order Date";
                GetTransportDetails(ShipmentHeader."Sell-to Customer No.", ShipmentHeader."Shipping Agent Code", ShipmentHeader."Shipping Agent Service Code", ShipmentHeader."Posting Date", ShipmentHeader."Package Tracking No.");
                Rec.PackageTrackingNo := ShipmentHeader."Package Tracking No.";
                PerPallet := GetPerPallet(Item);

                ShipmentLine.GetSalesInvLines(TempSalesInvLine);
                if TempSalesInvLine.FindFirst() then begin
                    Rec."Related Invoice Doc. No." := TempSalesInvLine."Document No.";
                    SalesInvoiceHeader.SetLoadFields("Posting Date", "No.");
                    SalesInvoiceHeader.Get(TempSalesInvLine."Document No.");
                    Rec."Related Invoice ID" := SalesInvoiceHeader.SystemId;
                end;

                WhseShipline.SetLoadFields("Whse. Shipment No.");
                WhseShipline.SetRange("Posted Source No.", ShipmentLine."Document No.");
                WhseShipline.SetRange("Posted Source Document", WhseShipline."Posted Source Document"::"Posted Shipment");

                If WhseShipline.FindFirst() then
                    Rec."Related Warehouse Shipment No." := WhseShipline."Whse. Shipment No.";


                Rec.QtyShipped := ShipmentLine."Quantity (Base)";
                Rec.PlannedShipmentDate := ShipmentLine."Planned Shipment Date";
                Rec.RequestedDeliveryDate := ShipmentLine."Requested Delivery Date";
                Rec.ActualShipmentDate := ShipmentLine."Posting Date";
                Rec."External Document No." := ShipmentHeader."External Document No.";
                Rec."Ship-to Code" := ShipmentHeader."Ship-to Code";
                Rec."Ship-to Name" := ShipmentHeader."Ship-to Name";
                Rec."Ship-to Address" := ShipmentHeader."Ship-to Address";
                Rec."Ship-to Address 2" := ShipmentHeader."Ship-to Address 2";
                Rec."Ship-to City" := ShipmentHeader."Ship-to City";
                Rec."Ship-to Contact" := ShipmentHeader."Ship-to Contact";
                Rec."Ship-to County" := ShipmentHeader."Ship-to County";
                Rec."Ship-to Post Code" := ShipmentHeader."Ship-to Post Code";
                Rec."Ship-to Country/Region Code" := ShipmentHeader."Ship-to Country/Region Code";
                Rec."No. Of Non-Conformances" := NonConformanceCount(ShipmentLine);

                Rec.Insert();
            until ShipmentLine.Next() = 0;
    end;

    local procedure NonConformanceCount(ShipmentLine: Record "Sales Shipment Line"): Integer

    var


    begin
        Exit(GetNonConformances(ShipmentLine).Count());
    end;

    local procedure GetNonConformances(ShipmentLine: Record "Sales Shipment Line") TempNCR: Record "TFB Non-Conformance Report" temporary

    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        NCR: Record "TFB Non-Conformance Report";
    begin
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Sale);
        ItemLedgerEntry.SetRange("Document No.", ShipmentLine."Document No.");
        ItemLedgerEntry.SetRange("Document Line No.", ShipmentLine."Line No.");
        ItemLedgerEntry.SetRange("Document Type", ItemLedgerEntry."Document Type"::"Sales Shipment");
        TempNCR.DeleteAll();

        If ItemLedgerEntry.FindSet(false, false) then
            repeat
                NCR.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                If NCR.FindSet(false, false) then
                    repeat
                        TempNCR.Init();
                        TempNCR := NCR;
                        TempNCR.Insert();
                    until NCR.Next() = 0;

            until ItemLedgerEntry.Next() = 0;

    end;

    local procedure GetTransportDetails(CustomerNo: Code[20]; "Shipping Agent Code": Code[10]; "Shipping Agent Service Code": Code[10]; PlannedShipmentDate: Date; PackageTrackingNo: Text[30]): Boolean

    var
        ShippingAgentServices: Record "Shipping Agent Services";
        CustomCalendarChange: Array[2] of Record "Customized Calendar Change";
        ShippingAgent: Record "Shipping Agent";
        Location: record Location;
        CalendarMgmt: CodeUnit "Calendar Management";

    begin
        ShippingAgentServices.Get("Shipping Agent Code", "Shipping Agent Service Code");
        Rec.AgentCode := ShippingAgentServices."Shipping Agent Code";
        Rec.AgentServiceCode := ShippingAgentServices.Code;

        CustomCalendarChange[1].SetSource(Enum::"Calendar Source Type"::Location, Location.Code, '', '');
        CustomCalendarChange[2].SetSource(Enum::"Calendar Source Type"::Customer, CustomerNo, '', '');
        Rec.EstDeliveryDateMin := CalendarMgmt.CalcDateBOC('', CalcDate(ShippingAgentServices."Shipping Time", PlannedShipmentDate), CustomCalendarChange, false);

        If format(ShippingAgentServices."TFB Shipping Time Max") <> '' then
            Rec.EstDeliveryDateMax := CalendarMgmt.CalcDateBOC('', CalcDate(ShippingAgentServices."TFB Shipping Time Max", PlannedShipmentDate), CustomCalendarChange, false)
        else
            Rec.EstDeliveryDateMax := EstDeliveryDateMin;

        If ShippingAgent.Get(Rec.AgentCode) then
            Rec.TrackingAvailable := (ShippingAgent."Internet Address" <> '') and (PackageTrackingNo <> ''); //internet address assumed to be trackingis available

        If TrackingAvailable then PackageTrackingURL := Text.CopyStr(ShippingAgent.GetTrackingInternetAddr(PackageTrackingNo), 1, 100);
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




    var
        TFBPricingLogic: CodeUnit "TFB Pricing Calculations";

}