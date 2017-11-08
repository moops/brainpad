class Workout
  include Mongoid::Document
  include Mongoid::Timestamps::Short

  field :loc, as: :location
  field :rc, as: :race
  field :dsc, as: :description
  field :tg, as: :tags
  field :dur, as: :duration, type: Integer
  field :int, as: :intensity, type: Float
  field :wt, as: :weight, type: Integer
  field :di, as: :distance, type: Float
  field :w_on, as: :workout_on, type: Date
  field :st, as: :strava_id

  belongs_to :person
  belongs_to :route, class_name: 'Lookup', optional: true

  validates :location, presence: true
  validates :duration, presence: true
  validates :workout_on, presence: true
  paginates_per 10
  INTENSITIES = [
    ['1 - brisk walk', 1], ['1.5', 1.5], ['2', 2], ['2.5', 2.5], ['3 - very light jog', 3],
    ['3.5', 3.5], ['4', 4], ['4.5', 4.5], ['5 - standard workout', 5], ['5.5', 5.5], ['6', 6],
    ['6.5', 6.5], ['7 - something hard', 7], ['7.5', 7.5], ['8 - what am i doing this for?', 8],
    ['8.5', 8.5], ['9 - blacking out', 9], ['9.5', 9.5], ['10 - heart\'s about to explode', 10]
  ].freeze

  def self.recent_workouts(user, days)
    user.workouts.where(:workout_on.gte => Time.zone.today - days)
  end

  def self.days_with_workouts?(user, days)
    user.workouts.and({ :workout_on.gte => Time.zone.today - days }, :workout_on.lt => Time.zone.today + 1)
        .distinct(:workout_on).count
  end

  def self.workout_duration_by_tag(user, days)
    report = {}
    total_duration = 0
    workouts = recent_workouts(user, days)
    workouts.each do |w|
      next unless w.tags
      total_duration += w.duration
      # TODO: individual tag not all tags
      tags_list = w.tags.split(' ')
      tags_list.each do |tag|
        if report.key?(tag)
          report[tag][:duration] += w.duration
        else
          report[tag] = { duration: w.duration }
        end
      end
    end
    report.each_value do |tag|
      tag[:percentage] = ((tag[:duration] / total_duration.to_f) * 100).to_i || 1
    end
    report.sort { |a, b| b[1][:duration] <=> a[1][:duration] }
  end

  def self.summary(user, days)
    workouts = Workout.recent_workouts(user, days)
    mileage = 0
    duration = 0
    max_weight = 0
    min_weight = 999
    workouts.each do |w|
      mileage += w.distance if w.distance
      duration += w.duration if w.duration
      max_weight = w.weight if w.weight && w.weight > max_weight
      min_weight = w.weight if w.weight && w.weight < min_weight
    end
    {
      weight_range: "#{min_weight}-#{max_weight}",
      workout_days: Workout.days_with_workouts?(user, days),
      mileage: (mileage * 10).ceil / 10.0, # tenths of kms
      duration: (duration / 60 * 10).ceil / 10.0 # minutes to tenths of hours
    }
  end

  def to_s
    "#{tags} #{distance} - #{location}"
  end
end
