page 53000 "TFB Price List Dialog"
{
    PageType = StandardDialog;
    Caption = 'Price List Parameters';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(MessageTopic; MessageTopicVar)
                {
                    Caption = 'Special Message';
                    ApplicationArea = All;
                    MultiLine = True;
                    Importance = Promoted;
                    ToolTip = 'Specifies the message to be included in the price list email';
                }
                field(EffectiveDate; _EffectiveDate)
                {
                    Caption = 'Effective Date';
                    Importance = Promoted;
                    ApplicationArea = All;
                    ToolTip = ' Enter a date for which you want the price list to be effective';
                }
                field(Duration; _Duration)
                {
                    Caption = 'Price History Duration';
                    Importance = Promoted;
                    ApplicationArea = All;
                    ToolTip = ' Enter a date formulae represents how far back you want to explore dates. Default is -1Y if nothing is entered';
                }
            }
        }
    }

    procedure Setup(newMessageTopic: text; newEffectiveDate: Date; newDuration: DateFormula)

    begin
        _Duration := newDuration;
        _EffectiveDate := newEffectiveDate;
        MessageTopicVar := newMessageTopic;

    end;

    procedure GetEffectiveDate(): Date

    begin
        Exit(_EffectiveDate);
    end;

    procedure GetDuration(): DateFormula

    begin
        Exit(_Duration);
    end;

    procedure GetMessageTopic(): Text

    begin
        Exit (MessageTopicVar);
    end;

    var
        _Duration: DateFormula;
        _EffectiveDate: Date;
        MessageTopicVar: Text;

}