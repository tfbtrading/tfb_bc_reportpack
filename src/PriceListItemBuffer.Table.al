table 53120 "TFB Price List Item Buffer"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "No."; Code[20])
        {
            TableRelation = Item;
            ValidateTableRelation = true;

        }

        field(8; "Base Unit of Measure"; Code[10])
        {
            Caption = 'Base Unit of Measure';
            TableRelation = "Unit of Measure";
            ValidateTableRelation = false;
        }
        field(10; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Inventory,Service,Non-Inventory';
            OptionMembers = Inventory,Service,"Non-Inventory";
        }

        field(31; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
            //This property is currently not supported
            //TestTableRelation = true;
            ValidateTableRelation = true;
        }
        field(42; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(43; "Units per Parcel"; Decimal)
        {
            Caption = 'Units per Parcel';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(49; "Country/Region Purchased Code"; Code[10])
        {
            Caption = 'Country/Region Purchased Code';
            TableRelation = "Country/Region";
        }
        field(95; "Country/Region of Origin Code"; Code[10])
        {
            Caption = 'Country/Region of Origin Code';
            TableRelation = "Country/Region";
        }
        field(54; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(92; Picture; MediaSet)
        {
            Caption = 'Picture';
        }
        field(5413; "Safety Stock Quantity"; Decimal)
        {
            AccessByPermission = TableData "Req. Wksh. Template" = R;
            Caption = 'Safety Stock Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        field(5702; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(53010; KgPrice; Decimal)
        {

        }
        field(53020; UnitPrice; Decimal)
        {

        }

        field(53030; OldKgPrice; Decimal)
        {
        }

        field(53040; OldUnitPrice; Decimal)
        {
        }
        field(53050; PriceChangeDate; Text[100])
        {

        }
        field(53055; DaysSincePriceChange; Integer)
        {

        }
        field(53060; Availability; Text[100])
        {
        }
        field(53070; EstETA; Text[50])
        {

        }
        field(53080; AQISFactors; Text[50])
        {

        }
        field(53090; UnitType; Text[50])
        {
        }
        field(53100; PerPallet; Integer)
        {

        }

        field(53110; BookMarkedItem; Boolean)
        {

        }
        field(53120; BookmarkHTML; Text[512])
        {

        }
        field(53130; flagHTML; Text[512])
        {

        }
        field(53140; FavouritedItem; Boolean)
        {

        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }

    var


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}