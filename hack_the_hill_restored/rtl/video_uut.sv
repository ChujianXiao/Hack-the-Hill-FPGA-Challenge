/****************************************************************************
FILENAME     :  video_uut.sv
PROJECT      :  Hack the Hill 2024
****************************************************************************/

/*  INSTANTIATION TEMPLATE  -------------------------------------------------

video_uut video_uut (       
    .clk_i          ( ),//               
    .cen_i          ( ),//
    .vid_sel_i      ( ),//
    .vdat_bars_i    ( ),//[19:0]
    .vdat_colour_i  ( ),//[19:0]
    .fvht_i         ( ),//[ 3:0]
    .fvht_o         ( ),//[ 3:0]
    .video_o        ( ) //[19:0]
);

-------------------------------------------------------------------------- */


module video_uut (
    input  wire         clk_i           ,// clock
    input  wire         cen_i           ,// clock enable
    input  wire         vid_sel_i       ,// select source video
    input  wire [19:0]  vdat_bars_i     ,// input video {luma, chroma}
    input  wire [19:0]  vdat_colour_i   ,// input video {luma, chroma}
    input  wire [3:0]   fvht_i          ,// input video timing signals
    output wire [3:0]   fvht_o          ,// 1 clk pulse after falling edge on input signal
    output wire [19:0]  video_o          // 1 clk pulse after any edge on input signal
); 

reg [19:0]  vid_d1;
reg [3:0]   fvht_d1;
wire [19:0] vdat_bars_inter,vdat_colour_inter,vdat_bars_inter2,vdat_colour_inter2;

signalModifier image1Modifier(
    .i_clk(clk_i),
    .i_vdat_colour(vdat_bars_i),
    .i_fvht(fvht_i),
    .o_updated_colour(vdat_bars_inter)
);

signalModifier image2Modifier(
    .i_clk(clk_i),
    .i_vdat_colour(vdat_colour_i),
    .i_fvht(fvht_i),
    .o_updated_colour(vdat_colour_inter)
);

verticalModifier image1Vmod(
	.i_vdat_colour(vdat_bars_inter),
	.i_fvht(fvht_i),
   .o_updated_colour(vdat_bars_inter2)
);

verticalModifier image2Vmod(
	.i_vdat_colour(vdat_colour_inter),
	.i_fvht(fvht_i),
   .o_updated_colour(vdat_colour_inter2)
);


always @(posedge clk_i) begin
    if(cen_i) begin
        vid_d1  <= (vid_sel_i)? vdat_colour_inter2 : vdat_bars_inter2;
 //       vid_d1  <= (vid_sel_i)? vdat_colour_i : vdat_bars_i;
       fvht_d1 <= fvht_i;
    end
end

// OUTPUT
assign fvht_o  = fvht_d1;
assign video_o = vid_d1;

endmodule

