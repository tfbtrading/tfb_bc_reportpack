page 53014 "TFB APIV2 Vend. Ledg. Appl."
{
    PageType = API;
    Caption = 'vendorLedgerEntryApplications';
    APIPublisher = 'tfb';
    APIGroup = 'vendorportal';
    APIVersion = 'v2.0';
    EntityName = 'vendorLedgerEntryApplication';
    EntitySetName = 'vendorLedgerEntryApplications';
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
                field(closedByAmount; Rec."Closed by Amount")
                {
                    Caption = 'Çlosed By Amount';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
            }
        }


    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        RelatedIdFilter: Text;

        FilterView: Text;
    begin
        RelatedIdFilter := Rec.GetFilter("Entry No.");

        if RelatedIdFilter = '' then begin
            Rec.FilterGroup(4);
            RelatedIdFilter := Rec.GetFilter("Entry No.");
            Rec.FilterGroup(0);
            if (RelatedIdFilter = '') then
                Error(FiltersNotSpecifiedErrorLbl);
        end;


        CreateVendLedgEntry.Get(RelatedIdFilter);
        FindApplnEntriesDtldtLedgEntry();
        Rec.SetCurrentKey("Entry No.");
        Rec.SetRange("Entry No.");

        if CreateVendLedgEntry."Closed by Entry No." <> 0 then begin
            Rec."Entry No." := CreateVendLedgEntry."Closed by Entry No.";
            Rec.Mark(true);
        end;

        Rec.SetCurrentKey("Closed by Entry No.");
        Rec.SetRange("Closed by Entry No.", CreateVendLedgEntry."Entry No.");
        if Rec.FindSet(false) then
            repeat
                Rec.Mark(true);
            until Rec.Next() = 0;

        Rec.SetCurrentKey("Entry No.");
        Rec.SetRange("Closed by Entry No.");
        Rec.MarkedOnly(true);


        exit(true);
    end;

    var

    local procedure FindApplnEntriesDtldtLedgEntry()
    var
        DtldVendLedgEntry1: Record "Detailed Vendor Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
    begin
        DtldVendLedgEntry1.Reset();
        DtldVendLedgEntry1.SetCurrentKey("Vendor Ledger Entry No.");
        DtldVendLedgEntry1.SetRange("Vendor Ledger Entry No.", CreateVendLedgEntry."Entry No.");
        DtldVendLedgEntry1.SetRange(Unapplied, false);
        if DtldVendLedgEntry1.Find('-') then
            repeat
                if DtldVendLedgEntry1."Vendor Ledger Entry No." =
                   DtldVendLedgEntry1."Applied Vend. Ledger Entry No."
                then begin
                    DtldVendLedgEntry2.Reset();
                    DtldVendLedgEntry2.SetCurrentKey("Applied Vend. Ledger Entry No.", "Entry Type");
                    DtldVendLedgEntry2.SetRange(
                      "Applied Vend. Ledger Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    DtldVendLedgEntry2.SetRange("Entry Type", DtldVendLedgEntry2."Entry Type"::Application);
                    DtldVendLedgEntry2.SetRange(Unapplied, false);
                    if DtldVendLedgEntry2.Find('-') then
                        repeat
                            if DtldVendLedgEntry2."Vendor Ledger Entry No." <>
                               DtldVendLedgEntry2."Applied Vend. Ledger Entry No."
                            then begin
                                Rec.SetCurrentKey("Entry No.");
                                Rec.SetRange("Entry No.", DtldVendLedgEntry2."Vendor Ledger Entry No.");
                                if Rec.FindSet(false) then
                                    Rec.Mark(true);
                            end;
                        until DtldVendLedgEntry2.Next() = 0;
                end else begin
                    Rec.SetCurrentKey("Entry No.");
                    Rec.SetRange("Entry No.", DtldVendLedgEntry1."Applied Vend. Ledger Entry No.");
                    if Rec.Find('-') then
                        Rec.Mark(true);
                end;
            until DtldVendLedgEntry1.Next() = 0;
    end;


    trigger OnAfterGetRecord()

    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        Rec.CalcFields(Amount, "Remaining Amount");
        DtldVendLedgEntry.SetRange("Vendor Ledger Entry No.", "Entry No.");
        DtldVendLedgEntry.SetRange("Entry Type", DtldVendLedgEntry."Entry Type"::Application);
        DtldVendLedgEntry.SetRange("Document Type", DtldVendLedgEntry."Document Type"::Payment);
        DtldVendLedgEntry.SetRange("Document No.", CreateVendLedgEntry."Document No.");
        DtldVendLedgEntry.SetRange(Unapplied, false);
        //if DtldVendLedgEntry.IsEmpty() then



    end;



    trigger OnOpenPage()

    begin

    end;

    var
        FiltersNotSpecifiedErrorLbl: Label 'id type not specified.';
        CreateVendLedgEntry: Record "Vendor Ledger Entry";
        RecordsLoaded: Boolean;
}
