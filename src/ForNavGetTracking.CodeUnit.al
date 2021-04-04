codeunit 53000 "ForNAV Get Tracking"
{
    // Copyright (c) 2019 ForNAV ApS - All Rights Reserved
    // The intellectual work and technical concepts contained in this file are proprietary to ForNAV.
    // Unauthorized reverse engineering, distribution or copying of this file, parts hereof, or derived work, via any medium is strictly prohibited without written permission from ForNAV ApS.
    // This source code is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

    procedure GetTrackingSpecification(var TrackingSpecification: Record "Tracking Specification"; RecordRef: RecordRef)
    begin
        case RecordRef.Number() of
            Database::"Sales Line",
            Database::"Purchase Line":
                begin
                    GetReservationEntries(TrackingSpecification, RecordRef);
                    GetItemLedgerEntries(TrackingSpecification, RecordRef);
                end;
            Database::"Sales Invoice Line",
            Database::"Purch. Inv. Line",
            Database::"Sales Shipment Line",
            Database::"Purch. Rcpt. Line":
                GetItemLedgerEntries(TrackingSpecification, RecordRef);
        end;
    end;

    local procedure GetReservationEntries(var TrackingSpecification: Record "Tracking Specification"; RecordRef: RecordRef)
    var
        ReservationEntry: Record "Reservation Entry";
        FieldRef: FieldRef;
        NewLotNo: Boolean;
        PendingInsert: Boolean;
        TotalQtyBase: Decimal;
        TotalQtyToHandle: Decimal;
        LastLotNo: Code[50];


    begin
        LastLotNo := '';
        FieldRef := RecordRef.Field(3); // Document No
        ReservationEntry.SetRange("Source ID", FieldRef.Value());
        FieldRef := RecordRef.Field(4); // Line No
        ReservationEntry.SetRange("Source Ref. No.", FieldRef.Value());
        FieldRef := RecordRef.Field(6); // No.
        ReservationEntry.SetRange("Item No.", FieldRef.Value());
        ReservationEntry.SetRange("Source Type", RecordRef.Number());
        ReservationEntry.SetFilter("Item Tracking", '> %1', ReservationEntry."Item Tracking"::None);
        if ReservationEntry.FindSet() then
            repeat
                If ReservationEntry."Lot No." <> LastLotNo then
                    //Treat as a new lot no
                    NewLotNo := true
                else
                    NewLotNo := false;

                If (NewLotNo) and (PendingInsert) then begin
                    TrackingSpecification.Insert();
                    PendingInsert := false;
                end;
                //If it is the same lot number add to total
                If NewLotNo = true then begin

                    TotalQtyToHandle := 0;
                    TotalQtyBase := 0;
                end;

                TotalQtyBase := TotalQtyBase + ABS(ReservationEntry."Quantity (Base)");
                TotalQtyToHandle := TotalQtyToHandle + ABS(ReservationEntry."Qty. to Handle (Base)");


                If NewLotNo then begin
                    TrackingSpecification.Init();
                    TrackingSpecification."Entry No." := TrackingSpecification."Entry No." + 1;
                    TrackingSpecification."Item No." := ReservationEntry."Item No.";
                    TrackingSpecification."Serial No." := ReservationEntry."Serial No.";
                    TrackingSpecification."Lot No." := ReservationEntry."Lot No.";
                    LastLotNo := ReservationEntry."Lot No.";
                    PendingInsert := true;
                end;
                TrackingSpecification."Qty. to Handle" := TotalQtyToHandle;
                TrackingSpecification."Quantity (Base)" := TotalQtyBase;



            until ReservationEntry.Next() = 0;

        If PendingInsert then
            TrackingSpecification.Insert();
    end;

    local procedure GetItemLedgerEntries(var TrackingSpecification: Record "Tracking Specification"; RecordRef: RecordRef)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesShipmentLine: Record "Sales Shipment Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
        ValueEntry: Record "Value Entry";
        ShippingRecordRef: RecordRef;
        FieldRef: FieldRef;
        ShippingFieldRef: FieldRef;
    begin
        case RecordRef.Number() of
            Database::"Sales Line",
            Database::"Sales Invoice Line":
                ShippingRecordRef.GetTable(SalesShipmentLine);
            Database::"Purchase Line",
            Database::"Purch. Inv. Line":
                ShippingRecordRef.GetTable(PurchRcptLine);
        end;

        case RecordRef.Number() of
            Database::"Sales Line",
            Database::"Purchase Line":
                begin
                    ShippingFieldRef := ShippingRecordRef.Field(65);
                    FieldRef := RecordRef.Field(3); // Document No
                    ShippingFieldRef.SetRange(FieldRef.Value());
                    ShippingFieldRef := ShippingRecordRef.Field(66);
                    FieldRef := RecordRef.Field(4); // Line No
                    ShippingFieldRef.SetRange(FieldRef.Value());
                    if not ShippingRecordRef.FindSet() then
                        exit;
                end;
            Database::"Sales Invoice Line",
            Database::"Purch. Inv. Line":
                begin
                    ValueEntry.SetCurrentKey("Document No.");
                    FieldRef := RecordRef.Field(3); // Document No
                    ValueEntry.SetRange("Document No.", FieldRef.Value());
                    ValueEntry.SetRange("Document Type", ValueEntry."Document Type"::"Purchase Invoice");
                    FieldRef := RecordRef.Field(4); // Line No
                    ValueEntry.SetRange("Document Line No.", FieldRef.Value());
                    if ValueEntry.FindSet() then
                        repeat
                            if ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                                TrackingSpecification.Init();
                                TrackingSpecification."Entry No." := TrackingSpecification."Entry No." + 1;
                                TrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                                TrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
                                TrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
                                TrackingSpecification."Quantity (Base)" := abs(ItemLedgerEntry.Quantity);
                                TrackingSpecification.Insert();
                            end;
                        until ValueEntry.Next() = 0;
                end;
            Database::"Sales Shipment Line",
            Database::"Purch. Rcpt. Line":
                begin
                    ShippingRecordRef := RecordRef;
                    ShippingRecordRef.SetRecFilter();
                end;
            else
                exit;
        end;

        ShippingRecordRef.SetRecFilter();
        if ShippingRecordRef.FindSet() then
            repeat
                FieldRef := ShippingRecordRef.Field(3); // Document No
                ItemLedgerEntry.SetRange("Document No.", FieldRef.Value());
                FieldRef := ShippingRecordRef.Field(4); // Line No
                ItemLedgerEntry.SetRange("Document Line No.", FieldRef.Value());
                ItemLedgerEntry.SetFilter("Item Tracking", '> %1', ItemLedgerEntry."Item Tracking"::None);
                if ItemLedgerEntry.FindSet() then
                    repeat
                        TrackingSpecification.Init();
                        TrackingSpecification."Entry No." := TrackingSpecification."Entry No." + 1;
                        TrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
                        TrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
                        TrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
                        TrackingSpecification."Quantity (Base)" := abs(ItemLedgerEntry.Quantity);
                        TrackingSpecification.Insert();
                    until ItemLedgerEntry.Next() = 0;
            until ShippingRecordRef.Next() = 0;
    end;
}