## -----------------------------------------------------------------------------
## Code for R Course 'Introduction to ggplot2' held at 
## Aufland-Conference 2015, Landau
## Written by Eduard Szöcs, University Koblenz-Landau
## -----------------------------------------------------------------------------


## -----------------------------------------------------------------------------
## Preparation

## ----- Install packages ------------------------------------------------------

# Uncomment and run (if not done before the course)
# install.packages(c("ggplot2", "plyr", "blmeco", "ggmap", "ggthemes"),  dependencies = TRUE)





## -----------------------------------------------------------------------------
## Load & prepare datasets

## ---- Frog data -----
library(blmeco)     # load blmeco package
data(frogs)         # load frog data
head(frogs)         # show first 6 lines of the dataset

# fish and vegetation (0/1 - data) are categorical, so we convert to factor.
frogs$fish <- factor(frogs$fish)
frogs$vegetation <- factor(frogs$vegetation)


## ---- diamonds data -----
library(ggplot2)
data(diamonds)
head(diamonds)
?diamonds            # show help 





## -----------------------------------------------------------------------------
## ggplot2 basics

## ---- With base R -----
cols <- c('orange', 'steelblue')
plot(count1 ~ waterarea, data = frogs, type = 'n', log = 'x')
with(frogs, points(waterarea, count1, col = cols[fish], pch = 16))
legend('topleft', legend = c('fish 0', 'fish 1'), pch = 16, 
     col = cols, 
     cex = 0.8)


## ---- With ggplot2 -----
ggplot(frogs) +
  geom_point(aes(x = waterarea, y = count1, col = fish)) +
  scale_x_log10()


## ---- The grammar --------
ggplot(frogs) +                                    # main function, here we pass frogs as globel dataset
  geom_point(                                      # geometric object (we want to draw points)
    aes(x = waterarea, y = count1, col = fish)) +  # aesthetics (map a variable to properties of the geom, here x and y coordinates and color)
  scale_x_log10() +                                # scales: change how the variable are mapped (from data to plot). here plot on a log10 scale
  theme_bw()                                       # themes: change the general appearance of the plot






## -----------------------------------------------------------------------------
## Univariate data

## ---- geom: histogramm ------
ggplot(frogs,                     # use the frogs datasez
           aes(x = elevation))+   # take the variable 'elevation' from the dataset) 
  geom_histogram()                # display a histogramm


## ---- geom: density + rug -----
# geoms can be combined / overplotted
ggplot(frogs, aes(x = elevation)) +     # plot the 'elevation' from the frogs data
  geom_density() +                      # display a density
  geom_rug()                            # display a rug




## ---- Excercise 1  -----
# Plot a histogramm of diamond prices at different binwidths
# (50, 500, 5000).
# How does this affect the preception of the data?

## Solution: 
ggplot(diamonds) +
  geom_histogram(aes(x = price), binwidth = 5000)
ggplot(diamonds) +
  geom_histogram(aes(x = price), binwidth = 500)
ggplot(diamonds) +
  geom_histogram(aes(x = price), binwidth = 50)



## -----------------------------------------------------------------------------
## Bivariate data


## ----- geom:point -----
## the scatterplot, mother of all plots
ggplot(frogs, aes(x = count1, y = count2)) +
  geom_point()



## ----- aesthetic: color (discrete) ------
## fish is a discrete / categorical variable
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +  # added col = aesthetics here!
  geom_point()


## ----- aesthetic: color (continuous) ------
## If we supply a continuous variable the legend changes
ggplot(frogs, aes(x = count1, y = count2, col = sqrt(waterarea))) +  # use the square root of lakearea as color
  geom_point()


## ----- aesthetic: shape ------
# the shape aesthetic changes the shape of the geom (points)
ggplot(frogs, aes(x = count1, y = count2, shape = fish)) +
  geom_point()


## ----- aesthetic: shape ------
# aesthetics can be mappe to the same variable
ggplot(frogs, aes(x = count1, y = count2, shape = fish, col = fish)) +
  geom_point()



## ---- aesthetics: alpha (=transparency) ------
# the alpha aesthetic controls the transparency
ggplot(frogs) +
  geom_point(aes(x = count1, y = count2, col = fish), alpha = 0.4) 

# Note: alpha is outside of aes and has a fixed value (not mapped to a variable)
# what would happen if we map it to a variable?



## ---- Excercise 2  -----
# Create the displayed plot!

## Solution
ggplot(diamonds, aes(x = carat, y = price, col = color)) +
  geom_point(alpha = 0.2)





## -----------------------------------------------------------------------------
## Bivariate data (discrete x continuous)

## ----- geom: boxplot -----
# create a boxplot, splitted by categories of fish (x-aesthetic)
ggplot(frogs, aes(x = fish, y = elevation)) +
  geom_boxplot()


## ----- aesthetic: color (discrete) -----
# for boxplots the color - aesthetic changes the color of the border
ggplot(frogs, aes(x = fish, y = elevation, col = vegetation)) +
  geom_boxplot()


## ----- aesthetic: fill (discrete) -----
# use the fill aesthetic to change the color of the boxes
ggplot(frogs, aes(x = fish, y = elevation, fill = vegetation)) +
  geom_boxplot()



## ----- geom: violin -----
# Violin plots show the distribution of the data
# and show therefore more information then the boxplot
ggplot(frogs, aes(x = fish, y = elevation)) +
  geom_violin() +
  geom_boxplot(width = 0.3)

# Here we also overplot the violins with a boxplot. the width aesthetic controls 
# the with of the boxplots. This could be also mapped to a variable like 'sample size'
# boxes with less data will be narrower.




## ---- Excercise 3  -----
# Create the displayed plot!

### solution
ggplot(diamonds, aes(x = cut, y = price)) +
  geom_violin() +
  geom_boxplot(width = 0.15, fill = 'grey90')



## -----------------------------------------------------------------------------
## Multivariate data (Facets)

## ---- Subgroupgs ----
# a scatterplot with points coloured by fish presence
ggplot(frogs, aes(x = elevation, y = count1, col = fish)) +
  geom_point()


## ---- facets: Split the plots by groups - facet_wrap----
# facet_wrap splits the plot into subplots
# and "wraps" them to arrange nicely
ggplot(frogs, aes(x = elevation, y = count1, col = fish)) +
  geom_point() +
  facet_wrap(~fish)


## ---- facets: Split the plots by groups - facet_grid----
# with facet_grid you can specify by which variables columns and rows should be splitted
ggplot(frogs, aes(x = elevation, y = count1, col = fish)) +
  geom_point() +
  facet_grid(vegetation~fish)


## ---- facets: Split the plots by groups - labeller ----
# use labeller = label_both to show both: The variable name and the levels
ggplot(frogs, aes(x = elevation, y = count1, col = fish)) +
  geom_point() +
  facet_grid(vegetation~fish, labeller = label_both)


## ----facets: Split the plots by groups - scales--------------
# the subplots have all the same axis 
# using scales = 'free' will limit the axes to the data displaye in the subplots.
ggplot(frogs, aes(x = elevation, y = count1, col = fish)) +
  geom_point() +
  facet_grid(vegetation~fish, 
             scales = 'free_y')


## ---- Excercise 4  -----
# Create the displayed plot!

## solution
ggplot(diamonds, aes(x = carat, y = price, col = clarity)) +
  geom_point(alpha = 0.3) +
  facet_grid(cut ~ color, labeller = label_both)




## -----------------------------------------------------------------------------
## Aggregated data

## ----- Aggregate data -----
ggplot(frogs, aes(x = fish, y = elevation)) +
  geom_point(position = position_jitter(width = 0.2), alpha = 0.2)
# position_jitter adds soem random noise (in x direction) to the points
# therefore we can better splot the distribution of points


## ---- Aggregate data-----
require(plyr)
mean_ci <- ddply(frogs,                  # take the frogs dataset
                 .(fish),                # split it by fish
                 summarise,              # summarise the data (will be less after aggregation)
                 mean = mean(elevation), # for each group calculate mean and CI
                 err = qnorm(0.975) * sd(elevation) / sqrt(length(elevation))) # CI based on normal
mean_ci


## ---- geom: bar -----
ggplot(mean_ci, aes(x = fish, y = mean)) +
  geom_bar(stat = 'identity')
# We need to set stat = ’identity’ so that the heights of the bars represent the mean.
# Otherwise geom_bar tries to transform the data (height = number of observations per group)


## ----- geom: errorbars -----
ggplot(data = mean_ci, aes(x = fish, y = mean)) +
  geom_point(size = 4) +
  geom_errorbar(aes(ymin = mean - err, ymax = mean + err), width = 0.2)
# takes upper (ymax) and lower (ymin) limits. witdth controls the whisker width


## ---- Combining different datasets into on plot ----
ggplot() +                              # no dataset passed globally (because the geoms use different datasets)              
  geom_point(data = mean_ci,            # dataset to plot mean + error
             aes(x = fish, y = mean), 
             size = 4) +
  geom_errorbar(data = mean_ci, 
                aes(x = fish, y = mean, ymin = mean - err, ymax = mean + err), 
                width = 0.2, size = 1) +
  geom_point(data = frogs,              # dataset to plot points
             aes(x = fish, y = elevation), 
             position = position_jitter(width = 0.2), 
             alpha = 0.2, size = 4) 




## -----------------------------------------------------------------------------
## Maps
## ----Prepare data: Transform coordinates to lat/lon---------------------------
require(sp)
frogs_sp <- frogs
coordinates(frogs_sp) <- ~x+y                     # set coordinates
proj4string(frogs_sp) <- CRS("+init=epsg:21781")  # set Coordinate reference system (CRS) for coordinates
# transform coordinates to WGS84 (lat/lon)
frogs_84 <- spTransform(frogs_sp, CRS("+init=epsg:4326"))
head(coordinates(frogs_sp))
head(coordinates(frogs_84))


## ----Retrieve backgound map------
require(ggmap)
ggmap(get_map(frogs_84@bbox, source = 'google'), zoom = 10)
# try different sources & zoom levels


## ----Add layers------
# as before we add a point layer to the plot
ggmap(get_map(frogs_84@bbox, source = 'google', zoom = 10)) +
  geom_point(data = data.frame(frogs_84), 
             aes(x = x, y = y, col = elevation), 
             size = 2,
             shape = 18)




## -----------------------------------------------------------------------------
## BREAK
## -----------------------------------------------------------------------------



## -----------------------------------------------------------------------------
## Customization and Prettification

## ---- Working with labels -----
ggplot(frogs, aes(x = count1, y = count2, col = sqrt(waterarea))) +
  geom_point() +
  # labs() can be used to set axis labels & title
  labs(x = 'Count at date 1', y = 'Count at date 3', title = 'Date 1 vs Date 2')


## ----plotmath -----
## If we wrap the text into expression() we can use mathematical annotations 
# see ?plotmatch for possibilities
ggplot(frogs, aes(x = count1, y = count2, col = sqrt(waterarea))) +
  geom_point() +
   labs(x = expression(sqrt(x[underscript]^superscript)), 
        y = expression('Greek gamma'~gamma), 
      title = expression(hat(y) <= frac(bar(x), sigma)~'; some text here'))


## ---- transformations / scales ----
ggplot(frogs, aes(x = count1 + 1, y = count2 + 1, col = sqrt(waterarea))) +
  geom_point() +
  scale_x_log10() +     # log x-axis
  scale_y_log10()       # log y-axis


## ----scales: axes ticks--------
# use the breaks= argument to specify where ticks shoud be drawn
ggplot(frogs, aes(x = count1 + 1, y = count2 + 1, col = sqrt(waterarea))) +
  geom_point() +
  scale_x_continuous(breaks = c(0, 31.5, 101.7, 400)) +
  scale_y_log10(breaks = c(1, 10, 100, 400))


## ----scales: Change order discrete axes------
# use the limits= argument to specify the order
ggplot(frogs, aes(x = fish, y = elevation)) +
   geom_boxplot() +
  scale_x_discrete(limits = c("1", "0"))
# or to generally reverse
# scale_x_discrete(limits = rev(levels(frogs$fish)))


## ----- axes: swap x and y -----
# with coord_flip
ggplot(frogs, aes(x = fish, y = elevation)) +
   geom_boxplot() +
  coord_flip()


## ----scales: color (manual)---------
# use scale_fill / colour_manual to use specific colors
# here we use built-in colors (see ?color)
ggplot(frogs, aes(x = fish, y = elevation, fill = fish)) +
   geom_boxplot() +
  scale_fill_manual(values = c('steelblue', 'chocolate2'))
  

## ----scales: color (manual)---------
#  but also hex-codes possible for max. flexibility
# check internet paletton.com
ggplot(frogs, aes(x = fish, y = elevation, fill = fish)) +
   geom_boxplot() +
  scale_fill_manual(values = c('#7A9F35', '#226666'))


## ----- scales: color (palettes) ----
# colorbrewer has some nice palettes
ggplot(frogs, aes(x = fish, y = elevation, fill = fish)) +
   geom_boxplot() +
  scale_fill_brewer(palette = 'Dark2')


## ---- scales: color (gradients) ----
ggplot(frogs, aes(x = count1, y = count2, col = log10(count1))) +
  geom_point() +
  scale_color_gradient(low = 'darkred', high = 'blue', na.value = 'green')
# low is the color at the low end of the legend
# high is the color at the high end of the legend
# na.value specifys the color for missing values


## ----scales: color (gradients)---------------------
# scale_*_gradient2 for a diverging gradient
# midpoint defaults to 0, changed to mean here
midp <- mean(log10(frogs$count1+1))
ggplot(frogs, aes(x = count1, y = count2, col = log10(count1+1))) +
  geom_point() +
  scale_color_gradient2(low = 'red', mid = 'white', high = 'green', 
                        midpoint = midp, space = 'Lab')
### change the mid, what happens?


## ---- Excercise 5 -----
# Create the displayed plot!

## solution
ggplot(diamonds, aes(x = carat, y = price, col = color)) +
  geom_point() +
  labs(y = 'Price [US $]', x = expression('Weigth [ct = 2'%.%10^-4~'kg]')) +
  scale_color_brewer(palette = 'YlOrRd') +
  scale_y_log10(breaks = c(500,1000, 5000, 10000))


## ----change order on x-axis---------
# 
# limits= of a discrete axis changes the order on the x-axis
ggplot(frogs, aes(x = fish, y = elevation, fill = fish)) +
  geom_boxplot() +
  scale_x_discrete(limits = c("1", "0"))
# scale_ 
# x_         # x-axis (=x aesthetic)
# discrete   # is discrete


## ----Working with legends: Change order in legend -----
# the color (legend) is specified by the fill aesthetics
# therefore we use the scale_fill_aesthetic
# se breaks = <levels> to specify the order
ggplot(frogs, aes(x = fish, y = elevation, fill = fish)) +
  geom_boxplot() +
  scale_x_discrete(limits = c('1', '0')) +
  scale_fill_discrete(breaks = c('1', '0'))


## ----Working with legends: Change legend title-----
# use name = <legendtitle> in the scale_* functions
ggplot(frogs, aes(x = fish, y = elevation, fill = fish)) +
  geom_boxplot() +
  scale_x_discrete(limits = c('1', '0')) +
  scale_fill_discrete(name = 'Fish presence', breaks = c('1', '0'))


## ----Working with legends: Change legend labels-------------------------------
# either change the names of the factor levels (not shown here)
# or use the labels argument
ggplot(frogs, aes(x = fish, y = elevation, fill = fish)) +
  geom_boxplot() +
  scale_x_discrete(limits = c('1', '0')) +
  scale_fill_discrete(name = 'Fish presence', breaks = c('1', '0'), labels = c('with fish', 'without fish'))





## ------------------------------------------------------------------------
## Themes

### ----- Themes: predefined themes -----
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme_classic()


### ----- Themes: predefined themes -----
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme_bw()

### ----- Themes: predefined themes -----
require(ggthemes)
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme_wsj()

## ----- Themes: axis text -----
# each element of a theme can be controlled with element_*
# see ?theme for a list of elements
# elements are of type text, line, rect, blank (=omit element)
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 50, size = 25, vjust = 0.5), 
        # x-axis: rotated (50°), bigger (25) and mid-aligned text 
        axis.text.y = element_text(colour = 'green'))   
        # y-axis green axis text



## ----hjust, vjust, angle?! -----
# stolen from the internt
# http://stackoverflow.com/questions/7263849/what-do-hjust-and-vjust-do-when-making-a-plot-using-ggplot
td <- expand.grid(
    hjust = c(0, 0.5, 1),
    vjust = c(0, 0.5, 1),
    angle = c(0, 45, 90),
    text = "text"
)
ggplot(td, aes(x = hjust, y = vjust)) + 
    geom_point() +
    geom_text(aes(label = text, angle = angle, hjust = hjust, vjust = vjust)) + 
    facet_grid(~angle) +
    scale_x_continuous(breaks = c(0, 0.5, 1), expand = c(0, 0.2)) +
    scale_y_continuous(breaks = c(0, 0.5, 1), expand = c(0, 0.2))


## ------ Themes: axis title -----
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme(axis.title = element_text(face = 'bold', colour = 'red', size = 25))
# red, big, bold, axis texts (on both sides)


## --- Themes: axis ticks ----
# but axes can be also controlled separately
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme(axis.ticks.x = element_line(colour = 'red', size = 1),
        axis.ticks.y = element_blank())   
# element_blank onit the element


## ---- Themes: legend title -----
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme(legend.title=element_blank())


## ---- Themes: legend title -----
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme(legend.title=element_text(colour = 'green'))


## ----- Themes: legend background -----
# the background is a rectangular element, so we use element_rect
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme(legend.key = element_rect(fill = 'green'))


## ----- Themes: position of the legend-----
# position can be ”none”, ”left”, ”right”, ”bottom”, ”top”
# also check legend.direction (”horizontal” or ”vertical”)
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme(legend.position = 'bottom')


## ----- Themes: panel background -----
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme(panel.background = element_rect(fill = 'grey50'))


## ----- Themes: panel grid -----
## the grid is made up of lines, so we use element_line
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  theme(panel.grid.major = element_line(colour = 'darkred', size = 2),
        panel.grid.minor = element_line(color = 'blue'))


## -----Themes: strips (facets)-----
# The strip is the 'heading ot the facets
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  facet_wrap(~fish) +
  theme(strip.background = element_rect(colour = 'blue', fill = 'orange', linetype = 'dotted'),
        strip.text = element_text(face = 'bold'))


## ---- Themes: my theme ----
# I often use something like this
edis_theme <- theme_bw(base_size = 12, base_family = "Helvetica") +  # use theme_bw as basis
  theme(panel.grid.major = element_blank(),   # no grid
        panel.grid.minor = element_blank(), 
        text = element_text(size = 14),   # bigger text
        axis.text = element_text(size = 12), # bigger text
        axis.title.x = element_text(size = 14,face = "bold", vjust = 0), # bold text
        axis.title.y = element_text(size = 14,face = "bold", vjust = 1), # bold text
        legend.position = "bottom",
        legend.key = element_blank(),
        strip.background = element_blank(),  # white strip
        strip.text = element_text(size = 14, face = 'bold')) # with bold headings


## ----- Themes: my theme -----
ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point() +
  facet_wrap(~fish) +
  edis_theme
# Note the edis_theme is not a function! - No ().


## ---- Excercise 6 -----
# Create the displayed plot!

## solitions
ggplot(diamonds, aes(x = carat, y = price, col = color)) +
  geom_point() +
  labs(y = 'Price [US $]', x = 'Weigth [ct]') +
  facet_grid(.~cut) +
  scale_x_continuous(breaks = c(0, 2.5, 5)) +
  scale_color_brewer(name = 'Color of \n diamond', palette = 'RdYlGn') + 
  theme(axis.title.x = element_text(size = 20,face = "bold", vjust = 0),
        axis.title.y = element_text(size = 20,face = "bold", vjust = 1),
        strip.background = element_rect(fill = 'gold'),
        panel.grid.minor = element_blank(),
        panel.grid.major = element_line(colour = 'grey80', linetype = 'dotted'),
        panel.background = element_rect(fill = 'white'),
        legend.key = element_blank(), 
        axis.line = element_line(colour = 'gold', size = 1.5))


## ------------------------------------------------------------------------
## Exporting your plots
## ------------------------------------------------------------------------
p <- ggplot(frogs, aes(x = count1, y = count2, col = fish)) +
  geom_point()


## ----- export to different formats -----
ggsave('myplot.pdf', p)
ggsave('myplot.png', p)
ggsave('myplot.svg', p)


## ----- set height and resolution -----
ggsave('myplot.png', p, width = 7, height = 6, dpi = 300)


## ---- use vector graphics -----
ggsave('myplot.svg', p, width = 7, height = 6)


## ------------------------------------------------------------------------
## Misc Stuff

## ----geom: smooth -----
ggplot(frogs, aes(y = log10(count1  + 1), x = elevation, col = fish)) +
  geom_point() +
  geom_smooth(se = FALSE, linetype = 'dashed') +
  geom_smooth(se = FALSE, method = 'lm')

## ----Annotate the plots -----
ggplot(frogs, aes(x = count1, y =count2)) +
  geom_point() +
  annotate('text', 
           x = max(frogs$count1), 
           y = frogs$count2[which.max(frogs$count1)], 
          label = paste0('The biggest number \n of frogs counted was ', 
                         max(frogs$count1)), 
          vjust = 1, hjust = 1, size = 3) +
  annotate('text', x = 300, y = 100, 
           label = 'This text is placed \n at (300, 100)', 
           size = 3, col = 'blue')

