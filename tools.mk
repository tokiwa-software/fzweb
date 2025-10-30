# -----------------------------------------------------------------------
#
#  Tokiwa Software GmbH, Germany
#
#  Source code of tools.mk
#
#  collections of tools to ease development of fzweb
#
# -----------------------------------------------------------------------

# usage example:
#
# make -f tools.mk flamegraph
#

include Makefile

.PHONY: bench_tutorial
bench_tutorial:
	ss -ltnp | grep :8080 || (echo "fzweb not running?" && exit 1)
	for i in $$($(FUZION_BIN)/fz -e '(1..50).for_each say'); do curl -o /dev/null -s -w "%{time_total}\n" http://127.0.0.1:8080/tutorial/index; done | sort | awk '{ total += $$1; count++ } END { print "Avg:", total/count }'

.PHONY: bench_root
bench_root:
	ss -ltnp | grep :8080 || (echo "fzweb not running?" && exit 1)
	for i in $$($(FUZION_BIN)/fz -e '(1..50).for_each say'); do curl -o /dev/null -s -w "%{time_total}\n" http://127.0.0.1:8080/; done | sort | awk '{ total += $$1; count++ } END { print "Avg:", total/count }'

.PHONY: profile
profile:
	printf "output will be in out.prof\n"
	$(FUZION_BIN)/fz -XjavaProf=out.prof -jvm -JLibraries="wolfssl sodium" -verbose=2 -modules=$(MODULES) -sourceDirs=src run

.PHONY: flamegraph
flamegraph:
	printf "output will be in out.svg\n"
	$(FUZION_BIN)/fz -XjavaProf=out.svg -jvm -JLibraries="wolfssl sodium" -verbose=2 -modules=$(MODULES) -sourceDirs=src run
