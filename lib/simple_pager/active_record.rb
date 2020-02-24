require 'simple_pager/per_page'
require 'active_record'
module SimplePager
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
