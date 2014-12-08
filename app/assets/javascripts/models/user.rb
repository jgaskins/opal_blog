class User
  attr_reader :id, :email, :password

  def initialize attributes={}
    @id = attributes[:id]
    @email = attributes[:email]
    @password = attributes[:password]
  end
end
