Here are some webdev tasks where we could use help with, roughly in difficulty order, easiest first.

Tasks
-----
- checking and making sure our archived pages are HTTPS ready
  - I've set up Let's Encrypt recently, but only deployed it partially, since there are hardcoded http paths in various files and I didn't have time to check everything yet
  - since most of them are static html archives, likely a few regex replaces could do the brunt of the work
  - some may work out of the box
  - browser developer tools notify you if there are problems (usually in the network tab)
- check https://khan.github.io/tota11y/ compliance of https://github.com/ewba/english-intro (https://ebm.si/en) 
- converting the three unstructured CSV files into JSON for our help-me-separate-waste mini app
  - the javascript and php code reading it will need slight adjustment
  - https://ebm.si/p/locevanje/
- a Zero Waste municipality data visualisation solution
  - this one is a bit more involved, but mostly done, only the overview remains to be solved (on the harmonica opened by default on http://ebm.si/zw/obcine)
  - basically a data presentation/graphing problem:
    - the data is already stored in google sheets and could be manipulated there
    - the challenge is to display statistic per municipality per year per goals (3), so it can't easily fit into a table
      - easiest to do via a pretty table that has a radio control to determine which goal is to be shown and then shows just a municipal timeline of that
      - manually designed it looked like this: http://ebm.si/zw/wp-content/uploads/2018/05/poro%C4%8Dilo-zw-ob%C4%8Din-2018-768x939.jpg
- help with data migration from joomla2 to drupal8
  - either the Migrate plugin needs an extra script or some other solution found to make it work good
  - maybe upgrading to joomla3 first would help
  - the core issue is that joomla2 doesn't have a separate field for article thumbnails, but just uses the first image referenced in the article
    - while everyone else wants a separate field
 - create a "year in review" web report template
   - example: http://report.zerowasteeurope.eu/
   - perfect indicators are not ready yet, but the overall design can already be made

Done
----
- renovating our help-me-separate-waste mini app
  - it's a simple bootstrap page, with the core lookup logic in php (=serverside) and some js glue to make it work better; that's fine
  - it has a generic look that can be vastly improved
  - usability or at least the way info is presented could surely be done better
- our custom 404 page needs improving, eg. http://ebm.si/asdas (view source)
  - you can see that the long script loading causes the gradient to not be expanded immediately
  - it could be much prettier or creative
    - you can try whatever you want (our topic is waste and we indeed hate incineration)
  - the iats donation div is loaded via a <script> tag and can't be styled directly; an override is possible through an upstream interface
