class Node < ApplicationRecord

  def assign_from_hash(hash)
    puts 'Assign from hash:'
    puts hash
    self.first_name = hash['first_name']
    self.last_name = hash['last_name']
    self.gender = hash['gender']
    self.is_alive = hash['is_alive']
    self.geni_id = hash['id'].remove 'profile-'
    birthday = hash['birth'].try(:[], 'date').try(:[], 'day')
    if birthday
      self.birthday = birthday
    end
    birthmonth= hash['birth'].try(:[], 'date').try(:[], 'month')
    if birthmonth
      self.birthmonth = birthmonth
    end
    birthyear = hash['birth'].try(:[], 'date').try(:[], 'year')
    if birthyear
      self.birthyear = birthyear
    end
    self
  end

  def to_treant_node
    {
        text: {
            name: "#{first_name} #{last_name}",
            desc: birthdate || geni_id
        },
        HTMLclass: "#{gender} #{is_alive ? 'alive' : 'deceased'}",
        link: {
            href: "/family/show/#{geni_id}"
        }
    }
  end

  def get_data
    token
  end

  def birthdate
    [birthday, birthmonth, birthyear].compact.join('.')
  end

  def self.from_hash(hash)
    geni_id = hash['id'].remove 'profile-'
    if geni_id
      nodes = Node.where(geni_id: geni_id)
      if nodes.size > 1
        puts "Consistency error: #{geni_id} has #{nodes.size} nodes in DB"
        nodes.first
      elsif nodes.size == 1
        node = nodes.first
        node.assign_from_hash hash
        if node.changed?
          node.save
        end
        node
      else
        node = Node.new
        node.assign_from_hash hash
        node.save
        node
      end
    end
  end

end
