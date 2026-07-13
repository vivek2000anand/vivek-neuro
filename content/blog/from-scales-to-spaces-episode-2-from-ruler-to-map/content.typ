In the previous episode, Thurstone handed us a psychological ruler. By turning how often people *confuse* two stimuli into a *distance* between them, he built a scale for things that have no physical yardstick, the loudness of a sound or the seriousness of a crime. But a ruler only measures along a single line, and that line turned out to be its cage. In this episode we break out of it, and watch a table of numbers quietly turn into a map.

== From a line to a space: why one dimension isn't enough

Remember the dessert problem from last time. Ask someone whether a chocolate cake is more like a chocolate croissant or a pound cake and they hesitate, not because the items are identical, but because "similar" secretly splits into *chocolatiness* and *cakeness*, two different axes. Thurstone's method reads that hesitation as closeness on one line, and in doing so it flattens two dimensions into one and throws away the very structure we care about.

So what if we stopped forcing everything onto a line? Suppose we lay the stimuli out as points in a *space*, and treat every dissimilarity as the *distance* between two of those points. Confusable things sit close together, distinct things sit far apart, but now "close" can happen in many directions at once. This is the exact same move Thurstone made to get distances out of confusions, promoted from a line to a plane, or to a ten-dimensional cloud.

It even has a familiar inverse. A road atlas prints a little triangular table of distances between cities: New York to Chicago, Chicago to Denver, and so on. A cartographer goes from the *map* to that *table*. We want to run the arrow backwards, to start with nothing but the table of distances and recover the map. And if we can do it for cities, maybe we can do it for colors, sounds, or faces.

#figure(
  image("figures/atlas_to_map.svg", width: 100%),
  caption: [*A distance table secretly contains a map.* Given only the pairwise distances between cities, we can reconstruct their positions, up to a rotation or a flip, since a map has no built-in sense of which way is "north."],
) <fig:atlas_to_map>

== Richardson's argument to go multidimensional

The first person to say this out loud was Marion Webster Richardson, the same Richardson of the Kuder--Richardson reliability formulas, in a 1938 talk to the American Psychological Association @richardson1938multidimensional. He named the problem exactly. The "traditional psychophysical methods are limited to one dimension," he noted, yet often "the basis for psychophysical judgments is a complex of variables instead of a single variable," which had forced everyone "to be content with an inferior one-dimensional approximation" @richardson1938multidimensional. His remedy was to scale judgments in $m$ dimensions and let the data decide how many were really needed.

And he did more than theorize; he ran the experiment. Richardson showed people "nine (Munsell) colored cards arranged in triadic combinations," the method of triads, to get "scale-distances between all pairs of stimuli," then recovered "the representation, as points in a space approximating to two dimensions, of the colors used," reading off "the relative contributions to similarity of saturation and brightness" @richardson1938multidimensional. Out of a heap of "which two of these three look most alike" judgments, a two-dimensional color space reassembled itself. (Torgerson, who later re-ran the study, matched Richardson's two axes to the Munsell dimensions of value and chroma @torgerson1958theory.)

#figure(
  image("figures/richardson_color.svg", width: 100%),
  caption: [*Colors, remapped from similarity alone.* A reconstruction in the spirit of Richardson's 1938 experiment: classical scaling applied to perceptual distances between Munsell chips recovers a two-dimensional grid whose axes are brightness and saturation, the Munsell dimensions of value and chroma. Richardson's original judgments are lost, so this is a modern stand-in for his result.],
) <fig:richardson_color>

There was just one soft spot. To decide how many dimensions the colors needed, Richardson leaned on "a theorem concerning the rank of a certain matrix ... as a criterion for determining the number of factors involved" @richardson1938multidimensional, but he was adapting a result he had not proved. He had the idea, the experiment, and the right instinct that dimensionality lives in the rank of a matrix; what he lacked was the rigorous mathematics beneath it. For that, he turned to two mathematicians.

== Young and Householder's math to make it happen

In that same year, Gale Young and Alston Householder answered Richardson's question completely and exactly. Their four-page paper opens by crediting him: it was written "in response to suggestions by Harold Gulliksen and by M. W. Richardson," whose problem made "the dimensionality of a set of points whose mutual distances are available" the central idea @young1938discussion.

Here is the obstacle they had to clear. A table of distances does not pin down coordinates, because you can slide, rotate, or flip an entire constellation of points without changing a single distance between them. Their fix is elegant: nail one point down as the origin, and turn every distance into a *scalar product*, a single number that captures how aligned two points are as seen from that origin. Put the origin at point $n$, write $bold(x)_i$ for the position of point $i$ measured from there, and the law of cosines gives

$ b_(i j) = angle.l bold(x)_i, bold(x)_j angle.r = 1/2 (d_(i n)^2 + d_(j n)^2 - d_(i j)^2), $

a quantity we can compute from the distances alone. Stack these numbers into an $n times n$ matrix $bold(B)$.

Now comes the observation the whole method balances on. If we gather the (still unknown) coordinates as the rows of a matrix $bold(X)$, then $bold(B) = bold(X) bold(X)^T$: the table of scalar products is nothing but the coordinates multiplied by their own transpose. That single identity, that $bold(B)$ is a *Gram matrix*, answers all three of Richardson's questions at once. (If you only want the gist, the three bold questions below are the whole story; the algebra just says why each answer is forced.)

+ *Is this even a real set of distances?* A Gram matrix is always *positive semi-definite*: for any vector $bold(v)$, $bold(v)^T bold(B) bold(v) = bold(v)^T bold(X) bold(X)^T bold(v) = norm(bold(X)^T bold(v))^2 gt.eq 0$, so $bold(B)$ can never have a negative eigenvalue. Young and Householder proved the converse too: *any* positive semi-definite matrix can be factored as $bold(X) bold(X)^T$, so it always corresponds to a genuine set of points. Their theorem is exactly this, "a necessary and sufficient condition for a set of numbers ... to be the mutual distances of a real set of points in Euclidean space is that the matrix $bold(B)$ ... be positive semi-definite," with the configuration "unique apart from a Euclidean transformation" @young1938discussion. A single negative eigenvalue is proof that no Euclidean map can reproduce your distances.
+ *How many dimensions do the points need?* Diagonalize $bold(B) = bold(Q) bold(Lambda) bold(Q)^T$, so its eigenvalues $lambda_1 gt.eq lambda_2 gt.eq dots.h gt.eq 0$ line up along $bold(Lambda)$. The number of *strictly positive* eigenvalues is the *rank* of $bold(B)$, and that is the dimensionality: a cloud that genuinely lies in a plane has exactly two positive eigenvalues and the rest are zero. You do not assume the number of dimensions, you count it off the spectrum.
+ *Where are the points?* Take $bold(X) = bold(Q) bold(Lambda)^(1/2)$: each eigenvector, stretched by the square root of its eigenvalue, becomes one coordinate axis. The largest eigenvalue marks the direction the points spread along the most, the next-largest the second, and so on, the very same machinery that powers principal component analysis. Keep the top two eigenvalues and you have a map you can draw on a page.

Feed in a clean table of distances, turn this one crank, and out fall both the map and its true dimensionality. A table of numbers really does contain a picture. (A pleasing footnote for us: for the actual factorization, Young and Householder point the reader to "a method given by Thurstone," the same Thurstone from Episode 1.)

#figure(
  image("figures/classical_mds_pipeline.svg", width: 100%),
  caption: [*One crank from distances to coordinates.* Turn the table of distances into the scalar-product matrix $bold(B)$, then read off its answers: the rank gives the dimensionality, and the eigenvectors give the coordinates.],
) <fig:pipeline>

_An aside worth savoring. In 1938 Alston Householder was a young mathematician in Nicolas Rashevsky's mathematical-biology group at Chicago, and the eigen-factorization his own paper calls for had to be ground out by hand. A decade later, at Oak Ridge, he would invent the Householder transformation @householder1958unitary, one of the workhorse algorithms computers still use to compute exactly these decompositions. The man who taught machines to do the arithmetic first co-wrote the paper that demanded it._

So we are done, right? Given distances, we can build the space. Except for one enormous catch, and it is the reason this beautiful result sat on a shelf for years.

== Torgerson's method to construct these spaces

Young and Householder's machine assumes you already hold a clean, exact table of Euclidean distances. Read their paper and you will find no mention of error, of noise, or of fallible human judgment; the distances are simply *given*. But where would a psychologist get exact distances? Experiments do not hand you distances. They hand you *comparative judgments*, and, as we saw with Thurstone, those are only distances up to an unknown shift and a great deal of noise. Torgerson put it precisely: a comparative distance "is not a distance in the usual sense of the term, but is a distance minus an unknown constant" @torgerson1952multidimensional.

Closing that gap, between the messy numbers an experiment produces and the exact distances the theorem demands, is what Warren Torgerson did in 1952. He set out, in his words, to extend Young and Householder's model "to include procedures for obtaining the projections of stimuli on axes from *fallible* absolute distances" @torgerson1952multidimensional, real data rather than the pristine kind. Make the problem concrete. A procedure like the method of triads hands you numbers $h_(i j)$ that behave like distances on an *interval* scale: their differences are meaningful, but their zero point is not. The true, ratio-scale distance the theorem actually needs is

$ d_(i j) = h_(i j) + c, $

for a single unknown constant $c$ shared by every pair, and pinning down $c$ is Torgerson's *additive constant problem*. It is no mere bookkeeping: the Young--Householder machine only accepts the true $d_(i j)$, so nothing can begin until $c$ is fixed.

Torgerson's move was to let the geometry choose $c$ for itself. Recall the two demands on $bold(B)$: it must be positive semi-definite, and its rank is the dimensionality. Set $c$ too small and $bold(B)$ grows negative eigenvalues, the distances describe no real space at all; set it too large and you needlessly inflate the cloud into extra dimensions. The right $c$ is the smallest one that lets the data sit in a real Euclidean space of the *lowest* dimensionality, and Torgerson supplied practical least-squares procedures to estimate it @torgerson1952multidimensional. Fix $c$, build $bold(B)$ (in practice by centering at the cloud's centroid rather than one corner point, a cosmetic change that treats every point evenhandedly), run the eigendecomposition from the last section, and the map falls out. He also handed the method the name we still use today: *multidimensional scaling*.

The division of labor is worth stating plainly. *Young and Householder solved the mathematics. Torgerson solved the data.*

#figure(
  image("figures/measurement_vs_geometry.svg", width: 100%),
  caption: [*Two different problems.* Young and Householder solved a problem of pure geometry: clean distances in, coordinates out. But real experiments live one step earlier, in the problem of measurement, where all you have are noisy comparative judgments. Torgerson built the bridge between them.],
) <fig:measurement_vs_geometry>

== But this was really hard

And yet, even with Torgerson's recipe in hand, multidimensional scaling barely caught on for another two decades. Torgerson himself, writing in 1952, noticed the silence: apart from Richardson's own experiment, "only one person, Klingberg, has used the model." His diagnosis is the honest heart of this story: "It may well be that one of the reasons for the lack of experimental investigation in this area is that no clear statement of analytical procedure has been published" @torgerson1952multidimensional. The mathematics had existed since 1938. A *usable* recipe had not.

But there were deeper problems than missing instructions:

1. *It demands exact, metric distances.* The whole pipeline treats your dissimilarities as true distances on a ratio scale. But human similarity judgments are really only trustworthy as a *ranking*: we can say that A and B are more alike than C and D, but not that they differ by exactly 1.7 units. Classical scaling asks for a precision the data simply does not have.
2. *Noise breaks the geometry.* With real, fallible data the scalar-product matrix stops being positive semi-definite. Torgerson saw it at once: errors "would tend to change some zero roots in the positive direction and some in the negative." Negative eigenvalues mean the tidy "rank equals dimensionality" answer dissolves into a judgment call, and the recovered map starts to wobble.
3. *The arithmetic was brutal.* Eigen-decomposing a matrix by hand, on a desk calculator, was feasible only for a handful of stimuli, and there was no software to lean on. The ten-city map above takes a modern computer a few microseconds; in 1938 it would have been days of careful, error-prone work.

#figure(
  image("figures/eigenvalue_spectrum.svg", width: 100%),
  caption: [*Where the method cracks.* With clean distances the eigenvalues drop to zero once you pass the true dimensionality, telling you exactly how many dimensions you need. Feed in noisy human data and some eigenvalues go *negative*, muddying both the map and the count.],
) <fig:eigenvalue_spectrum>

Klingberg's lone application, incidentally, was not about perception at all: he used the model to map the *relations among sovereign states* @klingberg1941studies. The idea was clearly powerful. It simply demanded data cleaner, and computation cheaper, than 1940s psychology could supply.

== Coming up next

So the exact answer had been sitting in plain sight since 1938, and it *still* was not enough. What finally set multidimensional scaling loose was a change of ambition: stop insisting on exact distances, and use only the part of the data we actually trust, the *rank order* of the dissimilarities. Define a score for how badly a map violates that ordering, then let a computer nudge the points around until the score bottoms out. That is *nonmetric* MDS, the version that would sweep through psychology in the 1960s, and it is where Episode 3 picks up.

Stay tuned!

== References
#bibliography("refs.bib", style:"ieee")
