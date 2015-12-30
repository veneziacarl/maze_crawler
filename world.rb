require 'pry'
require_relative 'square.rb'

class World
  attr_reader :row_count, :column_count, :value_grid, :character_position
  attr_accessor :level

  def initialize(row_count, column_count, level)
    @column_count = column_count
    @row_count = row_count
    @board_grid = []
    @value_grid = {}
    @character_position = []
    @level = level
    make_value_grid
  end

  def make_board_grid
    (0...row_count).each do |grid_row|
      (0...column_count).each do |grid_col|
        @board_grid << [grid_row, grid_col]
      end
    end
  end

  def make_value_grid
    make_board_grid

    @board_grid.each do |space|
      pixColor = level.get_pixel(space[0], space[1])
      @value_grid[space] = Square.new
      if pixColor[0] == 1 && pixColor[1] == 0 && pixColor[2] == 0
        @value_grid[space].lava = true
      elsif pixColor[0] == 0 && pixColor[1] == 1 && pixColor[2] == 0
        @character_position = [space[0], space[1]]
        move_character(@character_position[0], @character_position[1])
      elsif pixColor[0] == 1 && pixColor[1] == 1 && pixColor[2] == 0
        @value_grid[space].key = true
      elsif pixColor[0] == 0 && pixColor[1] == 0 && pixColor[2] == 1
        @value_grid[space].portal = true
      end
    end
  end

  def move_character(row, col)
    if valid_move?(row, col)
      @value_grid[@character_position].character_present = false
      @character_position = [row, col]
      @value_grid[@character_position].character_present = true
      find_adjacent_spaces(row, col).each do |space|
        @value_grid[space].visible = true
      end
    end
  end

  def valid_move?(row, col)
    row < row_count && col < column_count && row >= 0 && col >= 0 && on_path?(row, col)
  end

  def on_path?(row, col)
    !@value_grid[[row, col]].lava
  end


  def find_adjacent_spaces(row, col)
    adjacent_spaces = []
    directions_to_search = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1], [0, 0]]
    directions_to_search.each do |direction|
      adjacent_space = [row + direction[0], col + direction[1]]
      if !@value_grid[adjacent_space].nil?
        adjacent_spaces << adjacent_space
      end
    end
    adjacent_spaces
  end

  # Return true if the cell been uncovered, false otherwise.
  # def cell_cleared?(row, col)
  #   @value_grid[[row, col]][:cleared]
  # end

  # Uncover the given cell. If there are no adjacent mines to this cell
  # it should also clear any adjacent cells as well. This is the action
  # when the player clicks on the cell.
  # def clear(row, col)
  #   @value_grid[[row, col]][:cleared] = true
  # end

  # Check if all cells that don't have mines have been uncovered. This is the
  # condition used to see if the player has won the game.
  # def all_cells_cleared?
  #   !@value_grid.any?{ |space, properties| properties == { cleared: false, mine: false } }
  # end

  # Returns the number of mines that are surrounding this cell (maximum of 8).
  # def adjacent_mines(row, col)
  #   number_of_mines = 0
  #   spaces_to_scan = find_spaces_to_scan(row, col)
  #   spaces_to_scan.each do |space|
  #     number_of_mines += 1 if contains_mine?(space[0], space[1])
  #   end
  #   number_of_mines
  # end

  # Returns true if the given cell contains a mine, false otherwise.
  # def contains_mine?(row, col)
  #   @value_grid[[row, col]][:mine]
  # end


end
