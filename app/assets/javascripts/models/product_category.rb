class ProductCategory
  attr_accessor :id, :name

  def initialize attributes={}
    @id = attributes[:id]
    @name = attributes[:name]
  end
end
