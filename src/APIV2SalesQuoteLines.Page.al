#pragma implicitwith disable
page 53011 "TFB APIV2 - Sales Quote Lines"
{
    DelayedInsert = true;
    APIVersion = 'v2.0';
    EntityCaption = 'Sales Quote Line';
    EntitySetCaption = 'Sales Quote Lines';
    PageType = API;
    APIPublisher = 'tfb';
    APIGroup = 'inreach';
    ODataKeyFields = SystemId;
    EntityName = 'salesQuoteLine2';
    EntitySetName = 'salesQuoteLines2';
    SourceTable = "Sales Invoice Line Aggregate";
    SourceTableTemporary = true;
    Extensible = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    Caption = 'Id';
                    Editable = false;
                }
                field(documentId; Rec."Document Id")
                {
                    Caption = 'Document Id';

                    trigger OnValidate()
                    begin
                        if (not IsNullGuid(xRec."Document Id")) and (xRec."Document Id" <> Rec."Document Id") then
                            Error(CannotChangeDocumentIdNoErr);
                    end;
                }
                field(sequence; Rec."Line No.")
                {
                    Caption = 'Sequence';

                    trigger OnValidate()
                    begin
                        if (xRec."Line No." <> Rec."Line No.") and
                           (xRec."Line No." <> 0)
                        then
                            Error(CannotChangeLineNoErr);

                        RegisterFieldSet(Rec.FieldNo("Line No."));
                    end;
                }
                field(itemId; Rec."Item Id")
                {
                    Caption = 'Item Id';

                    trigger OnValidate()
                    begin
                        if not Item.GetBySystemId(Rec."Item Id") then
                            Error(ItemDoesNotExistErr);

                        RegisterFieldSet(Rec.FieldNo(Type));
                        RegisterFieldSet(Rec.FieldNo("No."));
                        RegisterFieldSet(Rec.FieldNo("Item Id"));

                        Rec."No." := Item."No.";
                    end;
                }
                field(accountId; Rec."Account Id")
                {
                    Caption = 'Account Id';

                    trigger OnValidate()
                    var
                        GLAccount: Record "G/L Account";
                        EmptyGuid: Guid;
                    begin
                        if Rec."Account Id" <> EmptyGuid then
                            if Item."No." <> '' then
                                Error(BothItemIdAndAccountIdAreSpecifiedErr);

                        if not GLAccount.GetBySystemId(Rec."Account Id") then
                            Error(AccountDoesNotExistErr);

                        RegisterFieldSet(Rec.FieldNo(Type));
                        RegisterFieldSet(Rec.FieldNo("Account Id"));
                        RegisterFieldSet(Rec.FieldNo("No."));
                    end;
                }
                field(lineType; Rec."API Type")
                {
                    Caption = 'Line Type';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Type));
                    end;
                }
                field(lineObjectNumber; Rec."No.")
                {
                    Caption = 'Line Object No.';

                    trigger OnValidate()
                    var
                        GLAccount: Record "G/L Account";
                    begin
                        if (xRec."No." <> Rec."No.") and (xRec."No." <> '') then
                            Error(CannotChangeLineObjectNoErr);

                        case Rec."API Type" of
                            Rec."API Type"::Item:
                                begin
                                    if not Item.Get(Rec."No.") then
                                        Error(ItemDoesNotExistErr);

                                    RegisterFieldSet(Rec.FieldNo("Item Id"));
                                    Rec."Item Id" := Item.SystemId;
                                end;
                            Rec."API Type"::Account:
                                begin
                                    if not GLAccount.Get(Rec."No.") then
                                        Error(AccountDoesNotExistErr);

                                    RegisterFieldSet(Rec.FieldNo("Account Id"));
                                    Rec."Account Id" := GLAccount.SystemId;
                                end;
                        end;
                        RegisterFieldSet(Rec.FieldNo("No."));
                    end;
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Description));
                    end;
                }
                field(unitOfMeasureId; Rec."Unit of Measure Id")
                {
                    Caption = 'Unit Of Measure Id';

                    trigger OnValidate()
                    var
                        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
                    begin
                        SalesInvoiceAggregator.VerifyCanUpdateUOM(Rec);
                        RegisterFieldSet(Rec.FieldNo("Unit of Measure Code"));
                    end;
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit Of Measure Code';
                    trigger OnValidate()
                    var
                        SalesInvoiceAggregator: Codeunit "Sales Invoice Aggregator";
                    begin
                        SalesInvoiceAggregator.VerifyCanUpdateUOM(Rec);
                        RegisterFieldSet(Rec.FieldNo("Unit of Measure Code"));
                    end;
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Unit Price"));
                    end;
                }
                field(pricePerKg; _pricePerKg)
                {
                    Caption = 'PricePerKg';
                    Editable = false;

                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Quantity));
                    end;
                }
                field(discountAmount; Rec."Line Discount Amount")
                {
                    Caption = 'DiscountAmount';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Line Discount Amount"));
                    end;
                }
                field(discountPerKg; _discountPerKg)
                {
                    Caption = 'DiscountPerKg';
                    Editable = false;

                }
                field(unitWeight; _unitWeight)
                {
                    Caption = 'UnitWeight';
                    Editable = false;
                }

                field(discountPercent; Rec."Line Discount %")
                {
                    Caption = 'Discount Percent';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Line Discount %"));
                    end;
                }
                field(discountAppliedBeforeTax; Rec."Discount Applied Before Tax")
                {
                    Caption = 'Discount Applied Before Tax';
                    Editable = false;
                }
                field(amountExcludingTax; Rec."Line Amount Excluding Tax")
                {
                    Caption = 'Amount Excluding Tax';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Amount));
                    end;
                }
                field(taxCode; Rec."Tax Code")
                {
                    Caption = 'Tax Code';

                    trigger OnValidate()
                    var
                        GeneralLedgerSetup: Record "General Ledger Setup";
                    begin
                        if GeneralLedgerSetup.UseVat() then begin
                            Rec.Validate("VAT Prod. Posting Group", COPYSTR(Rec."Tax Code", 1, 20));
                            RegisterFieldSet(Rec.FieldNo("VAT Prod. Posting Group"));
                        end else begin
                            Rec.Validate("Tax Group Code", COPYSTR(Rec."Tax Code", 1, 20));
                            RegisterFieldSet(Rec.FieldNo("Tax Group Code"));
                        end;
                    end;
                }
                field(taxPercent; Rec."VAT %")
                {
                    Caption = 'Tax Percent';
                    Editable = false;
                }
                field(totalTaxAmount; Rec."Line Tax Amount")
                {
                    Caption = 'Total Tax Amount';
                    Editable = false;
                }
                field(amountIncludingTax; Rec."Line Amount Including Tax")
                {
                    Caption = 'Amount Including Tax';
                    Editable = false;

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Amount Including VAT"));
                    end;
                }
                field(netAmount; Rec.Amount)
                {
                    Caption = 'Net Amount';
                }
                field(netTaxAmount; Rec."Tax Amount")
                {
                    Caption = 'Net Tax Amount';
                    Editable = false;
                }
                field(netAmountIncludingTax; Rec."Amount Including VAT")
                {
                    Caption = 'Net Amount Including Tax';
                    Editable = false;
                }
                field(itemVariantId; Rec."Variant Id")
                {
                    Caption = 'Item Variant Id';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Variant Code"));
                    end;
                }
                field(locationId; Rec."Location Id")
                {
                    Caption = 'Location Id';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo("Location Code"));
                    end;
                }
                part(dimensionSetLines; "APIV2 - Dimension Set Lines")
                {
                    Caption = 'Dimension Set Lines';
                    EntityName = 'dimensionSetLine';
                    EntitySetName = 'dimensionSetLines';
                    SubPageLink = "Parent Id" = Field(SystemId), "Parent Type" = const("Sales Quote Line");
                }
                part(location; "APIV2 - Locations")
                {
                    Caption = 'Location';
                    EntityName = 'location';
                    EntitySetName = 'locations';
                    Multiplicity = ZeroOrOne;
                    SubPageLink = SystemId = field("Location Id");
                }
            }
        }
    }

    actions
    {
    }



    trigger OnDeleteRecord(): Boolean
    var
        GraphMgtSalesQuoteBuffer: Codeunit "Graph Mgt - Sales Quote Buffer";
    begin
        GraphMgtSalesQuoteBuffer.PropagateDeleteLine(Rec);
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        GraphMgtSalesInvLines: Codeunit "Graph Mgt - Sales Inv. Lines";
        GraphMgtSalesQuoteBuffer: Codeunit "Graph Mgt - Sales Quote Buffer";
        SysId: Guid;
        DocumentIdFilter: Text;
        FilterView: Text;
        IdFilter: Text;
    begin
        if not LinesLoaded then begin
            FilterView := Rec.GetView();
            IdFilter := Rec.GetFilter(SystemId);
            DocumentIdFilter := Rec.GetFilter("Document Id");
            if (IdFilter = '') and (DocumentIdFilter = '') then
                Error(IDOrDocumentIdShouldBeSpecifiedForLinesErr);
            if IdFilter <> '' then begin
                Evaluate(SysId, IdFilter);
                DocumentIdFilter := GraphMgtSalesInvLines.GetSalesQuoteDocumentIdFilterFromSystemId(SysId);
            end else
                DocumentIdFilter := Rec.GetFilter("Document Id");
            GraphMgtSalesQuoteBuffer.LoadLines(Rec, DocumentIdFilter);
            Rec.SetView(FilterView);
            if not Rec.FindFirst() then
                exit(false);
            LinesLoaded := true;
        end;

        exit(true);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        GraphMgtSalesQuoteBuffer: Codeunit "Graph Mgt - Sales Quote Buffer";
    begin
        GraphMgtSalesQuoteBuffer.PropagateInsertLine(Rec, TempFieldBuffer);
    end;

    trigger OnModifyRecord(): Boolean
    var
        GraphMgtSalesQuoteBuffer: Codeunit "Graph Mgt - Sales Quote Buffer";
    begin
        GraphMgtSalesQuoteBuffer.PropagateModifyLine(Rec, TempFieldBuffer);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearCalculatedFields();
        RegisterFieldSet(Rec.FieldNo(Type));
    end;

    var
        Item: Record "Item";
        TempFieldBuffer: Record "Field Buffer" temporary;
        TempItemFieldSet: Record 2000000041 temporary;
        LinesLoaded: Boolean;
        _discountPerKg: Decimal;
        _pricePerKg: Decimal;
        _unitWeight: Decimal;
        AccountDoesNotExistErr: Label 'Account does not exist.';
        BothItemIdAndAccountIdAreSpecifiedErr: Label 'Both "itemId" and "accountId" are specified. Specify only one of them.', Comment = 'itemId and accountId are field names and should not be translated.';
        CannotChangeDocumentIdNoErr: Label 'The value for "documentId" cannot be modified.', Comment = 'documentId is a field name and should not be translated.';
        CannotChangeLineNoErr: Label 'The value for sequence cannot be modified. Delete and insert the line again.';
        CannotChangeLineObjectNoErr: Label 'The value for "lineObjectNumber" cannot be modified.', Comment = 'lineObjectNumber is a field name and should not be translated.';
        IDOrDocumentIdShouldBeSpecifiedForLinesErr: Label 'You must specify an Id or a Document Id to get the lines.';
        ItemDoesNotExistErr: Label 'Item does not exist.';


    local procedure RegisterFieldSet(FieldNo: Integer)
    var
        LastOrderNo: Integer;
    begin
        LastOrderNo := 1;
        if TempFieldBuffer.FindLast() then
            LastOrderNo := TempFieldBuffer.Order + 1;

        Clear(TempFieldBuffer);
        TempFieldBuffer.Order := LastOrderNo;
        TempFieldBuffer."Table ID" := Database::"Sales Invoice Line Aggregate";
        TempFieldBuffer."Field ID" := FieldNo;
        TempFieldBuffer.Insert();
    end;

    local procedure ClearCalculatedFields()
    begin
        TempFieldBuffer.Reset();
        TempFieldBuffer.DeleteAll();
        TempItemFieldSet.Reset();
        TempItemFieldSet.DeleteAll();

        Clear(Item);
    end;
}
#pragma implicitwith restore
