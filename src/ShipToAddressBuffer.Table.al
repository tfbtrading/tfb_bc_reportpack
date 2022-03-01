table 53050 "TFB Ship-to Address Buffer"
{
    Caption = 'Ship-to Address Buffer';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {

        field(1; "ShipTo AddressId"; Guid)
        {
            NotBlank = true;
            Caption = 'ShipTo Address Id';

        }
        field(53005; "Standard Address"; Boolean)

        {
            Caption = 'Standard Address';

        }
        field(53010; "Default Address"; Boolean)
        {
            Caption = 'Default Address';

        }
        field(2; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;

        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';

        }
        field(4; "Name 2"; Text[50])
        {
            Caption = 'Name 2';

        }
        field(5; Address; Text[100])
        {
            Caption = 'Address';


        }
        field(6; "Address 2"; Text[50])
        {
            Caption = 'Address 2';



        }
        field(7; City; Text[30])
        {
            Caption = 'City';


        }
        field(8; Contact; Text[100])
        {
            Caption = 'Contact';

        }
        field(9; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;

        }

        field(35; "Country/Region Code"; Code[10])
        {
            Caption = 'Country/Region Code';



        }
        field(100; "Related Id"; Guid)
        {
            Caption = 'Related Id';
            NotBlank = true;

        }


        field(91; "Post Code"; Code[20])
        {
            Caption = 'Post Code';


        }
        field(92; County; Text[30])
        {
            CaptionClass = '5,1,' + "Country/Region Code";
            Caption = 'County';
        }

    }

    keys
    {
        key(PK; "ShipTo AddressId")
        {
            Clustered = true;
        }
    }


    procedure LoadDataFromFilters(RelatedIdFilter: Text)
    var
        ShipToAddress: Record "Ship-to Address";
        Customer: Record Customer;
        FiltersNotSpecifiedErrorLbl: Label 'No customer filter has been specified';
    begin

        Customer.SetLoadFields(SystemId, "No.", Address, "Ship-to Code", "Address 2", City, County, "Country/Region Code", "Post Code", Name);
        If not Customer.GetBySystemId(RelatedIdFilter) then
            Error(FiltersNotSpecifiedErrorLbl);

        Clear(Rec);
        If Customer."Ship-to Code" = '' then
            Rec."Default Address" := true;
        Rec."Standard Address" := true;
        Rec."ShipTo AddressId" := Customer.SystemId;
        Rec.Address := Customer.Address;
        Rec."Related Id" := Customer.SystemId;
        Rec."Address 2" := Customer."Address 2";
        Rec.City := Customer.City;
        Rec.County := Customer.County;
        Rec."Country/Region Code" := Customer."Country/Region Code";
        Rec."Post Code" := Customer."Post Code";
        Rec.Name := Customer.Name;
        Rec.Insert();

        ShipToAddress.SetRange("Customer No.", Customer."No.");

        If ShipToAddress.FindSet() then
            repeat
                Clear(Rec);
                If ShipToAddress.Code = Customer."Ship-to Code" then
                    Rec."Default Address" := true;
                Rec."ShipTo AddressId" := ShipToAddress.SystemId;
                Rec."Standard Address" := false;
                Rec.Address := ShipToAddress.Address;
                Rec."Address 2" := ShipToAddress."Address 2";
                Rec.City := ShipToAddress.City;
                Rec.County := ShipToAddress.County;
                Rec."Related Id" := Customer.SystemId;
                Rec."Country/Region Code" := ShipToAddress."Country/Region Code";
                Rec."Post Code" := ShipToAddress."Post Code";
                Rec.Name := ShipToAddress.Name;
                Rec.Insert();

            until ShipToAddress.Next() = 0;
    end;
}