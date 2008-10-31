# For details on Sequel migrations see 
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class WikiMigration < Sequel::Migration

  def up
    create_table :wikis do
      primary_key :id
      varchar :name, :default => "new wiki"
    end
  end

  def down
    drop_table :wikis
  end

end
