# RISC-V Log Analyzer Makefile

ANALYZER := ./analyze.sh
TEST_DIR := test_data
OUTPUT_DIR := output

.PHONY: all test report clean help setup

# Run the analyzer on all test log files
all: report

# Run the analyzer on each test file
test:
	@echo "Running tests..."
	@for file in $(TEST_DIR)/*.log; do \
		echo "Testing $$file"; \
		$(ANALYZER) "$$file" > /dev/null || exit 1; \
	done
	@echo "All tests passed."

# Generate a summary report in output/
report:
	@mkdir -p $(OUTPUT_DIR)
	@echo "Generating reports..."
	@for file in $(TEST_DIR)/*.log; do \
		name=$$(basename "$$file" .log); \
		$(ANALYZER) "$$file" > "$(OUTPUT_DIR)/$${name}_report.txt" || exit 1; \
	done
	@echo "Reports generated in $(OUTPUT_DIR)/"

# Remove generated output files
clean:
	@echo "Removing generated output..."
	@rm -rf $(OUTPUT_DIR)/*
	@echo "Clean complete."

# Print available targets
help:
	@echo "RISC-V Log Analyzer"
	@echo ""
	@echo "Available targets:"
	@echo "  all      Run the analyzer on all test log files"
	@echo "  test     Run the analyzer on each test log file"
	@echo "  report   Generate summary reports in output/"
	@echo "  clean    Remove all generated output files"
	@echo "  help     Show this help message"
	@echo "  setup    Check required tools"

# Check required tools
setup:
	@echo "Checking required tools..."
	@command -v bash >/dev/null || { echo "ERROR: bash is not installed"; exit 1; }
	@command -v grep >/dev/null || { echo "ERROR: grep is not installed"; exit 1; }
	@command -v sed >/dev/null || { echo "ERROR: sed is not installed"; exit 1; }
	@command -v awk >/dev/null || { echo "ERROR: awk is not installed"; exit 1; }
	@command -v date >/dev/null || { echo "ERROR: date is not installed"; exit 1; }
	@echo "All required tools are installed."
