reg [31:0] read_val;

initial begin
  #1000;
  wait(URESETN == 1);
  nclk();
  $display("write");
  iochannel_write_ctrl_thread_coramiochannel_0(1, 0);
  iochannel_write_ctrl_thread_coramiochannel_0(1024, 0);
  nclk();
  $display("read");
  iochannel_read_ctrl_thread_coramiochannel_0(read_val, 0);
  nclk();
  $display("iochannel read_val=%d", read_val);
  #1000;
  $finish;
end