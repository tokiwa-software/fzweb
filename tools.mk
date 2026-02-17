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
	for i in $$($(FZ) -e '(1..50).for_each say'); do curl -o /dev/null -s -w "%{time_total}\n" http://127.0.0.1:8080/tutorial/index; done | sort | awk '{ total += $$1; count++ } END { print "Avg:", total/count }'

.PHONY: bench_root
bench_root:
	ss -ltnp | grep :8080 || (echo "fzweb not running?" && exit 1)
	for i in $$($(FZ) -e '(1..50).for_each say'); do curl -o /dev/null -s -w "%{time_total}\n" http://127.0.0.1:8080/; done | sort | awk '{ total += $$1; count++ } END { print "Avg:", total/count }'

.PHONY: profile
profile:
	printf "output will be in out.prof\n"
	$(FZ) -debug=0 -XjavaProf=out.prof -jvm -JLibraries="wolfssl sodium" -verbose=2 -modules=$(MODULES) -sourceDirs=src run

.PHONY: flamegraph
flamegraph:
	printf "output will be in out.svg\n"
	$(FZ) -debug=0 -XjavaProf=out.svg -jvm -JLibraries="wolfssl sodium" -verbose=2 -modules=$(MODULES) -sourceDirs=src run

.PHONY: run_benchmarks
run_benchmarks:
	$(FZ) -debug=0 -jvm -JLibraries="wolfssl sodium" -modules=$(MODULES) -sourceDirs=src,benchmarks benchmarks

.PHONY: run_tests
run_tests:
	$(FZ) -jvm -JLibraries="wolfssl sodium" -modules=$(MODULES) -sourceDirs=src,tests tests

.PHONY: flamegraph_benchmarks
flamegraph_benchmarks:
	$(FZ) -debug=0 -XjavaProf=out.svg -jvm -JLibraries="wolfssl sodium" -modules=$(MODULES) -sourceDirs=src,benchmarks benchmarks

.PHONY: flamegraph_tests
flamegraph_tests:
	$(FZ) -debug=0 -XjavaProf=out.svg -jvm -JLibraries="wolfssl sodium" -modules=$(MODULES) -sourceDirs=src,tests tests
