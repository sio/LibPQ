PQ?=pqnet
export LIBPQ=$(abspath ../)


.PHONY: test
test: LibPQ.pq LibPQPath.pq credentials.xml
	$(PQ) . $@ -c credentials.xml -o json


.PHONY: clean
clean:
	git clean -dix


LibPQ.pq: ../LibPQ.pq
	cp $< $@


%: %.template
	envsubst < $< > $@
