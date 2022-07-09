# Project: Simple Game of Life automaton in ruby
# Author: Hugo V. Elías (c0d34fn@gmail.com)

require "./cell.rb"

class Grid
  attr_reader :cells, :status

  def initialize(size: 16)
    @size = size
    @cells, @status = [], []

    self.build()
  end

  def iterate()
    @cells.each do |row|
      row.each do |cell|
        # p status_for_neighbors(cell.position)
        # puts "#{cell.alive} -> #{cell.dead_or_alive(status_for_neighbors(cell.position))}"
        @status << { position: cell.position, alive: cell.dead_or_alive?(status_for_neighbors(cell.position)) }
      end
    end

    update!
  end

  private
  # neighbouring map:
  # [[row - 1, col - 1],[row - 1, col],[row - 1, col + 1],
  # [row, col - 1], NULL, [row, col + 1],
  # [row + 1, col-1],[row + 1, col], [row + 1, col + 1]]
  def status_for_neighbors(position)
    [
      sfn([position[0]-1, position[1]-1]), sfn([position[0]-1, position[1]]), sfn([position[0]-1, position[1]+1]),
      sfn([position[0], position[1]-1]), nil, sfn([position[0], position[1]+1]),
      sfn([position[0]+1, position[1]-1]), sfn([position[0]+1, position[1]]), sfn([position[0]+1, position[1]+1])
    ]
  end

  def status_for_neighbor(position)
    cell = @cells.flatten.find { |cell| cell.position == position }
    return unless cell

    cell.alive
  end

  alias :sfn :status_for_neighbor

  def build()
    @size.times.each do |y|
      @cells << Array.new()
      @size.times.each do |x|
        alive = (rand() >= 0.5) ? true : false
        @cells[y] << Cell.new(alive: alive, position: [y, x])
      end
    end
  end

  def update!
    @status.each do |item|
      cell = @cells.flatten.find {|cell| cell.position == item[:position]}
      next unless cell

      cell.update!(item[:alive])
    end

    @status = []
  end
end