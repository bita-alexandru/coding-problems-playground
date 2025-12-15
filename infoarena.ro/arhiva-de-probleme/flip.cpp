#include <bits/stdc++.h>

using namespace std;

ifstream in("flip.in");
ofstream out("flip.out");

int main() {
    int n, m;
    in >> n >> m;
    
    vector<vector<int>> v(n, vector<int>(m));
    for (auto& row: v) {
        for (auto& val: row) {
            in >> val;
        }
    }

    vector<bitset<16>> rowMasks;
    for (int i = 0; i < (1 << n); i++) {
        rowMasks.emplace_back(bitset<16>(i));
    }

    int sol = INT_MIN;
    for (const auto& rowMask: rowMasks) {
        vector<int> colSums(m);
        for (int i = 0; i < n; i++) {
            bool rowBit = rowMask[i];
            for (int j = 0; j < m; j++) {
                int vij = v[i][j];
                if (rowBit) vij *= -1;
                colSums[j] += vij;
            }
        }
        int sum = 0;
        for (const auto& colSum: colSums) {
            sum += max(colSum, -colSum);
        }
        sol = max(sol, sum);
    }

    out << sol;

    return 0;
}
