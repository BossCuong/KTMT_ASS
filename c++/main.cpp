#include <iostream>

void input(int&, int&, bool&);
void multiply(int, int, int&);
void divide(int, int, short&, int&);
void output(int&, short&, int&, bool&);

int main(int argc, char** argv) {
      int lhs        = 0;
      int rhs        = 0;
      int tich       = 0;
      short quotient = 0;
      int remainder  = 0;
      bool hexflag   = 0;

      input(lhs, rhs, hexflag);

      multiply(lhs, rhs, tich);

      divide(lhs, rhs, quotient, remainder);

      output(tich, quotient, remainder, hexflag);

      return 0;
}