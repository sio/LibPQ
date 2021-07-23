PQ?=pqnet
PY?=python3


export EXPECT_PASSED_TESTS=30


export LIBPQ=$(abspath ../)
RESULTS=results.json


.PHONY: test
test: $(RESULTS)
$(RESULTS): LibPQ.pq LibPQPath.pq credentials.xml test.pq
$(RESULTS): $(wildcard ../Modules/*) $(wildcard ../Tests/*)
	$(PQ) . test -c credentials.xml -o json -f $(RESULTS)


.PHONY: verify
verify: $(RESULTS)
	$(PY) verify.py $(RESULTS)


.PHONY: clean
clean:
	git clean -dix


LibPQ.pq: ../LibPQ.pq
	cp $< $@


%: %.template
	envsubst < $< > $@
