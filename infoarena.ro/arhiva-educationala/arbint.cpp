#include <bits/stdc++.h>

using namespace std;

ifstream in("arbint.in");
ofstream out("arbint.out");

struct Node {
  int l, r;
  int amax;
  Node *parent;
  unique_ptr<Node> left, right;
};

int getMaxFromRange(int l, int r, Node *n) {
  if (!n || r < n->l || l > n->r)
    return 0;
  if (l <= n->l && r >= n->r)
    return n->amax;

  return max(getMaxFromRange(l, r, n->left.get()),
             getMaxFromRange(l, r, n->right.get()));
}

int main() {
  int n, m;
  in >> n >> m;

  vector<int> a(n + 1);
  for (int i = 1; i <= n; i++)
    in >> a[i];

  function<unique_ptr<Node>(int, int, Node *)> buildTree =
      [&](int l, int r, Node *parent) -> unique_ptr<Node> {
    if (l == r)
      return make_unique<Node>(Node{l, r, a[l], parent});

    const int m = (l + r) / 2;
    auto left = buildTree(l, m, nullptr);
    auto right = buildTree(m + 1, r, nullptr);
    const int amax = max(left->amax, right->amax);
    auto curr = make_unique<Node>(
        Node{l, r, amax, parent, std::move(left), std::move(right)});
    curr->left->parent = curr.get();
    curr->right->parent = curr.get();

    return curr;
  };

  const auto root = buildTree(1, n, nullptr);

  function<void(int, int, Node *)> updateTree = [&](int pos, int val,
                                                    Node *n) -> void {
    if (n->l == n->r) {
      n->amax = val;
      return;
    }

    const int m = (n->l + n->r) / 2;
    if (pos <= m) {
      updateTree(pos, val, n->left.get());
    } else {
      updateTree(pos, val, n->right.get());
    }

    n->amax = max(n->left->amax, n->right->amax);
  };

  while (m--) {
    int x, y, z;
    in >> x >> y >> z;

    if (x == 0) {
      int sol = getMaxFromRange(y, z, root.get());
      out << sol << "\n";
    } else if (x == 1) {
      a[y] = z;
      updateTree(y, z, root.get());
    }
  }

  return 0;
}
