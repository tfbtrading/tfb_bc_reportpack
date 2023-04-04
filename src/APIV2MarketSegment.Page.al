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
                field(imageCDN; ImageCDN)
                {
                    Caption = 'Image CDN';
                }

                field(lastModifiedDateTime; Rec.SystemModifiedAt)
                {

                }

            }
        }
    }

    trigger OnOpenPage()

    var

    begin
        CoreSetup.Get();
    end;

    trigger OnAfterGetRecord()
    var

    begin

        ImageCDN := StrSubstNo(CoreSetup."Image URL Pattern", ConvertStr(Rec.TableCaption + '_' + Rec.Title, ' ', '_'));

    end;

    var

        CoreSetup: Record "TFB Core Setup";
        ImageCDN: Text;
}
