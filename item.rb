class Item
  attr_reader :hp_mod, :str_mod, :name

  def initialize(item_attributes)
    @hp_mod = item_attributes[:hp_mod]
    @str_mod = item_attributes[:str_mod]
    @name = item_attributes[:name]
  end
end
