#include <iostream>

void input(int&, int&, bool&);
void multiply(int, int, int&);
void divide(int&, int&, short&, short&);
void output(int&, short&, short&, bool&);

int main(int argc, char** argv) {
      int lhs        = 0;
      int rhs        = 0;
      int tich       = 0;
      short quotient = 0;
      short remainer = 0;
      bool hexflag   = 0;

      input(lhs, rhs, hexflag);

      multiply(lhs, rhs, tich);

      divide(lhs, rhs, quotient, remainer);

      output(tich, quotient, remainer, hexflag);

      return 0;
}