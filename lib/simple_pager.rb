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

module SimplePagerHelper
  def simple_pager(collection,per_page=nil,prev_name='Previous',next_name='More')
    return if !collection
    per_page = collection.first.class.per_page if per_page.blank? and collection.first.class.respond_to?(:per_page)
    per_page ||= 30
    pprev = ''
    pnext = ''
    prefix = ''
    if params[:page] and params[:page].to_i > 1
      if collection.empty?
        prefix = content_tag(:p,"There are no more.")
      end
      pprev = content_tag(:li, link_to( "&larr; #{prev_name}".html_safe, request.query_parameters.merge({:page => (params[:page].to_i - 1)}) ),:class => 'previous')
    end
    if !@no_more_pages and collection.size >= per_page
      pnext = content_tag(:li, link_to( "#{next_name} &rarr;".html_safe, request.query_parameters.merge({:page => (params[:page] ? params[:page].to_i + 1 : 2)}) ),:class => 'next')
    end
    (prefix + content_tag(:ul, (pprev+pnext).html_safe, :class => 'pager')).html_safe
  end
end


# mix everything into rails
ActiveRecord::Base.send(:include, SimplePager)
ActionView::Base.send( :include, SimplePagerHelper)