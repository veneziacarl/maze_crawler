require_relative "file_helper"
require "gosu"
require_relative "world"
require 'pry'
require_relative "timer"
require 'texplay'

class MazeCrawler < Gosu::Window
  SCREEN_WIDTH = 1428
  SCREEN_HEIGHT = 1000

  TILE_IMAGE = Gosu::Image.new('./bitmaps/dungeonTile.png')
  LAVA_IMAGE = Gosu::Image.new('./bitmaps/lavaTile.png')

  LEVELS = []

  LEVELS << Gosu::Image.new('./levels/lvltest.png')


  attr_reader :world, :large_font, :state

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)

    @level = 0
    @world = World.new(25, 25, LEVELS[@level])
    # @mine_font = Gosu::Font.new(self, "Arial", (cell_size / 1.2).to_i)
    @large_font = Gosu::Font.new(self, "Arial", screen_height / 50)
    @state = :running
    @timer = Timer.new
  end

  def button_down(key)
    row, col = world.character_position
    case key
    when Gosu::KbRight
      if state == :running
        world.move_character(row, (col+1))
      end
    when Gosu::KbLeft
      if state == :running
        world.move_character(row, (col - 1))
      end
    when Gosu::KbUp
      if state == :running
        world.move_character(row - 1, (col))
      end
    when Gosu::KbDown
      if state == :running
        world.move_character(row + 1, (col))
      end
    when Gosu::KbEscape
      close
    when Gosu::KbSpace
      if state != :running
        reset
      end
    end
  end

  def reset
    @world = World.new(3, 3, 1)
    @state = :running
  end

  def draw
    @timer.update
    draw_rect(0, 0, screen_width, screen_height, Gosu::Color::BLACK)
    draw_rect(start_x, start_y, world_width, world_height, Gosu::Color::BLACK)
    draw_rect(hud_start_x, hud_start_y, hud_width, hud_height, Gosu::Color::WHITE)

    dark_gray = Gosu::Color.new(50, 50, 50)
    gray = Gosu::Color.new(127, 127, 127)
    light_gray = Gosu::Color.new(200, 200, 200)

    draw_text(25,25,"level #{@level+1}", large_font)


    if @world.next_level?
      draw_text(25,45,"you won!", large_font, Gosu::Color::GREEN)
    elsif @world.player.inventory.has_key?
      draw_text(25,45,"got key! try to find the blue space", large_font, Gosu::Color::RED)
    else
      draw_text(25,45,"key required before entering portal", large_font, Gosu::Color::BLACK)
      draw_text(25,65,"#{@timer.hours}:#{@timer.minutes}:#{@timer.seconds}", large_font)
    end

    (0...world.row_count).each do |row|
      (0...world.column_count).each do |col|
        x = start_x + (col * cell_size)
        y = start_y + (row * cell_size)

        if world.value_grid[[row, col]].character_present
          color = Gosu::Color::RED

          adjacent_spaces = world.find_adjacent_spaces(row, col)
          draw_rect(x + 2, y + 2, cell_size - 4, cell_size - 4, color)
        elsif world.value_grid[[row, col]].key && world.value_grid[[row,col]].visible
            color = Gosu::Color::YELLOW
            draw_rect(x + 2, y + 2, cell_size - 4, cell_size - 4, color)
        elsif world.value_grid[[row, col]].portal && world.value_grid[[row,col]].visible
            color = Gosu::Color::BLUE
            draw_rect(x + 2, y + 2, cell_size - 4, cell_size - 4, color)
        elsif world.value_grid[[row,col]].visible
          image = TILE_IMAGE
          if world.value_grid[[row, col]].lava
            image = LAVA_IMAGE
          end
          image.draw(x, y, 1)
        else
          color = dark_gray
        end
      end
    end

    case state
    when :lost
      draw_text_centered("game over", large_font)
    when :cleared
      draw_text_centered("cleared!", large_font)
    end
  end

  def cell_size
    max_cell_width = (screen_width * 0.90) / world.column_count
    max_cell_height = (screen_height * 0.90) / world.row_count

    if max_cell_width > max_cell_height
      max_cell_height
    else
      max_cell_width
    end
  end

  def world_width
    cell_size * world.column_count
  end

  def world_height
    cell_size * world.row_count
  end

  def hud_width
    world_width * 0.4
  end

  def hud_height
    world_height * 0.1
  end
  def start_x
    (screen_width - world_width) / 2.0
  end

  def start_y
    (screen_height - world_height) / 2.0
  end

  def hud_start_x
    20
  end

  def hud_start_y
    20
  end

  def needs_cursor?
    true
  end

  def draw_rect(x, y, width, height, color)
    draw_quad(x, y, color,
      x + width, y, color,
      x + width, y + height, color,
      x, y + height, color)
  end

  def draw_text(x, y, text, font, color = Gosu::Color::BLUE)
    font.draw(text, x, y, 1, 1, 1, color)
  end

  def draw_text_centered(text, font)
    x = (screen_width - font.text_width(text)) / 2
    y = (screen_height - font.height) / 2

    draw_text(x, y, text, font)

  end

  def within_world?(x, y)
    x >= start_x && x < (start_x + world_width) &&
      y >= start_y && y < (start_y + world_height)
  end

  def screen_coord_to_cell(x, y)
    col = ((x - start_x) / cell_size).to_i
    row = ((y - start_y) / cell_size).to_i

    [row, col]
  end

  def screen_width
    width
  end

  def screen_height
    height
  end

end

game = MazeCrawler.new
game.show
