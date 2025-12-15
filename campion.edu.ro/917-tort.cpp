#include <bits/stdc++.h>

using namespace std;

int cmmdc(int a, int b)
{
    if (b == 0) return a;
    
    return cmmdc(b, a % b);
}

int main() {
    ifstream in("tort.in");
    ofstream out("tort.out");

    int m, n;
    in >> m >> n;

    const int l = cmmdc(m, n);
    const int a_mn = m * n;
    const int a_l = l * l;
    out << a_mn / a_l << " " << l;

    return 0;
}