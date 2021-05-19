kahn: dune dune-project kahn.ml unix_implem.ml network_implem.ml seq_implem.ml th.ml application.ml sig.ml
	dune build 
	cp _build/default/kahn.exe kahn
	chmod +w kahn

clean:
	rm -rf _build
	rm kahn