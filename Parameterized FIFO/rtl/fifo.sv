`timescale 1ns/1ps

module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 16,
    parameter ADDR_WIDTH = $clog2(DEPTH)
)(
    input  logic                     clk,
    input  logic                     rst_n,

    input  logic                     wr_en,
    input  logic                     rd_en,

    input  logic [DATA_WIDTH-1:0]    din,

    output logic [DATA_WIDTH-1:0]    dout,

    output logic                     full,
    output logic                     empty,

    output logic                     almost_full,
    output logic                     almost_empty,

    output logic [ADDR_WIDTH:0]      count
);

////////////////////////////////////////////////////////////
// Memory
////////////////////////////////////////////////////////////

logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

////////////////////////////////////////////////////////////
// Read / Write Pointers
////////////////////////////////////////////////////////////

logic [ADDR_WIDTH-1:0] wr_ptr;
logic [ADDR_WIDTH-1:0] rd_ptr;

////////////////////////////////////////////////////////////
// Status Flags
////////////////////////////////////////////////////////////

assign empty = (count == 0);

assign full  = (count == DEPTH);

assign almost_empty = (count <= 1);

assign almost_full  = (count >= DEPTH-1);

////////////////////////////////////////////////////////////
// FIFO Logic
////////////////////////////////////////////////////////////

always_ff @(posedge clk or negedge rst_n)
begin

    if(!rst_n)
    begin
        wr_ptr <= '0;
        rd_ptr <= '0;
        count  <= '0;
        dout   <= '0;
    end

    else
    begin

        case ({wr_en && !full, rd_en && !empty})

        ////////////////////////////////////////////////////
        // IDLE
        ////////////////////////////////////////////////////

        2'b00:
        begin
            // No Operation
        end

        ////////////////////////////////////////////////////
        // WRITE ONLY
        ////////////////////////////////////////////////////

        2'b10:
        begin

            mem[wr_ptr] <= din;

            if(wr_ptr == DEPTH-1)
                wr_ptr <= '0;
            else
                wr_ptr <= wr_ptr + 1;

            count <= count + 1;

        end

        ////////////////////////////////////////////////////
        // READ ONLY
        ////////////////////////////////////////////////////

        2'b01:
        begin

            dout <= mem[rd_ptr];

            if(rd_ptr == DEPTH-1)
                rd_ptr <= '0;
            else
                rd_ptr <= rd_ptr + 1;

            count <= count - 1;

        end

        ////////////////////////////////////////////////////
        // SIMULTANEOUS READ & WRITE
        ////////////////////////////////////////////////////

        2'b11:
        begin

            // Read old data
            dout <= mem[rd_ptr];

            // Write new data
            mem[wr_ptr] <= din;

            if(wr_ptr == DEPTH-1)
                wr_ptr <= '0;
            else
                wr_ptr <= wr_ptr + 1;

            if(rd_ptr == DEPTH-1)
                rd_ptr <= '0;
            else
                rd_ptr <= rd_ptr + 1;

            // Count remains unchanged

        end

        endcase

    end

end

endmodule