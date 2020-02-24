require 'simple_pager/per_page'
require 'active_record'
module SimplePager
  def self.included(base)
    base.extend(ActiveRecord)
  end
  # = Simple Paginating for ActiveRecord models
  # 
  # Adds pager scope to all ActiveRecord models. Works similar to will_paginate but does not count the collection.
  #  per_page defaults to 30
  #
  #   @posts = Post.pager(:page => params[:page]).order('created_at DESC')
  #   @posts = Post.pager(:page => params[:page], :per_page => 15).order('created_at DESC')
  module ActiveRecord
    module RelationMethods
      def per_page(value = nil)
        if value.nil? then limit_value
        else limit(value)
        end
      end
    end  
    
    module SimplePagination
      def pager(options)
        
        options  = options.dup
        pagenum  = options.fetch(:page) { raise ArgumentError, ":page parameter required" }
        options.delete(:page)
        per_page = options.delete(:per_page) || self.per_page
        
        limit(per_page.to_i).
        offset(pagenum.blank? ? 0 : ((pagenum.to_i-1)*(per_page))) 
      end
      def paginate(options)
        options  = options.dup
        pagenum  = options.fetch(:page) { raise ArgumentError, ":page parameter required" }
        options.delete(:page)
        per_page = options.delete(:per_page) || self.per_page
        total    = options.delete(:total_entries)

        if options.any?
          raise ArgumentError, "unsupported parameters: %p" % options.keys
        end

        rel = limit(per_page.to_i).page(pagenum)
        rel.total_entries = total.to_i          unless total.blank?
        rel
      end
    end
    
    # mix everything into Active Record
    ::ActiveRecord::Base.extend PerPage
    ::ActiveRecord::Base.extend SimplePagination
    
    klasses = [::ActiveRecord::Relation]
    if defined? ::ActiveRecord::Associations::CollectionProxy
      klasses << ::ActiveRecord::Associations::CollectionProxy
    else
      klasses << ::ActiveRecord::Associations::AssociationCollection
    end

    # support pagination on associations and scopes
    klasses.each { |klass| klass.send(:include, SimplePagination) }
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
      prevnum = (params[:page].to_i - 1)
      pprev = content_tag(:li, link_to( "&larr; #{prev_name}".html_safe, request.query_parameters.merge({:page => (prevnum == 1 ? nil : prevnum)}) ),:class => 'previous')
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