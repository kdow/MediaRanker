class Work < ApplicationRecord
  def self.get_spotlight
    works = Work.all
    return works.sample
  end

  def self.get_top_ten(category)
    works = Work.where(category: category)
    return works.sample(10)
  end
end
