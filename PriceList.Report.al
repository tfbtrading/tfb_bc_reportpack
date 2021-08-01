Report 53120 "TFB Price List"
{
    Caption = 'Standard Price List';
    UsageCategory = Lists;
    ApplicationArea = All;
    WordLayout = '.\Layouts\TFB Price List.docx';
    DataAccessIntent = ReadOnly;
    EnableExternalImages = true;

    DefaultLayout = Word;

    dataset
    {
        dataitem(Customer; Customer)
        {
            PrintOnlyIfDetail = true;
            DataItemTableView = sorting("Customer Price Group", "No.") order(Descending);
            RequestFilterFields = "No.", "Customer Price Group";
            column(ReportForNavId_2; 2) { } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Customer; ReportForNavWriteDataItem('Customer', Customer)) { }
            column(EffectiveDate; format(_EffectiveDate))
            {
                IncludeCaption = false;
            }
            column(PriceHistory; _PriceHistory)
            {
                IncludeCaption = false;
            }
            dataitem(Item; Item)
            {
                DataItemTableView = sorting("Item Category Code", Description);
                RequestFilterFields = "Item Category Code";
                column(ReportForNavId_3; 3) { } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_Item; ReportForNavWriteDataItem('Item', Item)) { }
                column(KilogramPrice; KgPrice)
                {
                    IncludeCaption = false;
                }
                column(UnitPrice; UnitPrice)
                {
                    IncludeCaption = false;
                }
                column(OldKgPrice; OldKgPrice)
                {
                    IncludeCaption = false;
                }
                column(OldUnitPrice; OldUnitPrice)
                {
                    IncludeCaption = false;
                }
                column(PriceChangeDate; PriceChangeDate)
                {
                    IncludeCaption = false;
                }
                column(DaysSincePriceChange; DaysSincePriceChange)
                {
                    IncludeCaption = false;
                }
                column(Availability; Availability)
                {
                    IncludeCaption = false;
                }
                column(EstETA; EstETA)
                {
                    IncludeCaption = false;
                }
                column(AQISFactors; AQISFactors)
                {
                    IncludeCaption = false;
                }
                column(UnitType; UnitType)
                {
                    IncludeCaption = false;
                }
                column(PerPallet; PerPallet)
                {
                    IncludeCaption = false;
                }
                column(LastDispatchDate; LastDispatchDate)
                {
                    IncludeCaption = false;
                }
                column(QtyPendingDelivery; QtyPendingDelivery)
                {
                    IncludeCaption = false;

                }

                column(BookMarkedItem; BookMarkedItem)
                {
                    IncludeCaption = false;
                }
                column(BookmarkHTML; BookmarkHTML)
                {
                    IncludeCaption = false;
                }
                column(FavouriteItem; FavouriteItem)
                {
                    IncludeCaption = false;
                }
                column(flagHTML; FlagHTML)
                {
                    IncludeCaption = false;
                }
                trigger OnPreDataItem();

                begin
                    SetRange(Type, Type::Inventory);
                    SetRange("Sales Blocked", false);
                    SetRange("TFB Publishing Block", false);
                    SetAscending("Item Category Code", false);
                    clear(BookMarkedItems);
                    ReportForNav.OnPreDataItem('Item', Item);
                end;

                trigger OnAfterGetRecord();
                begin
                    GetSalesListPricing(Customer."No.", Customer."Customer Price Group", Item);
                    // GetPricing(Customer."No.", Customer."Customer Price Group", Item); Obselete Code
                    GetAvailability(Item);
                    QtyPendingDelivery := GetQtyPendingDelivery(Item."No.", Customer."No.");
                    AQISFactors := Text.CopyStr(GetAQISFactors(Item), 1, 50);
                    UnitType := Text.CopyStr(GetUnitType(Item), 1, 50);
                    PerPallet := GetPerPallet(Item);
                    LastDispatchDate := GetLastDispatchDate("No.", Customer."No.");
                    FavouriteItem := GetFavouriteStatus("No.", Customer."No.");
                    BookMarkedItem := GetBookmarkStatus("No.", Customer."No.");
                    FlagHTML := Text.CopyStr(GetFlagHTML("No."), 1, 512);
                    If BookMarkedItem = true then
                        BookmarkHTML := Text.CopyStr(BookmarkHTMLResource, 1, 512)
                    else
                        BookmarkHTML := '';

                    If BookMarkedItem then begin
                        BookmarkedItems.Init();
                        BookmarkedItems.TransferFields(Item, true);
                        BookmarkedItems.KgPrice := KgPrice;
                        BookmarkedItems.UnitPrice := UnitPrice;
                        BookmarkedItems.OldKgPrice := OldKgPrice;
                        BookmarkedItems.OldUnitPrice := OldUnitPrice;
                        BookmarkedItems.PriceChangeDate := PriceChangeDate;
                        BookmarkedItems.DaysSincePriceChange := DaysSincePriceChange;
                        BookmarkedItems.Availability := Availability;
                        BookmarkedItems.EstETA := EstETA;
                        BookmarkedItems.AQISFactors := AQISFactors;
                        BookmarkedItems.UnitType := UnitType;
                        BookmarkedItems.PerPallet := PerPallet;
                        BookmarkedItems.BookMarkedItem := BookMarkedItem;
                        BookmarkedItems.BookmarkHTML := BookmarkHTML;
                        BookMarkedItems.FavouritedItem := FavouriteItem;
                        BookMarkedItems.flagHTML := FlagHTML;
                        BookmarkedItems.Insert();
                    end;

                end;

                trigger OnPostDataItem();

                begin

                end;

            }
            dataitem(BookMarkedItems; "TFB Price List Item Buffer")
            {
                UseTemporary = true;
                column(ReportForNavId_4; 4) { } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_BookMarkedItems; ReportForNavWriteDataItem('BookMarkedItems', BookMarkedItems)) { }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('BookMarkedItems', BookMarkedItems);
                end;

            }
            trigger OnPreDataItem();
            begin
                ReportForNav.OnPreDataItem('Customer', Customer);
            end;

        }
    }


    requestpage
    {

        SaveValues = true;
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ForNavOpenDesigner; ReportForNavOpenDesigner)
                    {
                        ApplicationArea = All;
                        Caption = 'Design';
                        Visible = ReportForNavAllowDesign;
                        ToolTip = 'Specify that a designer file is downloaded for editing';
                        trigger OnValidate()
                        begin
                            ReportForNav.LaunchDesigner(ReportForNavOpenDesigner);
                            CurrReport.RequestOptionsPage.Close();
                        end;

                    }
                    field(EffectiveDate; _EffectiveDate)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specify the date on which the price list should be based';
                        Caption = 'Effective Date';
                        Visible = true;
                    }
                    field(PriceHistory; _PriceHistory)
                    {
                        ApplicationArea = All;
                        Caption = 'Price History Comparison Duration';
                        Visible = true;
                        ToolTip = ' Enter a date formulae represents how far back you want to explore dates. Default is -1Y if nothing is entered';
                    }
                }
            }
        }

        actions
        {
        }
        trigger OnOpenPage()
        begin
            ReportForNavOpenDesigner := false;
        end;
    }



    trigger OnInitReport()
    begin
        BookmarkHTMLResource := GetBookmarkHTML();
        ;
        ReportsForNavInit();
    end;

    trigger OnPostReport()
    begin



    end;

    trigger OnPreReport()
    begin
        ;
        ReportsForNavPre();

    end;

    var

        PricingCalculations: CodeUnit "TFB Pricing Calculations";

        _PriceHistory: DateFormula;
        _EffectiveDate: Date;
        KgPrice: Decimal;
        OldKgPrice: Decimal;
        OldUnitPrice: Decimal;
        QtyPendingDelivery: Decimal;
        FavouriteItem: Boolean;

        PriceChangeDate: Text[100];
        DaysSincePriceChange: Integer;
        UnitPrice: Decimal;
        Availability: Text[100];
        EstETA: Text[50];
        AQISFactors: Text[50];
        UnitType: Text[50];
        PerPallet: Integer;
        LastDispatchDate: Date;
        BookMarkedItem: Boolean;
        FlagHTML: Text[512];
        BookmarkHTMLResource: Text;
        BookmarkHTML: Text[512];

    procedure SetEffectiveDate(NewDate: Date)

    begin
        If NewDate > 0D then
            _EffectiveDate := NewDate;
    end;

    procedure SetDuration(NewDuration: DateFormula)

    begin
        If not (format(NewDuration) = '') then
            _PriceHistory := NewDuration;
    end;

    local procedure GetFlagHTML(ItemNo: Code[20]): Text

    var

        Item: Record Item;
        HtmlBuilder: TextBuilder;

    begin

        If Item.Get(ItemNo) then begin

            HtmlBuilder.Append('<!DOCTYPE html><html><body><img src="https://flagpedia.net/data/flags/w580/%1.png" height="13" width="25" alt="Flag"></body></html>');
            HtmlBuilder.Replace('%1', LowerCase(Item."Country/Region of Origin Code"));

        end;
        Exit(HtmlBuilder.ToText());

    end;

    local procedure GetBookmarkHTML(): Text

    var
        HtmlBuilder: TextBuilder;
        BookMarkTxt: Label 'https://tfbdata001.blob.core.windows.net/pubresources/bookmarkicon1.png';

    begin
        HtmlBuilder.Append('<!DOCTYPE html><html><body><img src="%1" height="12" width="12" alt="Bookmark"></body></html>');
        HtmlBuilder.Replace('%1', BookMarkTxt);
        Exit(HtmlBuilder.ToText());
    end;

    local procedure GetSalesListPricing(CustNo: Code[20]; CustomerPriceGroup: Code[20]; Item: Record Item): Boolean

    var
        PriceAsset: Record "Price Asset";
        PriceListLine: Record "Price List Line";
        OldPriceListLine: Record "Price List Line";

        SearchDate: Date;
        OldStartDate: Date;
        CutOffDate: Date;
    begin

        KgPrice := 0;
        UnitPrice := 0;
        OldKgPrice := 0;
        OldUnitPrice := 0;
        PriceChangeDate := '';
        DaysSincePriceChange := 0;

        If _EffectiveDate = 0D then
            SearchDate := Today()
        else
            SearchDate := _EffectiveDate;

        If format(_PriceHistory) = '' then
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
                    PriceChangeDate := StrSubstNo('Last changed %1 days ago', _EffectiveDate - PriceListLine."Starting Date");
                    DaysSincePriceChange := _EffectiveDate - PriceListLine."Starting Date";
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

    local procedure GetAvailability(var ItemVar: Record Item): Boolean
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
        Availability := '';
        NextQtyRemaining := 0;
        If ItemVar."Safety Stock Quantity" = 0 then
            SafetyStock := 200 else
            SafetyStock := ItemVar."Safety Stock Quantity";

        If PurchasingCode.Get(ItemVar."Purchasing Code") then
            If PurchasingCode."Drop Shipment" then
                DropShip := true;


        //Item is not set as a drop ship item
        If DropShip then
            case ItemVar."TFB DropShip Avail." of
                ItemVar."TFB DropShip Avail."::"Out of Stock":
                    begin
                        Availability := 'Out of Stock';

                        If Item."TFB DropShip ETA" <> 0D then
                            EstETA := StrSubstNo('Est. ETA %1 ', Item."TFB DropShip ETA");
                    end;
                ItemVar."TFB DropShip Avail."::Restricted:
                    Availability := 'Low';
                ItemVar."TFB DropShip Avail."::Available:
                    Availability := 'Okay';
            end
        else begin
            Clear(ItemLedger);
            ItemLedger.SetRange("Item No.", ItemVar."No.");
            ItemLedger.SetFilter("Entry Type", '%1|%2|%3|%4', ItemLedger."Entry Type"::Purchase, ItemLedger."Entry Type"::"Positive Adjmt.", ItemLedger."Entry Type"::Transfer, ItemLedger."Entry Type"::"Assembly Output");
            ItemLedger.SetRange(Open, true);


            If ItemLedger.CalcSums("Remaining Quantity") then begin

                ResEntry.SetRange("Source Type", 32);
                ResEntry.SetRange("Item No.", ItemVar."No.");
                ResEntry.SetRange("Reservation Status", ResEntry."Reservation Status"::Reservation);
                ResEntry.SetRange(Positive, true);
                ResEntry.CalcSums("Qty. to Handle (Base)");
                QtyReserved := ResEntry."Qty. to Handle (Base)";
                QtyRemaining := ItemLedger."Remaining Quantity" - QtyReserved;


                Case QtyRemaining of
                    0:
                        begin
                            Availability := 'Out of Stock';

                            If GetDateOfNextOrderOrTransfer(ItemVar."No.", NextQtyRemaining, EstDateInt) then
                                EstETA := StrSubstNo('Est. ETA %1 ', EstDateInt);
                        end;
                    1 .. SafetyStock:
                        Availability := 'Low';
                    else
                        Availability := 'Okay';
                end;
            end;

        end;
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

    local procedure GetUnitType(var ItemVar: Record Item): Text

    var

        UnitOfMeasure: Record "Unit of Measure";


    begin

        If UnitOfMeasure.Get(ItemVar."Base Unit of Measure") then
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

    // --> Reports ForNAV Autogenerated code - do not delete or modify
    var
        ReportForNav: Codeunit "ForNAV Report Management";
        ReportForNavInitialized: Boolean;

        ReportForNavOpenDesigner: Boolean;
        [InDataSet]
        ReportForNavAllowDesign: Boolean;

    local procedure ReportsForNavInit()
    var
        id: Integer;
    begin
        Evaluate(id, CopyStr(CurrReport.ObjectId(false), StrPos(CurrReport.ObjectId(false), ' ') + 1));
        ReportForNav.OnInit(id, ReportForNavAllowDesign);
    end;

    local procedure ReportsForNavPre()
    begin
        if ReportForNav.LaunchDesigner(ReportForNavOpenDesigner) then CurrReport.Quit();
    end;



    local procedure ReportForNavInit(jsonObject: JsonObject)
    begin
        ReportForNav.Init(jsonObject, CurrReport.ObjectId());
    end;

    local procedure ReportForNavWriteDataItem(dataItemId: Text; rec: Variant): Text
    var
        values: Text;
        jsonObject: JsonObject;
        currLanguage: Integer;
    begin
        if not ReportForNavInitialized then begin
            ReportForNavInit(jsonObject);
            ReportForNavInitialized := true;
        end;

        case (dataItemId) of
            'BookMarkedItems':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$BookMarkedItems$CurrentKey$Text', BookMarkedItems.CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
        end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
