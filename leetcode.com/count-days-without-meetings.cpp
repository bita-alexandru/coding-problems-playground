#include <bits/stdc++.h>

using namespace std;

ifstream in("input.txt");
ofstream out("output.txt");

class Solution {
public:
  int countDays(int days, vector<vector<int>> &meetings) {
    sort(meetings.begin(), meetings.end());

    int write = 0;
    for (int read = 1; read < meetings.size(); ++read) {
      int& s1 = meetings[write][0];
      int& e1 = meetings[write][1];
      int s2 = meetings[read][0];
      int e2 = meetings[read][1];

      if (e1 >= s2) {
        e1 = max(e1, e2);
      } else {
        meetings[++write] = meetings[read];
      }
    }

    int sol = 0;
    int dayPrev = 1;
    for (int i = 0; i <= write; ++i) {
      sol += (meetings[i][0] - dayPrev);
      dayPrev = meetings[i][1] + 1;
    }
    if (dayPrev <= days) {
      sol += (days + 1 - dayPrev);
    }

    return sol;
  }
};

int main() {
  int days;
  in >> days;
  int dayStart, dayEnd;
  vector<vector<int>> meetings;
  while (in >> dayStart >> dayEnd) {
    meetings.push_back(vector<int>({dayStart, dayEnd}));
  }

  Solution solution;
  out << solution.countDays(days, meetings);
  return 0;
}