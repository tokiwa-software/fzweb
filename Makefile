ifndef FUZION_HOME
$(info ********FUZION_HOME not set************)
$(error ********please set FUZION_HOME to the build dir************)
endif

FZ = $(shell readlink -f $(FUZION_HOME)/bin)/fz

MODULES = http,lock_free,uuid,mail,wolfssl,crypto,sodium,nom,web

.PHONY: run_fz
run_fz:
	$(FZ) -jvm -JLibraries="wolfssl sodium" -verbose=3 -modules=$(MODULES) -sourceDirs=src run

# run fzweb from jar file
#
# NYI: UNDER DEVELOPMENT: Check if mail sending and hashing for login works
# (requires wolfssl and sodium, resp.).
#
.PHONY: run_fzjar
run_jar: build/fzweb_jar
	$^ run

# build fzweb into a jar file
#
build/fzweb_jar: $(shell find src/ -name "*.fz")
	mkdir -p $(@D)
	$(FZ) -jar -o=$@ -JLibraries="wolfssl sodium" -verbose=3 -modules=$(MODULES) -sourceDirs=src run

webserver:
	$(FZ) -c -CLink="wolfssl sodium" -CInclude="wolfssl/options.h wolfssl/ssl.h sodium.h" -modules=$(MODULES) -sourceDirs=src -o=webserver run

.PHONY: run_fz_c
run_fz_c: webserver
	./webserver
