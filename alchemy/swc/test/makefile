CC= gcc
AR= ar rcu
RANLIB= ranlib
CFLAGS= -O2 -Wall -fno-strict-aliasing -I../../src/mesa/include -I../../src/mesa/src/glu/sgi/include

default:test.swc

test.o:../../src/test/src/test.c
	$(CC) $(CFLAGS) $? -c -o $@
	
test.swc:test.o ../mesa/libmesa.a
	$(CC) $? -swc -o $@
