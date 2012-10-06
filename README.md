# simple_pager

Super lightweight and simple Rails 3 pagination for when you don't need to count the number of items or pages.

Sometimes [will_paginate][https://github.com/mislav/will_paginate] is too much for your pagination needs. If you've got a complicated query and performance is more important than being able to navigate all the pages, then you'll want something simple like this. Or if you are joining tables and adding `.uniq` to your relation, will_paginate won't actually work, since it's count method is a little broken.

So simple\_pager just shows Previous and More links. It's designed to play nicely with will\_paginate so you can use both in the same app.

Uses markup compatible with [Bootstrap's pager class][http://twitter.github.com/bootstrap/components.html#pagination].


## Installation:

``` ruby
## add to Gemfile in Rails 3 app
gem 'simple\_pager', :git => 'git://github.com/accidental/simple\_pager.git'
```


## Basic simple\_pager use

``` ruby
## perform a paginated query:
@posts = Post.paginate(:page => params[:page])

## render page links in the view:
<%= simple_pager @posts %>
```

And that's it! You're done. You just need to add some CSS styles to [make those pagination links prettier][http://twitter.github.com/bootstrap/components.html#pagination].

You can customize the default "per_page" value:

``` ruby
# for the Post model
class Post
  self.per_page = 10
end

```