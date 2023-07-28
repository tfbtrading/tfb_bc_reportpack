page 53013 "TFB APIV2 Vend. Ledger Entries"
{
    PageType = API;
    Caption = 'vendorLedgerEntries';
    APIPublisher = 'tfb';
    APIGroup = 'vendorportal';
    APIVersion = 'v2.0';
    EntityName = 'vendorLedgerEntry';
    EntitySetName = 'vendorLedgerEntries';
    SourceTable = "Vendor Ledger Entry";
    InsertAllowed = false;
    DataAccessIntent = ReadOnly;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(paymentMethodCode; Rec."Payment Method Code")
                {
                    Caption = 'Payment Method Code';
                }
                field(vendorNo; Rec."Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(vendorName; Rec."Vendor Name")
                {
                    Caption = 'Vendor Name';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(originalAmount; Rec."Original Amount")
                {
                    Caption = 'Original Amount';
                }

                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }

                part(appliedEntries; "TFB APIV2 Vend. Ledg. Appl.")
                {
                    Caption = 'Applied Entries';
                    EntityName = 'vendorLedgerEntryApplication';
                    EntitySetName = 'vendorLedgerEntryApplications';
                    SubPageLink = "Entry No." = Field("Entry No.");
                }
            }
        }


    }

    [ServiceEnabled]
    procedure SendRemittance(var actionContext: WebServiceActionContext)

    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        VendorLedgerEntry := Rec;
        CurrPage.SETSELECTIONFILTER(VendorLedgerEntry);
        VendorLedgerEntry.SETRANGE("Document Type", VendorLedgerEntry."Document Type"::Payment);
        SendVendorRecords(VendorLedgerEntry);
    end;


    local procedure SendVendorRecords(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    var
        DocumentSendingProfile: Record "Document Sending Profile";
        DummyReportSelections: Record "Report Selections";
        ReportSelectionInteger: Integer;
    begin
        IF NOT VendorLedgerEntry.FindSet() THEN
            EXIT;

        DummyReportSelections.Usage := DummyReportSelections.Usage::"P.V.Remit.";
        ReportSelectionInteger := DummyReportSelections.Usage.AsInteger();

        DocumentSendingProfile.SendVendorRecords(
            ReportSelectionInteger, VendorLedgerEntry, RemittanceAdviceTxt, "Vendor No.", "Document No.",
            VendorLedgerEntry.FIELDNO("Vendor No."), VendorLedgerEntry.FIELDNO("Document No."));
    end;

    var
        RemittanceAdviceTxt: Label 'Remittance Advice';
}
