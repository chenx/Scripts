#!/bin/bash
#
# Take the input file, combine NUMBER_OF_LINES of lines in one line, and write to the output file.
#
INPUT_FILE="z.txt"
OUTPUT_FILE="z3.txt"
NUMBER_OF_LINES=4

# Clear the output file if it exists, or create a new one
> "$OUTPUT_FILE"

ct=0
while IFS= read -r line; do
  # Process the line (example: convert to uppercase)
  processed_line=$(echo "$line" | tr '[:lower:]' '[:upper:]')
  
  # Output the processed line to the output file
  printf '%s\t' "$processed_line" >> "$OUTPUT_FILE"

  ((ct++))
  if (( ct % NUMBER_OF_LINES == 0 )); then
    printf '\n' >> "$OUTPUT_FILE"
  fi

done < "$INPUT_FILE"
