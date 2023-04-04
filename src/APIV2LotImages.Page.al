page 53012 "TFB APIV2 - Lot Image URLs"
{
    APIVersion = 'v2.0';
    EntityCaption = 'Lot Image';
    EntitySetCaption = 'Lot Images';
    DelayedInsert = true;
    EntityName = 'lotImage';
    EntitySetName = 'lotImages';
    ODataKeyFields = SystemId;

    PageType = API;
    SourceTable = "TFB Lot Image";

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
                    Caption = 'id';
                }
                field(number; Rec."Item No.")
                {
                    Caption = 'number';
                }
                field(lotNo; Rec."Lot No.")
                {
                    Caption = 'lotno';
                }
                field(sequenceNo; Rec."Import Sequence No.")
                {
                    Caption = 'sequenceno';
                }
                field(modifiedAt; Rec.SystemModifiedAt)
                {
                    Caption = 'modifiedat';
                }
                field(gridUrl; getGridURL())
                {
                    Caption = 'gridurl';
                }


            }
        }
    }



    var
        CommonCU: CodeUnit "TFB Common Library";

    local procedure getGridURL(): Text[256]
    begin

        exit(CommonCU.GetLotImagesURL('gridbowl', Rec."Isol. Image Blob Name", Rec."Lot No.", Rec."Item No."));

    end;
}
