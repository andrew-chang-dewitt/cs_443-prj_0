all:
	dune build
	cp _build/default/src/iit_main.exe iit
	chmod 771 iit

iit: all

clean:
	rm -rf iit
	dune clean

test: iit
	./test.sh alltests
