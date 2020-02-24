module SimplePager
  # = ActionView helpers
  # 
  # This module serves for availability in ActionView templates. 
  #
  module ActionView
    
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


    protected

    ::ActionView::Base.send :include, self
  end
end
