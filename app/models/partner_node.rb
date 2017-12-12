class PartnerNode < Node

  def to_treant_node
    super.merge({
      hideConnectorToParent: true
    })
  end

end
