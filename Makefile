all:
	dune build
	cp _build/default/src/iit_main.exe iit
	chmod 771 iit

clean:
	rm -rf iit
	dune clean
