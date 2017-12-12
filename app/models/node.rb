class Node

  attr_accessor :first_name, :last_name, :gender, :id, :is_alive

  def initialize(hash)
    @first_name = hash['first_name']
    @last_name = hash['last_name']
    @gender = hash['gender']
    @is_alive = hash['is_alive']
    @id = hash['id'].remove 'profile-'
  end

  def to_treant_node
    {
      text: {
        name: "#{@first_name} #{@last_name}",
        desc: @birthdate || @id
      },
      HTMLclass: "#{@gender} #{@is_alive ? 'alive' : 'deceased'}",
      link: {
        href: "/family/show/#{@id}"
      }
    }
  end

  def get_data
    token
  end

end
