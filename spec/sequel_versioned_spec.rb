require File.join(File.dirname(__FILE__), "spec_helper")

DB = Sequel.sqlite

class Fact < Sequel::Model(:items)
  set_schema do
    primary_key :id
    varchar :name
    forign_key :dimension_id, Dimension
    integer :dimension_version
    integer :collections_version
  end

  is(:versioned_fact, {:collections => [Collection], :dimensions => [Dimension]})
  
  one_to_many :collections
  one_to_many :dimensions
end
 
class Dimension < Sequel::Model(:items)
  set_schema do
    primary_key :id
    integer     :version, :default => 0
    forign_key :fact_id, Fact
  end

  is :versioned_object
  many_to_one :fact
end

class Collection < Sequel::Model(:items)
  set_schema do
    primary_key :id
    integer     :version, :default => 0
    forign_key :fact_id, Fact
  end

  is :versioned_collection
  
  many_to_one :fact
end




describe Sequel::Plugins::Versioned, "current_object(s)" do

  before(:each) do
    Fact.create_table!
    Collection.create_table!
    Dimension.create_table!
  end
  
  it "should have a dimention created" do
    f = Fact.create
    f.current_dimention.should_not be_nil
  end

  it "store collection objects" do
    f = Fact.create
    c = Collection.create
    r.add_collection()
    r.current_collections.include?(c).should == true
  end
  
end
