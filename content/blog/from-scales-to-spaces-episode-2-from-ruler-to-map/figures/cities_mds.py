"""
cities_mds.py — Classical (Torgerson / Young-Householder) MDS on the classic
Kruskal & Wish (1978) 10-US-city flying-mileage matrix.

Produces two SVGs for Episode 2 ("From Ruler to Map"):
  - cities_recovered_map.svg  : the 2-D configuration recovered from distances
                                alone (use as the basis for the atlas_to_map
                                hero; touch up / annotate in Figma).
  - eigenvalue_spectrum.svg   : clean vs. noisy eigenvalue spectra, showing how
                                real (fallible) data pushes eigenvalues negative.

The point of the demo: this 10x10 eigendecomposition is instant on a laptop but
would have been days of desk-calculator arithmetic in 1938 — part of why the
exact 1938 theorem sat unused.

Requires: numpy, matplotlib.  Run:  python cities_mds.py
Verify the mileage numbers against Kruskal & Wish (1978) before publishing.
"""

import os
import numpy as np
import matplotlib.pyplot as plt

CITIES = ["Atlanta", "Chicago", "Denver", "Houston", "Los Angeles",
          "Miami", "New York", "San Francisco", "Seattle", "Washington DC"]

# Airline distances in miles (Kruskal & Wish 1978), lower triangle.
_LOWER = [
    [],
    [587],
    [1212, 920],
    [701, 940, 879],
    [1936, 1745, 831, 1374],
    [604, 1188, 1726, 968, 2339],
    [748, 713, 1631, 1420, 2451, 1092],
    [2139, 1858, 949, 1645, 347, 2594, 2571],
    [2182, 1737, 1021, 1891, 959, 2734, 2408, 678],
    [543, 597, 1494, 1220, 2300, 923, 205, 2442, 2329],
]

# Approximate (longitude, latitude) used only to orient the recovered map so it
# reads like a real map (MDS cannot recover absolute orientation or handedness).
LONLAT = {
    "Atlanta": (-84.4, 33.7), "Chicago": (-87.6, 41.9), "Denver": (-105.0, 39.7),
    "Houston": (-95.4, 29.8), "Los Angeles": (-118.2, 34.1), "Miami": (-80.2, 25.8),
    "New York": (-74.0, 40.7), "San Francisco": (-122.4, 37.8),
    "Seattle": (-122.3, 47.6), "Washington DC": (-77.0, 38.9),
}


def build_distance_matrix():
    n = len(CITIES)
    D = np.zeros((n, n))
    for i, row in enumerate(_LOWER):
        for j, d in enumerate(row):
            D[i, j] = d
            D[j, i] = d
    return D


def classical_mds(D, k=None):
    """Torgerson classical MDS. Returns (coords_top2, eigenvalues_sorted_desc)."""
    n = D.shape[0]
    J = np.eye(n) - np.ones((n, n)) / n          # centering matrix
    B = -0.5 * J @ (D ** 2) @ J                   # double-centered scalar products
    eigvals, eigvecs = np.linalg.eigh(B)
    order = np.argsort(eigvals)[::-1]             # descending
    eigvals, eigvecs = eigvals[order], eigvecs[:, order]
    if k is None:
        k = 2
    L = np.diag(np.sqrt(np.clip(eigvals[:k], 0, None)))
    X = eigvecs[:, :k] @ L
    return X, eigvals


def orient_to_geography(X):
    """Reflect/rotate the recovered config to align with true lon/lat via a
    simple Procrustes (no scaling of shape needed for a schematic)."""
    target = np.array([LONLAT[c] for c in CITIES], dtype=float)
    Xc = X - X.mean(0)
    Tc = target - target.mean(0)
    # Optimal rotation/reflection: U V^T from SVD of cross-covariance.
    U, _, Vt = np.linalg.svd(Xc.T @ Tc)
    R = U @ Vt
    return Xc @ R


def plot_map(X, out):
    fig, ax = plt.subplots(figsize=(7.5, 5))
    ax.scatter(X[:, 0], X[:, 1], s=45, color="#2b6cb0", zorder=3)
    for (x, y), name in zip(X, CITIES):
        ax.annotate(name, (x, y), textcoords="offset points", xytext=(6, 4),
                    fontsize=9)
    ax.set_title("A map recovered from a table of distances alone")
    ax.set_xticks([]); ax.set_yticks([])
    for s in ax.spines.values():
        s.set_visible(False)
    ax.set_aspect("equal")
    fig.tight_layout()
    fig.savefig(out, format="svg", bbox_inches="tight")
    plt.close(fig)
    print(f"wrote {out}")


def plot_eigen_spectrum(D, out, noise_sd=120.0, seed=0):
    _, ev_clean = classical_mds(D)
    rng = np.random.default_rng(seed)
    noise = rng.normal(0, noise_sd, size=D.shape)
    noise = np.triu(noise, 1)
    noise = noise + noise.T
    D_noisy = np.clip(D + noise, 0, None)
    np.fill_diagonal(D_noisy, 0)
    _, ev_noisy = classical_mds(D_noisy)

    idx = np.arange(1, len(ev_clean) + 1)
    fig, ax = plt.subplots(figsize=(7.5, 4.2))
    w = 0.4
    ax.bar(idx - w / 2, ev_clean, width=w, label="clean distances", color="#2b6cb0")
    ax.bar(idx + w / 2, ev_noisy, width=w, label="noisy (fallible) data", color="#dd6b20")
    ax.axhline(0, color="#444", lw=0.8)
    ax.set_xlabel("eigenvalue index")
    ax.set_ylabel("eigenvalue")
    ax.set_title("Noise pushes eigenvalues negative")
    ax.legend(frameon=False)
    for s in ("top", "right"):
        ax.spines[s].set_visible(False)
    fig.tight_layout()
    fig.savefig(out, format="svg", bbox_inches="tight")
    plt.close(fig)
    print(f"wrote {out}")


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    D = build_distance_matrix()
    X, _ = classical_mds(D)
    X = orient_to_geography(X)
    plot_map(X, os.path.join(here, "cities_recovered_map.svg"))
    plot_eigen_spectrum(D, os.path.join(here, "eigenvalue_spectrum.svg"))


if __name__ == "__main__":
    main()
