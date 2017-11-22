#include <iostream>

bool isodd(int num) {
      return num & 0x01;
}

void xetdau(int lhs, int rhs, int& tich) {
      if (lhs < 0)
            tich = -tich;
}

void multiply(int lhs, int rhs, int& tich) {
      int lhs_copy = lhs;
      int rhs_copy = rhs;
      
      if (lhs == 0 || rhs == 0) {
            tich = 0;
            return;
      }

      while (true) {
            if (isodd(lhs)) {
                  tich += rhs;
            }

            if (lhs == 1 || lhs == -1)
                  break;

            rhs <<= 2;
            
            if (lhs < 0) {
                  lhs = -lhs;
                  lhs >>= 2;
                  lhs = -lhs;
            }
            else {
                  lhs >>= 2;
            }
      }

      xetdau(lhs_copy, rhs_copy, tich);
}