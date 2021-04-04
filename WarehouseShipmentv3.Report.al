Report 53003 "TFB Warehouse Shipment v3"
{
    Caption = 'Warehouse Shipment v2';
    UsageCategory = ReportsAndAnalysis;
    WordLayout = './Layouts/ForNAV Warehouse Shipment.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Header; "Warehouse Shipment Header")
        {
            RequestFilterFields = "No.", "Location Code";
            column(ReportForNavId_1000000000; 1000000000) { } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Header; ReportForNavWriteDataItem('Header', Header)) { }
            dataitem(Line; "Warehouse Shipment Line")
            {
                CalcFields = "Pick Qty.";
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = sorting("No.", "Bin Code");
                column(ReportForNavId_1000000001; 1000000001) { } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_Line; ReportForNavWriteDataItem('Line', Line)) { }
                dataitem(TrackingSpecification; "Tracking Specification")
                {
                    UseTemporary = true;
                    column(ReportForNavId_1000000002; 1000000002) { } // Autogenerated by ForNav - Do not delete
                    column(ReportForNav_TrackingSpecification; ReportForNavWriteDataItem('TrackingSpecification', TrackingSpecification)) { }
                }
                dataitem(BOMComponent; "BOM Component")
                {
                    DataItemLink = "Parent Item No." = FIELD("Item No.");
                    DataItemTableView = sorting("Parent Item No.", "Line No.");
                    column(ReportForNavId_1000000003; 1000000003) { } // Autogenerated by ForNav - Do not delete
                    column(ReportForNav_BOMComponent; ReportForNavWriteDataItem('BOMComponent', BOMComponent)) { }
                }
                dataitem(CommentLine; "Sales Comment Line")
                {
                    DataItemLink = "No." = FIELD("Source No."), "Document Line No." = FIELD("Source Line No.");
                    DataItemTableView = sorting("Document Type", "No.", "Document Line No.", "Line No.") where("Document Type" = const(Order));
                    column(ReportForNavId_1000000004; 1000000004) { } // Autogenerated by ForNav - Do not delete
                    column(ReportForNav_CommentLine; ReportForNavWriteDataItem('CommentLine', CommentLine)) { }
                }
                trigger OnAfterGetRecord();
                begin
                    GetTrackingSpecification();
                end;

            }
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
                        ToolTip = 'Specifies that a download file will enable designing';
                        Caption = 'Design';
                        Visible = ReportForNavAllowDesign;
                        trigger OnValidate()
                        begin
                            ForNAVReportManagement.LaunchDesigner(ReportForNavOpenDesigner);
                            CurrReport.RequestOptionsPage.Close();
                        end;

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
        Codeunit.Run(Codeunit::"ForNAV First Time Setup");
        Commit();
        LoadWatermark();
        ;
        ;
        ReportsForNavInit();
    end;

    trigger OnPostReport()
    begin

    end;

    trigger OnPreReport()
    begin
        ;
        ;
        ReportsForNavPre();
    end;

    local procedure LoadWatermark()
    var
        ForNAVSetup: Record "ForNAV Setup";

    begin

        ForNAVSetup.Get();
        ForNAVSetup.CalcFields("List Report Watermark");
        if not ForNAVSetup."List Report Watermark".Hasvalue() then
            exit;

        ForNAVReportManagement.LoadWatermarkImage(ForNAVSetup.GetListReportWatermark());
    end;

    local procedure GetTrackingSpecification()
    var
        SalesLine: Record "Sales Line";
        ForNAVGetTracking: Codeunit "ForNAV Get Tracking";
        RecRef: RecordRef;
    begin
        TrackingSpecification.DeleteAll();

        SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange("Document No.", Line."Source No.");
        SalesLine.SetRange("Line No.", Line."Source Line No.");
        If SalesLine.FindFirst() then begin
            RecRef.GetTable(SalesLine);
            ForNAVGetTracking.GetTrackingSpecification(TrackingSpecification, RecRef);
        end;
    end;

    // --> Reports ForNAV Autogenerated code - do not delete or modify
    var
        ForNAVReportManagement: Codeunit "ForNAV Report Management";
        ReportForNavInitialized: Boolean;
       
        ReportForNavOpenDesigner: Boolean;
        [InDataSet]
        ReportForNavAllowDesign: Boolean;

    local procedure ReportsForNavInit()
    var
        id: Integer;
    begin
        Evaluate(id, CopyStr(CurrReport.ObjectId(false), StrPos(CurrReport.ObjectId(false), ' ') + 1));
        ForNAVReportManagement.OnInit(id, ReportForNavAllowDesign);
    end;

    local procedure ReportsForNavPre()
    begin
        if ForNAVReportManagement.LaunchDesigner(ReportForNavOpenDesigner) then CurrReport.Quit();
    end;

    

    local procedure ReportForNavInit(jsonObject: JsonObject)
    begin
        ForNAVReportManagement.Init(jsonObject, CurrReport.ObjectId());
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
            'Header':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$Header$CurrentKey$Text', Header.CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
            'TrackingSpecification':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$TrackingSpecification$CurrentKey$Text', TrackingSpecification.CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
        end;
        ForNAVReportManagement.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
