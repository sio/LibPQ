PQ?=pqnet
PY?=python3


export EXPECT_PASSED_TESTS=30


export LIBPQ=$(abspath ../)
TEST_RESULTS=results.json


.PHONY: test
test: $(TEST_RESULTS)
$(TEST_RESULTS): LibPQ.pq LibPQPath.pq credentials.xml test.pq
$(TEST_RESULTS): $(wildcard ../Modules/*) $(wildcard ../Tests/*)
	$(PQ) . test -c credentials.xml -o json -f $(TEST_RESULTS)


.PHONY: verify
verify: $(TEST_RESULTS)
	$(PY) verify.py $(TEST_RESULTS)


.PHONY: clean
clean:
	git clean -dix


LibPQ.pq: ../LibPQ.pq
	cp $< $@


%: %.template
	envsubst < $< > $@
