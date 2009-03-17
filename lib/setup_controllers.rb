class ActiveScaffoldAutoAdmin

  FORCE = ENV['FORCE'] =~ /(y|1|tr)/i ? true : false

  def self.refresh
    clobber
    setup_controllers
  end

  def self.setup_controllers
    system("mkdir -p #{RAILS_ROOT}/app/controllers/admin/")
    add_base
    model_dir = "#{RAILS_ROOT}/app/models/*.rb"
    Dir[model_dir].each do |file|
      file.to_s =~ /([\w\-\_]+)\.rb$/i
      next unless model = $1
      if !FORCE
        next if File.exist?("#{RAILS_ROOT}/app/controllers/admin/#{model.pluralize}_controller.rb")
      end
      print "  creating \"#{RAILS_ROOT}/app/controllers/admin/#{model.pluralize}_controller.rb\" (model: #{model})\n"
      open("#{RAILS_ROOT}/app/controllers/admin/#{model.pluralize}_controller.rb", 'a') do |c|
        c.puts "class Admin::#{model.pluralize.classify}Controller < Admin::BaseController"
        c.puts "\n  active_scaffold :#{model}\n\nend"
      end
    end

    puts "Add the following to routes.rb:\n\n"
    Dir[model_dir].each do |file|
      file.to_s =~ /([\w\-\_]+)\.rb$/i
      next unless model = $1
      puts"  map.connect 'admin/#{model.pluralize}/:action/:id', :controller => 'admin/#{model.pluralize}'"
# RESTful
#      puts"  map.resources :#{model.pluralize}, :active_scaffold => true"
    end
  end

  def self.add_base
    print "  creating Admin::BaseController\n\n"
    open("#{RAILS_ROOT}/app/controllers/admin/base_controller.rb", 'a') do |c|
      c.puts "class Admin::BaseController < ::ApplicationController\n\n"
      c.puts 'layout "admin"'
      c.puts "\n\nend"
    end    
  end

  def self.clobber
    system("rm -f #{RAILS_ROOT}/app/controllers/admin/*.rb")
  end

end
