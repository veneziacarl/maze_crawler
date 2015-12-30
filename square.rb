class Square
  attr_accessor :character_present, :visible, :lava, :portal, :key
  def initialize
    @monster = false
    @trap = false
    @lava = false
    @visible = false
    @explored = false
    @character_present = false
    @portal = false
    @key = false
  end


end
