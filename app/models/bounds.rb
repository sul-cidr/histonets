# frozen_string_literal: true

##
# A simple class for dealing with bounds in Ruby
class Bounds
  attr_accessor :x1, :x2, :y1, :y2

  def initialize(x1:, x2:, y1:, y2:)
    @x1 = x1
    @x2 = x2
    @y1 = y1
    @y2 = y2
  end

  ##
  # @param [Array[Array][Integer]] 2D array of bounds [[x1, y1], [x2, y2]]
  def self.from_array(bounds)
    new(x1: bounds[0][0], y1: bounds[0][1], x2: bounds[1][0], y2: bounds[1][1])
  end

  def ==(other)
    self.class == other.class && state == other.state
  end

  def to_xywh
    "#{x_min},#{y_min},#{width},#{height}"
  end

  def x_max
    [x1, x2].max
  end

  def x_min
    [x1, x2].min
  end

  def y_max
    [y1, y2].max
  end

  def y_min
    [y1, y2].min
  end

  def width
    x_max - x_min
  end

  def height
    y_max - y_min
  end

  protected

  def state
    [x1, x2, y1, y2]
  end
end
