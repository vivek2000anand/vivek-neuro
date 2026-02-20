This is the first episode in a series of blog posts exploring how mental representations became a cornerstone of psychology and cognitive neuroscience, from the early 20th century to the present day. This episode focuses on the "crisis of confidence" the field faced in the early 1900s and the novel quantitative paradigm that allowed researchers to objectively quantify psychological phenomena, perhaps for the first time.
== The Crisis of Confidence
In the early 20th century, psychology was facing an identity crisis. As Joel Michell points out in his 1999 book, Measurement in Psychology @michell1999measurement, the field was under immense pressure to match the quantitative rigor of physics. At the time, giants like Einstein, Bohr, and Planck were revolutionizing our understanding of the physical world, not just through new theories, but through experiments that verified many of their predictions.

Psychology, by contrast, struggled for respect within the scientific community. There was a desperate need for a quantitative framework to earn academic legitimacy. This struggle was underscored in 1940 by the Ferguson Report @ferguson1940quantitative, commissioned by the British Association for the Advancement of Science. The report concluded that there was no valid way to perform psychological measurement, effectively eviscerating the very foundation of psychology as a science at least by the standards of the time. 

== Why is similarity needed? And why not absolute values?

The root of this evisceration was that psychology lacked a *ground truth*. In physics, we have absolute standards: a meter is a meter, and a ruler provides a direct scale for length. In psychology, however, there is no physical ruler to measure the internal perception of loudness, even if we can measure the loudness in decibels.

This problem compounds when considering abstract concepts with no physical correlate, such as the aesthetic appeal of a painting. How do you measure beauty on an absolute scale? You cannot. At least not in a way that is objective and universally agreed upon.

In the midst of this crisis, L.L. Thurstone proposed a breakthrough in his 1927 paper, A Law of Comparative Judgment @thurstone2017law. He argued that while humans lack an internal absolute scale, we possess a highly sensitive comparison mechanism. We are poor at stating, "This sound is exactly 80 decibels," but we are excellent at stating, "Sound A is louder than Sound B." This insight, that relative judgments are far more consistent than absolute ones, has been validated many times since then @stewart2005absolute.

#figure(
  image("figures/absolute_vs_relative_scales.svg", width: 100%),
  caption: [Absolute vs Relative Scales. Human perception does not have an absolute scale to measure against like physical concepts like length or weight. However, humans possess a high sensitive comparison mechanism to compare any two stimuli via a relative scale.],
) <fig:absolute_vs_relative_scales>

== Scales: The 1D Era
Relative judgments solved the "ruler" problem, but they didn't account for human inconsistency. Factors like attention and fatigue mean that a person might not give the same answer every time.

Thurstone accounted for this internal noise by modeling judgments as samples from a Gaussian (Normal) distribution. He proposed that every time we judge a stimulus, we are essentially drawing a value from a distribution centered on its true perceived value. More formally, if two sound stimuli $A$ and $B$ are presented to an individual where the perceived loudness is sampled from $N(mu_A, sigma^2)$ and $N(mu_B, sigma^2)$ independently where $x_A$ and $x_B$ are the samples from the respective distributions. Then the difference between the two samples is given by $delta = x_A - x_B$. tells us the perceived relationship between the two stimuli.
- If $delta > 0$, the individual perceives stimulus $A$ as louder than stimulus $B$.
- If $delta < 0$, the individual perceives stimulus $B$ as louder than stimulus $A$.

Consider a thought experiment:
+ *Whisper vs. Bomb Blast*: A listener chooses the bomb blast 100% of the time. A bomb is significantly louder than a whisper so there is no confusion
+ *Gunshot vs. Bomb Blast*: A listener chooses the bomb blast only 80% of the time. A bomb is louder than a gunshot but sometimes the listener may perceive the gunshot being louder.

The higher "confusion" in the second pair tells us that the gunshot and bomb blast are much closer together on the internal psychological scale than the whisper and the blast. A visualization can be seen in the figure below.

#figure(
  image("figures/sound_perception.svg", width: 100%),
  caption: [A whisper and a bomb blast are perceived as very different in loudness, while a bomb blast and a gun firing are perceived as less different in loudness due to increase in confusion between the stimuli.],
) <fig:sound_perception>

To formalize this, Thurstone noted that the difference between two Gaussian distributions is itself Gaussian @weisstein_normal_diff. Therefore, the percentage of times that the individual perceives stimulus A as different from stimulus B is related to the distance between the two stimuli. The percentage of times an individual chooses $A$ over $B$ directly maps to the distance between their means in terms of standard deviations. By applying the Inverse Cumulative Distribution Function (Z-score) to these probabilities to obtain a distance $D_(A B) = Z(P(A > B))$,Thurstone leveraged natural human error to create a quantitative scale.

But wait, we just have a collection of pairwise distances? How do you build a scale? Today, we might use Multidimensional Scaling (MDS), but that wasn't developed until the 1950s. If you don't know what MDS is, we'll cover it in a future episode. And also, this is only a One Dimensional Scale so MDS is overkill when something far simpler would suffice. Thurstone's approach was much simpler.

+ Create a pairwise distance matrix $bold(D)$ where $D_(i j)$ is the distance (Z-score) between stimulus $i$ and stimulus $j$ after aggregating over all of the data.
+ Average over the columns of $bold(D)$ to get a single value for each stimulus. This is akin to taking a "centroid" of the stimulus by comparing its relative score and distance to all other stimuli. By averaging how much 'better' or 'worse' a crime is compared to every other crime in the set, we find its unique coordinate on the moral map.
+ Sort the stimuli based on this centroid to get the scale.

#figure(
  image("figures/centroid_figure.svg", width: 100%),
  caption: [Making the distance matrix from the the Z scored pairwise probabilities and then averaging over the columns to get the scale for each stimulus.],
) <fig:centroid_figure>

== Using the 1D scale to evaluate morality
With this theoretical framework, Thurstone famously applied this for evaluating the crowdsourced seriousness of crimes @thurstone1927method. He asked 266 participants to make 171 pairwise comparisons across 19 different offenses.

The resulting scale showed that the 1920s American public viewed Vagrancy and Bootlegging as the least serious crimes while Rape and Homicide were viewed as the most serious crimes. Given the time, it is not surprising to see that Abortion and Seduction were viewed as more serious crimes than Assault and Battery. One could imagine that if today the same experiment was conducted, the scale would look very different.

#figure(
  image("figures/thurstone_scale_seriousness.svg", width: 100%),
  caption: [Thurstone's Crowdsourced 1D Scale of Seriousness of Various Crimes (1927) @thurstone1927method],
) <fig:thurstone_scale>

This method was revolutionary for its time as it enabled the quantitative measurement of abstract psychological percept without making any assumptions about the underlying percept or asking for numerical ratings. Later the same method was used to build psychological scales for a whole other set of phenomena like handwriting and personality traits @thurstone1931measurement. 

== Limitations of the 1D scale
As revolutionary as Thurstone's 1D scale was, it had three major flaws:

1. *The scale is unidimensional*: Take the following example: how would you compare the chocolate cake to chocolate croissant or the pound cake in terms of taste? Do you compare on the texture (cakeness) or to the mouthfeel (chocolatiness)? Thurstone's 1D method assumes that if people are confused between two items it is because they are identical on the single dimension being measured. Clearly this is not the case for taste. A 1D scale forces these nuances onto a single line, losing the complexity of the object.
2. *Intransitivity*: Thurstone's method also assumes that if $A > B$ and $B > C$ then $A$ _must_ be greater than $C$. For example, if one were to rank the three desserts Chocolate Cake, Chocolate Croissant and Pound Cake on chocolatiness, then the order would likely be Chocolate Cake > Chocolate Croissant > Pound Cake. However, if one ranked on the cakeness axis then the order would be Pound Cake > Chocolate Cake > Chocolate Croissant. A participant may invariably choose to evaluate on one axis for one query (Chocolate cake vs Chocolate croissant on chocolatiness) but not for another (Pound cake vs Chocolate cake on cakeness). Human preference is rarely simple and we often change our criteria depending on what we are comparing.
3. *Lack of Scalability*: Collecting every possible pair for $N$ stimuli requires $O(N^2)$ comparisons. This scales quite poorly with the number of stimuli and quickly becomes infeasible in human data collection. Thurstone managed to get 266 participants to do 171 comparisons each. That in itself is a feat especially for 1927! For 25 stimuli this would 625 comparisons and for 50 one would need to collect 2500 comparisons! Good luck with that.


== Coming Up Next....
Thurstone gave us the psychological ruler, but he kept us trapped on a single line. In the next episode, we'll see how researchers finally "broke out" of the first dimension and developed methods to build multidimensional psychological spaces. Episode 2 of From Scales to Spaces is titled "From Ruler to Map" and will be released next.

Stay tuned!
== References
#bibliography("refs.bib", style:"ieee")
