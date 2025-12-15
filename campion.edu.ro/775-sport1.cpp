#include <bits/stdc++.h>
#include <cctype>
#include <cstdio>
#include <iomanip>
#include <ios>
using namespace std;

ifstream in("sport1.in");
ofstream out("sport1.out");

int main() {
    int a, b;
    in >> a >> b;

    int n;
    in >> n;

    set<int> s;
    int curr = 2;
    int sum = a + b;
    int c;
    while (curr < n && curr++) {
        if (a == b) {
            if (a == 5) c = 2;
            else c = 3;
        } else {
            c = max(a, b);
        }
        sum += c;

        int k = a * 100 + b * 10 + c;
        if (s.count(k)) {
            break;
        } else {
            s.insert(k);
            a = b;
            b = c;
        }
    }

    if (curr != n) {
        int need = n - curr;
        int div3 = need / 3;
        int rem3 = need % 3;
        sum += div3 * (a + b + c);

        if (rem3 == 1) sum += a;
        else if (rem3 == 2) sum += a + b;
    }

    out << 100 * sum / n * 0.01f;
    
    return 0;
}
