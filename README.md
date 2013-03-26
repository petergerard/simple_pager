# simple_pager

Super lightweight and simple Rails 3 pagination for when you don't need to count the number of items or pages.

Sometimes [will_paginate][will] is too much for your pagination needs. If you've got a complicated query and performance is more important than being able to navigate all the pages, then you'll want something simple like this. Or if you are joining tables and adding `.uniq` to your relation, will_paginate won't actually work, since it's count method is a little broken.

So simple\_pager just shows Previous and More links. It's designed to play nicely with will\_paginate so you can use both in the same app.

Uses markup compatible with [Bootstrap's pager class][bootstrap].


## Installation:

``` ruby
## add to Gemfile in Rails 3 app
gem 'simple_pager'
```


## Basic simple\_pager use

``` ruby
## perform a paginated query:
@posts = Post.pager(:page => params[:page])

## specify a different number of items per page:
@posts = Post.pager(:page => params[:page], :per_page => 15)

## render page links in the view:
<%= simple_pager @posts %>
```

Remember to add some [CSS styles][bootstrap].

You can customize the default "per_page" value:

``` ruby
# set a default per_page value for the Post model:
class Post
  self.per_page = 10
end
```


[bootstrap]: http://twitter.github.com/bootstrap/components.html#pagination "Twitter Bootstrap Pager CSS"
[will]: https://github.com/mislav/will_paginate