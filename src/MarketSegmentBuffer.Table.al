table 53130 "TFB Market Segment Buffer"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {

        field(5; "Item ID"; GUID)
        {
            Caption = 'Item ID';
        }
        field(7; "Market Segment ID"; GUID)
        {
            Caption = 'Market Segment ID';
        }
        field(10; "Title"; Text[255])
        {
            Caption = 'Title';
        }

        field(20; "Description"; Text[512])
        {
            Caption = 'Short Description for slug';

        }
        field(92; Picture; MediaSet)
        {
            Caption = 'Picture';

        }

    }

    keys
    {
        key(PK; "Item ID", "Market Segment ID")
        {
            Clustered = true;
        }
    }

    procedure LoadDataFromFilters(ItemIdFilter: Guid)

    var
        Item: Record Item;
        ItemMarketRel: Record "TFB Generic Item Market Rel.";
        MarketSegment: Record "TFB Product Market Segment";

    begin

        If not IsNullGuid(ItemIdFilter) then
            If Item.GetBySystemId(ItemIdFilter) then
                ItemMarketRel.SetRange(GenericItemID, Item."TFB Generic Item ID");

        If ItemMarketRel.FindSet(false) then
            repeat
                clear(rec);
                Rec."Item ID" := ItemIdFilter;
                Rec."Market Segment ID" := ItemMarketRel.ProductMarketSegmentID;

                If MarketSegment.GetBySystemId(ItemMarketRel.ProductMarketSegmentID) then begin

                    Rec.Title := MarketSegment.Title;
                    Rec.Description := MarketSegment.Description;
                    Rec.Picture := MarketSegment.Picture;
                end;
                Rec.Insert();
            until ItemMarketRel.Next() = 0;


    end;




}