class Weight < ActiveRecord::Base
  belongs_to :user
  validate :fill_weight_gaps, :on => :create

  def bmi
    begin
      return ((avg_weight * 703) / (user.height**2)).round(2)
    rescue
      return 0
    end
  end

  def rmr
    begin
      return ((9.99 * (avg_weight/2.2)) + (6.25 * (user.height * 2.54)) - (4.92 * user.age) + 5).round(2)
    rescue
      return 0
    end
  end

  def tdee
    return (rmr * 1.2).round(2)
  end

  def fill_weight_gaps
    max_rec = Weight.where(:user_id => user_id).order('rec_date DESC').take()

    if max_rec == nil || max_rec.rec_type == RECTYPE['filler'] || (max_rec.rec_date - rec_date).abs == 1
      return
    end

    weight_diff = weight - max_rec.weight
    
    if bodyfat != nil && max_rec.bodyfat != nil
      bodyfat_diff = bodyfat - max_rec.bodyfat
    end

    days_between = (rec_date - max_rec.rec_date).to_i
    weight_per_day = (weight_diff / days_between).to_f
    bodyfat_per_day = (bodyfat_diff / days_between).to_f if bodyfat_diff != nil

    (1..(days_between-1)).each do |day|
      filler = Weight.new
      filler.user_id = user_id
      filler.rec_date = max_rec.rec_date + day
      filler.weight = max_rec.weight + (weight_per_day * day)
      filler.bodyfat = max_rec.bodyfat + (bodyfat_per_day * day) if bodyfat_diff != nil
      filler.rec_type = RECTYPE['filler']
      filler.save
      filler.calc_avg_weight
    end

  end

  def calc_avg_weight
    datapool = Weight.where("user_id = ? && rec_date <= ?", user_id, rec_date).order('rec_date DESC').limit(20)
    self[:avg_weight] = averageweight datapool
    save
  end

  private

  def averageweight(weights)
    total = 0

    return 0 if weight == nil || weights.length == 0

    weights.each do |weight|
      total += weight.weight
    end

    total = total / weights.length
    total = total * 100
    total = total.round()

    return total.to_f / 100;
  end


end
