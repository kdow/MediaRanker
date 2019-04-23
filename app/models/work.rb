class Work < ApplicationRecord
  def self.get_spotlight
    works = Work.all
    return works.sample
  end

  def get_top_ten
    return self.sample(10)
  end
end
