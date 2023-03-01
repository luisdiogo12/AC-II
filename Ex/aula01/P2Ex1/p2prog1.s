#int main(void){
#   char c;
#   do{
#       c = getChar();
#       putChar( c );
#   } while( c != '\n' );
#   return 0;
#}

    .equ    getChar , 2
    .equ    putChar , 3
    .data
    .text
    .globl  main
main:
    li      $v0 , getChar       # $v0 = getChar()
    syscall
    move    $a0 , $v0           # c = $a0 = $v0 
    li      $v0 , putChar       # putChar (c);
    syscall
    bne     $v0 , $zero , main
    li      $v0 , 10
    syscall
