# Makefile Usage

The project includes a `Makefile` to simplify common tasks such as running the analyzer, testing the analyzer, generating reports, cleaning generated files, and checking required tools.

Instead of typing the complete `./analyze.sh` command every time, you can use `make` commands.

## Makefile Syntax

The general syntax is:

```bash
make <target>
```

For example:

```bash
make help
```

displays the available Makefile targets.

---

## Available Targets

The Makefile provides the following targets:

| Target   | Description                                              |
| -------- | -------------------------------------------------------- |
| `all`    | Run the analyzer on all test log files                   |
| `test`   | Run the analyzer on test data and verify expected output |
| `report` | Generate a summary report in `output/`                   |
| `clean`  | Remove generated output files                            |
| `help`   | Display available Makefile targets                       |
| `setup`  | Check that all required tools are installed              |

---

## `make all`

Runs the analyzer on all available test log files.

### Syntax

```bash
make all
```

This target is useful for performing a complete analysis of the available simulation logs.

Example:

```bash
$ make all
```

The Makefile runs the analyzer for each applicable log file.

---

## `make test`

Runs the analyzer against the project's test data and checks the results against the expected output.

### Syntax

```bash
make test
```

Example:

```bash
$ make test
```

This target is useful for verifying that changes to `analyze.sh` have not broken existing functionality.

A typical workflow after modifying the analyzer is:

```bash
make test
```

If the tests pass, the analyzer is behaving as expected.

---

## `make report`

Generates a summary report and stores the generated files in the `output/` directory.

### Syntax

```bash
make report
```

Example:

```bash
$ make report
```

After running the target, generated reports can be found under:

```text
output/
```

This target is useful when a report needs to be generated without manually entering the complete analyzer command.

---

## `make clean`

Removes generated output files.

### Syntax

```bash
make clean
```

Example:

```bash
$ make clean
```

This is useful for returning the project to a clean state before running tests or generating new reports.

**Note:** This target should remove generated files only. Source files such as `analyze.sh`, `Makefile`, and test input files should not be deleted.

---

## `make help`

Displays the available Makefile targets and their descriptions.

### Syntax

```bash
make help
```

Example:

```bash
$ make help
```

A typical help message may look like:

```text
Available targets:
  all      Run analyzer on all test log files
  test     Run analyzer tests
  report   Generate summary report
  clean    Remove generated output files
  setup    Check required tools
  help     Show this help message
```

`make help` is useful when you forget the available project commands.

---

## `make setup`

Checks whether the required tools for the project are available.

### Syntax

```bash
make setup
```

Example:

```bash
$ make setup
```

The setup check can verify tools such as:

```text
bash
grep
sed
make
```

If a required tool is missing, the setup check should report the problem.

This target is especially useful when setting up the project on a new Linux system.

---

# Typical Makefile Workflow

A recommended workflow for the project is:

### 1. Check the environment

```bash
make setup
```

### 2. Run the tests

```bash
make test
```

### 3. Generate the report

```bash
make report
```

### 4. Run the complete analyzer

```bash
make all
```

### 5. Clean generated files when needed

```bash
make clean
```

---

# Direct Script vs Makefile

The analyzer can still be executed directly without using `make`.

For example:

```bash
./analyze.sh log_file.log --format csv --output report.csv
```

The Makefile provides shortcuts for common project operations.

| Direct command                  | Makefile approach                   |
| ------------------------------- | ----------------------------------- |
| `./analyze.sh log_file.log`     | Use the appropriate Makefile target |
| Run all logs manually           | `make all`                          |
| Run tests manually              | `make test`                         |
| Generate report manually        | `make report`                       |
| Delete generated files manually | `make clean`                        |
| Check available commands        | `make help`                         |
| Check required tools            | `make setup`                        |

The Makefile does not replace `analyze.sh`. It provides an easier way to automate and organize frequently used commands.

---

# Makefile Help

To see the available project commands at any time:

```bash
make help
```

This is the recommended starting point if you are unfamiliar with the project's Makefile.

