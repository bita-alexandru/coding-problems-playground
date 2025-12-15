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
        int n, m;
        cin >> n >> m;

        vector<vector<int>> v(n, vector<int>(m));
        vector<pair<long long, int>> vs;
        for (int i = 0; i < n; i++) {
            long long s = 0;
            for (int j = 0; j < m; j++) {
                cin >> v[i][j];
                s += v[i][j];
            }
            vs.emplace_back(s, i);
        }

        sort(vs.rbegin(), vs.rend());

        long long s_total = 0;
        long long s_tmp = 0;
        for (int i = 0; i < n; i++) {
            int k = vs[i].second;
            for (int j = 0; j < m; j++) {
                s_tmp += v[k][j];
                s_total += s_tmp;
            }
        }

        cout << s_total << "\n";
    }

    return 0;
}
