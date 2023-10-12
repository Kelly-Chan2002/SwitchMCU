/* verilator lint_off STMTDLY */

module ahbs_swc_tb;
  //Ports
  reg                   hclk  = 1   ;
  reg                   hrstn       ;
  reg   [31:0]          haddr       ;
  reg                   hmastlock   ;
  reg   [6:0]           hprot       ;
  reg   [2:0]           hsize       ;
  reg   [1:0]           htrans      ;
  reg   [31:0]          hwdata      ;
  wire  [31:0]          hrdata      ;
  reg                   hwrite      ;
  wire                  hready      ;
  wire                  hresp       ;
  wire                  wreq        ;
  wire  [31:0]          wbuffdata   ;
  wire  [31:0]          wbuffaddr   ;
  wire                  rreq        ;
  reg   [31:0]          rbuffdata   ;
  wire  [31:0]          rbuffaddr   ;
  wire                  done        ;
  wire                  resp        ;

  ahbs_swc  ahbs_swc_inst (
    .hclk       (hclk       ),
    .hrstn      (hrstn      ),
    .haddr      (haddr      ),
    .hmastlock  (hmastlock  ),
    .hprot      (hprot      ),
    .hsize      (hsize      ),
    .htrans     (htrans     ),
    .hwdata     (hwdata     ),
    .hrdata     (hrdata     ),
    .hwrite     (hwrite     ),
    .hready     (hready     ),
    .hresp      (hresp      ),
    .wreq       (wreq       ),
    .wbuffdata  (wbuffdata  ),
    .wbuffaddr  (wbuffaddr  ),
    .rreq       (rreq       ),
    .rbuffdata  (rbuffdata  ),
    .rbuffaddr  (rbuffaddr  ),
    .done       (done       ),
    .resp       (resp       )
  );

always #5  hclk = ! hclk ;

initial begin
    $dumpfile("ahbs_swc_tb.vcd");
    $dumpvars(0, ahbs_swc_tb);
    #500 $finish;
end

initial begin
    // Reset sequence
    #1;
    hrstn = 0;
    #10;
    hrstn = 1;

    // Setup
    #10;
    hmastlock = 0;
    hsize = 3'b010; // Word transfer
    hprot = 7'b0000000;

    // FSM Testbench
    // WRITE+READ 3x
    // WRITE 6x
    // READ 6x
    // WRITE -> RESET -> WRITE
    // WRITE -> RESET -> READ
    // READ -> RESET -> WRITE
    // READ -> RESET -> READ
    // WRITE -> ERROR -> WRITE
    // WRITE -> ERROR -> READ
    // READ -> ERROR -> WRITE
    // READ -> ERROR -> READ
    // WRITE -> IDLE -> WRITE
    // WRITE -> IDLE -> READ
    // READ -> IDLE -> WRITE
    // READ -> IDLE -> READ

    // WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    // READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;
    // WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    // READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;
    // WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    // READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;

    // WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    // WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    // WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    // WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    // WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    // WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;

    // READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;
    // READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;
    // READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;
    // READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;
    // READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;
    // READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;

        // WRITE -> RESET -> WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    #10;
    hrstn = 0; // RESET
    #10;
    hrstn = 1; // Exit RESET
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;

    // WRITE -> RESET -> READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;
    #10;
    hrstn = 0; // RESET
    #10;
    hrstn = 1; // Exit RESET
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;

    // READ -> RESET -> WRITE
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;
    #10;
    hrstn = 0; // RESET
    #10;
    hrstn = 1; // Exit RESET
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 1;

    // READ -> RESET -> READ
    #10;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;
    #10;
    hrstn = 0; // RESET
    #10;
    hrstn = 1; // Exit RESET
    #10;
    haddr = 32'h11010100;
    htrans = 2'b10; // NONSEQ
    hwrite = 0;

    // // WRITE -> ERROR -> WRITE
    // #10;
    // haddr = 32'h11010100;
    // htrans = 2'b10; // NONSEQ
    // hwrite = 1;
    // #10;
    // hresp = 1; // ERROR
    // #10;
    // hresp = 0; // Exit ERROR
    // #10;
    // haddr = 32'h11010100;
    // htrans = 2'b10; // NONSEQ
    // hwrite = 1;

    // // WRITE -> ERROR -> READ
    // #10;
    // haddr = 32'h11010100;
    // htrans = 2'b10; // NONSEQ
    // hwrite = 1;
    // #10;
    // hresp = 1; // ERROR
    // #10;
    // hresp = 0; // Exit ERROR
    // #10;
    // haddr = 32'h11010100;
    // htrans = 2'b10; // NONSEQ
    // hwrite = 0;

    // // READ -> ERROR -> WRITE
    // #10;
    // haddr = 32'h11010100;
    // htrans = 2'b10; // NONSEQ
    // hwrite = 0;
    // #10;
    // hresp = 1; // ERROR
    // #10;
    // hresp = 0; // Exit ERROR
    // #10;
    // haddr = 32'h11010100;
    // htrans = 2'b10; // NONSEQ
    // hwrite = 1;

    // // READ -> ERROR -> READ
    // #10;
    // haddr = 32'h11010100;
    // htrans = 2'b10; // NONSEQ
    // hwrite = 0;
    // #10;
    // hresp = 1; // ERROR
    // #10;
    // hresp = 0; // Exit ERROR
    // #10;
    // haddr = 32'h11010100;
    // htrans = 2'b10; // NONSEQ
    // hwrite = 0;

end

endmodule
/* verilator lint_on STMTDLY */