#include <iostream>

void output(int& tich, short& quotient, int& remainer, bool& hexflag) {
      if (!hexflag) {
            std::cout << "Tich hai so la  : " << tich << std::endl;
            std::cout << "Thuong hai so la: " << quotient << std::endl;
            std::cout << "Du sau khi chia : " << remainer << std::endl;
      }
      else {
            std::cout << "Tich hai so la  : " << std::hex << tich << std::endl;
            std::cout << "Thuong hai so la: " << std::hex << quotient << std::endl;
            std::cout << "Du sau khi chia : " << std::hex << remainer << std::endl;
      }
}