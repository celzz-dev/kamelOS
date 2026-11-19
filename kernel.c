

void kernel_main(void){

  volatile unsigned short *vga = (unsigned short*)0xB8000;
  vga[0] = 0x0400 | 'h';
  vga[1] = 0x0400 | 'e';
  vga[2] = 0x0400 | 'l';
  vga[3] = 0x0400 | 'l';
  vga[4] = 0x0400 | 'o';   
}
