# simple_pager

Super lightweight and simple Rails pagination for when you don't need to count the number of items or pages.

Sometimes [will_paginate][will] is too much for your pagination needs. If you've got a complicated query and performance is more important than being able to navigate all the pages, then you'll want something simple like this. Or if you are joining tables and adding `.uniq` to your relation, will_paginate won't actually work, since it's count method is a little broken.

So simple\_pager just shows Previous and More links. It's designed to play nicely with will\_paginate so you can use both in the same app.

Uses markup compatible with [Bootstrap's pager class][bootstrap].


## Installation:

``` ruby
# add to Gemfile in Rails 3 app
gem 'simple_pager'
```


## Basic simple\_pager use

``` ruby
# perform a paginated query:
@posts = Post.pager(:page => params[:page])

# render page links in the view:
<%= simple_pager @posts %>
```

You can customize the default "per_page" value for each model:

``` ruby
# set a default per_page value for the Post model:
class Post < ApplicationRecord
  self.per_page = 10
end
```

You can also pass a custom `:per_page` into `.pager`, but you also need to pass that to the helper:
``` ruby

# controller - specify a different number of items per page:
@posts = Post.pager(:page => params[:page], :per_page => 15)

# view - specify the same per\_page value
<%= simple_pager @posts, 15 %>
```

``` ruby
# customise the page link names:
<%= simple_pager @posts,nil,'Newer','Older' %>
```

Remember to add some [CSS styles][bootstrap].


[bootstrap]: http://twitter.github.com/bootstrap/components.html#pagination "Twitter Bootstrap Pager CSS"
[will]: https://github.com/mislav/will_paginate