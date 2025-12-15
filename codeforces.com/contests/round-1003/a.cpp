#include <bits/stdc++.h>
// #define cin in
// #define cout out

using namespace std;

// ifstream in("input.txt");
// ofstream out("output.txt");

int main() {
    int t;
    cin >> t;

    while (t--) {
        string s;
        cin >> s;

        cout << s.substr(0, s.size() - 2) + "i" << "\n";
    }

    return 0;
}
