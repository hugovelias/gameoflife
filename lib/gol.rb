# Project: Simple Game of Life automaton in ruby
# Author: Hugo V. Elías (c0d34fn@gmail.com)

require "./lib/grid.rb"

class Gol
  GRID_SIZE = 16
  SPEED_LIMIT = 1

  def initialize(grid_size: GRID_SIZE, speed_limit: SPEED_LIMIT)
    grid = Grid.new(size: grid_size, speed: speed_limit)

    while(true)
      draw(grid)
      grid.iterate()
    end
  end

  def draw(grid)
    puts "Generation: #{grid.generation}, Speed: #{grid.speed} (lower is faster), Stop with CTRL+C\n"
    grid.cells.each do |row|
      graph = row.map {|item| item.alive == true ? "X" : " "}
      p graph
    end
  end
end
