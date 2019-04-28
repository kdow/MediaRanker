class Work < ApplicationRecord
  has_many :votes

  validates :title, presence: true

  def self.get_spotlight
    works = Work.all
    return works.max_by { |work| work.votes.count }
  end

  def self.get_top_ten(category)
    works = Work.where(category: category)
    return works.sample(10)
  end

  def self.sorted_works(category)
    works = Work.where(category: category)
    works_sorted = works.sort_by { |work| work.votes.count }
    return works_sorted.reverse
  end
end
