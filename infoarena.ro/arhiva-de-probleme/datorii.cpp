#include <bits/stdc++.h>
using namespace std;

ifstream in("datorii.in");
ofstream out("datorii.out");

struct Node {
  int l, r;
  int sum;
  Node *parent;
  unique_ptr<Node> left, right;
};

int getSumFromRange(int a, int b, Node *n) {
  if (!n || b < n->l || a > n->r)
    return 0;
  if (n->l >= a && n->r <= b)
    return n->sum;

  return getSumFromRange(a, b, n->left.get()) +
         getSumFromRange(a, b, n->right.get());
}

int main() {
  int n, m;
  in >> n >> m;

  vector<int> s(n + 1);
  for (int i = 1; i <= n; i++) {
    int ai;
    in >> ai;
    s[i] = s[i - 1] + ai;
  }

  const auto root = make_unique<Node>(Node{1, n, s[n]});
  stack<Node *> stck({root.get()});
  while (!stck.empty()) {
    Node *curr = stck.top();
    stck.pop();

    if (curr->l == curr->r)
      continue;

    int m = (curr->l + curr->r) / 2;
    int slm = s[m] - s[curr->l - 1];
    int smr = s[curr->r] - s[m];

    curr->left = make_unique<Node>(Node{curr->l, m, slm, curr});
    curr->right = make_unique<Node>(Node{m + 1, curr->r, smr, curr});

    stck.push(curr->left.get());
    stck.push(curr->right.get());
  }

  while (m--) {
    int x, y, z;
    in >> x >> y >> z;

    if (x == 0) {
      Node *n = root.get();
      while (n) {
        n->sum -= z;
        int m = (n->l + n->r) / 2;
        if (y <= m)
          n = n->left.get();
        else
          n = n->right.get();
      }
    } else if (x == 1) {
      int sum = getSumFromRange(y, z, root.get());
      out << sum << "\n";
    }
  }

  return 0;
}