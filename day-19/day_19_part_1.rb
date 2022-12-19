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

def construction_choices(inventory, blueprint)
  choices = []
  choices << :ore if can_afford?(:ore, inventory, blueprint)
  choices << :clay if can_afford?(:clay, inventory, blueprint)
  choices << :obsidian if can_afford?(:obsidian, inventory, blueprint)
  choices << :geode if can_afford?(:geode, inventory, blueprint)

  choices << nil if choices.length < 4 && inventory[:ore] < 12

  choices
end

def collect_resources(robots, inventory)
  robots.each do |robot_type, quantity|
    inventory[robot_type] += quantity
  end
end

def solve(minutes_left, robots, inventory, blueprint, memoized_states)
  if memoized_states.include?({ minutes_left: minutes_left, robots: robots, inventory: inventory, blueprint: blueprint })
    return memoized_states[{ minutes_left: minutes_left, robots: robots, inventory: inventory, blueprint: blueprint }]
  end

  if minutes_left == 1
    collect_resources(robots, inventory)
    return inventory[:geode]
  end

  most_geodes = inventory[:geode]

  construction_choices(inventory, blueprint).each do |robot_type|
    inventory_fork = inventory.clone
    robots_fork = robots.clone
    deduct_cost(inventory_fork, blueprint.instance_variable_get("@#{robot_type}")) unless robot_type.nil?
    collect_resources(robots, inventory_fork)
    robots_fork[robot_type] += 1 unless robot_type.nil?

    resulting_geodes = solve(minutes_left - 1, robots_fork, inventory_fork, blueprint, memoized_states)
    most_geodes = resulting_geodes if resulting_geodes > most_geodes
  end

  memoized_states[{ minutes_left: minutes_left, robots: robots, inventory: inventory, blueprint: blueprint }] = most_geodes

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

# Takes about an hour to run.
# Could speed it up to some extent by running each blueprint solve on its own thread
# (up to our count of available CPU cores).

total_quality_level = 0
blueprints.each do |blueprint|
  geodes_cracked = solve(24, robots, inventory, blueprint, {})
  p "geodes_cracked: #{geodes_cracked} for blueprint #{blueprint.id}"
  total_quality_level += geodes_cracked * blueprint.id
end

p total_quality_level
