#include <bits/stdc++.h>
#include <cctype>
using namespace std;

ifstream in("magic6.in");
ofstream out("magic6.out");

int main() {
    int n;
    in >> n;

    bool s[10] = {0};
    while (n--) {
        char c;
        in >> c;
        if (isalpha(c)) {
            out << (char) toupper(c);
        } else {
            s[c - '0'] = true;
        }
    }

    out << "\n";
    for (int i = 1; i < 10; i++) {
        if (s[i]) {
            out << i;
            if (s[0]) {
                out << 0;
                s[0] = false;
            }
        }
    }
    out << "\n";
    
    return 0;
}
