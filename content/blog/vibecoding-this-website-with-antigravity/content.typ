// Write your Typst content here

My old personal website was looking old and outdated. Especially compared to some of the fabulous websites of some of my #link("https://alechelbling.com/")[colleagues]. I used to not really care about it as I viewed it as a distraction from my research. However, I was convinced by Alec that it is helpful to disseminate research to a wider audience besides the professional ramifications. I still put it off given other priorities but when I finally got around to it last weekend as a side project I though it would super simple to just use Gemini and Perplexity like I do for my usual research coding.

Though both Gemini and Perplexity (now I'm moving to Gemini because of the free Pro subscription for a year for students) are great when you have individual files to work with, they are not that great when you have to work with a whole codebase which is what most websites require.

I am completely unskilled with Javascript and web development in general. Therefore, it would make logical sense if I just used standard boilerplate templates that these AI tools suggest. However, I do not make it easy as I am incredibly particular about my tools and templates. Some of this particularity comes from my struggles earlier in my academic journey.

= My Hate Relationship with Latex

One of my biggest pet peeves is Latex, an unfortunate peeve for someone working in ML. At the current age, with three hundred thousand packages and a million ways to do things it is incredibly confusing and annoying. As anyone using templates for academic paper knows, it is a nightmare to fit floats (a class for figures and tables in Latex) in the right place while still complying with the format and the page limits. 

The earliest main paper I contributed #link("https://dl.acm.org/doi/10.1145/3680278")[to] (the paper was really cool but a pain in the a\*\* to typeset in Latex on Overleaf), caused me to go on multiple late nights solely to get the paper formatted and into page limits correctly in our multiple resubmissions. For the last submission to the journal, I in fact needed my PI (the super patient and nice Prof. #link("https://adamwierman.com/")[Adam Wierman]) to help me out with the last few floats. This was incredibly embarassing but despite best efforts to reverse engineer Latex and use it better (remember these were Stack Overflow days. So before ChatGPT for you young whippersnappers) but my progress remained slow.

Something similar happened with my next #link("https://vivek-anand.xyz/publications/anand2023incremental/")[paper] which needed the actual raw TeX files, that compiled without warnings and not the pdf because of it being a Springer Journal. One of Prof. #link("https://sites.cc.gatech.edu/fac/constantinos.dovrolis/")[Constantinos Dovrolis]'s PhD students needed to help me to get the Latex code formatted in time for submission. The paper was easy in comparison. And don't get me started on the process to get submissions into Arxiv as I found out when I tried submitting our #link("https://arxiv.org/abs/2209.08180")[class paper] to it. That was an entire weekend. For those unfamiliar with Arxiv, it is a repository for preprints of scientific papers. It is a great resource for researchers to share their work with the community, but it can be a pain to submit to if you are incompetent in Latex as I am. You need submit the raw .tex files and Arxiv will compile it for you similar to how Springer does. However, the compilation can take a ridiculous amount of time and the warnings and error messages are hard to decipher pre-ChatGPT.

This long rant aside, Latex is hard to use and is not just annoying just for me. I really enjoy the rants from these two guys #link("https://www.reddit.com/r/math/comments/1mqzuug/after_10_years_of_working_with_it_im_starting_to/")[reddit cuz duh] and #link("https://aty.sdsu.edu/bibliog/latex/gripe.html")[this Prof at San Diego State].

The main reason why Latex really sucks is because
+ It's hella unintuitive.
+ It takes so freaking long to compile. You could grab a cup of coffee and come back and it would still be compiling for long research papers with multiple figures and tables.
+ Debugging can be a nightmare. Especially before deadlines. Which we all have to deal with in academia.
+ Package installations and compilers vary dramatically from person to person if you run it locally. #link("https://overleaf.com")[Overleaf] has been revolutionary in making it easier to collaborate on papers but it is still not perfect and 1-3 are still very much time sinks.

However, the one thing I will give it is that it gives you a way to reproducibly get the same output every time you compile without having to use fine motor movements and three hundred thousand buttons like microsoft word. 

== My Infatuation with Typst
A student in the Lab, #link("https://www.linkedin.com/in/kyle-johnsen/")[Kyle Johnsen], had shared a link to typst on our lab's resources slack channel a while ago. One evening, I aimlessly clicked on it and saw that it was completely new programming language, #link("https://typst.app/")[typst], based on Rust, for typesetting documents and that did not have the issues that Latex had. I'm usually always skeptical of new tools given the time it takes to learn them and for the ecosystem to mature for it to be useful. However, given my toxic history with Latex, I gave it a shot.

Long story short, I'm a huge fan and have never looked back.

Some of the things I absolutely love about Typst are:
+ It is incredibly fast. It compiles so quickly due to the backend being written in Rust and an incremental compilation strategy. In fact, Zerodha, the Indian stock brokerage firm, uses Typst for their internal documents for regulatory compliance as it compiled so much faster than Latex.
+ It is incredibly easy to use. The syntax is very intuitive. What takes 10 lines in Latex takes 2 lines in Typst.
+ Even then, back in 2023, it had most of the important features that Latex had (except for multi column float support which was super annoying until 2024).

It takes me a long time to switch tools but once I do I commit fully and when it came time to submit to NeurIPS in early 2025, I decided to ignore all advice and not use the Latex template provided by NeurIPS. Instead I found this #link("https://typst.app/universe/package/bloated-neurips/")[template] in typst and decided to use it. At that time it was completely broken so I raised an issue on the github page and one of the creators, Daniel Bershatsky, updated it and that allowed me to use it.

Though their webapp (similar to Overleaf) is very easy and intuitive to use, I personally installed the language and use it locally in VS Code. Even long documents compile almost instantly. Typst even has this great command `typst watch` which basically is a live preview of the document as you type. This feature single handedly sped up my writing process for the submission. The paper didn't make it but it wasn't a desk rejection so the template did work well.

== Building a Website with Antigravity and Typst
Ok, long aside over. Me love typst. Me want to use it for everything. I mean everything. So I thought why not use it for my personal website? I plan on writing blog posts explaining some of my research and if I'm disciplined enough, an explanation for each paper I write. Because my work does involve a bit of math and equations to explain, I thought Typst would be a great choice for this instead of using Latex in Markdown.

The problem is that Typst is a typesetting language. It is not a website building language. Typst did have a feature to export to HTML but it was very limited and not very well supported and as of January 2026 is still in the experimental phase. 

To get around this, I decided to use some static site generators to build my website. I looked into a few options and settled on #link("https://www.getzola.org/")[Zola] which seemed to be much more intuitive and easier to use than options like #link("https://jekyllrb.com/")[Jekyll] and #link("https://gohugo.io/")[Hugo]. However, I want to use typst and none of these allow for that.

Gemini, found #link("https://github.com/dark-flames/apollo-typst/tree/main")[this] one repo on Github that used Zola and used the experimental Typst features to export to HTML. Unfortunately, after a better part of Sunday, the typst didn't show up locally or on my Netlify deployment. Later, I started using #link("https://tola-rs.github.io/example-sites/")[Tola], a small wrapper on top of Typst that works for static site generator but when I got hungry I decided to pivot as the maintainer warned that it was very early stage and that things would change drastically. Being the lazy person I am, I wanted to use something that was easy to use, would last a long time but still aesthetically pleasing.

Having heard a lot about #link("https://antigravity.google/")[antigravity] recently with #link("https://github.com/torvalds/AudioNoise")[Linus Torvald],the creator of the Linux kernel using it I decided to give it a try. 

As someone who had not used Cursor before, it was a refreshing surprise to see the VSCode like interface and the ease of use. Moreover,with the free year of Google Pro, I had enough tokens to really try it out even with the really good Claude Opus 4.5 model.

Basically, there is a chat interface on the side, just like Github Copilot, and you can ask it to do things like generate a website, generate a blog post, generate a resume, etc. However, unlike Copilot it doesn't suck. Not only are the models available quite powerful the really cool thing is that before it makes changes, it creates a list of tasks and a suggested plan on what it is going to do. You need to manually approve the suggested plan or make some edits or suggestions. Only after that will it start making changes. The agent works incredibly systematically and step by step which was a refreshing change from my copy paste into Perplexity/ChatGPT/Gemini days.

To build the website, initially, I simply wanted a working website with an about page, blog posts with typst and a way to change it. Antigravity basically used Zola as the static site generator but used Pandoc to convert the typst files to HTML and stitch them together. Even the first version was bug free and worked after a few powershell scripts (cuz windows) and a bit of CSS. After that I slowly escalated my requests by asking for Dark mode, a favicon (that's an actual word) a picture, an education section, publications from a .bib file and a tagging system to sort posts and publications by. It totally took a few hours to get it right but that was not really due to antigravity (it made only one mistake) but more due to my own specific preference on what I wanted.

Then, once the local version was running on my browser, I asked it to help me deploy it to netlify and it worked first time like a breeze. 

= Ramifications for the Future

I'm genuinely impressed by the ease of use, the accuracy of the output and the sheer next level it takes coding from the copy paste into ChatGPT/Perplexity/Gemini days. Some of the #link("https://github.com/vivek2000anand/vivek-neuro")[code] is definitely a bit hard coded if you dig in and could be more modular etc. but it is more than enough for my needs and my personal website requirements. I more than likely will be using the same framework for the rest of my PhD.

However, I probably will start using it even for my research. Till now, I've been very hesitant to use AI tools for my own research as I need to have complete control over what I code and the output it gives. Given that I'm not the best coder, I need to have confidence that what I think the code is doing is what it is doing. With this website, I have a lot more confidence and I might dip my toes into using it for my research code.

= Investment Advice (I'm Joking!!!)
Given the scale of money the tech companies are pouring into artificial intelligence, there's a definite necessity to make money and make money soon. Google is in a crazy enviable position of having a humongous cash pile, the best business in the world in terms of cash flow and probably the 2nd or 3rd best AI model (after Anthropic and maybe some of the Chinese ones as of January 2026). But, they also have a ridiculous amount of data that they haven't fully made use of for their AI models. I've criticized them a lot in the past decade for being very slow at making profitable products even if they have great user interfaces and are nice concepts but they've really got their act together now. Not only are their models much better after their code red but also their business model has improved.

With their Google One subscription they're moving towards a bundling strategy similar to microsoft but unlike microsoft the products are actually quite good. They've just started integrating it into Gmail, Drive etc. And given the cash they have, they can afford the free Pro subscriptions for students. It is gonna be incredibly difficult for me to switch next year when the subscriptions are not free and pay the roughly \$300 per year. It must be noted that last year, I said the same thing about Perplexity when I got the free subscription but this year I'll probably cancel mine soon as it just isn't needed or worth it anymore.

Despite the crazy increase in stock price google has seen this year, I still think there is room to grow (ask your financial advisor and don't take my word for it and do your own research) given their strong economics and their lock on crazy amounts of data.

So yes, this website was vibecoded with love with antigravity and zola and typst. And be prepared for what is to come both from me and Google. 
