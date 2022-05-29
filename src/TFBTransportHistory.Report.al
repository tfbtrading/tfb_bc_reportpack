report 53004 "TFB Transport History"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = ExcelDefault;
    Caption = 'Transport History';

    dataset
    {
        dataitem(WhseShipmentLine; "Posted Whse. Shipment Line")
        {
            DataItemTableView = sorting("Posting Date", "No.", "Line No.") where("Unit of Measure Code" = filter('PALLET'));
            RequestFilterFields = "Item No.";
            RequestFilterHeading = 'Warehouse Transport Details';
            PrintOnlyIfDetail = true;
            column(ItemNo; "Item No.")
            {

            }
            column(ItemName; Description)
            {

            }
            column(ReferenceNo; "Whse. Shipment No.")
            {

            }
            column(ShipmentNo; WhseShipmentLine."Posted Source No.")
            {

            }
            column(Type; WhseShipmentLine."Source Document")
            {

            }
            column(Quantity; Quantity)
            {

            }
            column(Consolidated; Consolidated)
            {

            }


            dataitem(WhseShipmentHeader; "Posted Whse. Shipment Header")
            {
                DataItemLinkReference = WhseShipmentLine;
                DataItemLink = "No." = field("No.");

                RequestFilterFields = "Posting Date";
                RequestFilterHeading = 'Warehouse Transport Details';

                column(DateShipped; "Posting Date")
                {

                }

                column(ShippingAgent; "Shipping Agent Code")
                {

                }

                column(DestPostCode; DestPostCode)
                {

                }

                dataitem(Location; Location)
                {
                    DataItemLinkReference = WhseShipmentHeader;
                    DataItemLink = Code = field("Location Code");


                    column(OrigPostCode; "Post Code")
                    {

                    }
                }

                column(Cubage; Cubage)
                {

                }
                column(Length; Length)
                {

                }
                column(Width; Width)
                {

                }
                column(Height; Height)
                {

                }
                column(UnitWeight; Weight)
                {

                }

                trigger OnAfterGetRecord()

                var
                    ItemUnitOfMeasure: Record "Item Unit of Measure";


                begin
                    If ItemUnitOfMeasure.Get(WhseShipmentLine."Item No.", WhseShipmentLine."Unit of Measure Code") then begin
                        Weight := ItemUnitOfMeasure.Weight;
                        Cubage := ItemUnitOfMeasure.Cubage;
                        Height := ItemUnitOfMeasure.Height;
                        Width := ItemUnitOfMeasure.Width;
                        Length := ItemUnitOfMeasure.Length;
                    end
                    else begin
                        Weight := 0;
                        Cubage := 0;
                        Height := 0;
                        Width := 0;
                        Length := 0;
                    end;



                end;

            }



            trigger OnAfterGetRecord()

            var
                SalesShipment: Record "Sales Shipment Header";
                TransferShipment: record "Transfer Shipment Header";


            begin

                If (WhseShipmentHeader."No." = TempPostedRef) then begin
                    if not (WhseShipmentLine."Posted Source No." = TempSourceRef) or Consolidated then begin
                        Consolidated := true
                    end
                end
                else
                    Consolidated := false;


                case WhseShipmentLine."Posted Source Document" of
                    WhseShipmentLine."Posted Source Document"::"Posted Shipment":
                        begin

                            SalesShipment.SetLoadFields("Ship-to Post Code");
                            SalesShipment.SetRange("No.", WhseShipmentLine."Posted Source No.");
                            If SalesShipment.FindFirst() then
                                DestPostCode := SalesShipment."Ship-to Post Code"
                            else
                                DestPostCode := '';
                        end;

                    WhseShipmentLine."Posted Source Document"::"Posted Transfer Shipment":
                        begin
                            TransferShipment.SetLoadFields("Transfer-to Post Code");
                            TransferShipment.SetRange("No.", WhseShipmentLine."No.");
                            If TransferShipment.FindFirst() then
                                DestPostCode := TransferShipment."Transfer-to Post Code";

                        end;

                end;



                TempPostedRef := WhseShipmentHeader."No.";
                TempSourceRef := WhseShipmentLine."Posted Source No.";

            end;
        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {

                }
            }
        }


    }

    rendering
    {
        layout(ExcelDefault)
        {
            Type = Excel;
            LayoutFile = 'Layouts/DefaultTransportHistory.xlsx';
        }
    }

    var
        DestPostCode: Code[20];

        Consolidated: Boolean;

        TempSourceRef: Code[20];
        TempPostedRef: Code[20];
        Weight, Cubage, Height, Width, Length : Decimal;
}