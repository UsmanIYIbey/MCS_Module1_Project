# RISC-V Log Analyzer

A Bash-based command-line tool for analyzing RISC-V simulation log files. It parses test results from simulation logs and generates a summary containing total, passed, failed, and skipped tests, failed test names, and timing statistics.

## Features

- Count total simulation tests
- Count passed, failed, and skipped tests
- Calculate pass, fail, and skip percentages
- List failed tests
- Calculate minimum, maximum, and average test execution time
- Generate reports in text or CSV format
- Write output to a file or display it on the terminal
- Verbose mode for additional information
- Command-line help

## Installation

Clone the repository:

```bash
git clone <repository-url>
cd riscv-log-analyzer
```

Make the script executable:

```bash
chmod +x analyze.sh
```

No external installation is required. The tool uses standard Linux utilities and Bash.

## Usage

Basic syntax:

```bash
./analyze.sh <log_file> [options]
```

For example:

```bash
./analyze.sh log_file.log
```

Generate a CSV report:

```bash
./analyze.sh log_file.log --format csv
```

Write the report to a file:

```bash
./analyze.sh log_file.log --output report.txt
```

Enable verbose mode:

```bash
./analyze.sh log_file.log --verbose
```

Display help:

```bash
./analyze.sh --help
```

Options can be combined:

```bash
./analyze.sh log_file.log --format csv --output report.csv --verbose
```

For a complete description of all commands and options, see [USAGE.md](USAGE.md).

## Example

Given a simulation log containing:

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

Run:

```bash
./analyze.sh log_file.log
```

### Sample Output

```text
=== Simulation Log Analysis ===
Log File: log_file.log
Analysis Date: 2026-10-06 17:20:00

--- Results Summary ---
Total Tests:         4
Passed:              2 (50%)
Fail:                1 (25%)
Skipped:             1 (25%)

------Failed Tests-----------
 1. rv32i-sll

----------------Timing Statistics----------------
Min time: 0.65s (rv32i-sub)
Max time: 1.02s (rv32i-sll)
Avg time: 0.83s
```

## Project Structure

```text
riscv-log-analyzer/
├── analyze.sh
├── README.md
├── USAGE.md
└── log_file.log
```

## Requirements

- Linux/Ubuntu
- Bash
- Standard Unix utilities:
  - `grep`
  - `sed`
  - `awk`
  - `date`

## License

This project is for educational purposes.
