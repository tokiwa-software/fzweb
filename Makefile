FUZION_SRC0 = fuzion/src
FUZION_SRC1 = ../fuzion/src
FUZION_SRC2 = ../../fuzion/src
FUZION_SRC3 = $(if $(shell test -e $(FUZION_SRC0) && echo OK),$(FUZION_SRC0), \
              $(if $(shell test -e $(FUZION_SRC1) && echo OK),$(FUZION_SRC1), \
              $(if $(shell test -e $(FUZION_SRC2) && echo OK),$(FUZION_SRC2),$(error "fuzion sources not found, tried $(FUZION_SRC0), $(FUZION_SRC1) or $(FUZION_SRC2)"))))
FUZION_SRC  = $(shell readlink -f $(FUZION_SRC3))

FUZION_BUILD = $(shell readlink -f $(FUZION_SRC)/../build)
FUZION_BIN = $(shell readlink -f $(FUZION_BUILD)/bin)

MODULES = http,lock_free,uuid,mail,wolfssl,crypto,sodium

.PHONY: run_fz
run_fz:
	$(FUZION_BIN)/fz -jvm -JLibraries=wolfssl -verbose=2 -unsafeIntrinsics=on -modules=$(MODULES) -sourceDirs=src run

webserver:
	$(FUZION_BIN)/fz -c -CLink="wolfssl sodium" -CInclude="wolfssl/options.h wolfssl/ssl.h sodium.h" -unsafeIntrinsics=on -modules=$(MODULES) -sourceDirs=src -o=webserver run

.PHONY: run_fz_c
run_fz_c: webserver
	./webserver
