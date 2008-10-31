# For details on Sequel migrations see 
# http://sequel.rubyforge.org/
# http://code.google.com/p/ruby-sequel/wiki/Migrations

class CommentMigration < Sequel::Migration

  def up
    create_table :comments do
      primary_key :id
      text      :body, :default => ''
      text      :body_html, :default => ''
      integer   :version, :default => 0
      foreign_key :page_id, :table => :pages
    end
  end

  def down
    drop_table :comments
  end

end
