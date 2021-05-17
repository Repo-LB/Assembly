# Assembly

This repository mostly contains machine language code for Intel's x86 CPUs.  
A script for the Windows command line is also available to help compile assembly programs to disc images.

Contents :  

BootS.asm -> Real Mode (16bits) Bootloader. Allows real mode programs to execute at startup.  
The numbers at the start of comments represent the size of the instruction in bytes. Highly compatible (Should execute on any x86).

Editor.asm -> Demo project of a real mode program. Very basic text editor.  
A save function could be added using interrupt 13 (Drive operations). 

BootEditor.img -> Combination of bootloader and demo program. A compiled image ready to boot. 

QuickCompile.cmd -> A command line script to obtain bootable ".img" files.  
Compiles assembly to binary using NASM, then combines binaries into disc image. It also lists all valid assembly files in the selected directory. Change path to the desired work directory on line 3.  

Note: NASM requires a path for an environement variable in order to be used via the command line.
