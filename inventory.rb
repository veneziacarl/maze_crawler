class Inventory
  def initialize
    @items = []
  end

  def add_item(item)
    if item.class == Item
      @items << item
      "Item added!"
    else
      "Error"
    end
  end

  def remove_item(item)
    if item.class == Item
      @items.delete(item)
      "Item removed!"
    else
      "Error"
    end
  end

  def has_key?
    @items.any? { |item| item.name == 'key' }
  end
end
