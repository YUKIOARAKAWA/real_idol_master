class DrawIdol < ApplicationRecord
  belongs_to :user
  belongs_to :idol

  def self.create_from_idol!(idol, user)
    draw_idol = DrawIdol.new
    draw_idol.user_id = user.id
    draw_idol.idol_id = idol.id
    draw_idol.name = idol.name
    draw_idol.img_url = idol.img_url
    draw_idol.save!
    draw_idol
  end

end
