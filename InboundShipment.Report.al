Report 53012 "TFB Inbound Shipment"
{
    WordLayout = './Layouts/TFB Inbound Shipment.docx';
    DefaultLayout = Word;
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    Caption = 'Inbound Shipment';

    dataset
    {
        dataitem(ContainerHeader; "TFB Container Entry")
        {
            RequestFilterHeading = 'Header Fields';
            RequestFilterFields = "No.", "Container No.";
            column(ReportForNavId_1; 1) { } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_ContainerHeader; ReportForNavWriteDataItem('ContainerHeader', ContainerHeader)) { }
            dataitem(ContainerContents; "TFB ContainerContents")
            {
                RequestFilterHeading = 'Contents';
                UseTemporary = true;
                column(ReportForNavId_2; 2) { } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_ContainerContents; ReportForNavWriteDataItem('ContainerContents', ContainerContents)) { }
            }

            trigger OnAfterGetRecord();

            begin

                PopulateContainerEntries(ContainerHeader, ContainerContents);

            end;
        }

    }


    requestpage
    {

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
                        ToolTip = 'Design report';
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

    /// <summary> 
    /// Description for PopulateContainerEntries.
    /// </summary>
    /// <param name="ContainerEntry">Parameter of type Record "TFB Container Entry".</param>
    /// <param name="Contents">Parameter of type Record "TFB ContainerContents" temporary.</param>
    local procedure PopulateContainerEntries(ContainerEntry: Record "TFB Container Entry"; var Contents: Record "TFB ContainerContents" temporary)

    var

    begin
        If ContainerEntry."Qty. On Transfer Rcpt" > 0 then
            ContainerMgmt.PopulateTransferLines(ContainerEntry, Contents)
        else
            if ContainerEntry."Qty. On Transfer Ship." > 0 then
                ContainerMgmt.PopulateTransferLines(ContainerEntry, Contents)
            else
                if ContainerEntry."Qty. On Transfer Order" > 0 then
                    ContainerMgmt.PopulateTransferLines(ContainerEntry, Contents)
                else
                    if ContainerENtry."Qty. On Purch. Rcpt" > 0 then
                        ContainerMgmt.PopulateReceiptLines(ContainerEntry, Contents)
                    else
                        ContainerMgmt.PopulateOrderOrderLines(ContainerEntry, Contents);


    end;

    var
        ContainerMgmt: CodeUnit "TFB Container Mgmt";

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
            'ContainerHeader':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$ContainerHeader$CurrentKey$Text', ContainerHeader.CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
            'ContainerContents':
                begin
                    currLanguage := GlobalLanguage;
                    GlobalLanguage := 1033;
                    jsonObject.Add('DataItem$ContainerContents$CurrentKey$Text', ContainerContents.CurrentKey);
                    GlobalLanguage := currLanguage;
                end;
        end;
        ForNAVReportManagement.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
