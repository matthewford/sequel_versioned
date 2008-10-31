class Page < Sequel::Model
  is(:versioned_fact, :collections => [Comment], :dimensions => [PageDetail])
  
  one_to_many :page_details
  one_to_many :comments

  # def body
  #   fetch_page_detail.nil? ? '' : fetch_page_detail.body
  # end
  # 
  # def body_html
  #   fetch_page_detail.nil? ? '' : fetch_page_detail.body_html
  # end
  # 
  # def title
  #   fetch_page_detail.nil? ? '' : fetch_page_detail.title
  # end
end
