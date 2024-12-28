# Numbering System Converter
---

## Features
- **Base Validation**: Ensures the input number is valid for the given base system.
- **Conversion**: 
  - Converts the input number from the specified current system to decimal.
  - Converts the decimal value to the desired target system.
- **User Interaction**: Accepts user input and displays results using MIPS syscall instructions.

---

## Program Flow
1. **Input**:
   - Prompts the user for:
     - The current base system.
     - The number to be converted.
     - The target base system.
2. **Validation**:
   - Ensures the number adheres to the rules of the current base system.
   - If invalid, displays an error and terminates the program.
3. **Conversion**:
   - Converts the number from the current base to decimal.
   - Converts the decimal number to the target base system.
4. **Output**:
   - Displays the converted number in the target base system.

---

## Usage
### Input/Output Format
- **Inputs**:
  1. Current Base System (e.g., 2, 8, 10, 16).
  2. The number to be converted (in string format).
  3. Target Base System (e.g., 2, 8, 10, 16).
- **Output**:
  - The number converted into the target base.

---

## How It Works
1. **Validation**:
   - For bases ≤10, verifies all digits are within the base range.
   - For bases >10, allows alphanumeric characters (e.g., A-F for base 16).
2. **Conversion**:
   - **Other to Decimal**:
     - Iterates through the string representation, calculating the decimal equivalent using positional values and powers of the base.
   - **Decimal to Other**:
     - Repeatedly divides the decimal number by the target base, storing remainders as characters.
     - Reverses the resultant string to form the final number.
3. **Error Handling**:
   - If the input number does not belong to the specified base, the program terminates with an appropriate error message.
---
