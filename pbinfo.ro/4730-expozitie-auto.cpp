#include <bits/stdc++.h>

using namespace std;

int main() {
    string an;
    cin >> an;

    string cod;
    string prev, prev1, prev2;
    while (cin >> cod) {
        string curr_id = cod.substr(0, cod.length() - 4);
        string curr_an = cod.substr(cod.length() - 4, 4);
        if (curr_an == an) {
            if (!prev.empty()) {
                prev1 = prev;
                prev2 = curr_id;
            }
            prev = curr_id;
        } else {
            prev.erase();
        }
    }

    if (prev1.empty() || prev2.empty()) printf("nu exista");
    else printf("%s %s", prev1.c_str(), prev2.c_str());

    return 0;
}