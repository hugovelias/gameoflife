# Project: Simple Game of Life automaton in ruby
# Author: Hugo V. Elías (c0d34fn@gmail.com)

class Cell
  MIN_NEIGHBOURS_TO_BE_ALIVE = 2
  MAX_NEIGHBOURS_TO_BE_ALIVE = 3

  attr_reader :alive, :position

  def initialize(alive: false, position:[])
    @alive = alive
    @position = position
  end

  # Rules (https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life):
  # Any live cell with two or three live neighbours survives.
  # Any dead cell with three live neighbours becomes a live cell.
  # All other live cells die in the next generation. Similarly, all other dead cells stay dead.
  def dead_or_alive?(status_for_neighbors = [])
    neighbors_alive = status_for_neighbors.select {|status| status == true}.count

    if @alive && (neighbors_alive >= MIN_NEIGHBOURS_TO_BE_ALIVE && neighbors_alive <= MAX_NEIGHBOURS_TO_BE_ALIVE)
      true
    elsif !@alive && neighbors_alive == MAX_NEIGHBOURS_TO_BE_ALIVE
      true
    else
      false
    end
  end

  def update!(alive)
    @alive = alive
  end
end