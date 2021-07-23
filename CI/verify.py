import json
import os
import sys


with open(sys.argv[1]) as f:
    results = json.load(f)

successes = []
failures = []
for r in results:
    if r['Status'] == 'PASSED':
        successes.append(r)
    else:
        failures.append(r)

if failures:
    print(json.dumps(failures, ensure_ascii=False, sort_keys=True, indent=2))
assert len(failures) == 0, f'Number of failed tests: {len(failures)}'

expected = int(os.environ.get('EXPECT_PASSED_TESTS', 0))
newline = '\n  '
assert len(successes) == expected, \
    (f'Expected {expected} tests to pass, got {len(successes)}: {newline}'
     f'{newline.join(s["Suite"] + "::" + s["Test"] for s in successes)}')
print(f'Passed {len(successes)} tests successfully!')
