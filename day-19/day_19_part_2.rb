require 'date'

class Blueprint
  attr_accessor :id, :ore, :clay, :obsidian, :geode
end

def read_blueprint_line(line)
  tokenized_line = line.split.map(&:to_i)
  blueprint = Blueprint.new
  blueprint.id = tokenized_line[1]
  blueprint.ore = { ore: tokenized_line[6] }
  blueprint.clay = { ore: tokenized_line[12] }
  blueprint.obsidian = { ore: tokenized_line[18], clay: tokenized_line[21] }
  blueprint.geode = { ore: tokenized_line[27], obsidian: tokenized_line[30] }
  blueprint
end

def read_blueprints
  blueprints = []

  File.foreach('input.txt', chomp: true) do |line|
    blueprints << read_blueprint_line(line)
  end

  blueprints
end

def deduct_cost(inventory, cost)
  inventory.merge!(cost) { |_k, v1, v2| v1 - v2 }
end

def can_afford?(robot_type, inventory, blueprint)
  blueprint.instance_variable_get("@#{robot_type}").each do |resource, amount|
    return false if inventory[resource] < amount
  end
  true
end

def construction_choices(inventory, blueprint, robots, minutes_left)
  return [:geode] if can_afford?(:geode, inventory, blueprint)

  choices = []
  choices << :ore if can_afford?(:ore, inventory, blueprint) && minutes_left >= 3 && robots[:ore] < 4
  choices << :clay if can_afford?(:clay, inventory, blueprint) && minutes_left >= 4 && robots[:clay] < blueprint.obsidian[:clay]
  choices << :obsidian if can_afford?(:obsidian, inventory, blueprint) && minutes_left >= 3 && robots[:obsidian] < blueprint.geode[:obsidian]
  choices << nil

  choices
end

def collect_resources(robots, inventory)
  robots.each do |robot_type, quantity|
    inventory[robot_type] += quantity
  end
end

def solve(minutes_left, robots, inventory, blueprint, memoized_states)
  if memoized_states.include?({ minutes_left: minutes_left, robots: robots, inventory: inventory })
    return memoized_states[{ minutes_left: minutes_left, robots: robots, inventory: inventory }]
  end

  if minutes_left == 1
    collect_resources(robots, inventory)
    return inventory[:geode]
  end

  most_geodes = inventory[:geode]

  construction_choices(inventory, blueprint, robots, minutes_left).each do |robot_type|
    inventory_fork = inventory.clone
    robots_fork = robots.clone
    deduct_cost(inventory_fork, blueprint.instance_variable_get("@#{robot_type}")) unless robot_type.nil?
    collect_resources(robots, inventory_fork)
    robots_fork[robot_type] += 1 unless robot_type.nil?
    resulting_geodes = solve(minutes_left - 1, robots_fork, inventory_fork, blueprint, memoized_states)
    most_geodes = resulting_geodes if resulting_geodes > most_geodes
  end

  memoized_states[{ minutes_left: minutes_left, robots: robots, inventory: inventory }] = most_geodes

  most_geodes
end

inventory = {
  ore: 0,
  clay: 0,
  obsidian: 0,
  geode: 0
}

robots = {
  ore: 1,
  clay: 0,
  obsidian: 0,
  geode: 0
}

blueprints = read_blueprints

# This takes just under an hour to run and produce the correct answer with my input on my 2019 Macbook.
#
# Things I could do to potentially further speed it up:
#
# - Identify states that can't possibly catch up to the best state found so far (in terms of final
#   # of geodes cracked), and discontinue processing them.
#
# - Run each blueprint on a separate thread. (Today I learned that the default C-based Ruby runtime doesn't
#   take advantage of multiple CPU cores for multiple threads! I could convert this implementation to a
#   different language; or use a different Ruby interpreter/runtime such as JRuby.)
#
# - Try to further tighten down the set of returned next-robot-to-build options in the construction_choices
#   method.
#
# - Try to expand the existing memoization to also discontinue evaluation of states that are "strictly worse"
#   than a memoized state. (I'm not sure if a significant count of such states exist, though; and/or if there
#   would be a time-efficient way to search for them among the collection of memoized states).

geodes_cracked = []
blueprints[0..2].each do |blueprint|
  p "Started solve for blueprint #{blueprint.id} at: #{DateTime.now.strftime '%d/%m/%Y %H:%M'}"
  geodes_cracked << solve(32, robots, inventory, blueprint, {})
  p "#{DateTime.now.strftime '%d/%m/%Y %H:%M'} geodes_cracked: #{geodes_cracked.last} for blueprint #{blueprint.id}"
end

p geodes_cracked.reduce(&:*)
