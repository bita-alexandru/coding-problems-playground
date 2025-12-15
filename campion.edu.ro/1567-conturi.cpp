#include <bits/stdc++.h>
using namespace std;

ifstream in("conturi.in");
ofstream out("conturi.out");

int main() {
    int n, x;
    in >> n >> x;

    int s = 0;
    while (n--) {
        int t;
        in >> t;
        s = max(s, (t / 100000 == x && (t / 10000) % 10 == 1) * t % 10000);
    }
    
    out << s;

    return 0;
}
