codeunit 53001 "Report Xml Parameters Builder"
{
    procedure "Get Report Page Structure As Xml"("Report ID": Integer): XmlDocument
    var
        ReportMetadata: Record "Report Metadata";
        "Xml Parameters": XmlElement;
        "Result": XmlDocument;
    begin
        ReportMetadata.SetRange(ID, "Report ID");
        ReportMetadata.FindFirst();

        "Xml Parameters" := XmlElement.Create('ReportParameters');
        "Xml Parameters".SetAttribute('name', ReportMetadata.Caption);
        "Xml Parameters".SetAttribute('id', Format("Report ID"));

        "Xml Parameters".Add(CreateXmlOptions("Report ID"));
        "Xml Parameters".Add(CreateXmlDataItems("Report ID"));

        Result := XmlDocument.Create();
        Result.Add("Xml Parameters");

        exit(Result);
    end;

    local procedure CreateXmlOptions("Report ID": Integer): XmlElement
    var
        AllControlFields: Record "All Control Fields";
        "Xml Options": XmlElement;
        "Xml Field": XmlElement;
    begin
        AllControlFields.SetRange("Object Type", AllControlFields."Object Type"::Report);
        AllControlFields.SetRange("Object ID", "Report ID");
        AllControlFields.Find('-');

        "Xml Options" := XmlElement.Create('Options');

        repeat
            "Xml Field" := XmlElement.Create('Field');
            "Xml Field".SetAttribute('name', AllControlFields."Source Expression");

            "Xml Options".Add("Xml Field");
        until AllControlFields.Next() = 0;

        exit("Xml Options");
    end;

    local procedure CreateXmlDataItems("Report ID": Integer): XmlElement
    var
        ReportDataItems: Record "Report Data Items";
        "Xml Data Items": XmlElement;
        "Xml Data Item": XmlElement;
    begin
        ReportDataItems.SetRange("Report ID", "Report ID");
        ReportDataItems.Find('-');

        "Xml Data Items" := XmlElement.Create('DataItems');

        repeat
            "Xml Data Item" := XmlElement.Create('DataItem');
            "Xml Data Item".SetAttribute('name', ReportDataItems.Name);
            "Xml Data Item".Add(XmlText.Create(ReportDataItems."Data Item Table View"));

            "Xml Data Items".Add("Xml Data Item");
        until ReportDataItems.Next() = 0;

        exit("Xml Data Items");
    end;
}