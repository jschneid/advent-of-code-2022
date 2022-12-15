class Point
  attr_accessor :x, :y

  def initialize(x:, y:)
    @x = x
    @y = y
  end
end

class Sensor
  attr_accessor :point, :closest_beacon

  def initialize(x:, y:, closest_beacon:)
    @point = Point.new(x: x, y: y)
    @closest_beacon = closest_beacon
  end

  def x
    @point.x
  end

  def y
    @point.y
  end

  def closest_beacon_distance
    manhattan_distance_between(@point, @closest_beacon)
  end
end

def read_input
  sensors = []
  beacons = []

  File.foreach('input.txt') do |line|
    tokenized_line = line.split

    beacon_x = tokenized_line[8][2..-2].to_i
    beacon_y = tokenized_line[9][2..].to_i

    beacon = beacons.find { |beacon| beacon.x == beacon_x && beacon.y == beacon_y }
    if beacon.nil?
      beacon = Point.new(x: beacon_x, y: beacon_y) if beacon.nil?
      beacons << beacon
    end

    sensors << Sensor.new(
      x: tokenized_line[2][2..-2].to_i,
      y: tokenized_line[3][2..-2].to_i,
      closest_beacon: beacon
    )
  end

  [sensors, beacons]
end

def manhattan_distance_between(point1, point2)
  (point1.x - point2.x).abs + (point1.y - point2.y).abs
end

def beacon_can_be_present_at?(point, sensors, beacons)
  return true if beacons.find { |beacon| beacon.x == point.x && beacon.y == point.y }

  sensors.each do |sensor|
    distance_to_point = manhattan_distance_between(point, sensor)
    return false if distance_to_point <= sensor.closest_beacon_distance
  end
  true
end

sensors, beacons = read_input

positions_that_cannot_contain_a_beacon = 0
(-5_000_000..5_000_000).each do |x|
  positions_that_cannot_contain_a_beacon += 1 unless beacon_can_be_present_at?(Point.new(x: x, y: 2_000_000), sensors, beacons)
end

p positions_that_cannot_contain_a_beacon
