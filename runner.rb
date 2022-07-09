# Project: Simple Game of Life automaton in ruby
# Author: Hugo V. Elías (c0d34fn@gmail.com)

require "./grid.rb"

class Runner
  GRID_SIZE = 16
  SLEEP_TIME = 1

  def initialize(grid_size: GRID_SIZE, sleep_time: SLEEP_TIME)
    @grid = Grid.new(size: grid_size)
    @generation = 0

    while(true)
      @generation += 1
      draw()
      @grid.iterate()
      sleep(sleep_time)
    end
  end

  def draw()
    puts "Generation: #{@generation}, Speed: #{SLEEP_TIME} (lower is faster), Stop with CTRL+C\n"
    @grid.cells.each do |row|
      graph = row.map {|item| item.alive == true ? "X" : " "}
      p graph
    end
  end
end