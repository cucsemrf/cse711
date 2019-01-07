The code for the packages appears in ve directories: main, lexer, symbol,
parser, and inter. The commands for creating the compiler vary from system
to system. The following are from a UNIX implementation:
        javac lexer/*.java
        javac symbols/*.java
        javac inter/*.java
        javac parser/*.java
        javac main/*.java
The javac command creates .class les for each class. The translator can
then be exercised by typing java main.Main followed by the source program to
be translated; e.g., the contents of le test
        1) { // File test
        2) int i; int j; float v; float x; float[100] a;
        3) while( true ) {
        4) do i = i+1; while( a[i] < v);
        5) do j = j-1; while( a[j] > v);
        6) if( i >= j ) break;
        7) x = a[i]; a[i] = a[j]; a[j] = x;
        8) }
        9) }