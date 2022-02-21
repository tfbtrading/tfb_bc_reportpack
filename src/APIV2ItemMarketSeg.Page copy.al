page 53009 "TFB APIV2 - Customer ShipTos"
{
    APIVersion = 'v2.0';
    EntityCaption = 'ShipTo Information';
    EntitySetCaption = 'ShipTo Information';
    DelayedInsert = true;
    EntityName = 'shipTo';
    EntitySetName = 'shipTo';
    ODataKeyFields = "Market Segment ID";

    PageType = API;
    SourceTable = "TFB Market Segment Buffer";
    SourceTableTemporary = true;

    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    APIPublisher = 'tfb';
    APIGroup = 'inreach';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field(marketSegmentID; Rec."Market Segment ID")
                {
                    Caption = 'Market Segment Id';
                }
                field(title; Rec.Title)
                {
                    Caption = 'Title';
                }
                part(marketSegment; "TFB APIV2 - Market Segment")
                {
                    Caption = 'Market Segment';
                    Multiplicity = ZeroOrOne;
                    EntityName = 'marketSegment';
                    EntitySetName = 'marketSegments';
                    SubPageLink = SystemId = Field("Market Segment ID");
                }

            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        RelatedIdFilter: Text;
        FilterView: Text;
    begin
        RelatedIdFilter := Rec.GetFilter("Item ID");

        if RelatedIdFilter = '' then begin
            Rec.FilterGroup(4);
            RelatedIdFilter := Rec.GetFilter("Item ID");
            Rec.FilterGroup(0);
            if (RelatedIdFilter = '') then
                Error(FiltersNotSpecifiedErrorLbl);
        end;
        if RecordsLoaded then
            exit(true);
        FilterView := Rec.GetView();
        Rec.LoadDataFromFilters(RelatedIdFilter);
        Rec.SetView(FilterView);
        if not Rec.FindFirst() then
            exit(false);
        RecordsLoaded := true;
        exit(true);
    end;

    var
        RecordsLoaded: Boolean;
        FiltersNotSpecifiedErrorLbl: Label 'id type not specified.';
}
