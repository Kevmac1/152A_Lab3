module ucsbece152a_counter #(
    parameter WIDTH = 3
) (
    input logic clk,
    input logic rst,
    output logic [WIDTH-1:0] count_o,
    input logic enable_i,
    input logic dir_i
);

logic [WIDTH-1:0] count;


always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 0;
    end else if (enable_i) begin
        if (dir_i) begin
          if (count == 0) count <= (2**WIDTH - 1);
          else count <= count - 1;
            
          end else begin 
           if (count == (2**WIDTH - 1)) count <=0;
           else count <= count + 1;
    end
  end
end
assign count_o = count;

endmodule
