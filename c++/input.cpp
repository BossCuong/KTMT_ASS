#include <iostream>

void input(int& lhs, int& rhs, bool& hexflag) {
      while (true) {
            std::cout << "1. Thap phan" << std::endl;
            std::cout << "2. Ma hex" << std::endl;
            std::cout << "3. Thoat" << std::endl;
            std::cout << "Chon cach nhap  : " << std::endl;

            int choice = 0;

            if (choice == 1) {
                  std::cout << "Nhap so thu nhat: " << std::endl;
                  std::cin >> lhs;
                  std::cout << "Nhap so thu hai : " << std::endl;
                  std::cin >> rhs;
                  return;
            }
            else if (choice == 2) {
                  hexflag = true;
                  std::cout << "Nhap so thu nhat: 0x" << std::endl;
                  std::cin >> std::hex >> lhs;
                  std::cout << "Nhap so thu hai : 0x" << std::endl;
                  std::cin >> std::hex >> rhs;
                  return;
            }
            else if (choice == 3) {
                  exit(0);
            }
            // meo xoa man hinh duoc
      }
}