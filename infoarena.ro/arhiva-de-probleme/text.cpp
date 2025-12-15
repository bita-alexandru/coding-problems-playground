#include <bits/stdc++.h>
#include <regex>

using namespace std;

ifstream in("text.in");
ofstream out("text.out");

int main() {
    int length = 0, count = 0;
    const regex r("[a-zA-Z]+");
    string s;
    while (getline(in, s)) {
        for (auto it = sregex_iterator(s.begin(), s.end(), r); it != sregex_iterator(); it++) {
            length += it->str().size();
            count++;
        }
    }
    
    if (count == 0) out << 0;
    else out << length / count;

    return 0;
}
