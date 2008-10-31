class Wiki < Sequel::Model
  one_to_many :pages
end
