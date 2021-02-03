codeunit 53001 "Report Xml Parameters Builder"
{
    procedure "Get Report Page Structure As Xml"("Report ID": Integer): XmlDocument
    var
        "Report Metadata": Record "Report Metadata";
        "Xml Parameters": XmlElement;
        "Result": XmlDocument;
    begin
        "Report Metadata".SetRange(ID, "Report ID");
        "Report Metadata".Find('-');

        "Xml Parameters" := XmlElement.Create('ReportParameters');
        "Xml Parameters".SetAttribute('name', "Report Metadata".Caption);
        "Xml Parameters".SetAttribute('id', Format("Report ID"));

        "Xml Parameters".Add("Create Xml Options"("Report ID"));
        "Xml Parameters".Add("Create Xml Data Items"("Report ID"));

        Result := XmlDocument.Create();
        Result.Add("Xml Parameters");

        exit(Result);
    end;

    local procedure "Create Xml Options"("Report ID": Integer): XmlElement
    var
        "All Control Fields": Record "All Control Fields";
        "Xml Options": XmlElement;
        "Xml Field": XmlElement;
    begin
        "All Control Fields".SetRange("Object Type", "All Control Fields"."Object Type"::Report);
        "All Control Fields".SetRange("Object ID", "Report ID");
        "All Control Fields".Find('-');

        "Xml Options" := XmlElement.Create('Options');

        repeat
            "Xml Field" := XmlElement.Create('Field');
            "Xml Field".SetAttribute('name', "All Control Fields"."Source Expression");

            "Xml Options".Add("Xml Field");
        until "All Control Fields".Next() = 0;

        exit("Xml Options");
    end;

    local procedure "Create Xml Data Items"("Report ID": Integer): XmlElement
    var
        "Report Data Items": Record "Report Data Items";
        "Xml Data Items": XmlElement;
        "Xml Data Item": XmlElement;
    begin
        "Report Data Items".SetRange("Report ID", "Report ID");
        "Report Data Items".Find('-');

        "Xml Data Items" := XmlElement.Create('DataItems');

        repeat
            "Xml Data Item" := XmlElement.Create('DataItem');
            "Xml Data Item".SetAttribute('name', "Report Data Items".Name);
            "Xml Data Item".Add(XmlText.Create("Report Data Items"."Data Item Table View"));

            "Xml Data Items".Add("Xml Data Item");
        until "Report Data Items".Next() = 0;

        exit("Xml Data Items");
    end;
}