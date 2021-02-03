report 53000 "TFB Send Cust. Price Lists"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = True;
    UseRequestPage = True;
    Caption = 'Send Customer Price Lists';


    dataset
    {
        dataitem(Customer; Customer)
        {

            trigger OnPreDataItem()

            var
                PriceReport: Report "TFB Price List";
                Builder: CodeUnit "Report Xml Parameters Builder";

            begin
                SetRange("TFB Price List Recipient", true);
                SetFilter("E-Mail", '<>%1', '');
                //XMLParameters := PriceReport.RunRequestPage();
                ParametersXML := Builder."Get Report Page Structure As Xml"(Report::"TFB Price List");

                //Update 
                "Update Field Value"(ParametersXml, '_EffectiveDate', format(_EffectiveDate, 0, '<Year4>-<Month,2>-<Day,2>'));
                "Update Field Value"(ParametersXml, '_PriceHistory', format(_Duration));
                ParametersXML.WriteTo(ParametersString);
                HTMLTemplate := ReportPackCU.GetPriceListHTMLTemplate(MessageTopicVar);

                StartTS := CurrentDateTime();
                Window.Open(Text001Msg);
                AvgTimeText := '';
            end;

            trigger OnAfterGetRecord()

            var

            begin
                Window.Update(1, StrSubstNo('%1 %2 %3', "No.", Name, AvgTimeText));
                If ReportPackCU.SendCustomerPriceListEmail("No.", HTMLTemplate, ParametersString, _EffectiveDate, _Duration, false) then begin
                    SentCount := SentCount + 1;
                    EndTS := CurrentDateTime();
                    ProcessingTime := EndTS - StartTS;
                    AvgTimeSecs := (ProcessingTime / SentCount) / 1000;
                    AvgTimeText := StrSubstNo('Avg Secs is %1 so far', Format(AvgTimeSecs, 0, '<Precision,2><sign><Integer Thousand><Decimals,3>'));

                end;
            end;

            trigger OnPostDataItem()

            var

            begin
                Window.Close();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                field(MessageTopic; MessageTopicVar)
                {
                    Caption = 'Special Message';
                    ApplicationArea = All;
                    MultiLine = True;
                    Importance = Promoted;
                    ToolTip = 'Specifies the message to be included in the price list email';
                }
                field(EffectiveDate; _EffectiveDate)
                {
                    Caption = 'Effective Date';
                    Importance = Promoted;
                    ApplicationArea = All;
                    ToolTip = ' Enter a date for which you want the price list to be effective';
                }
                field(Duration; _Duration)
                {
                    Caption = 'Price History Duration';
                    Importance = Promoted;
                    ApplicationArea = All;
                    ToolTip = ' Enter a date formulae represents how far back you want to explore dates. Default is -1Y if nothing is entered';
                }

            }
        }

        actions
        {

        }
    }

    var
        ReportPackCU: CodeUnit "TFB Report Pack Mgmt";
        _Duration: DateFormula;
        Window: Dialog;
        HTMLTemplate: Text;
        MessageTopicVar: Text;
        _EffectiveDate: Date;
        Text001Msg: Label 'Sending Customer Price Lists:\#1#########2##################', comment = '%1=Customer No,%2=Customer Name';
        StartTS: DateTime;
        EndTS: DateTime;
        ProcessingTime: Duration;
        AvgTimeText: Text;
        AvgTimeSecs: Decimal;
        SentCount: Integer;

        ParametersString: Text;
        ParametersXML: XmlDocument;

    local procedure "Update Field Value"(var Document: XmlDocument; "Field Name": Text; "Field Value": Text)
    var
        Node: XmlNode;
    begin
        Document.SelectSingleNode('//Field[@name="' + "Field Name" + '"]', Node);
        Node.AsXmlElement().Add(XmlText.Create("Field Value"));
    end;
}