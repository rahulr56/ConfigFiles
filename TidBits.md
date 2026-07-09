### 1) Print all files being loaded in bash
```
/bin/bash -lixc exit 2>&1 | sed -nE 's/^\+* (source|\.) //p'
```
* `-li` is login interactively
* `-x` prints out what bash is doing internally
* `-c` exit just tells bash to terminate immediately
* sed to filter out the `source` command or the `.` alias.
  * Passing -E flag to sed allows using extended (modern) regular expressions
