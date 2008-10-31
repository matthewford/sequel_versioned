# For details on Sequel migrations see 
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class PageMigration < Sequel::Migration

  def up
    create_table :pages do
      primary_key :id
      foreign_key :wiki_id, :table => :wikis
      foreign_key :page_detail_id, :table => :page_details
      integer :page_detail_version, :default => 0
      integer :comments_version, :default => 0
    end
  end

  def down
    drop_table :pages
  end

end
