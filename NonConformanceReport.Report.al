Report 53001 "TFB Non-Conformance Report"
{
	WordLayout = './Layouts/TFB Non-Conformance Report.docx'; DefaultLayout = Word;

	dataset
	{
		dataitem(NonConformanceHeader;"TFB Non-Conformance Report")
		{
			column(ReportForNavId_2; 2) {} // Autogenerated by ForNav - Do not delete
			column(ReportForNav_NonConformanceHeader; ReportForNavWriteDataItem('NonConformanceHeader',NonConformanceHeader)) {}
			dataitem(ItemLedgerEntry;"Item Ledger Entry")
			{
				DataItemLinkReference = NonConformanceHeader;
				DataItemLink = "Entry No." = FIELD("Item Ledger Entry No.");
				column(ReportForNavId_3; 3) {} // Autogenerated by ForNav - Do not delete
				column(ReportForNav_ItemLedgerEntry; ReportForNavWriteDataItem('ItemLedgerEntry',ItemLedgerEntry)) {}
				trigger OnPreDataItem();
				begin
					ReportForNav.OnPreDataItem('ItemLedgerEntry',ItemLedgerEntry);
				end;
				
			}
			trigger OnPreDataItem();
			begin
				ReportForNav.OnPreDataItem('NonConformanceHeader',NonConformanceHeader);
			end;
			
		}
	}

	requestpage
	{

		SaveValues = false;
		layout
		{
			area(content)
			{
				group(Options)
				{
					Caption = 'Options';
					field(ForNavOpenDesigner; ReportForNavOpenDesigner)
					{
						ApplicationArea = Basic,Suite;
						Caption = 'Design';
						Visible = ReportForNavAllowDesign;
						ToolTip = 'Specifies whether report can be designed';
						trigger OnValidate()
						begin
							ReportForNav.LaunchDesigner(ReportForNavOpenDesigner);
							CurrReport.RequestOptionsPage.Close();
						end;

					}
				}
			}
		}

		actions
		{
		}
		trigger OnOpenPage()
		begin
			ReportForNavOpenDesigner := false;
		end;
	}

	trigger OnInitReport()
	begin
		;ReportsForNavInit;

	end;

	trigger OnPostReport()
	begin

	end;

	trigger OnPreReport()
	begin
		;ReportsForNavPre;
	end;

	// --> Reports ForNAV Autogenerated code - do not delete or modify
	var
		ReportForNavInitialized : Boolean;
		ReportForNavShowOutput : Boolean;
		ReportForNavTotalsCausedBy : Integer;
		ReportForNavOpenDesigner : Boolean;
		[InDataSet]
		ReportForNavAllowDesign : Boolean;
		ReportForNav : Codeunit "ForNAV Report Management";

	local procedure ReportsForNavInit() var id: Integer; begin Evaluate(id, CopyStr(CurrReport.ObjectId(false), StrPos(CurrReport.ObjectId(false), ' ') + 1)); ReportForNav.OnInit(id, ReportForNavAllowDesign); end;
	local procedure ReportsForNavPre() begin if ReportForNav.LaunchDesigner(ReportForNavOpenDesigner) then CurrReport.Quit(); end;
	local procedure ReportForNavSetTotalsCausedBy(value : Integer) begin ReportForNavTotalsCausedBy := value; end;
	local procedure ReportForNavSetShowOutput(value : Boolean) begin ReportForNavShowOutput := value; end;
	local procedure ReportForNavInit(jsonObject : JsonObject) begin ReportForNav.Init(jsonObject, CurrReport.ObjectId); end;
	local procedure ReportForNavWriteDataItem(dataItemId: Text; rec : Variant) : Text
	var
		values: Text;
		jsonObject: JsonObject;
		currLanguage: Integer;
	begin
		if not ReportForNavInitialized then begin
			ReportForNavInit(jsonObject);
			ReportForNavInitialized := true;
		end;

		case (dataItemId) of
			'NonConformanceHeader':
				begin
					currLanguage := GlobalLanguage; GlobalLanguage := 1033; jsonObject.Add('DataItem$NonConformanceHeader$CurrentKey$Text',NonConformanceHeader.CurrentKey); GlobalLanguage := currLanguage;
				end;
			'ItemLedgerEntry':
				begin
					currLanguage := GlobalLanguage; GlobalLanguage := 1033; jsonObject.Add('DataItem$ItemLedgerEntry$CurrentKey$Text',ItemLedgerEntry.CurrentKey); GlobalLanguage := currLanguage;
				end;
		end;
		ReportForNav.AddDataItemValues(jsonObject,dataItemId,rec);
		jsonObject.WriteTo(values);
		exit(values);
	end;
	// Reports ForNAV Autogenerated code - do not delete or modify -->
}
