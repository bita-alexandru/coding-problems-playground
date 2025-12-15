#include <bits/stdc++.h>

using namespace std;

int main() {
    int t;
    cin >> t;

    while (t--) {
        int n, m;
        cin >> n >> m;

        vector<pair<int, int>> cards;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                int card;
                cin >> card;
                cards.emplace_back(card, i);
            }
        }
        sort(cards.begin(), cards.end());
        
        vector<set<int>> sets(n, set<int>());
        bool ok = true;
        for (int i = 0; i < cards.size(); i++) {
            const auto& [card, cow] = cards[i];
            const int k = i % n;
            sets[cow].insert(k);
            if (sets[cow].size() > 1) {
                ok = false;
                break;
            }
        }
        if (!ok ) {
            cout << -1 << "\n";
        } else {
            for (int i = 0; i < n; i++) {
                cout << cards[i].second + 1 << " ";
            }
            cout << "\n";
        }
        
    }
    return 0;
}
