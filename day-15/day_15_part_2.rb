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

def in_bounds(point)
  point.x >= 0 && point.x <= 4_000_000 && point.y >= 0 && point.y <= 4_000_000
end

def beacon_can_be_present_at?(point, sensors, beacons)
  return false unless in_bounds(point)

  sensors.each do |sensor|
    distance_to_point = manhattan_distance_between(point, sensor)
    return false if distance_to_point <= sensor.closest_beacon_distance && !beacons.find { |beacon| beacon.x == point.x && beacon.y == point.y }
  end

  true
end

def tuning_frequency(point)
  point.x * 4_000_000 + point.y
end

def scan_edge_of_sensor_range(scan_target, distance, dx, dy, sensors, beacons)
  distance.times do
    return tuning_frequency(scan_target) if beacon_can_be_present_at?(scan_target, sensors, beacons)

    scan_target.x += dx
    scan_target.y += dy
  end
  nil
end

def find_tuning_frequency(sensors, beacons)
  sensors.each do |sensor|
    distance_to_just_beyond_sensor_range = sensor.closest_beacon_distance + 1
    scan_target = Point.new(x: sensor.x, y: sensor.y - distance_to_just_beyond_sensor_range)

    [[1, 1], [-1, 1], [-1, -1], [1, -1]].each do |dx, dy|
      tuning_frequency = scan_edge_of_sensor_range(scan_target, distance_to_just_beyond_sensor_range, dx, dy, sensors, beacons)
      return tuning_frequency unless tuning_frequency.nil?
    end
  end
end

sensors, beacons = read_input
p find_tuning_frequency(sensors, beacons)
