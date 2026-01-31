This is episode 1 in series of blog posts that seek to explain how the representation became a powerful tool in psychology and cognitive neuroscience from the early 20th century to the present day. The first episode focusses on the dire straits the field found itself in in the early 20th century and novel quantitative paradigm that allowed the field to objectively quantify psychological phenomena (perhaps for the first time!).

== The Crisis of Confidence
In the early 20th century, psychology was facing a crisis of confidence. As Joel Michell pointed out in his very well written Measurement in Psychology @michell1999measurement, psychology faced an immense pressure to be quantitative like Physics at that time was. Note that Einstein, Bohr and Planck were all revolutionizing the way we think about the physical world at that time. The main way they were doing this by coming with new measurement paradigms to model how people viewed the world. As Michell points out in his book, psychology as a field was not viewed with much respect by the scientific community and the community eminently felt a need to be more quantitative to earn legitimacy. This is not withstanding the fact that the Ferguson report commissioned by the British Association for the Advancement of Science that finished in 1940, concluded that there is no real way to perform psychological measurement thereby eviscerating the very foundation of psychology as a science - at least at the time. 

== Why is similarity needed? And why not absolute values?

The main reason for this evisceration was largely due to the fact that psychology did not have a ground truth to measure against. The canonical example from physics is that of length. There exists an absolute length of a ruler and of the standard measurement units for length. However, in psychology, there is no rule or scale to measure the perception of loudness to a sound perceived by an individual. 

This becomes even harder when you consider concepts that do not have a physical correlate like sound does. For example, the beauty of a painting? How do measure the beauty of a painting with an absolute scale? You cannot - at least not in a way that is objective and can be agreed upon by everyone. 

[TODO: Have a figure on ruler and the absolute scale but no absolute scale for a psychological concept]

In the midst of this crisis of the field, L.L. Thurstone in his 1927 paper, A Law of Comparative Judgement @thurstone2017law proposed a new way to perform psychological measurement [ignore the year on the citation as I am not able to find the original 1927 bib entry] argued that while we as humans may not have an absolute scale, we possess a high sensitive comparison mechanism to compare any two stimuli via a relative scale.

That is, we are not very good at saying "This light is at 400 lumens" but we are very good at saying "Light A is brighter than Light B". The idea that humans are more consistent in their relative judgements than absolute judgements has been replicated repeatedly since then @stewart2005absolute.

== Scales: The 1D Era
While relative judgements allow one to get around the fact that there exists no absolute scale to measure against, it still doesn't allow one to account for the fact that humans are highly inconsistent in comparing stimuli due to factors like attention, fatigue etc.

The way that Thurstone was able to explain this is via assuming that this internal noise could be modelled as a Gaussian Process. More formally, if two light stimuli $mu_A$ and $mu_B$ are presented to an individual where the perceived brightness is sampled from $N(mu_A, sigma^2)$ and $N(mu_B, sigma^2)$.

This way, each time the individual is presented with the same two stimuli, that individual is essentially using one draw from each of the two Gaussian distributions to compare them.

Now, to model if the individual perceives stimulus $A$ as brighter than stimulus $B$, we can compute the difference between the two draws, $delta = x_A - x_B$. 
- If $delta > 0$, the individual perceives stimulus $A$ as brighter than stimulus $B$.
- If $delta < 0$, the individual perceives stimulus $B$ as brighter than stimulus $A$.

Consider two sets of stimuli. The first is between the sun and a lightbulb where the human assesses on all trials that the sun is brighter than the lightbulb. The second is between a lightbulb and a candle where the human assesses that the lightbulb is brighter than the candle only about 75% of the time. What this essentially tells you is that the brightness of the sun is very far from the brightness of the lightbulb, while the brightness of the lightbulb is closer to the brightness of the candle.

[Have a figure here showing the relative distances between the sun, lightbulb and candle]

To formalize this, note that the difference between gaussian distributions is also gaussian. Therefore, the percentage of times that the individual perceives stimulus A as different from stimulus B is related to the distance between the two stimuli.

For example, if $P(A > B) = 0.5$, then the distance between the means $mu_A$ and $mu_B$ is 0. If $P(A > B) = 0.84$, then the distance between the means is 1 standard deviation. If $P(A > B) = 0.977$, then the distance between the means is 2 standard deviations. 

If these numbers seem familiar, it is because they are essentially the same numbers that you would see in a standard normal distribution table. Basically, the Inverse Cumulative Distribution Function (CDF) or the Z-score function evaluated on the probability of A being greater than B gives you the distance between the means in terms of standard deviations. 

Or 

$
d(A, B) = Z(P(A > B))
$

With this technique, Thurstone essentially was able to derive a quantitative scale for measuring the difference between two stimuli based on the relative judgements. He turned the natural human error in judgement into a feature of the measurement scale. (He also described similar methods for cases where the standard deviation of the internal noise was not constant across stimuli but the same idea holds)

But wait, we just have a collection of pairwise distances? How do we go from that to a scale? I know that all of you folks are thinking about Multidimensional Scaling (MDS) here. But that was created only in late 1950s and early 1960s so Thurstone couldn't have used it. And also, this is only a One Dimensional Scale so MDS is overkill.

The algorithm is actually pretty simple. They created a pairwise distance matrix $D$ where $D_(i j)$ is the distance (Z-score) between stimulus $i$ and stimulus $j$ after aggregating over all of the data. Then, to find the scale they just averaged over the columns of $D$ to get a single value for each stimulus. This is akin to taking a "centroid" of the stimulus by comparing its relative score and distance to all other stimuli. Then, if you sort the stimuli based on this centroid, you get the scale.

[TODO: Add a figure here showing the pairwise distance matrix and the centroid]

== Using the 1D scale to evaluate morality
With this theoretical framework, Thurstone operationalized it to learn scales for a variety of psychological phenomena but most famously known for evaluating morality of various crimes @thurstone1927method.

In that study, Thurstone used the scale to evaluate the morality of 19 crimes to see if there was a scale that could capture the moral judgments of individuals. He asked a total of 266 participants to compare every pair of crimes (171 in total) and used the entire aggregated data to learn the scale.

The resulting scale clearly had semantic sense must be viewed from the late 1920s moral perspective.

#figure(
  image("figures/thurstone_scale_seriousness.svg", width: 100%),
  caption: [Learned Scale of Seriousness of Various Crimes @thurstone1927method],
) <fig:thurstone_scale>

Serious crimes like Rape and Homicide are viewed as most immoral while minor crimes like Bootlegging (selling alcohol - this was prohibition mind you) and Vagrancy are viewed as least immoral. One could imagine that today, this scale could look very different.

This method was revolutionary for its time and was used for a whole other set of scales to evaluate other psychological phenomena like handwriting and personality traits @thurstone1931measurement. 

== Limitations of the 1D scale
However, there were definitely a few issues with this method.

1. The scale is unidimensional. For example, in the followin example, it is not clear how one would compare the chocolate cake to chocolate croissant or the pound cake in terms of taste? Do you compare on the texture (cakeness) or to the taste (chocalatiness)? Thurstone's 1D method assumes that if people are confused between two items it is because they are identical on the single dimension being measured. Clearly this is not the case for this example. You lose out on this nuance in the 1D scale.
2. Intransitivity: Thurstone's method also assumes that if $A > B$ and $B > C$ then $A$ must be greater than $C$. For example, if one were to evaluate on the chocalatiness axis then the order would likely be Chocolate Cake > Chocolate Croissant > Pound Cake. However, if one were to evaluate on the cakeness axis then the order would be Pound Cake > Chocolate Cake > Chocolate Croissant. A participant may invariably choose to evaluate on one axis for one query (Chocolate cake vs Chocolate croissant on chocolatiness) but not for another (Pound cake vs Chocolate cake on cakeness). This subtlety is lost in the 1D scale.
3. Needing to collect all the pairwise judgements is very time consuming and not scalable: In terms of sample complexity, this is $O(N^2)$ where $N$ is the number of stimuli. This scales quite poorly with the number of stimuli and quickly becomes infeasible in human data collection. For 25 stimuli this is 625 comparisons, but for 50 one would need to collect 2500 comparisons! Good luck with that.

Next time, we will introduce a method that adds dimensions to Thurstone's scale and addresses some of these issues (while amplifying some of the others!).

#bibliography("refs.bib", style:"ieee")
