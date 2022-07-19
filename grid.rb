# Project: Simple Game of Life automaton in ruby
# Author: Hugo V. Elías (c0d34fn@gmail.com)

require "./cell.rb"
require "byebug"

class Grid
  attr_reader :cells, :generation

  GRID_SIZE = 3

  def initialize(size: GRID_SIZE)
    @size = size
    @cells, @status = [], []
    @generation = 0

    build()
  end

  def iterate()
    @cells.each do |depth|
      depth.each do |row|
        row.each do |cell|
          # p status_for_neighbors(cell.position)
          # puts "#{cell.alive} -> #{cell.dead_or_alive(status_for_neighbors(cell.position))}"
          @status << { position: cell.position, alive: cell.dead_or_alive?(status_for_neighbors(cell.position)) }
        end
      end
    end

    @generation += 1
    update!
  end

  private
  # 3D map
  # [[[#<Cell:0x00007fdc5b9b9198 @alive=false, @position=[0, 0, 0]>, #<Cell:0x00007fdc5b9b8f18 @alive=true, @position=[0, 0, 1]>, #<Cell:0x00007fdc5b9b8cc0 @alive=false, @position=[0, 0, 2]>],
  #     [#<Cell:0x00007fdc5b9b8950 @alive=false, @position=[0, 1, 0]>, #<Cell:0x00007fdc5b9b86f8 @alive=true, @position=[0, 1, 1]>, #<Cell:0x00007fdc5b9b83d8 @alive=false, @position=[0, 1, 2]>],
  #       [#<Cell:0x00007fdc5b9b8108 @alive=false, @position=[0, 2, 0]>, #<Cell:0x00007fdc5b9b7e88 @alive=false, @position=[0, 2, 1]>, #<Cell:0x00007fdc5b9b7c30 @alive=true, @position=[0, 2, 2]>]],
  #
  #         [[#<Cell:0x00007fdc5b9b7668 @alive=true, @position=[1, 0, 0]>, #<Cell:0x00007fdc5b9b7398 @alive=false, @position=[1, 0, 1]>, #<Cell:0x00007fdc5b9b7140 @alive=false, @position=[1, 0, 2]>],
  #            [#<Cell:0x00007fdc5b9b6dd0 @alive=false, @position=[1, 1, 0]>, #<Cell:0x00007fdc5b9b6920 @alive=false, @position=[1, 1, 1]>, #<Cell:0x00007fdc5b9b66a0 @alive=false, @position=[1, 1, 2]>],
  #              [#<Cell:0x00007fdc5b9b6268 @alive=true, @position=[1, 2, 0]>, #<Cell:0x00007fdc5b9b60b0 @alive=false, @position=[1, 2, 1]>, #<Cell:0x00007fdc5b9b5e58 @alive=false, @position=[1, 2, 2]>]],
  #
  #                [[#<Cell:0x00007fdc5b9b58e0 @alive=true, @position=[2, 0, 0]>, #<Cell:0x00007fdc5b9b5548 @alive=true, @position=[2, 0, 1]>, #<Cell:0x00007fdc5b9b53e0 @alive=false, @position=[2, 0, 2]>],
  #                   [#<Cell:0x00007fdc5b9b51b0 @alive=true, @position=[2, 1, 0]>, #<Cell:0x00007fdc5b9b4ee0 @alive=true, @position=[2, 1, 1]>, #<Cell:0x00007fdc5b9b4e68 @alive=false, @position=[2, 1, 2]>],
  #                     [#<Cell:0x00007fdc5b9b4da0 @alive=true, @position=[2, 2, 0]>, #<Cell:0x00007fdc5b9b4cb0 @alive=false, @position=[2, 2, 1]>, #<Cell:0x00007fdc5b9b4c38 @alive=true, @position=[2, 2, 2]>]]]
  def status_for_neighbors(position)
    [
      [
        [sfn([position[0]-1, position[1]-1, position[2]-1]), sfn([position[0]-1, position[1]-1, position[2]]), sfn([position[0]-1, position[1]-1, position[2]+1])],
        [sfn([position[0]-1, position[1], position[2]-1]), sfn([position[0]-1, position[1], position[2]]), sfn([position[0]-1, position[1], position[2]+1])],
        [sfn([position[0]-1, position[1]+1, position[2]-1]), sfn([position[0]-1, position[1]+1, position[2]]), sfn([position[0]-1, position[1]+1, position[2]+1])]
      ],
      [
        [sfn([position[0], position[1]-1, position[2]-1]), sfn([position[0], position[1]-1, position[2]]), sfn([position[0], position[1]-1, position[2]+1])],
        [sfn([position[0], position[1], position[2]-1]), nil, sfn([position[0], position[1], position[2]+1])],
        [sfn([position[0], position[1]+1, position[2]-1]), sfn([position[0], position[1]+1, position[2]]), sfn([position[0], position[1]+1, position[2]+1])]
      ],
      [
        [sfn([position[0]+1, position[1]-1, position[2]-1]), sfn([position[0]+1, position[1]-1, position[2]]), sfn([position[0]+1, position[1]-1, position[2]+1])],
        [sfn([position[0]+1, position[1], position[2]-1]), sfn([position[0]+1, position[1], position[2]]), sfn([position[0]+1, position[1], position[2]+1])],
        [sfn([position[0]+1, position[1]+1, position[2]-1]), sfn([position[0]+1, position[1]+1, position[2]]), sfn([position[0]+1, position[1]+1, position[2]+1])]
      ]
    ]
  end

  def status_for_neighbor(position)
    cell = @cells.flatten.find { |cell| cell.position == position }
    return unless cell

    cell.alive
  end

  alias :sfn :status_for_neighbor

  def build()
    @size.times.each do |z|
      @cells << Array.new()
      @size.times.each do |y|
        @cells[z] << Array.new()
        @size.times.each do |x|
          @cells[z][y] << Cell.new(alive: ((rand() < 0.2) ? true : false), position: [z, y, x])
        end
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