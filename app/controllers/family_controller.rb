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
    children = [
      focus.to_treant_node
    ] + partners.map do |partner|
      [
        {
          pseudo: true,
          children: family.children.map{|ch| Node.from_hash(ch).to_treant_node}
        },
        partner.to_treant_node
      ]
    end.flatten + siblings.map(&:to_treant_node)

    if family.parents.count > 0
      if family.parents.count > 1
        children = [
          Node.from_hash(family.parents[0]).to_treant_node,
          {
            pseudo: true,
            children: children
          },
          Node.from_hash(family.parents[1]).to_treant_node
        ]
      else
        children = [
          Node.from_hash(family.parents[0]).to_treant_node
        ]
      end
    end
    gon.simple_chart_config = {
      chart: {
        container: "#tree-simple"
      },      
      nodeStructure: {
        children: children
      }
    }
  end
end
