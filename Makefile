FUZION_SRC0 = fuzion/src
FUZION_SRC1 = ../fuzion/src
FUZION_SRC2 = ../../fuzion/src
FUZION_SRC3 = $(if $(shell test -e $(FUZION_SRC0) && echo OK),$(FUZION_SRC0), \
              $(if $(shell test -e $(FUZION_SRC1) && echo OK),$(FUZION_SRC1), \
              $(if $(shell test -e $(FUZION_SRC2) && echo OK),$(FUZION_SRC2),$(error "fuzion sources not found, tried $(FUZION_SRC0), $(FUZION_SRC1) or $(FUZION_SRC2)"))))
FUZION_SRC  = $(shell readlink -f $(FUZION_SRC3))

FUZION_BUILD = $(shell readlink -f $(FUZION_SRC)/../build)
FUZION_BIN = $(shell readlink -f $(FUZION_BUILD)/bin)

MODULES = http,lock_free,uuid,mail,wolfssl,java.base
MODULES_WITH_BCRYPT = $(MODULES),bcrypt

.PHONY: run_fz
run_fz: export FUZION_JAVA_ADDITIONAL_CLASSPATH = classes
run_fz: classes $(FUZION_BUILD)/modules/bcrypt.fum
	$(FUZION_BIN)/fz -jvm -JLibraries=wolfssl -verbose=2 -unsafeIntrinsics=on -modules=$(MODULES_WITH_BCRYPT) -sourceDirs=src run

webserver: export FUZION_JAVA_ADDITIONAL_CLASSPATH = classes
webserver: classes $(FUZION_BUILD)/modules/bcrypt.fum
	$(FUZION_BIN)/fz -c -CLink=wolfssl -CInclude="wolfssl/options.h wolfssl/ssl.h" -unsafeIntrinsics=on -modules=$(MODULES_WITH_BCRYPT) -sourceDirs=src -o=webserver run

.PHONY: run_fz_c
run_fz_c: export FUZION_JAVA_ADDITIONAL_CLASSPATH = classes
run_fz_c: export LD_LIBRARY_PATH = $(JAVA_HOME)/lib/server
run_fz_c: classes webserver
	./webserver

JAVA_COMPILER_RELEASE = 21

JAVA_FILES = java/module-info.java

JARS = \
	jars/bytes-1.3.0.jar \
	jars/bcrypt-0.9.0-optimized.jar

classes: $(JARS)
	mkdir -p $@
	unzip -o jars/bcrypt-0.9.0-optimized.jar -d classes
	unzip -o jars/bytes-1.3.0.jar -d classes
	javac --release $(JAVA_COMPILER_RELEASE) -d $@ $(JAVA_FILES)

jars:
	mkdir -p $@

jars/bcrypt-0.9.0-optimized.jar: | jars
	wget -O $@ https://github.com/patrickfav/bcrypt/releases/download/v0.9.0/bcrypt-0.9.0-optimized.jar

jars/bytes-1.3.0.jar: | jars
	wget -O $@ https://github.com/patrickfav/bytes-java/releases/download/v1.3.0/$(@F)

bcrypt.jmod: classes
	rm -f $@
	jmod create --class-path classes $@

$(FUZION_BUILD)/modules/bcrypt: export FUZION_JAVA_ADDITIONAL_CLASSPATH = classes
$(FUZION_BUILD)/modules/bcrypt: classes bcrypt.jmod
	rm -rf "$@"
	$(FUZION_BIN)/fzjava -to="$@" -modules=$(MODULES) bcrypt.jmod

$(FUZION_BUILD)/modules/bcrypt.fum: $(FUZION_BUILD)/modules/bcrypt
	rm -rf "$@"
	$(FUZION_BIN)/fz -sourceDirs="$(FUZION_BUILD)/modules/bcrypt" -modules=$(MODULES) -saveModule="$@"
