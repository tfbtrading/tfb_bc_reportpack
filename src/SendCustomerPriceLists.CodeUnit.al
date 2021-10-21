codeunit 53002 "TFB Send Customer Price Lists"
{
    trigger OnRun()
    begin


        //XMLParameters := PriceReport.RunRequestPage();
        ParametersXML := Builder."Get Report Page Structure As Xml"(Report::"TFB Price List");

        //Update 


        If (Customer.Count > 0) and MultipleSelect then
            If not Confirm('There are %1 records selected for the send price list action. Continue?', true, Customer.Count()) then exit;

        If not (PriceListDialog.RunModal() = Action::OK) then exit;


        UpdateFieldValue(ParametersXml, '_EffectiveDate', format(PriceListDialog.GetEffectiveDate(), 0, '<Year4>-<Month,2>-<Day,2>'));
        UpdateFieldValue(ParametersXml, '_PriceHistory', format(PriceListDialog.GetDuration()));
        ParametersXML.WriteTo(ParametersString);
        HTMLTemplate := ReportPackCU.GetPriceListHTMLTemplate(PriceListDialog.GetMessageTopic());

        StartTS := CurrentDateTime();
        Window.HideSubsequentDialogs := true;
        Window.Open(Text001Msg);
        AvgTimeText := '';
        If (Customer.Count > 0) and MultipleSelect then begin
            Customer.SetRange("TFB Price List Recipient", true);
            Customer.SetFilter("E-Mail", '<>%1', '');
        end;
        If Customer.FindSet(false, false) then
            repeat
                Window.Update(1, StrSubstNo('%1 %2 %3', Customer."No.", Customer.Name, AvgTimeText));

                If ReportPackCU.SendCustomerPriceListEmail(Customer."No.", HTMLTemplate, ParametersString, PriceListDialog.GetEffectiveDate(), PriceListDialog.GetDuration(), false) then begin
                    SentCount := SentCount + 1;
                    EndTS := CurrentDateTime();
                    ProcessingTime := EndTS - StartTS;
                    AvgTimeSecs := (ProcessingTime / SentCount) / 1000;
                    AvgTimeText := StrSubstNo('Avg Secs is %1 so far', Format(AvgTimeSecs, 0, '<Precision,2><sign><Integer Thousand><Decimals,3>'));

                end;

            until Customer.Next() = 0;

        Window.Close();

        Clear(Customer);
    end;



    procedure Setup(_MultipleSelect: Boolean)

    begin
        MultipleSelect := _MultipleSelect;
    end;

    procedure SelectCustomers(_Customers: Record Customer)

    begin
        Customer.Copy(_Customers);
        Customer.MarkedOnly(true);

    end;

    local procedure UpdateFieldValue(var Document: XmlDocument; "Field Name": Text; "Field Value": Text)
    var
        Node: XmlNode;
    begin
        Document.SelectSingleNode('//Field[@name="' + "Field Name" + '"]', Node);
        Node.AsXmlElement().Add(XmlText.Create("Field Value"));
    end;

    var

        Customer: Record Customer;
        Builder: CodeUnit "Report Xml Parameters Builder";
        ReportPackCU: CodeUnit "TFB Report Pack Mgmt";
        PriceListDialog: Page "TFB Price List Dialog";
        Window: Dialog;
        ParametersXML: XmlDocument;
        ParametersString: Text;
        HTMLTemplate: Text;
        StartTS: DateTime;
        EndTS: DateTime;
        ProcessingTime: Duration;
        AvgTimeText: Text;
        Text001Msg: Label 'Sending Customer Price Lists:\#1#########2##################', comment = '%1=Customer No,%2=Customer Name';

        AvgTimeSecs: Decimal;
        SentCount: Integer;

        MultipleSelect: Boolean;
}