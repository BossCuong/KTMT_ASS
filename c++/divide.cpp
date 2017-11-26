#include<iostream>
#include<cmath>
void set_sign_bit(const int& lhs,const int& rhs,short& quotient)
{
    if(lhs < 0 || rhs < 0) quotient = -quotient;
}
void divide(int lhs,int rhs,short& quotient,int& remainder)
{
    if (rhs == 0) throw std::invalid_argument("division by zero");
    else if (lhs == 0)
    {
        quotient = remainder = 0;
        return;
    }

    //Get sign bit
    int lhs_copy = lhs;
    int rhs_copy = rhs;

     //Get absolute value
    lhs = abs(lhs);
    rhs = abs(rhs);
    
    //Save dividend to remainder
    remainder = lhs;

    //Shift divisor to left half of register (32 bit 16|16)
    rhs <<= 16;
    for (int i = 0; i < 17; ++i)
    { 
               
         remainder -= rhs;
       
         if (remainder >= 0)
         {
             //Shift quotient left 1 bit
             quotient <<= 1;
             //Setting new right most bit to 1
             quotient += 1;
         }
         else //remainder < 0 
         {
             //Restore value of remainder
             remainder += rhs;
             //Shift quotient left 1 bit
             quotient <<= 1;
         }

         //Shift divisor right 1 bit
         rhs >>= 1;
    }

    //Set sign bit and return
    set_sign_bit(lhs_copy,rhs_copy,quotient);
}