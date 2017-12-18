class HomeController < ApplicationController
  def index

  end

  # アイドルくじを引く
  def draw
    @idol = Idol.get_idol
  end

  def my_idols

  end
end
