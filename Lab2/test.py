import subprocess

tests = [
    'a', 
    'bada*', 
    '123', 
    's'*255,
    's'*256,
    'first', 
    'second',
    'third', 
    'fifth'
]

notFoundErr = "The key you are looking for was not found!\n"
overflowErr = "The input key is too large! (max size - 255 symb)\n"

expected = [
    notFoundErr,
    notFoundErr,
    notFoundErr,
    notFoundErr,
    overflowErr,
    '1st data\n',
    '2nd data\n',
    '3rd data\n', 
    '5th data\n'
]

FAIL = '\033[91m'
OK = '\033[92m'
ENDC = '\033[0m'

print("\n\n ---  Tests started  --- \n")
fileStartCommand = './app'
failures = 0

for i in range(len(tests)):
    print(f"Test {i+1}: ", end='')
    result = subprocess.run([fileStartCommand], input = tests[i].encode('utf_8') + b'\n', capture_output = True)

    if (i <= 4):
        output = result.stderr
    else:
        output = result.stdout

    if (output == expected[i].encode('utf_8')):
        print(OK + 'OK\n' + ENDC)
    else:
        failures += 1
        print(FAIL + 'FAIL\n' + ENDC)

if (failures == 1):
    print(FAIL + f'\n --- {failures} test failed --- \n' + ENDC)
elif(failures > 1):
    print(FAIL + f'\n --- {failures} tests failed --- \n' + ENDC)
else:
    print(OK + f'\n --- All test cases are passed! --- \n' + ENDC)