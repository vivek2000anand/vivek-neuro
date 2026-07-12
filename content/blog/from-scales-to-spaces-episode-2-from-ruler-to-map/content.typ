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

The first person to say this out loud was Marion Webster Richardson, the same Richardson of the Kuder--Richardson reliability formulas, in a 1938 talk to the American Psychological Association @richardson1938multidimensional. His proposal broke from Thurstone in two ways. As Torgerson later summarized it, the method "does not require judgments along a given dimension, but utilizes, instead, judgments of similarity between the stimuli," and, crucially, "the dimensionality, as well as the scale values, of the stimuli is determined from the data themselves" @torgerson1952multidimensional. You don't tell the method how many dimensions there are. You let the data tell you.

And he actually tried it. Richardson took Munsell color chips varying in brightness and saturation, collected similarity judgments using the *method of triads* (show three chips, ask which two look most alike), and recovered a two-dimensional layout that lined up with the known Munsell dimensions of *value* and *chroma* @torgerson1958theory. Out of a pile of "which of these is most alike" judgments, the color space reassembled itself.

#figure(
  image("figures/richardson_color.svg", width: 100%),
  caption: [*Colors, remapped from similarity alone.* A reconstruction in the spirit of Richardson's 1938 experiment: classical scaling applied to perceptual distances between Munsell chips recovers a two-dimensional grid whose axes are value (brightness) and chroma (saturation). Richardson's original judgments are lost, so this is a modern stand-in for his result.],
) <fig:richardson_color>

But Richardson had an argument, not an algorithm. He could see that a table of dissimilarities *ought* to contain a spatial map. He could not yet say, given the table, exactly how to compute the coordinates, or how to read off the number of dimensions. For that, he turned to two mathematicians.

== Young and Householder's math to make it happen

In that same year, Gale Young and Alston Householder answered Richardson's question completely and exactly. Their four-page paper opens by crediting him: it was written "in response to suggestions by Harold Gulliksen and by M. W. Richardson," whose problem made "the dimensionality of a set of points whose mutual distances are available" the central idea @young1938discussion.

Here is the obstacle they had to clear. A table of distances does not pin down coordinates, because you can slide, rotate, or flip an entire constellation of points without changing a single distance between them. Their fix is elegant: nail one point down as the origin, and convert every distance into a *scalar product*, a number that captures how aligned two points are as seen from that origin. The law of cosines does the conversion:

$ b_(i j) = 1/2 (d_(i n)^2 + d_(j n)^2 - d_(i j)^2) $

Collect these numbers into a matrix $bold(B)$, and three questions all get answered at once, just by looking at it:

+ *Is this even a real set of distances?* Yes, if and only if $bold(B)$ is *positive semi-definite*, meaning it has no negative eigenvalues. This is, in their words, "a necessary and sufficient condition for a set of numbers ... to be the mutual distances of a real set of points in Euclidean space," and when it holds the configuration is "unique apart from a Euclidean transformation" @young1938discussion.
+ *How many dimensions do the points need?* Exactly the *rank* of $bold(B)$, the number of nonzero eigenvalues. This is the direct answer to Richardson: the dimensionality is not assumed, it is read straight off the matrix.
+ *Where are the points?* Factor $bold(B) = bold(Q) bold(Lambda) bold(Q)^T$, and the coordinates are $bold(X) = bold(Q) bold(Lambda)^(1/2)$, the eigenvectors stretched by the square roots of the eigenvalues.

Feed in a clean table of distances, turn one crank, and out fall both the map and its true dimensionality. A table of numbers really does contain a picture. (A pleasing footnote for us: for the actual factorization, Young and Householder point the reader to "a method given by Thurstone," the same Thurstone from Episode 1.)

#figure(
  image("figures/classical_mds_pipeline.svg", width: 100%),
  caption: [*One crank from distances to coordinates.* Turn the table of distances into the scalar-product matrix $bold(B)$, then read off its answers: the rank gives the dimensionality, and the eigenvectors give the coordinates.],
) <fig:pipeline>

_An aside worth savoring. In 1938 Alston Householder was a young mathematician in Nicolas Rashevsky's mathematical-biology group at Chicago, and the eigen-factorization his own paper calls for had to be ground out by hand. A decade later, at Oak Ridge, he would invent the Householder transformation @householder1958unitary, one of the workhorse algorithms computers still use to compute exactly these decompositions. The man who taught machines to do the arithmetic first co-wrote the paper that demanded it._

So we are done, right? Given distances, we can build the space. Except for one enormous catch, and it is the reason this beautiful result sat on a shelf for years.

== Torgerson's method to construct these spaces

Young and Householder's machine assumes you already hold a clean, exact table of Euclidean distances. Read their paper and you will find no mention of error, of noise, or of fallible human judgment; the distances are simply *given*. But where would a psychologist get exact distances? Experiments do not hand you distances. They hand you *comparative judgments*, and, as we saw with Thurstone, those are only distances up to an unknown shift and a great deal of noise. Torgerson put it precisely: a comparative distance "is not a distance in the usual sense of the term, but is a distance minus an unknown constant" @torgerson1952multidimensional.

Closing that gap, between the messy numbers an experiment produces and the exact distances the theorem demands, is what Warren Torgerson did in 1952. He extended Young and Householder's model "to include procedures for obtaining the projections of stimuli on axes from *fallible* absolute distances," and he cracked the *additive constant problem*: how to recover the unknown offset $C$ that turns a comparative number $h_(i j)$ into a genuine distance $d_(i j) = h_(i j) + C$ @torgerson1952multidimensional. Guess $C$ wrong and $bold(B)$ sprouts negative eigenvalues, and the machine seizes up, insisting your data cannot live in any real space. Get it right, write down the step-by-step recipe, and for the first time a working psychologist could actually run the thing. Torgerson even gave it the name we still use today: *multidimensional scaling*.

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
