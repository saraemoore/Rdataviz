---
title: "Presenter Notes: Advanced Data Visualization in R"
author: Sara E. Moore
date: February 24, 2015
output: 
  html_document:
    theme: flatly
    highlight: default
---


## Intro

---

## Why `ggplot`?

* If you're here, you're probably already using ggplot or are interested in learning to use it. But, I'm still going to tell you why it's a good thing to use.
* Of course, it's pretty. Graphics made with ggplot are eye-catching.  This is actually pretty important -- it goes a long way when you want anyone who is not a statistician to look at your graphs.
* The code you use to call ggplot and create a graphic is fairly intuitive.  This is because of the "grammar of graphics" that it adheres to, and we'll get back to that in a bit. This is what the "gg" in "ggplot" stands for -- "grammar of graphics" -- so the philosophy is pretty central to the package.
* If you learn how to use it well, you can make almost any visualization in it, and your reports, presentations, papers, and so on will look more cohesive because you stuck to a particular style throughout.
* Finally, with a little help from other R packages, ggplot is able to interface with geographical maps.

---

## Why not `ggplot`?

* So, what are the arguments against ggplot?
* It's slower than other R graphics systems. This is a fair point. However, it's probably not something you'll notice under everyday use.
* It also won't draw some graphics that you might want it to. One example that's often brought up is 3D surface plots. But, do you really want to make a static 3D perspective plot? There are other, arguably better, ways to represent three-dimensional data in 2D, like contour plots and heatmaps. This is kind of the story with most things that ggplot supposedly "can't" do -- it's a principled decision by a designer to limit the use of his product -- artistic license. For example, having two y-axes, each using a different scale for a different variable, is difficult if not impossible to do in ggplot -- which may be for the best because having two y-axes can be misleading. Moving x-axis labels to the top, rather than the bottom, is difficult but can be done. ggplot also refuses to use more than six shapes -- citing difficultly in determining which is which -- unless you manually override this by specifying your own shapes. 
* ggplot can be difficult to break into. If you force yourself to use it, it will become natural fairly quickly, though. You can also start with qplot aka "quick plot," but I won't be going over that here. 
* Some people argue that lattice is better at trellis graphs, which were made popular by William Cleveland's 1993 book "Visualizing Data." However, I disagree. I've included a link here to a compilation of a series of blog posts from 2009 in which nearly every graphic in the entire Lattice book by Deepayan Sarkar was recreated in ggplot. You can tweak these examples to make them look even more like lattice output, if you want, but the point is that faceting works just as well.

---

## Tidy data

* One stumbling block when getting started with ggplot is that your data needs to be in a certain format before you can use it in ggplot effectively.  One name for this format is "tidy data." It can also be called long or tall, as opposed to wide, data, but tidy data is a particular type of long data.  The general idea is that there should be one row per observation, whatever you're calling a single observation for your purposes, and one column per variable.  This means that you're typically going to want to collapse indicators into factors, for example, or you may need to think carefully about what your observational unit is.
* Here, the first two tables display data that is not tidy. The third table displays the same data, but made tidy.

---

## The (Layered) Grammar of Graphics

* As I mentioned previously, one of the best qualities of ggplot is that a series of commands used to generate a graphic are human-readable.  This is because ggplot adheres to the so-called "grammar of graphics," first laid out by Leland Wilkinson in 1995. The general idea is, instead of using a "name," "chart typology," or drawing from what Hadley Wickham calls a "big collection of special cases," think more abstractly and use a "statement" to describe a graphic -- and we need a grammar to construct statements. This infinitely expands the number of unique graphics that can be created and it adheres to the **DRY** ("don't repeat yourself") programming principle (as opposed to WET, "write everything twice" or "we enjoy typing")
* Hadley Wickham's quote from his 2010 paper on his take grammar of graphics is just meant to say that this is not a recipe for a perfect graphic -- you can still make some pretty poor visualizations with ggplot -- but it is the first step.

---

## Components of the Grammar

* The general concepts or classes, which are kind of a mash-up of Wilkinson's and Wickham's philosophies, are listed here. The realizations of these concepts in `ggplot` are in parentheses so we can connect the ideas to the R commands. Also, layering is not a statement itself, but is implied by the order of the other components.

---

## The anatomy of a `ggplot` command

* Some guides, including the ggplot book, start you off with the qplot or "quick plot" command. That's nice if you're coming from another graphics framework like base graphics in R. But, in the interest of time, because I'm assuming a little bit of familiarity with ggplot with this group, and because the ggplot command is more powerful than qplot, I'm going to skip right to using the ggplot command here.
* These are some simple examples of the ways in which you would create a very simple graph using ggplot. Any aesthetics or data you provide to the ggplot command, which always gets called first in the "statement," set defaults for the entire graph. You can instead choose to leave the ggplot command empty -- without arguments -- if you'd like to specify individual data and aesthetics for each geometric object. You can even specify a defaults AND specify different settings for individual geometric elements. Note that it is best practice to not repeat yourself, so typically you'll set some defaults up front and only change later in the statement any individual elements that you want to change.

---

## The data

* The dataset I'll be using throughout the presentation is from a Kaggle competition that's currently open. This is historical NCAA basketball data from 1984 to 2014. I'm not allowed to distribute the dataset, but the CSVs are free to download from Kaggle's site after you sign up for an account with them. If you'd like to be able to recreate or play around with the graphics here, that's what you'll need to do. I've included an R file in the repo containing a function called load.clean.ncaa that loads the data into your R workspace and does some minimal cleaning. To use it, just change the argument to the path where the Kaggle CSVs are stored on your machine.  If you don't want to go to this trouble, ggplot2 ships with several good datasets that you can use instead -- a few of them are listed here. You can try your hand with one of those if you want some practice.

---

## A simple scatterplot

* This is a simple example to get us started. Here we have DATA which contains all the NCAA basketball games played over 30 seasons between 1984 and 2014. Each row is an observation, as we've defined it for this problem -- a single basketball game. Each column is a variable. This data is tidy, at least for how we choose to represent it now -- but there are other ways to structure it.
* There are no implicit or explicit transformations of the data going on, and the only aesthetics are the position of each point in two dimensional space, defined by x and y. The geometric objects here are points, which are displayed in ggplot by default as circles. And, because it's just good practice, we've tweaked some visual elements, adding labels to each axis and a title to the graph.
* All that said, this is not a great graphic.  We can tell that, obviously, the winning team always scored as many or more points than the losing team, and it seems like there might be many games where the score was close, but it's difficult to tell because of all the overplotting. I'm not going to dwell too much on what a good versus bad plot is -- you'll know that from other classes, like Professor Dudoit's Computational Statistics course, but I just wanted to point that out here as a segue to the next graphic.

---

## Improving the scatterplot

* Here we are explicitly calling a ggplot transformation that asks ggplot to hexagonally bin, in two dimensions, our observations. Here we're telling it to create bins of width 4 points for both x and y. The default is actually specified as binwidth, not number of bins, and it is 30 for both. The geometric objects, hexagons, are implied by this statement. Whenever you allow ggplot to transform your data, you should always know what it's doing -- here I'm careful to state the defaults and changed them just to demonstrate how it can be done.  This is one tricky part about using a "smart" graphics package -- you need to be sure to keep up with what it's doing to your data.  There was a job talk recently that I know some of you attended which was really amazing for the most part -- really advanced theory and good discussion -- but it was completely derailed for a good 5 minutes by discussion over a single graphic, which was made in ggplot, and which wasn't even demonstrating a main point of the talk.  The big issues were that there were several geometric objects drawn on the graph, and a couple of them performed transformations on the data, but it wasn't made clear exactly what those transformations were.  It's easy to use some of these functions without thinking very hard about them, particularly if you leave them at their default settings, but you really need to be careful.  That's why I'm showing this plot with the "stat_binhex" first, so that it's clear there's a transformation happening.  However...

---

## Improving the scatterplot

* As you can see, this produces the same graph. However, now I'm using a call to a "geom" which has a defualt statistical transformation (as opposed to a stat with a default geom). I've explicitly stated the default here for clarity, which is called "binhex," or hexagonal binning of observations to form counts.

---

## When geoms transform

* Here is a reference list of the geometric elements in ggplot that "silently" transform data by default, i.e. their default stat is not "identity. Also listed here are the defaults of those transformations. Although I called a "stat" function earlier that, by default, created a "geom", it is much more common in practice to just call a "geom" and add arguments specifying the "stat".
* The boxplot is a special case where many elements cannot be set by the user, but that's alright because they're what you'd expect them to be. The middle line is the median and the lower and upper hinges represent the lower and upper quartiles, respectively. The one thing you can specify is how far - at a maximum - the whiskers extend beyond the hinges, but the default (1.5 x inter-quartile range) is consistent with John Tukey's boxplot. You can also make a notched boxplot with geom_boxplot, and the notch locations are not specifiable, but I won't go into the settings for that here -- you can find it in the documentation if you're interested.
* For one and two dimensional kernel density estimates, by default, the bandwidth is chosen automatically via Silverman's "rule of thumb," which I won't go into here, but the formula is available in the R help via the functions I've listed here, or on Wikipedia if you search for Silverman's "rule of thumb." Essentially it's the optimal bandwidth if your data's underlying distribution is Gaussian.
* For loess and gam I only listed the most interesting parameters -- there are more that you can set. Just know that the "et cetera" indicates that any defaults not listed here for these functions are not modified in ggplot's call.
* FYI, violin plots were the big culprit for derailing the job talk a few weeks ago. As you can see, they're a bit tricky.

---

## Other `ggplot` transformations

---

## Dates, `tidyr`, and summaries with `ggplot2`

---

## A heatmap with `ggplot2::geom_tile`

* Note that there is a package called `gplots` with a function called `heatmap.2`: this is commonly used to make heatmaps with dendrograms but is not the same as `ggplot`.

---

## Creating a dendrogram with `ggdendro`

---

## Simplifying the dendrogram

---

## Heatmap, reordered

---

## Putting it all together

---

## Packages that pair well with `ggplot2`

* The examples for ggsubplot are a little "busy" but it actually can be useful in practice.  For example, if you want to zoom in on a particular part of a plot and show it as an inset, or show an inset of what a particular graph would look like under conditions like the null, and so on.
* Note that the munsell color system is what is used by ggplot by default, but you may want to use the same color system to make your own palettes.

---

## Where to go for help with `ggplot2`

---

# Interactive data visualizations in R

---

## Why interactive?

---

## SVG `ggplot` with `plotly`

* Start with the static ggplot
* Note that graphics are uploaded to plot.ly and are **public** by default. So, don't use this unless you're ok with other people seeing it.
* Also, the conversion does not always go as planned.  Sometimes the ggplotly function will reject the ggplot object with a cryptic error message. Sometimes it will convert it, but it will not look sensible. The tooltips are also not as helpful as they could be -- but there are apparently cumbersome ways to hack them. Your mileage may vary.

---

## SVG graphic with `clickme`

---

## MotionChart with `googleVis` (Flash)

* "The googleVis package provides an interface between R and the Google Charts API. Google Charts offer interactive charts which can be embedded into web pages. The best known of these charts is probably the Motion Chart, popularised by Hans Rosling in his TED talks.
The functions of the googleVis package allow the user to visualise data stored in R data frames with Google Charts without uploading the data to Google. The output of a googleVis function is html code that contains the data and references to JavaScript functions hosted by Google."

---

## Many interactive options in R

* I'm only listing R packages that are currently available to download and use, appear to be actively maintained and haven't been subsumed by other R packages, produce graphics that can viewed in a web browser locally or embedded in an html document like this one that was produced with knitr and rmarkdown. I'm not going to list anything that requires server-side support from interfaces like Shiny or Rook to be interactive, for example. Whether or not SVGAnnotation is actively maintained is questionable, but I listed it anyway because it's still referenced by people, it does seem to offer some unique features, and one of the two developers on it was Deborah Nolan who is right here at Berkeley.
* Many of these produce graphics in SVG, or Scalable Vector Graphics, which is, according to wikipedia, an XML-based vector image format for 2D graphics with support for interactivity and animation.  Not all of them do, though -- for example, googleVis produces some output as Flash.
* Paul Murrell, who wrote grid, the backbone of both ggplot2 and lattice, also wrote gridSVG, along with one of his students, Simon Potter.
* [tabplotd3](http://cran.r-project.org/web/packages/tabplotd3/index.html): interactive tableplots (see [tabplot](http://cran.r-project.org/web/packages/tabplot/index.html)) - but needs to be served by [Rook](http://cran.r-project.org/web/packages/Rook/index.html)?

---

# Questions?

---

## References

---

## Credits
