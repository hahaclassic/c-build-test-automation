// For this problem we assume that 1 byte is equal to 8 bits
#include <stdio.h>
#include <limits.h>
#include <stdint.h>

// Defining constants for conversion
#define FIRST_BYTE_SHIFT 24
#define SECOND_BYTE_SHIFT 16
#define THIRD_BYTE_SHIFT 8
#define MAX UCHAR_MAX

// Defining error return codes
#define OK_END 0
#define INPUT_ERROR_END 1
#define BYTE_OVERFLOW_ERROR_END 3


uint32_t convert_to_binary(uint32_t byte_1, uint32_t byte_2, uint32_t byte_3, uint32_t byte_4)
{
    uint32_t result;

    uint32_t byte_shifted_1 = byte_1 << FIRST_BYTE_SHIFT;
    uint32_t byte_shifted_2 = byte_2 << SECOND_BYTE_SHIFT;
    uint32_t byte_shifted_3 = byte_3 << THIRD_BYTE_SHIFT;
    uint32_t byte_shifted_4 = byte_4;

    result = byte_shifted_1 + byte_shifted_2 + byte_shifted_3 + byte_shifted_4;

    return result;
}


uint32_t convert_to_decimal(uint32_t binary, uint32_t shift)
{
    uint32_t delta = 8 * shift;
    uint32_t mask_out = 255 << delta;
    uint32_t byte_dec = (binary & mask_out) >> delta;

    return byte_dec;
}


void binary_output(uint32_t binary)
{
    uint32_t mask_out = 1 << 31;

    for (int i = 0; i < 32; i++)
    {
        if (binary & mask_out)
        {
            printf("1");
        }
        else
        {
            printf("0");
        }

        mask_out >>= 1;
    }
    printf(" ");
}


void decimal_output(uint32_t byte_1, uint32_t byte_2, uint32_t byte_3, uint32_t byte_4)
{
    printf("%u %u %u %u", byte_1, byte_2, byte_3, byte_4);
}


int main(void)
{
    uint32_t byte_1, byte_2, byte_3, byte_4;

    printf("Insert values of four bytes: ");
    int input = scanf("%u%u%u%u", &byte_1, &byte_2, &byte_3, &byte_4);

    // Input validation
    if (input != 4)
    {
        printf("Error: incorrect input");

        return INPUT_ERROR_END;
    }
    //Checking overflow of MAX and MIN boundaries
    // We assume that byte values are from 0 to 255
    else if (byte_1 > MAX || byte_2 > MAX || byte_3 > MAX || byte_4 > MAX)
    {
        printf("Error: byte overflow");
        return BYTE_OVERFLOW_ERROR_END;
    }
    else if (byte_1 < 0 || byte_2 < 0 || byte_3 < 0 || byte_4 < 0)
    {
        printf("Error: byte overflow");
        return BYTE_OVERFLOW_ERROR_END;
    }

    // Printing prompt
    printf("Result: ");

    // Converting & output
    uint32_t binary_representation = convert_to_binary(byte_1, byte_2, byte_3, byte_4);
    binary_output(binary_representation);

    uint32_t byte_dec_1 = convert_to_decimal(binary_representation, 3);
    uint32_t byte_dec_2 = convert_to_decimal(binary_representation, 2);
    uint32_t byte_dec_3 = convert_to_decimal(binary_representation, 1);
    uint32_t byte_dec_4 = convert_to_decimal(binary_representation, 0);
    decimal_output(byte_dec_1, byte_dec_2, byte_dec_3, byte_dec_4);

    return OK_END;
}
