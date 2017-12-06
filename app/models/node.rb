class Node

  attr_accessor :first_name, :last_name, :gender, :id

  def initialize(hash)
    @first_name = hash['first_name']
    @last_name = hash['last_name']
    @gender = hash['gender']
    @id = hash['id'].remove 'profile-'
  end

  def get_data
    token
  end

end
