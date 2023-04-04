codeunit 53003 "TFB Cust. Statement Subs."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TFB Customer Mgmt", 'OnSendCustomerStatementeBeforeRunRequestPage', '', false, false)]
    local procedure MyProcedure(ReportID: Integer; var SkipRequest: Boolean)


    begin

        If ReportID = Report::"ForNAV Statement" then
            SkipRequest := true;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TFB Customer Mgmt", 'OnGenerateCustomerStatement', '', false, false)]
    local procedure OnGenerateCustomerStatement(ReportID: Integer; XmlParameters: Text; var OStream: OutStream; VarEmailRecordRef: RecordRef; var isHandled: Boolean);
    var
        ForNavStatement: Report "ForNAV Statement";

    begin

        ForNavStatement.InitializeRequest(true, true, true, true, '1M+CM', 1, CalcDate('<-1y>', WorkDate()), WorkDate());
        If ForNavStatement.SaveAs(XmlParameters, ReportFormat::Pdf, OStream, VarEmailRecordRef) then
            isHandled := true;
    end;

}