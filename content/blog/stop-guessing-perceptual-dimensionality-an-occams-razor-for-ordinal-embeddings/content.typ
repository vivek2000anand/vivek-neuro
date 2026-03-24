#import "@preview/ouset:0.2.0": underset

// #import "@preview/subpar:0.2.2"
Based on our ICLR 2026 paper: #link("https://arxiv.org/abs/2602.04192")[LORE: Jointly Learning The Intrinsic Dimensionality and Relative Similarity Structure from Ordinal Data]

#figure(
  image("figures/crown_jewel_version_3.3.svg", width: 100%),
  caption: [*LORE jointly learns both the intrinsic dimensionality and relative similarities.*: Other methods require the embedding dimension to be chosen apriori, making them highly susceptible to underfitting or overparameterizing the latent space.],
) <fig:crown_jewel_teaser>


== Introduction
Measuring and mapping human perception quantitatively is hard. If you want to measure physical distance, you use a ruler. But if you want to measure how "sweet" a cake is, or how "aesthetic" a painting is, no absolute physical ruler exists.

Historically, researchers relied on absolute queries, like asking subjects to rate a stimulus on a 1-5 Likert scale. But absolute scales are fundamentally flawed: my "moderately sweet" might be your "cloyingly sweet". Moreover, humans are quite inconsistent in their absolute judgments giving very different answers to the same questions at different times @stewart2005absolute. To get around the lack of an absolute ruler, early psychophysics @thurstone2017law @thurstone1931measurement @thurstone1931measurement and later, machine learning @shepard1962analysis1 @tamuzAdaptivelyLearningCrowd2011 @terada2014local leveraged relative queries. These ask subjects to compare stimuli against each other (e.g., "Is stimulus A more similar to B than to C?") instead of rating them in a vacuum. (Check out #link("https://vivek-anand.xyz/blog/from-scales-to-spaces-episode-1-building-the-psychological-ruler/")[Episode 1] of my blog series for more details on how relative queries allowed psychophysics to escape the absolute ruler.) 

However, converting these relative judgements into a latent geometry is non-trivial. The field developed Multidimensional Scaling (MDS) algorithms @kruskal1964multidimensional, which yield exact solutions but require an exhaustive pairwise distance matrix, and Ordinal Embedding (OE) algorithms @agarwal2007generalized @tamuzAdaptivelyLearningCrowd2011 @terada2014local, which are highly data-efficient but non-convex. The non-convexity can be problematic if the algorithm settles in a particularly bad local minima leading to suboptimal embeddings that may be quite different from the true underlying percept. Despite their challenges, these methods allowed researchers to finally build multidimensional perceptual _maps_ instead of flat rulers.

#figure(
  image("figures/absolute_vs_relative_scales.svg", width: 100%),
  caption: [*Relative Scales are more reliable than absolute scales.* Human perception lacks an absolute baseline for abstract concepts like loudness or taste. However, we possess a highly sensitive comparison mechanism. In this example, it is much easier to say which sound is louder than to quantify exactly how loud each sound is.],
) <fig:absolute_vs_relative_scales>

But there's a massive catch. Both MDS and OEs require you to specify the dimensionality of the map *before* you even start building it.

== The Problem of Dimensionality
Consider a thought experiment. Imagine trying to map the perceptual geometry of food. How many dimensions do you think you need? Sweetness and sourness give us two. Texture adds a third. Maybe temperature adds a fourth?

Regardless of your intuition, manually choosing the dimensionality means you are making an arbitrary guess about the shape of the space. This is a major roadblock when the entire goal of your research is to _discover_ the underlying structure of an unknown percept, which is the case for much of psychology!

Because existing OEs require you to specify this intrinsic rank upfront, you are forced into a blind guessing game that leads to two major problems:

- *Underfitting*: If you guess too few dimensions, you crush complex relationships. The model might combine "spicy" and "hot temperature" into a single confusing axis.

- *Overparameterizing*: If you play it safe and guess 15 dimensions, the algorithm will happily spread the data across all of them. A 15D model might satisfy all your triplet comparisons perfectly, but it fractures simple concepts across multiple axes, making the resulting map totally uninterpretable to scientists.

Scientific discovery demands *Occam's Razor*: we want the simplest model that explains the data. A 2D taste map is infinitely more useful than a 10D one if the underlying percept only varies in two ways. Yet, historically, we had no scalable way to let the data tell us its own complexity.

#figure(
  image("figures/crown_jewel_version_3.3.svg", width: 100%),
  caption: [*LORE jointly learns both the intrinsic dimensionality and relative similarities.*: Other methods require the embedding dimension to be chosen apriori, making them highly susceptible to underfitting or overparameterizing the latent space.],
) <fig:crown_jewel>

== LORE: Letting the Data Reveal the Intrinsic Rank
To solve this, we introduce LORE (Low Rank Ordinal Embedding), a new algorithm that jointly learns the intrinsic rank and the relative similarities directly from the data.

The core intuition behind LORE is to apply Occam's Razor mathematically. We want to balance fitting the similarity structure (which existing OEs do quite well) with penalizing unnecessary dimensions. Strictly minimizing the number of dimensions (the matrix rank) is computationally NP-Hard @fazel2001rank. The standard workaround is to use a convex relaxation called the nuclear norm @candesExactMatrixCompletion2008a.

However, there is a problem: the nuclear norm uniformly shrinks _all_ singular values @negahban2011estimation @zhang2010nearly not just the lower order ones. The reason why this is an issue is because the a low rank solution has small or negligible lower singular values but usually would have large dominant singular values. A uniform shrinkage can lead to optimization results could lead to small errors in the magnitude of the singular values that could lead to very different ranks learned. While this works well empirically for standard matrix completion @candesExactMatrixCompletion2008a, it often fails to recover the true intrinsic rank of perceptual spaces because it over-penalizes the largest, most important dimensions that actually define the space @luGeneralizedNonconvexNonsmooth2014.

Instead LORE regularizes using the nonconvex Schatten $p$ Quasi-norm ($0<p<1$) @luGeneralizedNonconvexNonsmooth2014 @marjanovic2012l_q. This specific penalty is much more forgiving to the large, dominant singular values but aggressively crushes the smaller, noisy ones to zero. The following graph which compares the nuclear norm with the Schatten Quasi-norm visually illustrates the penalty each imposes (y axis) on the the particular singular value (x axis). 

#figure(
  image("figures/why_schatten.svg", width: 100%),
  caption: [The Schatten $p$-quasi-norm is much more forgiving to large, dominant singular values than the nuclear norm but aggressively crushes smaller, noisy ones to zero. This allows is to empirically recover low rank solutions much more reliably than the nuclear norm.],
) <fig:why_schatten>



By balancing a smoothed ordinal embedding loss with this Schatten $p$-quasi-norm penalty, LORE automatically prunes away unnecessary dimensions during training.
$

  underset("min", bold(Z)) " " Psi(bold(Z))  &= underset(sum, (a,i,j) in T)  log(1 + exp(1 + d(bold(Z)_(a,:), bold(Z)_(i,:)) - d(bold(Z)_(a,:), bold(Z)_(j,:))))) & + lambda sum_(i=1)^(min{N, d^'}) sigma_(i) (bold(Z))^p .

$

Because this objective is highly non-convex, standard optimization methods often fail to learn a good enough solution. To solve this, we use an efficiently scaled, iteratively reweighted Singular Value Decomposition (SVD) algorithm @sun2017convergence. Even with the inherent non-convexity, this guarantees convergence to a stationary point. And because stationary points in OE landscapes are generally known to be nearly as good as global optima @bower2018landscape @vankadara2023insights, LORE reliably yields robust, high quality embeddings.

== Does it work? Yes!
Evaluating LORE against existing methods is tricky because, for real human data, we don't actually know the "true" intrinsic rank. Therefore, we first had to leverage synthetic data where the ground-truth rank is known.

We benchmarked LORE against state-of-the-art OEs across synthetic environments, as well as LLM-generated proxy perceptual spaces (using SBERT @reimers-2019-sentence-bert to model human alignment. It has been found that LLMs are able to capture human perceptual similarity @marjieh2024large). As seen in the plot below, the results were stark: *LORE was the only method that accurately tracked and recovered the true intrinsic rank while maintaining near-optimal test triplet accuracy.*

#figure(
  image("figures/artificial_perceptual_full.svg", width: 100%),
  caption: [Only LORE successfully learns the true intrinsic rank while maintaining high accuracy on LLM-simulated perceptual data.],
) <fig:artificial_perceptual>

But the most exciting results came from real, noisy human data, including the Food-100 dataset @wilber2014cost, which contains crowdsourced triplet ratings of 100 different food items based on perceived similarity of taste.

Given a maximum allowable dimension of 15, standard OEs blindly used all 15 dimensions, creating a completely tangled perceptual space. LORE, acting as an automated Occam's Razor, seamlessly compressed the embedding down to roughly 3.3 dimensions without sacrificing accuracy.


#figure(
  block(
    fill: white,       // Forces a solid white background behind the entire table
    inset: 8pt,        // Adds a little breathing room around the edges
    width: 100%,
    table(
      columns: 4, // Allow columns to expand evenly instead of forcing fractional sizing
      stroke: 0.5pt + black,
      align: (left, center, center, center),
      table.header(
        [*Method*], [*Test Acc.*], [*Rank*], [*Time (s)*],
      ),
      table.hline(stroke: 2pt + black),
      [*LORE* \ (Ours)], text(fill: rgb(128, 128, 128))[$82.45$  $plus.minus$ $0.27$], [*$3.3$*  *$plus.minus$ $0.47$*], text(fill: rgb(128, 128, 128))[$6.64$  $plus.minus$ $3.90$],
      [*SOE*], text(fill: rgb(128, 128, 128))[$82.34$  $plus.minus$ $0.32$], text(fill: rgb(128, 128, 128))[$15$  $plus.minus$ $0.00$], text(fill: rgb(128, 128, 128))[$27.09$  $plus.minus$ $1.38$],
      [*FORTE*], text(fill: rgb(128, 128, 128))[$81.73$  $plus.minus$ $0.46$], text(fill: rgb(128, 128, 128))[$15$  $plus.minus$ $0.00$], text(fill: rgb(128, 128, 128))[$6.34$  $plus.minus$ $0.52$],
      [*t-STE*], text(fill: rgb(128, 128, 128))[$82.79$  $plus.minus$ $0.24$], text(fill: rgb(128, 128, 128))[$15$  $plus.minus$ $0.00$], text(fill: rgb(128, 128, 128))[$40.93$  $plus.minus$ $20.14$],
      [*CKL*], text(fill: rgb(128, 128, 128))[$82.75$  $plus.minus$ $0.20$], text(fill: rgb(128, 128, 128))[$15$  $plus.minus$ $0.00$], text(fill: rgb(128, 128, 128))[$18.41$  $plus.minus$ $7.89$],
      [*Dim-CV*], text(fill: rgb(128, 128, 128))[$77.67$  $plus.minus$ $0.02$], text(fill: rgb(128, 128, 128))[$1.47$  $plus.minus$ $0.51$], text(fill: rgb(128, 128, 128))[$1721.9$  $plus.minus$ $26.71$],
    )
  ),
  caption: [*Only LORE is able to recover the low dimensional structure of the data* while maintaining near-optimal test triplet accuracy on the Food-100 dataset @wilber2014cost.]
) <table:food100_dataset>


The ultimate test of any perceptual map is whether its dimensions actually mean something. Remarkably, even though LORE was trained purely on relative similarities, the resulting axes organically aligned with human interpretable features. The first axis naturally separates sweet from savory; the second contrasts dense foods with light ones; and the third distinguishes carb-heavy items from proteins and vegetables.

#figure(
  image("figures/interpretability.svg", width: 100%),
  caption: [LORE's learned axes are semantically interpretable on the Food-100 dataset. @wilber2014cost],
) <fig:interpretability>

== The Takeaway
When we model human perception, we aren't just trying to maximize predictive accuracy on a holdout set. Instead, we are trying to uncover the latent perceptual maps which involve both learning the relative similarities and the intrinsic dimensionality. By jointly inferring both together, LORE bakes Occam's Razor directly into the ordinal embedding learning algorithm. It removes the need to blindly guess the dimensionality, ensuring we neither underfit nor overparameterize the underlying perceptual space while still learning the relative similarities.

== Code
Code to reproduce our results and for your own ordinal datasets is available at #link("https://github.com/vivek2000anand/lore_iclr")[https://github.com/vivek2000anand/lore_iclr]. We are in progress of integrating LORE into the open source python comparison based machine learning library #link("https://cblearn.readthedocs.io/en/stable/")[cblearn] which would make calling LORE as easy as a call to a standard sciki-learn model. Stay tuned!

== Acknowledgements
I would like to thank #link("https://alechelbling.com/")[Alec Helbling] for feedback on earlier drafts of this blog post.

== References
#bibliography("refs.bib", style:"ieee")

