require 'net/http'

class FamilyController < AuthorizedController
  def show
    @profile_id = params[:profile_id]
    @token   = OAuth2::AccessToken.new(client, cookies['token'])
    node_id = "-#{@profile_id}" if @profile_id
    family  = Family.new(@token.get("/api/profile#{node_id}/immediate-family").parsed)

    focus = Node.from_hash family.focus
    partners = family.partners.map do |partner|
      PartnerNode.from_hash(partner)
    end
    siblings = family.siblings.map do |sibling|
      Node.from_hash(sibling)
    end
    node_structure = if family.children.count > 0 || partners.count > 0
                 [{
                      pseudo: true,
                      children: family.children.map {|ch| Node.from_hash(ch).to_treant_node}
                  }]
               else
                 []
               end
    node_structure = [
      focus.to_treant_node
    ] + node_structure + partners.map(&:to_treant_node).map{|i| [i,{pseudo: true}]}.flatten[0..-2] + siblings.map(&:to_treant_node)

    if family.parents.count > 0
      if family.parents.count > 1
        node_structure = [
          Node.from_hash(family.parents[0]).to_treant_node,
          {
            pseudo: true,
            children: node_structure
          },
          Node.from_hash(family.parents[1]).to_treant_node
        ]
      else
        node_structure = [
          Node.from_hash(family.parents[0]).to_treant_node,
          {
              pseudo: true,
              children: node_structure
          }
        ]
      end
    end
    gon.simple_chart_config = {
      chart: {
        container: "#tree-simple"
      },      
      nodeStructure: {
        children: node_structure
      }
    }
  end
end
