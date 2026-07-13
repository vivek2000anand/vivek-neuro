# Klingberg (1941) — data for a reconstructed figure

Working document for building a "relations among sovereign states" figure for
Episode 2. **Status: data not yet transcribed** — the source is paywalled and no
open full text was found (see access notes). Fill the tables below once you have
the PDF, then feed them to a classical-MDS script (like `cities_mds.py`) to
generate `klingberg_states.svg`.

## Source

- Klingberg, F. L. (1941). "Studies in the measurement of the relations among
  sovereign states." *Psychometrika*, **6**(6), 335–352.
- DOI: https://doi.org/10.1007/BF02288590
- Publisher (paywalled): https://link.springer.com/article/10.1007/BF02288590
- Abstract (open JSON): https://api.crossref.org/works/10.1007/BF02288590

## What the paper contains (from the published abstract)

Klingberg mailed judgment "schedules" to students of international affairs
repeatedly (mid-1930s–1941) and applied three scaling methods:

| Method | Yields | Sample / date |
|---|---|---|
| Equal-appearing intervals | relative **probability of war**, **88 pairs of states** | Jan 1937 |
| Triadic combinations | relative **friendliness** among the **Great Powers** | Nov 1938 |
| "Multidimensional" (group rank order) | attitudes of important states toward the Great Powers | Mar–Apr 1939, Jun 1940, Jun 1941 |

Figures in the paper: (i) a **trend chart** of pairwise Great-Power scale values
over 1937–1941; (ii) a depiction of the **Great Powers in multidimensional
space** by mutual friendliness, reached via "a type of factor analysis."

Caveat for the prose: Klingberg's layout came from *factor analysis*, and his
"multidimensional" names a data-collection method — so he is a proto-MDS
forerunner (Torgerson 1952 counts him as an application), not classical
Young–Householder/Torgerson MDS. Don't overstate the method.

## Access (the numbers are behind a paywall)

- A 2026-07-13 open-source sweep confirmed **no cell values are available online**:
  Springer/Cambridge paywalled; HathiTrust holds *Psychometrika* v.6 but "Limited
  (search only)" — https://catalog.hathitrust.org/Record/000639051 ; no galileoco
  mirror; Google Books quota-blocked. Quincy Wright's *A Study of War* only lists
  the study, no tables.
- Best route to the real numbers: **institutional SpringerLink access or
  interlibrary loan (ILL)** of DOI `10.1007/BF02288590` (pp. 335–352); or a
  HathiTrust print-partner library scan; or the **University of Chicago archives**
  (the data came from Quincy Wright's "Causes of War" project; Klingberg's 1939
  manuscript of the same title may hold the raw schedules).
- Copyright note: the *original figures* are in-copyright (Cambridge Univ. Press,
  ~through 2036) and should not be reproduced. But **numbers are facts, not
  copyrightable** — transcribing the tables and rendering a *new* figure is clean.
  Caption it "reconstructed from Klingberg (1941) data."

## Tables to fill in (placeholders)

Once you have the PDF, transcribe the printed values here. Two candidates for a
figure; the **Great-Powers friendliness matrix** is the better one for an MDS map.

### A. Great-Powers mutual friendliness (Nov 1938) — for the MDS map

Confirm the exact roster from the paper (likely: United States, United Kingdom,
France, Germany, Italy, USSR, Japan, China). Enter friendliness/closeness values
(note the scale direction — higher = friendlier or higher = more distant).

```
# states (row/col order):
# 1 = ...
# symmetric friendliness (or distance) matrix, blank until transcribed
        S1   S2   S3   S4   S5   S6   S7   S8
S1       -
S2            -
S3                 -
...
```

### B. Relative probability of war, 88 state-pairs (Jan 1937) — optional

```
# pair, scale value (relative probability of war), source page:
# stateA -- stateB : value
```

## Reconstruction plan

1. Fill Table A with the printed friendliness/distance values (and note the scale
   direction; if it's "friendliness," convert to distance, e.g. distance = max − friendliness).
2. Run classical MDS on the matrix (reuse the `classical_mds` routine in
   `cities_mds.py`): double-center → eigendecompose → top-2.
3. Plot the Great Powers as labeled points → `klingberg_states.svg`; caption it as
   a reconstruction from Klingberg (1941) data.
4. Sanity-check the eigenvalue spectrum (expect it to be messier / possibly with
   negative eigenvalues — real, fallible 1930s judgment data, which nicely
   illustrates §5's "noise breaks the geometry" point).
