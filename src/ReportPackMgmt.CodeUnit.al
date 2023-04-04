codeunit 53030 "TFB Report Pack Mgmt"
{



    procedure SendOneCustomerPriceList(CustNo: Code[20]; SetTopic: Text; EffectiveDate: Date; Duration: DateFormula): Boolean

    var

        ReportXmlParametersBuilder: CodeUnit "Report Xml Parameters Builder";
        Dialog: Dialog;
        TextMsg: Label 'Sending Customer Price List:\#1############################', Comment = '%1=Customer';
        Result: Boolean;
        ParametersString: Text;

        ParametersXML: XmlDocument;

    begin

        Dialog.Open(TextMsg);
        Dialog.Update(1, STRSUBSTNO('%1 %2', CustNo, ''));
        ParametersXML := ReportXmlParametersBuilder."Get Report Page Structure As Xml"(Report::"TFB Price List");

        UpdateFieldValue(ParametersXml, '_EffectiveDate', format(EffectiveDate, 0, '<Year4>-<Month,2>-<Day,2>'));
        UpdateFieldValue(ParametersXml, '_PriceHistory', format(Duration));
        ParametersXML.WriteTo(ParametersString);

        Result := SendCustomerPriceListEmail(CustNo, GetPriceListHTMLTemplate(SetTopic), ParametersString, EffectiveDate, Duration, true);
        Exit(Result);
    end;

    local procedure UpdateFieldValue(var Document: XmlDocument; "Field Name": Text; "Field Value": Text)
    var
        Node: XmlNode;
    begin
        Document.SelectSingleNode('//Field[@name="' + "Field Name" + '"]', Node);
        Node.AsXmlElement().Add(XmlText.Create("Field Value"));
    end;

    procedure SendCustomerPriceListEmail(CustNo: Code[20]; HTMLTemplate: Text; XMLParameters: Text; EffectiveDate: Date; Duration: DateFormula; Prompt: Boolean): Boolean

    var



        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        PrimaryContact: Record Contact;
        CompanyContact: Record Contact;
        OtherContacts: Record Contact;
        ContactJobResponsibility: Record "Contact Job Responsibility";
        CoreSetup: Record "TFB Core Setup";
        TFBPriceList: Report "TFB Price List";

        TempBlobCU: Codeunit "Temp Blob";
        Email: CodeUnit Email;
        EmailMessage: CodeUnit "Email Message";
        EmailRecordRef: RecordRef;
        EmailFieldRef: FieldRef;
        InStream: InStream;
        OutStream: OutStream;
        FileNameBuilder: TextBuilder;
        SubjectNameBuilder: TextBuilder;
        HTMLBuilder: TextBuilder;
        Recipients: List of [Text];
        EmailScenEnum: Enum "Email Scenario";


    begin

        CompanyInformation.Get();


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

            CoreSetup.Get();
            repeat
                If CoreSetup."PL Def. Job Resp. Rec." <> '' then begin
                    ContactJobResponsibility.SetRange("Job Responsibility Code", CoreSetup."PL Def. Job Resp. Rec.");
                    ContactJobResponsibility.SetRange("Contact No.", OtherContacts."No.");

                    If not ContactJobResponsibility.IsEmpty() then

                        //Contact has purchasing responsibility
                        If not Recipients.Contains(OtherContacts."E-Mail") then

                            //New email address is found and needs to be added
                            Recipients.Add(OtherContacts."E-Mail");

                end;

            until OtherContacts.Next() < 1;
        end;




        SubjectNameBuilder.Append(StrSubstNo('Updated price list from TFB Trading for %1', Customer.Name));

        //Get Record Reference for report
        EmailRecordRef.GetTable(Customer);
        EmailFieldRef := EmailRecordRef.Field(Customer.FieldNo("No."));
        EmailFieldRef.SetRange(Customer."No.");

        FileNameBuilder.Append('PriceListFor ');
        FileNameBuilder.Append(DelChr(Customer.Name, '=', ' '));
        FileNameBuilder.Append('.pdf');
        FileNameBuilder.Replace('/', '-');

        TempBlobCU.CreateOutStream(OutStream);


        TFBPriceList.SetTableView(Customer);
        TFBPriceList.SetEffectiveDate(EffectiveDate);
        TFBPriceList.SetDuration(Duration);
        If not TFBPriceList.SaveAs(XmlParameters, ReportFormat::Pdf, OutStream, EmailRecordRef) then exit;


        TempBlobCU.CreateInStream(InStream);

        HTMLBuilder.Append(HTMLTemplate);
        GeneratePriceListContent(Customer."No.", HTMLBuilder);
        EmailMessage.Create(Recipients, SubjectNameBuilder.ToText(), HTMLBuilder.ToText(), true);

        EmailMessage.AddAttachment(CopyStr(FileNameBuilder.ToText(), 1, 250), 'Application/pdf', InStream);

        Email.AddRelation(EmailMessage, Database::Customer, Customer.SystemId, Enum::"Email Relation Type"::"Related Entity", enum::"Email Relation Origin"::"Compose Context");
        If Prompt then
            Email.OpenInEditorModally(EmailMessage, EmailScenEnum::PriceList)
        else
            Email.Send(EmailMessage, EmailScenEnum::PriceList);
        Exit(true)

    end;

    local procedure GeneratePriceListContent(CustNo: Code[20]; var HTMLBuilder: TextBuilder): Text

    var
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