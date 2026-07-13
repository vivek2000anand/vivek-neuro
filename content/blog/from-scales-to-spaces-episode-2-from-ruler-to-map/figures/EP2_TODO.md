# Episode 2 "From Ruler to Map" — working to-do

Checklist for finishing the post. Lives in `figures/` so Zola ignores it
(`ignored_content` in `config.toml`). Preview:
http://localhost:1111/blog/from-scales-to-spaces-episode-2-from-ruler-to-map/

---

## 1. Text / narrative edits (do first)

- [ ] **Restructure the Young & Householder math** — current structure not liked;
      rewrite once through. (Content is in `content.typ`, section "Young and
      Householder's math to make it happen".) Keep it skimmable (three bold
      questions) but reshape the algebra: Gram identity `B = XX'`, PSD proof,
      rank = dimensionality, coordinates `X = Q L^{1/2}`, PCA connection.
- [ ] Re-read Torgerson section for the same "rigor but skimmable" balance
      (additive constant `d = h + c`, how `c` is chosen).
- [ ] Full read-through for Episode-1 voice + length parity (~target similar to Ep1).
- [ ] Decide whether to keep the Householder "aside" paragraph and its length.

## 2. Fact-check each claim against sources (verify wording)

Young & Householder (1938) — free OCR http://www.galileoco.com/literature/youngHouseholder38.pdf · DOI https://doi.org/10.1007/BF02287916
- [ ] footnote credits "Harold Gulliksen and … M. W. Richardson" (p.19)
- [ ] "necessary and sufficient condition … positive semi-definite … unique apart from a Euclidean transformation" (Thm III, p.21)
- [ ] dimensionality = rank of B (Thm I, p.20)
- [ ] scalar-product formula b_ij = ½(d²_in + d²_jn − d²_ij) (p.19–20)
- [ ] "a method given by Thurstone" for the factorization (p.21)

Torgerson (1952) — OCR http://www.galileoco.com/literature/torgerson52.pdf · DOI https://doi.org/10.1007/BF02288916
- [ ] "is not a distance in the usual sense … but is a distance minus an unknown constant" (p.402)
- [ ] extends Y&H to "fallible absolute distances"; additive constant (p.402–403)
- [ ] thesis quote: "only one person, Klingberg, has used the model … no clear statement of analytical procedure has been published" (p.402)
- [ ] negative eigenvalues: errors "change some zero roots in the positive direction and some in the negative" (~p.415)

Richardson (1938) — **now readable**: https://archive.org/details/sim_psychological-bulletin_1938-11_35_9/page/659/mode/2up (pp.659–660)
- [ ] "nine (Munsell) colored cards arranged in triadic combinations"
- [ ] "space approximating to two dimensions"
- [ ] dims are "saturation and brightness" (NOT "value and chroma" — that is Torgerson's gloss)
- [ ] "a theorem concerning the rank of a certain matrix … as a criterion"

Torgerson (1958) — free full text https://archive.org/details/dli.scoerat.6037theoryandmethodsofscaling
- [ ] Richardson Munsell chips → 2-D value/chroma (p.291); "method of triadic combinations" (p.261)

Other
- [ ] Householder bio: Rashevsky group → Oak Ridge → Householder transformation — https://mathshistory.st-andrews.ac.uk/Biographies/Householder/
- [ ] Klingberg = relations among sovereign states — https://doi.org/10.1007/BF02288590
- [ ] Wording check: "established the name MDS" (not "coined") if you want to be strict

## 3. Figures to build (in this `figures/` folder; names must match `content.typ`)

Python (scripts committed here):
- [ ] `eigenvalue_spectrum.svg` (§5) — `python cities_mds.py` (needs numpy, matplotlib)
- [ ] `richardson_color.svg` (§2) — `python richardson_color_mds.py` (needs numpy, matplotlib, `pip install colour-science`); caption must say "reconstruction," not Richardson's data
- [ ] `cities_mds.py` also emits `cities_recovered_map.svg` (raw material for the hero)
- [ ] ⚠︎ local Python is 3.14 with no numpy — set up a venv first

Figma (conceptual):
- [ ] `atlas_to_map.svg` (§1 hero) — mileage table → recovered map (build on cities_recovered_map.svg)
- [ ] `classical_mds_pipeline.svg` (§3) — distances → B → rank/eigenvectors → coordinates
- [ ] `measurement_vs_geometry.svg` (§4) — Y&H solve geometry; psychology stuck in measurement; Torgerson bridges

After adding SVGs: `.\build.ps1` (twice if needed), then reload preview. Figure
convention: `#figure(image("figures/NAME.svg", width: 100%), caption: [*Lead-in.* …]) <fig:name>`

## 4. Klingberg figure (optional / conditional)

- [ ] Data NOT available online — see `klingberg1941_data.md`. Get PDF via library/ILL
      (DOI 10.1007/BF02288590), transcribe the Great-Powers friendliness matrix,
      then reuse `classical_mds` from `cities_mds.py`. Skip if only charts (no tables).

## 5. Sources — master list with links

| Ref | Work | Link |
|---|---|---|
| Richardson (1938) | Multidimensional psychophysics, Psychol. Bull. 35:659–660 | https://archive.org/details/sim_psychological-bulletin_1938-11_35_9/page/659/mode/2up |
| Torgerson (1952) | MDS: I. Theory and method, Psychometrika 17(4) | https://doi.org/10.1007/BF02288916 · OCR http://www.galileoco.com/literature/torgerson52.pdf |
| Torgerson (1958) | Theory and Methods of Scaling (Wiley) | https://archive.org/details/dli.scoerat.6037theoryandmethodsofscaling |
| Young & Householder (1938) | Psychometrika 3(1):19–22 | https://doi.org/10.1007/BF02287916 · OCR http://www.galileoco.com/literature/youngHouseholder38.pdf |
| Householder (1958) | JACM 5(4):339–342 | https://doi.org/10.1145/320941.320947 · bio https://mathshistory.st-andrews.ac.uk/Biographies/Householder/ |
| Klingberg (1941) | Psychometrika 6(6):335–352 | https://doi.org/10.1007/BF02288590 |
| Eckart & Young (1936) | Psychometrika 1(3):211–218 | https://doi.org/10.1007/BF02288367 |
| Schoenberg (1935) | Annals of Math 36(3):724–732 | https://convexoptimization.com/TOOLS/Schoenberg2.pdf |
| Gower (1966) | Biometrika 53 | https://doi.org/10.1093/biomet/53.3-4.325 |
| Messick & Abelson (1956) | Psychometrika 21 | https://doi.org/10.1007/BF02289083 |
| Shepard (1962) | Psychometrika 27 (Ep3) | https://doi.org/10.1007/BF02289630 |
| Kruskal (1964) | Psychometrika 29 (Ep3) | https://doi.org/10.1007/BF02289565 |
| Kruskal & Wish (1978) | Sage (cities data) | https://doi.org/10.4135/9781412985130 |
| Groenen & Borg (2013) | MDS retrospective | https://repub.eur.nl/pub/39177/EI2013-07.pdf |

All cited works are already in `refs.bib` with `doi`/`url` fields, so the rendered
references are clickable; uncited ones are ready to link the moment you cite them.

## 6. Build / preview notes

- Author `content.typ` → `.\build.ps1` (Pandoc typst→HTML; may need to run twice) → `zola serve`.
- `config.toml` `ignored_content` keeps figure scripts/notes and build inputs out of
  the site (a stray front-matter-less `.md` under `content/` breaks the whole build).
- Windows-only `os error 32` file-lock warnings during build are an antivirus/indexer
  race; `zola serve` recovers and Netlify (Linux) is unaffected.

## 7. Series arc (context)

Ep1 comparative judgments → **Ep2 exact metric distances (this post)** → Ep3 nonmetric
MDS (rank order + Stress, Shepard/Kruskal) → Ep4 ordinal/triplet embeddings → LORE.
Add `series_next` to `index.md` once Ep3's slug exists.
