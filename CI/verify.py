import json
import os
import sys


with open(sys.argv[1]) as f:
    results = json.load(f)
print(json.dumps(results, ensure_ascii=False, sort_keys=True, indent=2))

assert len(results) == 1, f'Number of unique test statuses: {len(results)} instead of 1'

summary = results[0]
assert summary["Status"] == "PASSED", f'All tests are {summary["Status"]}'

expected = int(os.environ.get('EXPECTED_SUCCESS_TESTS', 0))
assert summary["Count"] == expected, f'Expected {expected} tests to pass, got {summary["Count"]}'
