# Simon_Cypher_Encryption

This is a VHDL implementation of Simon Cypher encryption for an FPGA. 

It will load an input RAM with instructions from a mif file upload, then encrypt each line of data with 12 rounds of encryption and store in an Output RAM. The ROM contains a 64 bit private key which is used to generate the 12 round keys. 
