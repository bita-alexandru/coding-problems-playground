#include <bits/stdc++.h>

using namespace std;

int main() {
    ifstream in("fact.in");
    ofstream out("fact.out");
    
    int p;
    in >> p;

    if (p == 0) {
        out << 1;
        return 0;
    }

    int left = 0;
    int right = 5*p;
    int sol = -1;
    while (left <= right) {
        int mid = left + (right - left) / 2;
        int zeros = 0;
        for (int i = 5; mid / i > 0; i *= 5) {
         zeros += mid / i;
        }
        if (zeros == p) {
            sol = mid;
            right = mid - 1;
        } else if (zeros < p) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    
    out << sol;
    return 0;
}
