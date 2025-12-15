#include <bits/stdc++.h>
using namespace std;

ifstream in("tablita.in");
ofstream out("tablita.out");

int main() {
    int n;
    in >> n;

    int prev = 0;
    for (int i = 1; i < 1e9; i++) {
        prev += i;
        if (n <= prev) {
            out << i;
            break;
        }
    }
    
    return 0;
}
