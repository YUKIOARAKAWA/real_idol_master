class Idol < ApplicationRecord
  def self.get_idol
    # TODO
    Idol.all.sample
  end
end
