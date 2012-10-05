require 'active_record'
module SimplePager
  def self.included(base)
    base.extend(ClassMethods)
  end
  # = Simple Paginating for ActiveRecord models
  # 
  # Adds pager scope to all ActiveRecord models. Works similar to will_paginate but does not count the collection.
  # You can't set a universal per_page yet, but you can set it on the model. Defaults to 30.
  #
  #   @posts = Post.pager(:page => params[:page]).order('created_at DESC')
  module ClassMethods
    def pager(pp={})
      limit(pp[:per_page] || (self.respond_to?(:per_page) ? self.per_page : 30)).
      offset(pp[:page].blank? ? 0 : ((pp[:page].to_i-1)*(pp[:per_page] || (self.respond_to?(:per_page) ? self.per_page : 30)))) 
    end
  end  
end

# mix everything into Active Record
ActiveRecord::Base.send(:include, SimplePager)