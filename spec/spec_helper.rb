require File.join(File.dirname(__FILE__), "../lib/sequel_versioned")


DB = Sequel.sqlite

DB.create_table :facts do
  primary_key :id
  integer :dimension_id
  integer :dimension_version, :default => 0
  integer :collections_version, :default => 0
end

DB.create_table :dimensions do
  primary_key :id
  integer     :version, :default => 0
  integer :fact_id
  varchar :name
end

DB.create_table :collections do
  primary_key :id
  integer     :version, :default => 0
  integer :fact_id
end


class Dimension < Sequel::Model
 set_schema do
   foreign_key :fact_id, :table => :facts
 end
 is :versioned_dimension
 many_to_one :fact
end

class Collection < Sequel::Model
 set_schema do
   foreign_key :fact_id, :table => :facts
 end
 is :versioned_collection
 many_to_one :fact
end


class Fact < Sequel::Model
  set_schema do
    foreign_key :dimension_id, :table => :dimensions
  end
  is(:versioned_fact, {:collections => [Collection], :dimensions => [Dimension]})  
  one_to_many :collections
  one_to_many :dimensions
  
  def name
    fetch_dimension.name
  end
end