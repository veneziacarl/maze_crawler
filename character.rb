require_relative 'file_helper'

class Character
  attr_reader :type, :max_hp, :current_hp, :str, :inventory

  def initialize(attributes)
    @type = attributes[:type]
    @max_hp = attributes[:max_hp]
    @current_hp = @max_hp
    @str = attributes[:str]
    @inventory = Inventory.new
    @equip = []
  end

  def roll_damage
    @str/3 + rand(6)
  end

  def equip_item(item)
    if item.class == Item
      if @equip.empty?
        @equip << item
        "Item equipped!"
      else
        @equip.clear
        @equip << item
        "Item equipped, old item dropped."
      end
    else
      "Error"
    end
  end

  def add_inventory(item)
    @inventory.add_item(item)
    update_stats(item, 'add')
  end

  def remove_inventory(item)
    @inventory.remove_item(item)
    update_stats(item, 'remove')
  end

  def hp_change(number)
    new_hp = @current_hp + number
    if new_hp < max_hp
      @current_hp = new_hp
    elsif new_hp >= max_hp
      @current_hp = max_hp
    end
  end

  def monster?
    type == :monster
  end

  def player?
    type == :player
  end

  private
  def update_stats(item, change)
    if change == 'add'
      @max_hp += item.hp_mod
      @current_hp += item.hp_mod
      @str += item.str_mod
    elsif change == 'remove'
      @max_hp -= item.hp_mod
      @current_hp -= item.hp_mod
      @str -= item.str_mod
    end
  end
end
