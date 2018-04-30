all:
	bison -d numbers.y
	flex -t numbers.l > numbers.c
	gcc -c -o numbers.o numbers.c
	gcc -c -o numbers.tab.o numbers.tab.c
	gcc numbers.o numbers.tab.o -o compiler
