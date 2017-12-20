class Idol < ApplicationRecord
  # アイドルをランダムに1件返す
  def self.get_idol
    # TODO
    Idol.all.sample
  end
end
