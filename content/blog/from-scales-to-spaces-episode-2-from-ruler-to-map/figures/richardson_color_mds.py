"""
richardson_color_mds.py — Reconstruction, in the spirit of Richardson (1938),
of recovering the Munsell value x chroma plane from color similarities alone.

Richardson's original similarity judgments are lost, so this is a modern
stand-in: we take Munsell chips at a fixed hue, compute perceptual distances
between them (CIEDE2000 in CIELAB), and run classical MDS. The recovered 2-D
configuration lines up with the Munsell dimensions of value (brightness) and
chroma (saturation) — the result Richardson reported.

Output: richardson_color.svg  (touch up / annotate in Figma).
Caption must make clear this is a reconstruction, NOT Richardson's data.

Requires: numpy, matplotlib, colour-science  (pip install colour-science)
Run:  python richardson_color_mds.py

Docs: https://colour.readthedocs.io/   PyPI: https://pypi.org/project/colour-science/
"""

import os
import numpy as np
import matplotlib.pyplot as plt

try:
    import colour
    from colour.notation.munsell import munsell_colour_to_xyY
except ImportError:
    raise SystemExit(
        "This script needs colour-science. Install with:\n"
        "    pip install colour-science\n"
    )

HUE = "5R"                       # a single Munsell hue page
VALUES = range(2, 10)           # value 2..9  (brightness)
CHROMAS = range(2, 12, 2)       # chroma 2,4,6,8,10  (saturation)

# Munsell renotation is defined under CIE Illuminant C (2-degree observer).
ILL_C = colour.CCS_ILLUMINANTS["CIE 1931 2 Degree Standard Observer"]["C"]


def collect_chips():
    """Return list of (value, chroma, Lab, sRGB) for in-gamut chips."""
    chips = []
    for v in VALUES:
        for c in CHROMAS:
            spec = f"{HUE} {v}/{c}"
            try:
                xyY = munsell_colour_to_xyY(spec)
            except Exception:
                continue  # chip outside the renotation gamut
            XYZ = colour.xyY_to_XYZ(xyY)
            Lab = colour.XYZ_to_Lab(XYZ, ILL_C)
            srgb = colour.XYZ_to_sRGB(XYZ, illuminant=ILL_C)
            chips.append((v, c, Lab, np.clip(srgb, 0, 1)))
    return chips


def ciede2000_matrix(labs):
    n = len(labs)
    D = np.zeros((n, n))
    for i in range(n):
        for j in range(i + 1, n):
            d = float(colour.difference.delta_E_CIE2000(labs[i], labs[j]))
            D[i, j] = D[j, i] = d
    return D


def classical_mds(D, k=2):
    n = D.shape[0]
    J = np.eye(n) - np.ones((n, n)) / n
    B = -0.5 * J @ (D ** 2) @ J
    eigvals, eigvecs = np.linalg.eigh(B)
    order = np.argsort(eigvals)[::-1]
    eigvals, eigvecs = eigvals[order], eigvecs[:, order]
    L = np.diag(np.sqrt(np.clip(eigvals[:k], 0, None)))
    return eigvecs[:, :k] @ L


def orient(X, values, chromas):
    """Rotate/reflect recovered coords to align axis-1 with value, axis-2 with
    chroma, so the plot is readable (MDS has no intrinsic orientation)."""
    target = np.column_stack([values, chromas]).astype(float)
    Xc = X - X.mean(0)
    Tc = target - target.mean(0)
    U, _, Vt = np.linalg.svd(Xc.T @ Tc)
    return Xc @ (U @ Vt)


def main():
    here = os.path.dirname(os.path.abspath(__file__))
    chips = collect_chips()
    if len(chips) < 4:
        raise SystemExit("Too few in-gamut chips; adjust HUE/VALUES/CHROMAS.")
    values = np.array([c[0] for c in chips])
    chromas = np.array([c[1] for c in chips])
    labs = [c[2] for c in chips]
    colors = [c[3] for c in chips]

    D = ciede2000_matrix(labs)
    X = orient(classical_mds(D), values, chromas)

    fig, ax = plt.subplots(figsize=(7, 5.5))
    ax.scatter(X[:, 0], X[:, 1], c=colors, s=140, edgecolors="#333", linewidths=0.5,
               zorder=3)
    ax.set_title(f"Munsell value x chroma, recovered from color distances ({HUE})")
    ax.set_xlabel("recovered axis 1  (tracks value / brightness)")
    ax.set_ylabel("recovered axis 2  (tracks chroma / saturation)")
    ax.set_xticks([]); ax.set_yticks([])
    for s in ("top", "right"):
        ax.spines[s].set_visible(False)
    ax.set_aspect("equal")
    fig.tight_layout()
    out = os.path.join(here, "richardson_color.svg")
    fig.savefig(out, format="svg", bbox_inches="tight")
    plt.close(fig)
    print(f"wrote {out}  ({len(chips)} chips)")


if __name__ == "__main__":
    main()
