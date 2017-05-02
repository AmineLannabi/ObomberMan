SOURCES = ig.ml reseau.ml bomberman.ml
EXEC = bomberman.out

CAMLC = ocamlc

WITHGRAPHICS =graphics.cma
WITHUNIX =unix.cma
LIBS=$(WITHGRAPHICS) $(WITHUNIX)

all: depend $(EXEC)

opt : $(EXEC).opt


OBJS = $(SOURCES:.ml=.cmo)
OPTOBJS = $(SOURCES2:.ml=.cmx)

$(EXEC): $(OBJS)
	$(CAMLC)  -o $(EXEC) $(LIBS) $(OBJS)

$(EXEC).opt: $(OPTOBJS)
	$(CAMLOPT) -o $(EXEC) $(LIBS:.cma=.cmxa) $(OPTOBJS)

.SUFFIXES:
.SUFFIXES: .ml .mli .cmo .cmi .cmx

.ml.cmo:
	$(CAMLC) -c $<

.mli.cmi:
	$(CAMLC) -c $<

.ml.cmx:
	$(CAMLOPT) -c $<

clean:
	rm -f *.cm[iox] *~ .*~ #*#
	rm -f $(EXEC)
	rm -f $(EXEC).opt

depend: $(SOURCES2)
	$(CAMLDEP) *.mli *.ml > .depend

include .depend
