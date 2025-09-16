FUZION_SRC0 = fuzion/src
FUZION_SRC1 = ../fuzion/src
FUZION_SRC2 = ../../fuzion/src
FUZION_SRC3 = $(if $(shell test -e $(FUZION_SRC0) && echo OK),$(FUZION_SRC0), \
              $(if $(shell test -e $(FUZION_SRC1) && echo OK),$(FUZION_SRC1), \
              $(if $(shell test -e $(FUZION_SRC2) && echo OK),$(FUZION_SRC2),$(error "fuzion sources not found, tried $(FUZION_SRC0), $(FUZION_SRC1) or $(FUZION_SRC2)"))))
FUZION_SRC  = $(shell readlink -f $(FUZION_SRC3))

FLANG_DEV0 = flang_dev
FLANG_DEV1 = ../flang_dev
FLANG_DEV2 = ../../flang_dev
FLANG_DEV3 = $(if $(shell test -e $(FLANG_DEV0) && echo OK),$(FLANG_DEV0), \
              $(if $(shell test -e $(FLANG_DEV1) && echo OK),$(FLANG_DEV1), \
              $(if $(shell test -e $(FLANG_DEV2) && echo OK),$(FLANG_DEV2),$(error "flang.dev sources not found, tried $(FLANG_DEV0), $(FLANG_DEV1) or $(FLANG_DEV2)"))))
FLANG_DEV  = $(shell readlink -f $(FLANG_DEV3))

FUZION_BIN = $(shell readlink -f $(FUZION_SRC)/../build/bin)
MODULES = http,lock_free,uuid,java.base,java.desktop,java.datatransfer,java.xml,java.logging,java.security.sasl,webserver

.PHONY: run_fz
run_fz: export FUZION_JAVA_ADDITIONAL_CLASSPATH = $(FLANG_DEV)/classes
run_fz:
	$(FUZION_BIN)/fz -verbose=2 -unsafeIntrinsics=on -modules=$(MODULES) -sourceDirs=src run

webserver: export FUZION_JAVA_ADDITIONAL_CLASSPATH = $(FLANG_DEV)/classes
webserver:
	$(FUZION_BIN)/fz -c -unsafeIntrinsics=on -modules=$(MODULES) -sourceDirs=src -o=webserver run

.PHONY: run_fz_c
run_fz_c: export FUZION_JAVA_ADDITIONAL_CLASSPATH = $(FLANG_DEV)/classes
run_fz_c: export LD_LIBRARY_PATH = $(JAVA_HOME)/lib/server
run_fz_c: webserver
	./webserver
