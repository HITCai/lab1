module Container_tb();

  // Inputs and Outputs
  reg clock;
  reg reset;
  reg [31:0] data_in;
  wire [31:0] data_out;

  // Instantiate the DUT (Design Under Test)
  Container DUT (
    .clk(clock),
    .resetn(reset),
    .in(data_in),
    .out(data_out)
  );

  // Clock Generation
  always begin
    #5 clock = ~clock; // Toggle the clock every 5 time units
  end

  // Testbench Logic
  initial begin
    // Initialize signals
    clock = 0;
    reset = 0;
    data_in = 32'h00000000;

    // Apply reset and wait for a few clock cycles
    reset = 1;
    #10 reset = 0;

    // Apply stimulus
    data_in = 32'h10101010; // Example input data

    // Monitor and check results
    // You can add code here to check the values of data_out
    // and compare them against expected results.

    // End simulation after some time
    #1000 $finish;
  end

endmodule
