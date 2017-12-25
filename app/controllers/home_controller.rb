class HomeController < ApplicationController
  def index

  end

  # アイドルくじを引く
  def draw
    @idol = Idol.get_idol
    smartContract = EthereumAPI.new()
    contract_result = smartContract.check_idol_issuance(@idol.id, current_user)

    if contract_result == true
      DrawIdol.create_from_idol!(@idol, current_user)
    else
      # TODO: idolの発行枚数が上限に達している場合
    end
  end

  def my_page
    @draw_idols = current_user.draw_idols
  end
end
