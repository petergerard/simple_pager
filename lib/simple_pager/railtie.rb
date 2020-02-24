
module SimplePager
  class Railtie < Rails::Railtie
    initializer "simple_pager" do |app|
      ActiveSupport.on_load :active_record do
        require 'simple_pager/active_record'
      end

      ActiveSupport.on_load :action_view do
        require 'simple_pager/action_view'
      end
      
    end

  end
end
