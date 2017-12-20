class HomeController < ApplicationController
  def index

  end

  # アイドルくじを引く
  def draw
    @idol = Idol.get_idol
    DrawIdol.create_from_idol!(@idol, current_user)
  end

  def my_page
    @draw_idols = current_user.draw_idols
  end
end
