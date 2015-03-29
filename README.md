# PSU Club Crawler

This simple script will crawl the PSU Student Affairs website and 
pull out all the data about student clubs:

http://studentaffairs.psu.edu/hub/studentorgs/orgdirectory/

It's problematic to scrape this site because of the way that it's generated. 
There appears to be stateful information that prevents plain `POST` requests 
from being effective, and none of the links actually have `href` attributes 
-- they're controlled by a javascript callback instead.

So our approach is to use phantomjs to manually navigate to each page, taking 
full advantage of the full session and javascript support that it provides.

## Prerequisites

- Ruby
- PhantomJS

## Run it

```
bundle install
ruby crawl.rb
```

After it runs (it can take 30 minutes), you'll have a CSV file with all
the PSU club data.
