#pragma implicitwith disable
page 53001 "TFB APIV2 - Customers"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Customer';
    EntitySetCaption = 'Customers';
    DataAccessIntent = ReadOnly;
    DelayedInsert = true;
    Editable = false;
    EntityName = 'customer';
    EntitySetName = 'customers';
    ODataKeyFields = SystemId;
    PageType = API;
    SourceTable = Customer;
    Extensible = false;
    APIPublisher = 'tfb';
    APIGroup = 'inreach';


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
                    ShowMandatory = true;

                }
                field(type; Rec."Contact Type")
                {
                    Caption = 'Type';


                }
                field(addressLine1; Rec.Address)
                {
                    Caption = 'Address Line 1';


                }
                field(addressLine2; Rec."Address 2")
                {
                    Caption = 'Address Line 2';

                }
                field(city; Rec.City)
                {
                    Caption = 'City';


                }
                field(state; Rec.County)
                {
                    Caption = 'State';
                }
                field(country; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(postalCode; Rec."Post Code")
                {
                    Caption = 'Post Code';

                }
                field(phoneNumber; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(email; Rec."E-Mail")
                {
                    Caption = 'Email';

                }
                field(website; Rec."Home Page")
                {
                    Caption = 'Website';


                }
                field(taxLiable; Rec."Tax Liable")
                {
                    Caption = 'Tax Liable';

                }

                field(currencyId; Rec."Currency Id")
                {
                    Caption = 'Currency Id';

                }
                field(currencyCode; CurrencyCodeTxt)
                {
                    Caption = 'Currency Code';


                }
                field(paymentTermsId; Rec."Payment Terms Id")
                {
                    Caption = 'Payment Terms Id';


                }
                field(paymentMethodId; Rec."Payment Method Id")
                {
                    Caption = 'Payment Method Id';

                }
                field(customerPriceGroupDesc; CustomerPriceGroupDesc)
                {

                    Caption = 'Customer Price Group';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';

                    trigger OnValidate()
                    begin
                        RegisterFieldSet(Rec.FieldNo(Blocked));
                    end;
                }
                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {
                    Caption = 'Last Modified Date';
                }
                part(customerFinancialDetails; "APIV2 - Cust Financial Details")
                {
                    Caption = 'Customer Financial Details';
                    Multiplicity = ZeroOrOne;
                    EntitySetName = 'customerFinancialDetails';
                    EntityName = 'customerFinancialDetail';
                    SubPageLink = SystemId = Field(SystemId);
                }
                part(picture; "APIV2 - Pictures")
                {
                    Caption = 'Picture';
                    Multiplicity = ZeroOrOne;
                    EntityName = 'picture';
                    EntitySetName = 'pictures';
                    SubPageLink = Id = Field(SystemId), "Parent Type" = const(Customer);
                }

                part(agedAccountsReceivable; "APIV2 - Aged AR")
                {
                    Caption = 'Aged Accounts Receivable';
                    Multiplicity = ZeroOrOne;
                    EntityName = 'agedAccountsReceivable';
                    EntitySetName = 'agedAccountsReceivables';
                    SubPageLink = AccountId = Field(SystemId);
                }
                part(contactsInformation; "APIV2 - Contacts Information")
                {
                    Caption = 'Contacts Information';
                    EntityName = 'contactInformation';
                    EntitySetName = 'contactsInformation';
                    SubPageLink = "Related Id" = field(SystemId), "Related Type" = const(Customer);
                }
                part(shipToAddresses; "TFB APIV2 - ShipTo Addresses")
                {
                    Caption = 'ShipTo Addresses';
                    EntityName = 'shipToAddress';
                    EntitySetName = 'shipToAddresses';
                    SubPageLink = "Related Id" = field(SystemId);
                }


                part(priceListItems; "TFB APIV2 - Price List Items")
                {
                    Caption = 'Price List Items';
                    EntityName = 'priceListItem';
                    EntitySetName = 'priceListItems';
                    SubPageLink = CustomerID = Field(SystemId);
                }
                part(orderLines; "TFB APIV2 - Order Lines")
                {
                    Caption = 'Customer Order Lines';
                    EntityName = 'orderLine';
                    EntitySetName = 'orderLines';
                    SubPageLink = CustomerID = Field(SystemId);
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetCalculatedFields();
    end;





    trigger OnOpenPage()
    begin

    end;

    var

        //PaymentMethod: Record "Payment Method";
        TempFieldSet: Record 2000000041 temporary;
        GraphMgtGeneralTools: Codeunit "Graph Mgt - General Tools";
        LCYCurrencyCode: Code[10];

        CurrencyCodeTxt: Text;
        CustomerPriceGroupDesc: Text;


    local procedure SetCalculatedFields()
    var
        CustomerPriceGroup: Record "Customer Price Group";

    begin
        CurrencyCodeTxt := GraphMgtGeneralTools.TranslateNAVCurrencyCodeToCurrencyCode(LCYCurrencyCode, Rec."Currency Code");
        CustomerPriceGroup.SetLoadFields(Description);
        CustomerPriceGroup.Get(Rec."Customer Price Group");
        CustomerPriceGroupDesc := CustomerPriceGroup.Description;
    end;



    local procedure RegisterFieldSet(FieldNo: Integer)
    begin
        if TempFieldSet.Get(Database::Customer, FieldNo) then
            exit;

        TempFieldSet.Init();
        TempFieldSet.TableNo := Database::Customer;
        TempFieldSet.Validate("No.", FieldNo);
        TempFieldSet.Insert(true);
    end;
}
#pragma implicitwith restore
