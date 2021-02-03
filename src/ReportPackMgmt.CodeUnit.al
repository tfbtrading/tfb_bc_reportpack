codeunit 53030 "TFB Report Pack Mgmt"
{



    procedure SendOneCustomerPriceList(CustNo: Code[20]; SetTopic: Text; EffectiveDate: Date; Duration: DateFormula): Boolean

    var

        PriceListRpt: Report "TFB Price List";
        Builder: CodeUnit "Report Xml Parameters Builder";
        Window: Dialog;
        TextMsg: Label 'Sending Customer Price List:\#1############################', Comment = '%1=Customer';
        Result: Boolean;
        ParametersString: Text;
        ParametersString2: Text;
        ParametersXML: XmlDocument;

    begin

        Window.Open(TextMsg);
        Window.Update(1, STRSUBSTNO('%1 %2', CustNo, ''));
        ParametersXML := Builder."Get Report Page Structure As Xml"(Report::"TFB Price List");

        "Update Field Value"(ParametersXml, '_EffectiveDate', format(EffectiveDate, 0, '<Year4>-<Month,2>-<Day,2>'));
        "Update Field Value"(ParametersXml, '_PriceHistory', format(Duration));
        ParametersXML.WriteTo(ParametersString);

        Result := SendCustomerPriceListEmail(CustNo, GetPriceListHTMLTemplate(SetTopic), ParametersString, EffectiveDate, Duration, true);
        Exit(Result);
    end;

    local procedure "Update Field Value"(var Document: XmlDocument; "Field Name": Text; "Field Value": Text)
    var
        Node: XmlNode;
    begin
        Document.SelectSingleNode('//Field[@name="' + "Field Name" + '"]', Node);
        Node.AsXmlElement().Add(XmlText.Create("Field Value"));
    end;

    procedure SendCustomerPriceListEmail(CustNo: Code[20]; HTMLTemplate: Text; XMLParameters: Text; EffectiveDate: Date; Duration: DateFormula; Prompt: Boolean): Boolean

    var



        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        PrimaryContact: Record Contact;
        CompanyContact: Record Contact;
        OtherContacts: Record Contact;
        Responsibility: Record "Contact Job Responsibility";
        SalesSetup: Record "Sales & Receivables Setup";
        PriceList: Report "TFB Price List";

        TempBlobCU: Codeunit "Temp Blob";
        Email: CodeUnit Email;
        EmailMessage: CodeUnit "Email Message";
        EmailRecordRef: RecordRef;
        EmailFieldRef: FieldRef;
        IStream: InStream;
        OStream: OutStream;
        FileNameBuilder: TextBuilder;
        SubjectNameBuilder: TextBuilder;
        HTMLBuilder: TextBuilder;
        Recipients: List of [Text];
        EmailScenEnum: Enum "Email Scenario";


    begin

        CompanyInfo.Get();


        If not Customer.Get(CustNo) then
            exit(false);

        If (Customer."E-Mail" = '') and Prompt then begin
            Message('No emal specified. Cannot email to customer.');
            exit(false);
        end;

        Recipients.Add(Customer."E-Mail");


        //Check for additional contacts who receive emails
        //First navigate via primary contact to company contact no
        PrimaryContact.Get(Customer."Primary Contact No.");
        CompanyContact.Get(PrimaryContact."Company No.");

        OtherContacts.SetRange("Company No.", CompanyContact."No.");

        //Iterate through other contacts with the same company contact to check for their purchasing responsibilities
        if OtherContacts.FindSet() then begin

            SalesSetup.Get();
            repeat
                If SalesSetup."TFB PL Def. Job Resp. Rec." <> '' then begin
                    Responsibility.SetRange("Job Responsibility Code", SalesSetup."TFB PL Def. Job Resp. Rec.");
                    Responsibility.SetRange("Contact No.", OtherContacts."No.");

                    If not Responsibility.IsEmpty() then

                        //Contact has purchasing responsibility
                        If not Recipients.Contains(OtherContacts."E-Mail") then

                            //New email address is found and needs to be added
                            Recipients.Add(OtherContacts."E-Mail");

                end;

            until OtherContacts.Next() < 1;
        end;




        SubjectNameBuilder.Append('Updated price list from TFB Trading');

        //Get Record Reference for report
        EmailRecordRef.GetTable(Customer);
        EmailFieldRef := EmailRecordRef.Field(Customer.FieldNo("No."));
        EmailFieldRef.SetRange(Customer."No.");

        FileNameBuilder.Append('PriceListFor ');
        FileNameBuilder.Append(DelChr(Customer.Name, '=', ' '));
        FileNameBuilder.Append('.pdf');
        FileNameBuilder.Replace('/', '-');

        TempBlobCU.CreateOutStream(OStream);
        TempBlobCU.CreateInStream(IStream);

        PriceList.SetTableView(Customer);
        PriceList.SetEffectiveDate(EffectiveDate);
        PriceList.SetDuration(Duration);
        PriceList.SaveAs(XmlParameters, ReportFormat::Pdf, OStream, EmailRecordRef);




        HTMLBuilder.Append(HTMLTemplate);
        GeneratePriceListContent(Customer."No.", HTMLBuilder);
        EmailMessage.Create(Recipients, SubjectNameBuilder.ToText(), HTMLBuilder.ToText(), true);

        EmailMessage.AddAttachment(FileNameBuilder.ToText(1, 250), 'Application/pdf', IStream);
        If Prompt then
            Email.OpenInEditorModally(EmailMessage, EmailScenEnum::PriceList)
        else
            Email.Enqueue(EmailMessage, EmailScenEnum::PriceList);
        Exit(true)

    end;

    local procedure GeneratePriceListContent(CustNo: Code[20]; var HTMLBuilder: TextBuilder): Text

    var
        TempCust: Code[20];
        Customer: Record Customer;


    begin

        Customer.Get(CustNo);

        HTMLBuilder.Replace('%{ExplanationCaption}', 'Notification type');
        HTMLBuilder.Replace('%{ExplanationValue}', 'New Price List');
        HTMLBuilder.Replace('%{DateCaption}', 'Generated On');
        HTMLBuilder.Replace('%{DateValue}', Format(Today(), 0, 4));
        HTMLBuilder.Replace('%{ReferenceCaption}', 'Customer Name');
        HTMLBuilder.Replace('%{ReferenceValue}', Customer.Name);
        HTMLBuilder.Replace('%{AlertText}', '');
        HTMLBuilder.Replace('%{EmailContent}', '');

    end;


    procedure GetPriceListHTMLTemplate(TempSubTitle: Text): Text

    var

        cu: CodeUnit "TFB Common Library";
        SubTitleText: Text;
        TitleText: Text;


    begin



        If TempSubTitle <> '' then
            SubTitleText := TempSubTitle
        else
            SubTitleText := 'Please find attached our latest price list.';

        TitleText := 'Updated price list';


        Exit(cu.GetHTMLTemplateActive(TitleText, SubTitleText))
    end;
}