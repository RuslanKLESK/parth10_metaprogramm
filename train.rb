# frozen_string_literal: true

# Train Class
class Train
  include CompanyName
  include InstanceCounter
  include Validation
  
  TRAIN_NUM = /^[а-Яa-z\d]{3}-?[а-Яa-z\d]{2}$/i.freeze

  attr_accessor :current_speed, :carriages, :number
  attr_reader :type

  # rubocop:disable Style/ClassVars
  @@trains = {}
  # rubocop:enable Style/ClassVars   

  def initialize(number, type)
    @number = number
    @type = type
    @current_speed = 0
    @carriages = []
    @@trains[number] = self
    register_instance(self.class)
    exceptions!
  end

  def self.find(number)
    @@trains[number]
  end

  def current_speed     # Может возвращать текущую скорость
    @current_speed
  end

  def speed_up(number)  # Может набирать скорость
    @current_speed += number
  end

  def brake             # Может тормозить до 0.
    @current_speed = 0
  end

  def add_carriage(carriage)   
    self.carriages << carriage if type == carriage.type && current_speed.zero?
  end

  def delete_carriage(carriage)
    if current_speed.zero?
      self.carriages = carriages.reject {|item| item.number == carriage.number}
    end
    carriages
  end

  def train_add_route(route)
    route.set_train(self)
  end

  def change_to_next_station(route)
    route.change_station(self, 'next')
  end

  def change_to_prew_station(route)
    route.change_station(self, 'prew')
  end

  def show_current_prew_next_stations(route)
    route.stations_near(self)
  end

  def move_next_station
    if next_station != nil
      self.station = next_station unless next_station
    end
  end

  def move_previous_station
    if self.station != self.route.stations.first
      self.station = previous_station unless previous_station
    end
  end

  def show_carriage_in_train(&block)
    @carriages.each do |carriage|
      yield(carriage)
    end
  end

end