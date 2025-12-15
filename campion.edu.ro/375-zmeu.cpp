#include <bits/stdc++.h>
using namespace std;

ifstream in("zmeu.in");
ofstream out("zmeu.out");

int main() {
    int n, m, p;
    in >> n >> m >> p;

    int ff;
    in >> ff; ff--;
    set<int> girls;
    for (int i = 0; i < 5; i++) {
        int g;
        in >> g; g--;
        girls.insert(g);
    }

    vector<vector<pair<int, int>>> tunnels(n, vector<pair<int, int>>());
    for (int i = 0; i < m; i++) {
        int u, v, c;
        in >> u >> v >> c; u--; v--;
        tunnels[u].emplace_back(v, c);
        tunnels[v].emplace_back(u, c);
    }

    set<int> exits;
    for (int i = 0; i < p; i++) {
        int e;
        in >> e; e--;
        exits.insert(e);
    }

    priority_queue<pair<int, pair<int, set<int>>>> pq;
    pq.push({0, {ff, set<int>()}});

    vector<map<set<int>, int>> dist(n);
    dist[ff][set<int>{}] = 0;

    int sol = INT_MAX;
    while (pq.size()) {
        auto pqTop = pq.top();
        pq.pop();

        const int currDist = -pqTop.first;
        auto [room, savedGirls] = pqTop.second;

        if (currDist > dist[room][savedGirls]) continue;

        bool areAllGirlsSaved = savedGirls.size() == 5;
        bool isRoomAnExit = exits.count(room);
        if (areAllGirlsSaved && isRoomAnExit) {
            sol = min(sol, currDist);
            continue;
        }

        for (const auto& [newRoom, cost]: tunnels[room]) {
            set<int> newSavedGirls(savedGirls);
            if (girls.count(newRoom)) newSavedGirls.insert(newRoom);
            
            int prevDist = INT_MAX;
            if (dist[newRoom].count(newSavedGirls)) prevDist = dist[newRoom][newSavedGirls];

            const int newDist = currDist + cost;
            if (newDist < prevDist) {
                dist[newRoom][newSavedGirls] = newDist;
                pq.push({-newDist, {newRoom, newSavedGirls}});
            }
        }
    }

    out << sol;
    
    return 0;
}
