# frozen_string_literal: true

# Station Class
class Station
  include InstanceCounter
  include Validation

  attr_accessor :trains, :stations
  attr_reader :name

  validate :name, :presence
  validate :station, :type, Station
  
  # rubocop:disable Style/ClassVars
  @@stations = []
  # rubocop:enable Style/ClassVars

  def initialize(name)
    @name = name
    @trains = []
    @@stations << self
    register_instance(self.class)
    
    valid?
  end
  
  def self.all
    @@stations
  end

  def add_train(train)
    trains << train
  end

  def delete_train(train)
    @trains = @trains.reject { |item| item.number == train.number }
    @trains
  end

  def all_trains_by_type(type)
    trains.filter { |train| train.type == type }
  end

  def type_count(type)
    train_by_type(type).size
  end

  def show_trains_on_station
    @trains.each(&block)
  end

end
