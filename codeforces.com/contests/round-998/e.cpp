#include <bits/stdc++.h>
#define cin in
#define cout out

using namespace std;

ifstream in("input.txt");
ofstream out("output.txt");

map<int, set<int>> getConnections(const int n, const vector<vector<int>>& graph) {
    map<int, set<int>> connections;
    for (int i = 0; i < n; i++) {
        stack<int> s;
        for (const auto& u: graph[i]) {
            s.push(u);
        }
        set<int> connectedToI;
        while(s.size()) {
            int u = s.top();
            s.pop();

            connectedToI.insert(u);
            for (const auto& v: graph[u]) {
                if (v == i) continue;
                if (connectedToI.count(v)) continue;
                s.push(v);
            }
        }
        connections[i] = connectedToI;
    }
    return connections;
}

int main() {
    int t;
    cin >> t;

    while (t--) {
        int n, mf, mg;
        cin >> n >> mf >> mg;

        vector<vector<int>> f(n);
        for (int i = 0; i < mf; i++) {
            int u, v;
            cin >> u >> v; u--; v--;
            f[u].push_back(v);
            f[v].push_back(u);
        }
        vector<vector<int>> g(n);
        for (int j = 0; j < mg; j++) {
            int u, v;
            cin >> u >> v; u--; v--;
            g[u].push_back(v);
            g[v].push_back(u);
        }

        map<int, set<int>> cf = getConnections(n, f);
        map<int, set<int>> cg = getConnections(n, g);

        printf("ORIGINAL\n");
        printf("=====CF=====\n");
        for (const auto& [node, conns]: cf) {
            printf("%i: ", node+1);
            for (const auto& conn: conns) {
                printf("%i ", conn+1);
            }
            printf("\n");
        }
        printf("=====CG=====\n");
        for (const auto& [node, conns]: cg) {
            printf("%i: ", node+1);
            for (const auto& conn: conns) {
                printf("%i ", conn+1);
            }
            printf("\n");
        }

        int moves = 0;
        for (int node = 0; node < n; node++) {
            for (const auto& conn: g[node]) {
                if (cf.count(node) == 0) {
                    cf[node] = set<int>({conn});
                    moves++;
                    printf("A.CF[%i]: %i, moves: %i\n", node+1, conn+1, moves);
                } else if (cf[node].count(conn) == 0) {
                    set<int> affectedSet;
                    stack<int> affectedStack({node});
                    while (!affectedStack.empty()) {
                        int currNode = affectedStack.top();
                        affectedStack.pop();
                        affectedSet.insert(currNode);
                        for (const auto& u: cf[currNode]) {
                            if (affectedSet.count(u) == 0) {
                                affectedStack.push(u);
                            }
                        }
                    }
                    for (const auto& affectedNode: affectedSet) {
                        cf[affectedNode].insert(conn);
                        printf("B.CF[%i] insert %i\n", affectedNode+1, conn+1);
                    }
                    moves++;
                    printf("B.moves: %i\n", moves);
                }
            }
        }

        for (int node = 0; node < n; node++) {
            for (const auto& conn: f[node]) {
                if (cg.count(node) == 0) {
                    moves += cf[node].size();
                    printf("C.moves: %i\n", moves);
                    set<int> affectedSet;
                    stack<int> affectedStack({node});
                    while (!affectedStack.empty()) {
                        int currNode = affectedStack.top();
                        affectedStack.pop();
                        affectedSet.insert(currNode);
                        for (const auto& u: cf[currNode]) {
                            cf[u].erase(node);
                            if (affectedSet.count(u) == 0) {
                                affectedStack.push(u);
                            }
                        }
                    }
                    for (const auto& affectedNode: affectedSet) {
                        cf[affectedNode].erase(conn);
                        printf("C1.CF[%i] erase %i\n", affectedNode+1, conn+1);
                    }
                    cg.erase(node);
                    printf("C2.CG erase %i\n", node+1);
                    break;
                } else if (cg[node].count(conn) == 0) {
                    set<int> affectedSet;
                    stack<int> affectedStack({node});
                    while (!affectedStack.empty()) {
                        int currNode = affectedStack.top();
                        affectedStack.pop();
                        affectedSet.insert(currNode);
                        for (const auto& u: cf[currNode]) {
                            if (affectedSet.count(u) == 0 && u != conn) {
                                affectedStack.push(u);
                            }
                        }
                    }
                    for (const auto& affectedNode: affectedSet) {
                        cf[affectedNode].erase(conn);
                        printf("D.CF[%i] erase %i\n", affectedNode+1, conn+1);
                    }
                    moves++;
                    printf("D.moves: %i\n", moves);
                }
            }
        }
        cout << moves << "\n";

        printf("MUTATED\n");
        printf("=====CF=====\n");
        for (const auto& [node, conns]: cf) {
            printf("%i: ", node+1);
            for (const auto& conn: conns) {
                printf("%i ", conn+1);
            }
            printf("\n");
        }
        printf("=====CG=====\n");
        for (const auto& [node, conns]: cg) {
            printf("%i: ", node+1);
            for (const auto& conn: conns) {
                printf("%i ", conn+1);
            }
            printf("\n");
        }

    }
    return 0;
}
