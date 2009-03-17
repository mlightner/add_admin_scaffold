namespace :active_scaffold_controllers do

  desc "Setup active scaffold admin controllers"
  task :full => :environment do
    ActiveScaffoldAutoAdmin::setup_controllers
  end

  desc "Remove active scaffold admin controllers"
  task :clobber => :environment do
    ActiveScaffoldAutoAdmin::clobber
  end

  desc "Remove and re-create active scaffold admin controllers"
  task :refresh => :environment do
    ActiveScaffoldAutoAdmin::refresh
  end

end
