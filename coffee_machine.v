// Code your design here
module coffee_machine(
    input clk,
    input rst,
    input bean_check,
    input start_btn,
    input [2:0] mode_select, // 0: Milk with sugar, 1: Milk without sugar, 2: Espresso with sugar, 3: Espresso without sugar, 4: Cappuccino with sugar, 5: Cappuccino without sugar
    output reg cup_placed,
    output reg milk_dispense,
    output reg coffee_dispense,
    output reg sugar_dispense,
    output reg water_dispense,
    output reg stirrer_action,
    output reg done
);

  reg [2:0] current_state;

  // State definitions
  localparam S_IDLE = 3'b000,
             S_CHECK_BEANS = 3'b001,
             S_SELECT_MODE = 3'b010,
             S_PROCESS = 3'b011,
             S_DISPENSE = 3'b100,
             S_DONE = 3'b101;

  always @(posedge clk) begin
    if (rst) begin
      current_state <= S_IDLE;
      cup_placed <= 0;
      milk_dispense <= 0;
      coffee_dispense <= 0;
      sugar_dispense <= 0;
      water_dispense <= 0;
      stirrer_action <= 0;
      done <= 0;
    end else begin
      case (current_state)
        S_IDLE: begin
          if (bean_check)
            current_state <= S_CHECK_BEANS;
        end
        S_CHECK_BEANS: begin
          current_state <= S_SELECT_MODE;
        end
        S_SELECT_MODE: begin
          if (start_btn) begin
            current_state <= S_PROCESS;
            cup_placed <= 1; // Assuming cup is placed at the start of the process
          end
        end
        S_PROCESS: begin
          case (mode_select)
            3'b000: begin // Milk with sugar
              milk_dispense <= 1;
              sugar_dispense <= 1;
              stirrer_action <= 1;
            end
            3'b001: begin // Milk without sugar
              milk_dispense <= 1;
              stirrer_action <= 1;
            end
            3'b010: begin // Espresso with sugar
              coffee_dispense <= 1;
              sugar_dispense <= 1;
              stirrer_action <= 1;
              water_dispense <=1;
            end
            3'b011: begin // Espresso without sugar
              coffee_dispense <= 1;
              stirrer_action <= 1;
              water_dispense <=1;
            end
            3'b100: begin // Cappuccino with sugar
              coffee_dispense <= 1;
              milk_dispense <= 1;
              sugar_dispense <= 1;
              stirrer_action <= 1;
            end
            3'b101: begin // Cappuccino without sugar
              coffee_dispense <= 1;
              milk_dispense <= 1;
              stirrer_action <= 1;
            end
          endcase
          current_state <= S_DISPENSE;
        end
        S_DISPENSE: begin
          milk_dispense <= 0;
          coffee_dispense <= 0;
          sugar_dispense <= 0;
          water_dispense <= 0;
          stirrer_action <= 0;
          done <= 1;
          current_state <= S_DONE;
        end
        S_DONE: begin
          done <= 0;
          current_state <= S_IDLE;
          cup_placed <= 0;
        end
        default: current_state <= S_IDLE;
      endcase
    end
  end
endmodule