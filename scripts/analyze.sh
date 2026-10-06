#!/bin/bash

set -euo pipefail #to ensure that script exit if command fail
	
LOG_FILE=""
VERBOSE=0
FORMAT="text"
OUTPUT="stdout"

#Results
total_test=0
pass=0
fail=0
skipped=0
failed_tests=()
test_times=()
test_times=()
#--------------Functions Defined Here----------------------------

 usage() {
    echo "Usage"	 
    echo "$0 <Path to log file (required)>"
    echo "--format [text|csv]: Output format (default: text)"
    echo "--output <path>: Output file path (default: stdout)"
    echo "--verbose: Enable verbose output"
    echo "--help: Print usage information"
 }
 
 verbose() { 
       if [ "$VERBOSE" -eq 1 ]; then 
            echo "[VERBOSE] $*" >&2 
      fi 
}

 process_file(){
          
	   
	  verbose "Processing log file: $LOG_FILE"
	  
          while IFS= read -r line; do
   
	   if echo "$line" | grep -q START; then
	          total_test=$((total_test+1))
	   fi
	   
	  if echo "$line" | grep -q "TEST PASS"; then

	    pass=$((pass + 1))

	    test_name=$(echo "$line" | sed -E 's/.*TEST PASS: ([^ ]+).*/\1/')
	    test_time=$(echo "$line" | sed -E 's/.*\(([0-9.]+)s\).*/\1/')

	    test_names+=("$test_name")
	    test_times+=("$test_time")

	elif echo "$line" | grep -q "TEST FAIL"; then

	    fail=$((fail + 1))

	    test_name=$(echo "$line" | sed -E 's/.*TEST FAIL: ([^ ]+).*/\1/')
	    test_time=$(echo "$line" | sed -E 's/.*\(([0-9.]+)s\).*/\1/')

	    test_names+=("$test_name")
	    test_times+=("$test_time")

	    failed_tests+=("$test_name")

	elif echo "$line" | grep -q "TEST SKIP"; then

	    skipped=$((skipped + 1))

	fi 
   done < "$LOG_FILE"	
   
   verbose "Finished processing log file"
   }

calculate_timing() {

    min=""
    min_name=""
    max=""
    max_name=""
    sum=0
    count=0

    for i in "${!test_times[@]}"; do

        name="${test_names[$i]}"
        time="${test_times[$i]}"

        if [ "$count" -eq 0 ]; then

            min="$time"
            min_name="$name"
            max="$time"
            max_name="$name"

        else

            if [ "$(echo "$time < $min" | bc -l)" -eq 1 ]; then
                min="$time"
                min_name="$name"
            fi

            if [ "$(echo "$time > $max" | bc -l)" -eq 1 ]; then
                max="$time"
                max_name="$name"
            fi

        fi

        sum=$(echo "$sum + $time" | bc -l)
        count=$((count + 1))

    done

    if [ "$count" -gt 0 ]; then
        avg=$(echo "scale=2; $sum / $count" | bc -l)
    fi
}

  print_text_summary(){
          echo "=== Simulation Log Analysis ==="
	  echo "Log File: $LOG_FILE"
	  echo "Analysis Date: $(date +'%Y-%m-%d %H:%M:%S')"
	  echo ""
	  echo "--- Results Summary ---"
	 if [ "$total_test" -gt 0 ]; then
	    echo "Total Tests:         $total_test"
	    echo "Passed:              $pass ($((pass * 100 / total_test))%)"
	    echo "Fail:                $fail ($((fail * 100 / total_test))%)"
	    echo "Skipped:             $skipped ($((skipped * 100 / total_test))%)"
	 else
	    echo "Passed:              $pass (0%)"
	    echo "Fail:                $fail (0%)"
	    echo "Skipped:             $skipped (0%)"
	 fi
	  echo ""
	  echo ""
	  echo "------Failed Tests-----------"
	  count=1
	  for test in "${failed_tests[@]}"; do
		 echo " $count.  $test"
		 count=$((count+1))
	 done
	
	for i in "${!test_times[@]}"; do
	    echo "${test_names[$i]} ${test_times[$i]}"
	done | awk '
	{
	    name = $1
	    time = $2

	    if (NR == 1 || time < min) {
		min = time
		min_name = name
	    }

	    if (NR == 1 || time > max) {
		max = time
		max_name = name
	    }

	    sum += time
	    count++
	}

	END {
	    if (count > 0) {
	        printf "\n"
	        printf "----------------Timing Statistics----------------\n"
		printf "Min time: %.2fs (%s)\n", min, min_name
		printf "Max time: %.2fs (%s)\n", max, max_name
		printf "Avg time: %.2fs\n", sum / count
	    }
	}'	
	       
      echo ""
      if [ "${#failed_tests[@]}" -gt 0 ]; then
         echo "------Verdict: Fail--------"
         echo "Exit Code: 1"
     else
         echo "------Verdict: Pass--------"
         echo "Exit Code: 0"
     fi    
 }
 
 print_csv_summary() {
     echo "" 
     echo "metric,value"
     echo "total_tests,$total_test" 
     echo "passed,$pass" 
     echo "failed,$fail" 
     echo "skipped,$skipped"
     
     # Timing statistics
   for i in "${!test_times[@]}"; do
	    echo "${test_names[$i]} ${test_times[$i]}"
	done | awk '
	{
	    name = $1
	    time = $2

	    if (NR == 1 || time < min) {
		min = time
		min_name = name
	    }

	    if (NR == 1 || time > max) {
		max = time
		max_name = name
	    }

	    sum += time
	    count++
	}

	END {
	    if (count > 0) {
	        printf "\n"
	        printf "----------------Timing Statistics----------------\n"
		printf "Min time: %.2fs (%s)\n", min, min_name
		printf "Max time: %.2fs (%s)\n", max, max_name
		printf "Avg time: %.2fs\n", sum / count
	    }
	}'	
}     
#   ------------------Error Handling-----------------------------------
if [ "$#" -eq 0 ]; then
    echo "LOG FILE is required"
    usage
    exit 1
fi

if [ "$1" = "--help" ]; then
    usage
    exit 0
fi

LOG_FILE="$1"
shift

while [ "$#" -gt 0 ]; do

    case "$1" in

        --format)
            if [ "$#" -lt 2 ]; then
                echo "ERROR: --format requires text or csv"
                exit 1
            fi

            if [ "$2" != "text" ] && [ "$2" != "csv" ]; then
                echo "ERROR: Acceptable formats are text or csv"
                exit 1
            fi

            FORMAT="$2"
            shift 2
            ;;

        --output)
            if [ "$#" -lt 2 ]; then
                echo "ERROR: --output requires a path"
                exit 1
            fi

            OUTPUT="$2"
            shift 2
            ;;

        --verbose)
            VERBOSE=1
            shift
            ;;

        --help)
            usage
            exit 0
            ;;

        *)
            echo "ERROR: Unknown option: $1"
            usage
            exit 1
            ;;

    esac

done
  


#----------------- Now we are going to process the file----------------------------
   process_file $LOG_FILE
   
   verbose "Log file : $LOG_FILE" 
   verbose "Format : $FORMAT" 
   verbose "Output : $OUTPUT"
   
   generate_output() { 
       if [ "$FORMAT" = "text" ]; then 
             print_text_summary 
      elif [ "$FORMAT" = "csv" ]; then 
            print_csv_summary 
      fi 
}

if [ "$OUTPUT" = "stdout" ]; then 
     generate_output 
else 
     generate_output > "$OUTPUT" 
     echo "Analysis written to: $OUTPUT" >&2 
fi

 
