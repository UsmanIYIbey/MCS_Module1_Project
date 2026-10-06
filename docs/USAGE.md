# RISC-V Log Analyzer — Command Reference

## Command Syntax

```bash
./analyze.sh <log_file> [options]
```

The log file is the required first argument. Options are provided after the log file.

Example:

```bash
./analyze.sh log_file.log --format csv --output report.csv
```

---

## Arguments

### `<log_file>`

Path to the RISC-V simulation log file.

Example:

```bash
./analyze.sh log_file.log
```

The log file is required.

If no log file is provided:

```bash
./analyze.sh
```

the script reports an error and exits.

---

# Options

## `--format`

Select the output format.

### Syntax

```bash
--format <format>
```

Supported formats:

| Format | Description |
|---|---|
| `text` | Human-readable text report |
| `csv` | Comma-separated report |

The default format is:

```text
text
```

### Example

```bash
./analyze.sh log_file.log --format text
```

CSV output:

```bash
./analyze.sh log_file.log --format csv
```

If an unsupported format is provided:

```bash
./analyze.sh log_file.log --format json
```

the script reports that only `text` and `csv` are supported.

---

## `--output`

Specify where the generated report should be written.

### Syntax

```bash
--output <path>
```

If `--output` is not specified, the report is written to standard output (the terminal).

### Example

```bash
./analyze.sh log_file.log --output report.txt
```

The report is written to:

```text
report.txt
```

CSV report:

```bash
./analyze.sh log_file.log --format csv --output report.csv
```

---

## `--verbose`

Enable verbose output.

### Syntax

```bash
--verbose
```

Example:

```bash
./analyze.sh log_file.log --verbose
```

Verbose mode can be used when additional information about processing is required.

---

## `--help`

Display the command usage information.

### Syntax

```bash
./analyze.sh --help
```

Example output:

```text
Usage
./analyze.sh <Path to log file (required)>
--format [text|csv]: Output format (default: text)
--output <path>: Output file path (default: stdout)
--verbose: Enable verbose output
--help: Print usage information
```

The script exits after displaying the help information.

---

# Combining Options

Multiple options can be used in the same command.

### Text report written to a file

```bash
./analyze.sh log_file.log --format text --output report.txt
```

### CSV report written to a file

```bash
./analyze.sh log_file.log --format csv --output report.csv
```

### CSV report with verbose mode

```bash
./analyze.sh log_file.log --format csv --verbose
```

### All options

```bash
./analyze.sh log_file.log --format csv --output report.csv --verbose
```

---

# Report Contents

The analyzer extracts the following information from the simulation log.

## Test Summary

The report contains:

- Total number of tests
- Number of passed tests
- Number of failed tests
- Number of skipped tests
- Percentage of passed tests
- Percentage of failed tests
- Percentage of skipped tests

Example:

```text
--- Results Summary ---
Total Tests:         4
Passed:              2 (50%)
Fail:                1 (25%)
Skipped:             1 (25%)
```

## Failed Tests

Failed test names are listed separately.

Example:

```text
------Failed Tests-----------
 1. rv32i-sll
```

## Timing Statistics

For tests that contain timing information, the analyzer calculates:

- Minimum execution time
- Test with the minimum execution time
- Maximum execution time
- Test with the maximum execution time
- Average execution time

Example:

```text
----------------Timing Statistics----------------
Min time: 0.65s (rv32i-sub)
Max time: 1.02s (rv32i-sll)
Avg time: 0.83s
```

---

# Expected Log Format

The analyzer expects test-related lines similar to:

```text
[2026-05-01 10:23:45] TEST START: rv32i-add
[2026-05-01 10:23:46] TEST PASS: rv32i-add (0.82s)
[2026-05-01 10:23:46] TEST START: rv32i-sub
[2026-05-01 10:23:47] TEST PASS: rv32i-sub (0.65s)
[2026-05-01 10:23:47] TEST START: rv32i-sll
[2026-05-01 10:23:48] TEST FAIL: rv32i-sll (1.02s)
[2026-05-01 10:23:48] ERROR: Signature mismatch at line 42
[2026-05-01 10:23:48] TEST START: rv32i-srl
[2026-05-01 10:23:48] TEST SKIP: rv32i-srl (not supported)
```

The analyzer recognizes the following test status patterns:

```text
TEST START
TEST PASS
TEST FAIL
TEST SKIP
```

---

# Exit Behavior

The script exits successfully after processing a valid log file.

An error exit status is used when a required argument is missing or another input error occurs.

For example:

```bash
./analyze.sh
```

results in an error because the log file is required.

---

# Examples

## Example 1 — Basic Analysis

```bash
./analyze.sh log_file.log
```

Produces a text report on the terminal.

## Example 2 — CSV Report

```bash
./analyze.sh log_file.log --format csv
```

Produces the report in CSV format.

## Example 3 — Save Report

```bash
./analyze.sh log_file.log --output analysis.txt
```

Saves the report to `analysis.txt`.

## Example 4 — Complete Command

```bash
./analyze.sh log_file.log --format csv --output analysis.csv --verbose
```

This:

1. Reads `log_file.log`
2. Generates a CSV report
3. Saves the report as `analysis.csv`
4. Enables verbose processing information
