class Comment < Sequel::Model
  is :versioned_collection
  many_to_one :page
  
  before_save do
    self.body_html = RDiscount.new(self.body || '').to_html
  end
end
