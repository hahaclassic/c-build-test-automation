## Tests description for lab_01_08_01

## Positive cases:

#### 01 - Normal behaviour
- In: 5 255 1 2
- Out: 00000101111111110000000100000010 
  5 255 1 2

## Negative cases:
#### 01 - Byte overflow (BYTE_OVERFLOW_ERROR_END 2)
- In: 0 255 0 256
- Out:

#### 02 - Incorrect input (INPUT_ERROR_END 1)
- In: 1 w 1 2
- Out: