PyCoRAM 
==============================
Yet Another Implementation of CoRAM Memory Architecture for AMBA AXI4 On-chip Interconnection

Copyright (C) 2013, Shinya Takamaeda-Yamazaki

E-mail: takamaeda\_at\_arch.cs.titech.ac.jp


License
------------------------------
Apache License 2.0
(http://www.apache.org/licenses/LICENSE-2.0)


What's PyCoRAM?
------------------------------

PyCoRAM is Python-based Implementation of CoRAM (Connected RAM) Memory Architecture for AXI4 Interconnection on FPGAs.

PyCoRAM generates AXI4 IP-core design from your computing kernel logic and memory access pattern descriptions.
The generated IP-core can be used as a standard IP-core with other common IP-cores together on vendor-provided EDK.

PyCoRAM differs in some points from the original soft-logic implementation of CoRAM on existing FPGAs.

* Memory access pattern representation in Python
    - The original CoRAM uses C. In PyCoRAM, you can describe in easier way using famous scripting language.
* AMBA AXI4 Interconnection Support
    - The original CoRAM uses CONNECT to generate an on-chip interconnect. PyCoRAM compiler generates IP-core design for AXI4 interconnection from you computing kernel logic. AMBA AXI4 is standard interconnection architecture supported in various environments.
* Parameterized RTL Design Support
    - The original CoRAM has some limitations in description of computing kernel logic. PyCoRAM has a sophisticated RTL analyzer to translate your logic design into suitable design for PyCoRAM.


Requirements
------------------------------

**Software**

*For simulation*

* Python 3.3 (or later)
* Pyverilog 0.7.0 (or later)
    - My original hardware design processing toolkit for Verilog HDL
    - Pyverilog 0.7.0 is included in this package.
* Icarus Verilog (0.9.6 or later)
   - Preprocessor of Pyverilog uses 'iverilog -E' command instead of the preprocessor.
* Jinja2 (2.7 or later)
   - Code generator requires jinja2 module.
   - 'pip3 install jinja2'

Icarus Verilog and Synopsys VCS are supported for Verilog simulation.

*For synthesis of an FPGA circuit design (bit-file)*

* Xilinx Platform Studio (14.6 or later)

**(Recommended) FPGA Board**

* Digilent Atlys (Spartan-6)
* Xilinx ML605 (Virtex-6)
* Xilinx VC707 (Virtex-7)


Getting Started
------------------------------

You can find the sample input projects in 'input/tests/single\_memory'.

* ctrl\_thread.py : Control-thread definition in Python
* userlogic.v  : User-defined Verilog code using CoRAM memory blocks

Then type 'make' and 'make run' to simulate sample system.

    make build
    make sim

Or type commands as below directly.

    python3.3 pycoram.py -t userlogic -I ./include/ ./input/tests/single_memory/ctrl_thread.py ./input/tests/single_memory/userlogic.v
    iverilog -I pycoram_userlogic_v1_00_a/hdl/verilog/ pycoram_userlogic_v1_00_a/test/test_pycoram_userlogic.v 
    ./a.out

PyCoRAM compiler generates a directory for IP-core (pycoram\_userlogic\_v1\_00\_a, in this example).

'pycoram\_userlogic\_v1\_00\_a.v' includes 
* IP-core RTL design (hdl/verilog/pycoram\_userlogic.v)
* Test bench (test/test\_pycoram\_userlogic.v) 
* XPS setting files (pycoram\_userlogic\_v2\_1\_0.{mpd,pao,tcl})

A bit-stream can be synthesized by using Xilinx Platform Studio.
Please copy the generated IP-core into 'pcores' directory of XPS project.


This software has some sample project in 'input'.
To build them, please modify 'Makefile', so that the corresponding files and parameters are selected (especially INPUT, MEMIMG and USERTEST)


PyCoRAM Command Options
------------------------------

**Command**

    python3 pycoram.py [-t topmodule] [-I includepath]+ [--memimg=filename] [--usertest=filename] [--simaddrwidth=int] [--noaxi] [-o outputfile] [file]+

**Description**

* file
    - User-logic Verilog file (.v) and control-thread definition file (.py).
      Automatically, .v file is recognized as a user-logic Verilog file, and 
      .py file recongnized as a control-thread definition, respectively.
* -t
    - Name of user-defined top module, default is "userlogic".
* -I
    - Include path for input Verilog HDL files.
* --memimg
    - DRAM image file in HEX DRAM (option, if you need).
      The file is copied into test directory.
      If no file is assigned, the array is initialized with incremental values.
* --usertest
    - User-defined test code file (option, if you need).
      The code is copied into testbench script.
* --simaddrwidth
    - DRAM address width of DRAM stub in the testbench.
* --noaxi
    - The compiler does NOT generate the system with AXI4 bus interface. default is disabled.
* -o
    - Name of output file in no-AXI mode. default is "out.v".

