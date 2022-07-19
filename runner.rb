# Project: Simple Game of Life automaton in ruby
# Author: Hugo V. Elías (c0d34fn@gmail.com)

require "./grid.rb"

class Runner
  SLEEP_TIME = 1

  def initialize(grid_size: nil, sleep_time: SLEEP_TIME)
    @grid = Grid.new(size: grid_size)

    while(true)
      draw()
      @grid.iterate()
      sleep(sleep_time)
    end
  end

  private

  def draw()
    puts "Generation: #{@grid.generation}, Speed: #{SLEEP_TIME} (lower is faster), Stop with CTRL+C\n"

    @grid.cells.each do |depth|
      depth.each do |row|
        graph = row.map {|item| item.alive == true ? "X" : " "}
        p graph
      end
    end
  end
end