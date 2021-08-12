page 53004 "TFB APIV2 - Market Segment"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Market Segment';
    EntitySetCaption = 'Market Segments';
    DelayedInsert = true;
    EntityName = 'marketSegment';
    EntitySetName = 'marketSegments';
    ODataKeyFields = SystemId;

    PageType = API;
    SourceTable = "TFB Product Market Segment";

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

                field(id; Rec.SystemId)
                {
                    Caption = 'Market Segment Id';
                }
                field(title; Rec.Title)
                {
                    Caption = 'Title';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {

                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {

                }

            }
        }
    }

}
