table 53150 "TFB Price History Buffer"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {

        field(1; "Customer ID"; GUID)
        {
            Caption = 'Customer ID';
        }
        field(5; "Item ID"; GUID)
        {
            Caption = 'Item ID';
        }

        field(7; "Price Type"; Enum "TFB Price History Type")
        {
            Caption = 'Price Type';
        }
        field(8; "Line No."; Integer)
        {
            Caption = 'Line No.';

        }
        field(10; Dated; Date)
        {
            Caption = 'Dated';
        }
        field(15; "Customer Price Group"; Code[20])
        {
            Caption = 'Pricing Group Code';
            TableRelation = "Customer Price Group";
        }
        field(20; "Unit Price"; Decimal)
        {
            Caption = 'Price Per Unit';
        }
        field(25; "Price Per Kg"; Decimal)
        {
            Caption = 'Price Per Kg';
        }
        field(30; "Price Source No."; Code[20])
        {
            Caption = 'Price Source No';
        }

    }

    keys
    {
        key(PK; "Customer ID", "Item ID", "Price Type", "Line No.")
        {
            Clustered = true;
        }
    }

    procedure LoadDataFromFilters(ItemIdFilter: Guid; CustomerIdFilter: Guid)

    var
        Item: Record Item;
        Customer: Record Customer;

    begin

        If not IsNullGuid(ItemIdFilter) and not IsNullGuid(CustomerIdFilter) then begin
            Item.GetBySystemId(ItemIdFilter);
            Customer.GetBySystemId(CustomerIdFilter);
        end;

        LoadPriceGroupHistory(Item, Customer);
        LoadCustomerPurchasePriceHistory(Item, Customer);


    end;


    local procedure LoadPriceGroupHistory(Item: record Item; Customer: record Customer)

    var
        PriceListLine: Record "Price List Line";
        PriceAsset: Record "Price Asset";
        _PriceHistory: DateFormula;
        SearchDate: Date;
        LineNo: Integer;

    begin


        SearchDate := Today();
        Evaluate(_PriceHistory, '-1Y');

        AsPriceAsset(Item."No.", PriceAsset);
        FilterPriceListLine(Customer."Customer Price Group", PriceAsset, PriceListLine, SearchDate, _PriceHistory, Customer."Currency Code", false);
        PriceListLine.SetCurrentKey("Starting Date");
        PriceListLine.SetAscending("Starting Date", true);


        If PriceListLine.FindSet(false, false) then
            repeat
                Clear(Rec);
                LineNo += 1;
                Rec."Customer ID" := Customer.SystemId;
                Rec."Item ID" := Item.SystemId;
                Rec."Price Type" := Rec."Price Type"::PriceList;
                Rec."Customer Price Group" := PriceListLine."Source No.";
                Rec."Line No." := LineNo;
                Rec."Unit Price" := PriceListLine."Unit Price";
                Rec."Price Per Kg" := PriceListLine.GetPriceAltPriceFromUnitPrice();
                Rec."Price Source No." := PriceListLine."Price List Code";
                Rec.Dated := PriceListLine."Starting Date";
                Rec.Insert();

            until PriceListLine.Next() = 0

    end;

    local procedure FilterPriceListLine(CustomerPriceGroup: Code[20]; PriceAsset: Record "Price Asset"; var PriceListLine: Record "Price List Line"; EffectiveDate: Date; PriceHistory: DateFormula; CurrencyCode: Code[20]; OpeningPrice: Boolean)
    var

    begin
        PriceListLine.SetRange("Asset Type", PriceAsset."Asset Type");
        PriceListLine.SetRange("Asset No.", PriceAsset."Asset No.");
        PriceListLine.SetFilter("Variant Code", '%1|%2', PriceAsset."Variant Code", '');
        PriceListLine.SetRange(Status, PriceListLine.Status::Active);
        PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Sale);
        PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::"Customer Price Group");
        PriceListLine.SetRange("Source No.", CustomerPriceGroup);
        PriceListLine.SetFilter("Amount Type", '%1|%2', PriceListLine."Amount Type"::Price, PriceListLine."Amount Type"::Any);
        If not OpeningPrice then
            PriceListLine.SetRange("Starting Date", CalcDate(PriceHistory, EffectiveDate), EffectiveDate);
        PriceListLine.SetFilter("Ending Date", '%1|<=%2', 0D, EffectiveDate);
        PriceListLine.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');

    end;


    local procedure AsPriceAsset(ItemNo: Code[20]; var PriceAsset: Record "Price Asset")

    begin
        PriceAsset.Init();
        PriceAsset."Asset Type" := PriceAsset."Asset Type"::Item;
        PriceAsset."Asset No." := ItemNo;


    end;


    local procedure LoadCustomerPurchasePriceHistory(Item: record Item; Customer: record Customer)

    var
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesInvoiceHeader: record "Sales Invoice Header";
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        LineNo: Integer;

    begin

        SalesInvoiceLine.SetRange("Sell-to Customer No.", Customer."No.");
        SalesInvoiceLine.SetRange("No.", Item."No.");
        SalesInvoiceLine.SetCurrentKey("Posting Date");
        SalesInvoiceLine.SetAscending("Posting Date", true);
        SalesInvoiceLine.SetFilter("Quantity (Base)", '>0');


        If SalesInvoiceLine.FindSet(false, false) then
            repeat


                SalesInvoiceHeader.SetLoadFields("No.", "Order No.", "Order Date");
                SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.");

                Clear(Rec);
                LineNo += 1;
                Rec."Customer ID" := Customer.SystemId;
                Rec."Item ID" := Item.SystemId;
                Rec."Price Type" := Rec."Price Type"::Purchase;
                Rec."Line No." := LineNo;
                Rec."Customer Price Group" := SalesInvoiceLine."Customer Price Group";
                Rec.Dated := SalesInvoiceHeader."Order Date";
                Rec."Unit Price" := SalesInvoiceLine."Unit Price" / SalesLine."Qty. per Unit of Measure";
                Rec."Price Per Kg" := PricingCU.CalculatePriceUnitByUnitPrice(Item."No.", SalesInvoiceLine."Unit of Measure Code", Enum::"TFB Price Unit"::KG, SalesInvoiceLine."Unit Price");
                Rec."Price Source No." := SalesInvoiceHeader."Order No.";
                Rec.Insert();
            until SalesInvoiceLine.Next() = 0;


        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Sell-to Customer No.", Customer."No.");
        SalesLine.SetRange("No.", Item."No.");
        SalesLine.SetFilter("Outstanding Qty. (Base)", '>0');
        SalesLine.SetCurrentKey("No.", "Line No.");
        SalesLine.SetFilter("Quantity (Base)", '>0');


        If SalesLine.FindSet(false, false) then
            repeat
                SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
                Clear(Rec);
                LineNo += 1;
                Rec."Customer ID" := Customer.SystemId;
                Rec."Item ID" := Item.SystemId;
                Rec."Line No." := LineNo;
                Rec."Price Type" := Rec."Price Type"::Purchase;
                Rec."Customer Price Group" := SalesLine."Customer Price Group";
                Rec.Dated := SalesHeader."Order Date";
                Rec."Unit Price" := SalesLine."Unit Price" / SalesLine."Qty. per Unit of Measure";
                Rec."Price Per Kg" := PricingCU.CalculatePriceUnitByUnitPrice(Item."No.", SalesLine."Unit of Measure Code", Enum::"TFB Price Unit"::KG, SalesLine."Unit Price");
                Rec."Price Source No." := SalesLine."Document No.";
                Rec.Insert();

            until SalesLine.Next() = 0;
    end;

    var
        PricingCU: CodeUnit "TFB Pricing Calculations";

}