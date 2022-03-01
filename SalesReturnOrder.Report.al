#pragma warning disable AA0008, AA0018, AA0021, AA0072, AA0201, AA0206, AA0218, AA0228, AW0006 // ForNAV settings
Report 53050 "TFB Sales Return Order"
{
    WordLayout = './Layouts/TFB Sales Return Order.docx';
    DefaultLayout = Word;

    dataset
    {
        dataitem(Header; "Sales Header")
        {
            CalcFields = "Amount Including VAT", Amount;
            RequestFilterFields = "No.";
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(5));
            column(ReportForNavId_2; 2) { } // Autogenerated by ForNav - Do not delete
            column(ReportForNav_Header; ReportForNavWriteDataItem('Header', Header)) { }
            dataitem(Line; "Sales Line")
            {
                DataItemLink = "Document No." = field("No."), "Document Type" = field("Document Type");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ReportForNavId_3; 3) { } // Autogenerated by ForNav - Do not delete
                column(ReportForNav_Line; ReportForNavWriteDataItem('Line', Line)) { }
                trigger OnPreDataItem();
                begin
                    ReportForNav.OnPreDataItem('Line', Line);
                end;
            }
            trigger OnPreDataItem();
            begin
                ReportForNav.OnPreDataItem('Header', Header);
            end;
        }
    }

    requestpage
    {

        SaveValues = false;
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ForNavOpenDesigner; ReportForNavOpenDesigner)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Design';
                        Visible = ReportForNavAllowDesign;
                        trigger OnValidate()
                        begin
                            ReportForNav.LaunchDesigner(ReportForNavOpenDesigner);
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
        end;
        ReportForNav.AddDataItemValues(jsonObject, dataItemId, rec);
        jsonObject.WriteTo(values);
        exit(values);
    end;
    // Reports ForNAV Autogenerated code - do not delete or modify -->
}
