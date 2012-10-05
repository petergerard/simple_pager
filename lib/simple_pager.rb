require 'active_record'
module SimplePager
  # = Simple Paginating for ActiveRecord models
  # 
  # Adds pager scope to all ActiveRecord models. Works similar to will_paginate but does not count the collection.
  # You can't set a universal per_page yet.
  #
  #   @posts = Post.pager :all, :page => params[:page], :order => 'created_at DESC'
  #
  module ActiveRecord
    # makes a Relation look like WillPaginate::Collection
    module Pager
      scope :pager, lambda { |pp| 
        limit(pp[:per_page] || (self.respond_to?(:per_page) ? self.per_page : 30)).
        offset(pp[:page].blank? ? 0 : ((pp[:page].to_i-1)*(pp[:per_page] || (self.respond_to?(:per_page) ? self.per_page : 30)))) 
      }
    end
    
    # mix everything into Active Record
    ::ActiveRecord::Base.extend Pager

    # support pagination on associations and scopes
    klasses.each { |klass| klass.send(:include, Pager) }
  end       
end