#include <bits/stdc++.h>

using namespace std;

ifstream in("cmlsc.in");
ofstream out("cmlsc.out");

int main() {
    int n, m;
    in >> n >> m;

    vector<int> a(n); for (auto& i: a) in >> i;
    vector<int> b(m); for (auto& i: b) in >> i;

    vector<vector<pair<int, char>>> dp(n + 1, vector<pair<int, char>>(m + 1));
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= m; j++) {
            if (a[i - 1] == b[j - 1]) {
                dp[i][j] = {dp[i - 1][j - 1].first + 1, 'Q'};
            } else {
                dp[i][j] = (dp[i - 1][j].first > dp[i][j - 1].first) ? 
                    make_pair(dp[i - 1][j].first, 'W') : make_pair(dp[i][j - 1].first, 'A');
            }
        }
    }

    out << dp[n][m].first << "\n";

    vector<int> vdp;
    while (dp[n][m].first) {
        switch (dp[n][m].second) {
            case 'W':
                n--;
                break;
            case 'A':
                m--;
                break;
            case 'Q':
                n--;
                m--;
                vdp.push_back(a[n]);
                break; 
        }
    }

    for (int i = vdp.size() - 1; i >= 0; i--) out << vdp[i] << " ";
    
    return 0;
}
