page 53005 "TFB APIV2 - Vendors"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Trade Vendor';
    EntitySetCaption = 'Trade Vendors';
    ChangeTrackingAllowed = true;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    EntityName = 'tradeVendor';
    EntitySetName = 'tradeVendors';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = Vendor;
    Extensible = false;
    APIPublisher = 'tfb';
    APIGroup = 'inreach';
    SourceTableView = where("TFB Vendor Type" = const(TRADE));


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
                field(number; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(displayName; Rec.Name)
                {
                    Caption = 'Display Name';


                }

                field(countryISO2; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';


                }

                
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                }

                part(picture; "APIV2 - Pictures")
                {
                    Caption = 'Picture';
                    Multiplicity = ZeroOrOne;
                    EntityName = 'picture';
                    EntitySetName = 'pictures';
                    SubPageLink = Id = Field(SystemId), "Parent Type" = const(Vendor);
                }

            }
        }
    }

    actions
    {
    }





    var
      
}

