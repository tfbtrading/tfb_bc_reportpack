#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 53005 "TFB Customer Order Status"
{
    WordLayout = './Layouts/TFB Customer Order Status.docx';
    DefaultLayout = Word;
    Caption = 'Customer Order Status';
    UseRequestPage = true;
    DataAccessIntent = ReadOnly;
    ApplicationArea = All;
    PdfFontEmbedding = Yes;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Customer; Customer)
        {
            CalcFields = "Balance (LCY)", "Balance Due (LCY)";
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1; 1) { } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Customer; ReportForNavWriteDataItem('Customer', Customer)) { }
            dataitem("Sales Line"; "Sales Line")
            {

                DataItemTableView = sorting("Planned Shipment Date") where("Document Type" = const(Order), Type = const(Item));
                RequestFilterFields = "No.";
                DataItemLink = "Sell-to Customer No." = FIELD("No.");
                column(ReportForNavId_2; 2) { } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_SalesLine; ReportForNavWriteDataItem('SalesLine', "Sales Line")) { }
                column(StatusDescr; GetStockStatus("Sales Line"))
                {
                    IncludeCaption = false;
                }
                dataitem("Sales Header"; "Sales Header")
                {
                    DataItemLinkReference = "Sales Line";
                    DataItemLink = "No." = FIELD("Document No."), "Document Type" = FIELD("Document Type");
                    column(ReportForNavId_3; 3) { } // Autogenerated by ForNav - Do not delete
                    column(ReportForNav_SalesHeader; ReportForNavWriteDataItem('SalesHeader', "Sales Header")) { }
                    trigger OnPreDataItem();
                    begin
                        "Sales Header".SetView(ReportForNav.OnPreDataItemView('SalesHeader', "Sales Header"));
                    end;

                }
                trigger OnPreDataItem();
                begin
                    "Sales Line".SetView(ReportForNav.OnPreDataItemView('SalesLine', "Sales Line"));
                end;

            }
            dataitem("Sales Invoice Line"; "Sales Invoice Line")
            {

                DataItemTableView = sorting("Posting Date");
                RequestFilterFields = "No.";
                DataItemLink = "Sell-to Customer No." = FIELD("No.");
                column(ReportForNavId_4; 4) { } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_SalesInvoiceLine; ReportForNavWriteDataItem('SalesInvoiceLine', "Sales Invoice Line")) { }
                dataitem("Sales Invoice Header"; "Sales Invoice Header")
                {
                    DataItemLinkReference = "Sales Invoice Line";
                    DataItemLink = "No." = FIELD("Document No.");
                    column(ReportForNavId_5; 5) { } // Autogenerated by ForNav - Do not delete
                    column(ReportForNav_InvoiceHeader; ReportForNavWriteDataItem('InvoiceHeader', "Sales Invoice Header")) { }
                    trigger OnPreDataItem();
                    begin
                        "Sales Invoice Header".SetView(ReportForNav.OnPreDataItemView('InvoiceHeader', "Sales Invoice Header"));
                    end;

                }
                trigger OnPreDataItem();
                begin
                    "Sales Invoice Line".SetFilter("Posting Date", StrSubstNo('> %1', CalcDate('<-7d>', Today())));
                    "Sales Invoice Line".SetFilter("Quantity (Base)", '>0');
                    "Sales Invoice Line".SetRange(Type, "Sales Invoice Line".Type::Item);
                    "Sales Invoice Line".SetView(ReportForNav.OnPreDataItemView('SalesInvoiceLine', "Sales Invoice Line"));
                end;

            }
            trigger OnPreDataItem();
            begin
                Customer.SetRange("Date Filter", 0D, today());
                Customer.SetView(ReportForNav.OnPreDataItemView('Customer', Customer));
            end;

        }
    }
    requestpage
    {

        SaveValues = false;
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ForNavOpenDesigner; ReportForNavOpenDesigner)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Design';
                        Visible = ReportForNavAllowDesign;
                    }
                }
            }
        }

    }

    trigger OnInitReport()
    begin
        ;
        ReportsForNavInit;

    end;

    trigger OnPostReport()
    begin




    end;

    trigger OnPreReport()
    begin
        ;
        ReportsForNavPre;
    end;

    procedure GetStockStatus(SalesLine: Record "Sales Line"): Text

    var
        Customer: Record Customer;
        Item: Record Item;
        UoM: Record "Unit of Measure";
        SalesOrder: Record "Sales Header";
        Invoice: Record "Sales Invoice Header";
        InvoiceLine: Record "Sales Invoice Line";
        LotNoInfo: Record "Lot No. Information";
        WhseShptLine: Record "Warehouse Shipment Line";
        Purchase: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Container: Record "TFB Container Entry";
        DemandResEntry: Record "Reservation Entry";
        SupplyResEntry: Record "Reservation Entry";
        LedgerEntry: Record "Item Ledger Entry";
        CoreSetup: Record "TFB Core Setup";
        Vendor: Record Vendor;

        PricingCU: CodeUnit "TFB Pricing Calculations";


        Count: Integer;

        BodyBuilder: TextBuilder;
        LineBuilder: TextBuilder;

        tdTxt: label '<td valign="top" style="line-height:15px;">%1</td>', Comment = '%1 = html content for the content of the table data cell';
        DeliverySLA: text;
        overdue, overCreditLimit, SuppressLine : Boolean;


        PricingUnit: Enum "TFB Price Unit";
        TempStatus: TextBuilder;

    begin

        if SalesLine."Qty. Shipped (Base)" = 0 then

            //Check if drop ship

            if not SalesLine."Drop Shipment" then

                //Check if anything is scheduled on warehouse shipment

                if SalesLine."Whse. Outstanding Qty." = 0 then begin

                    //Provide details of warehouse shipment
                    TempStatus.Append('Planned for dispatch');
                    if SalesLine."Reserved Qty. (Base)" = SalesLine."Outstanding Qty. (Base)" then begin

                        DemandResEntry.SetRange("Source ID", SalesLine."Document No.");
                        DemandResEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
                        DemandResEntry.SetRange("Item No.", SalesLine."No.");
                        DemandResEntry.SetRange(Positive, false);

                        if DemandResEntry.FindFirst() then begin

                            SupplyResEntry.SetRange(Positive, true);
                            SupplyResEntry.SetRange("Entry No.", DemandResEntry."Entry No.");

                            if SupplyResEntry.FindFirst() then
                                case SupplyResEntry."Source Type" of
                                    32: //Item Ledger Entry

                                        if LedgerEntry.Get(SupplyResEntry."Source Ref. No.") then begin

                                            TempStatus.Append(StrSubstNo(' from stock already in inventory'));

                                            LotNoInfo.SetRange("Item No.", LedgerEntry."Item No.");
                                            LotNoInfo.SetRange("Lot No.", LedgerEntry."Lot No.");
                                            LotNoInfo.SetRange("Variant Code", LedgerEntry."Variant Code");

                                            if LotNoInfo.FindFirst() then
                                                if (LotNoInfo.Blocked = true) and (LotNoInfo."TFB Date Available" > 0D) then
                                                    TempStatus.Append(StrSubstNo(' and pending release on %1', LotNoInfo."TFB Date Available"))

                                        end;

                                    39: //Purchase Order Entry
                                        begin
                                            PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
                                            PurchaseLine.SetRange("Line No.", SupplyResEntry."Source Ref. No.");
                                            PurchaseLine.SetRange("Document No.", SupplyResEntry."Source ID");

                                            if PurchaseLine.FindFirst() then
                                                case PurchaseLine."TFB Container Entry No." of
                                                    '':
                                                        TempStatus.Append(StrSubstNo(' based on arrival from local purchase order due into warehouse on %1', purchaseline."Expected Receipt Date"));

                                                    else
                                                        if Container.Get(PurchaseLine."TFB Container Entry No.") then
                                                            case Container.Status of

                                                                Container.Status::Planned:

                                                                    TempStatus.Append(StrSubstNo(' based on planned overseas container due for arrival on %1 and estimated to be available on %2', Container."Est. Arrival Date", Container."Est. Warehouse"));


                                                                Container.Status::ShippedFromPort:

                                                                    TempStatus.Append(StrSubstNo(' based on shipped container %1, due for arrival on %2 and estimated to be available on %3', Container."Container No.", Container."Est. Arrival Date", Container."Est. Warehouse"));


                                                                Container.Status::PendingClearance:
                                                                    begin
                                                                        TempStatus.Append(StrSubstNo(' based on container that arrived on %1.'));
                                                                        if Container."Fumigation Req." then
                                                                            TempStatus.Append(' Fumigation Req.');
                                                                        if Container."Inspection Req." or Container."IFIP Req." then
                                                                            TempStatus.Append(' Inspection Req.');
                                                                    end;
                                                            end;
                                                end;
                                        end;
                                end;
                        end;

                    end;
                    //Get reservation entries for this line
                end
                //Get Location of reservation

                else begin
                    TempStatus.Append('Being prepared by warehouse');
                    WhseShptLine.SetRange("Source Document", WhseShptLine."Source Document"::"Sales Order");
                    WhseShptLine.SetRange("Source No.", SalesLine."Document No.");
                    WhseShptLine.SetRange("Source Line No.", SalesLine."Line No.");

                    //if WhseShptLine.FindFirst() then
                    //ShipDatePlanned := WhseShptLine."Shipment Date"; //TODO Check if we need to add ship date
                end
            else begin
                //Get Vendor Details
                Clear(PurchaseLine);
                Purchase.SetRange("Document Type", Purchase."Document Type"::Order);
                Purchase.SetRange("No.", SalesLine."Purchase Order No.");
                if Purchase.FindFirst() then begin
                    if Purchase."TFB Delivery SLA" = '' then begin
                        Vendor.Get(Purchase."Buy-from Vendor No.");
                        DeliverySLA := Vendor."TFB Delivery SLA"
                    end
                    else
                        DeliverySLA := Purchase."TFB Delivery SLA";

                    TempStatus.Append('Confirmed by ' + Purchase."Buy-from Vendor Name" + ' for drop-ship with SLA of ' + DeliverySLA);
                end else
                    TempStatus.Append('Pending confirmation for drop-ship');
            end
        else

            if SalesLine."Qty. Shipped (Base)" < SalesLine."Quantity (Base)" then

                //Partially Shipped

                TempStatus.Append(format(SalesLine."Qty. Shipped (Base)") + ' already shipped. Remainder planned for dispatch.')
            else

                //Fully Shipped
                if SalesLine."Qty. Invoiced (Base)" = SalesLine."Qty. Shipped (Base)" then begin
                    TempStatus.Append('Shipped and invoiced');
                    SuppressLine := true;
                end
                else
                    TempStatus.Append('Shipped, but pending invoicing');

        Exit(TempStatus.ToText());
    end;

    // --> Reports ForNAV Autogenerated code - do not delete or modify
    var
        ReportForNav: Codeunit "ForNAV Report Management";
        ReportForNavTotalsCausedBy: Integer;
        ReportForNavInitialized: Boolean;
        ReportForNavShowOutput: Boolean;
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

    local procedure ReportForNavSetTotalsCausedBy(value: Integer)
    begin
        ReportForNavTotalsCausedBy := value;
    end;

    local procedure ReportForNavSetShowOutput(value: Boolean)
    begin
        ReportForNavShowOutput := value;
    end;

    local procedure ReportForNavInit(jsonObject: JsonObject)
    begin
        ReportForNav.Init(jsonObject, CurrReport.ObjectId);
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
            'Customer':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$Customer$CurrentKey$Text', Customer.CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
            'SalesHeader':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$SalesHeader$CurrentKey$Text', "Sales Header".CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
            'InvoiceHeader':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$InvoiceHeader$CurrentKey$Text', "Sales Invoice Header".CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
        end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
