class Work < ApplicationRecord
  has_many :votes

  validates :title, presence: true

  def self.get_spotlight
    works = Work.all
    return works.max_by { |work| work.votes.count }
  end

  def self.get_top_ten(category)
    return self.sorted_works(category)[0...10]
  end

  def self.sorted_works(category)
    works = Work.where(category: category)
    works_sorted = works.sort_by { |work| -work.votes.count }
    return works_sorted
  end
end
