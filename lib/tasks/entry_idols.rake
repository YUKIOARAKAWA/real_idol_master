namespace :idols do
  desc '初期データ用のアイドルを登録する'
  task :entry_idols => :environment do

    # 既存データを削除
    DrawIdol.delete_all
    Idol.delete_all

    entry_idols.each do |idol|
      Idol.create(
            name: idol[0],
            img_url: idol[1],
            max_issuance: idol[2]
          )
    end
  end

  def entry_idols
    [
      ['広瀬すず', '/idols/hirose_suzu.jpg', 10],
      ['川口春奈', '/idols/kawaguti_haruna.jpg', 3],
      ['小松菜奈', '/idols/komatsu_nana.jpg', 7],
      ['新垣結衣', '/idols/aragaki_yui.jpg', 10],
      ['有村架純', '/idols/arimura_kasumi.jpg', 8],
      ['本田翼', '/idols/honda_tsubasa.jpg', 10],
      ['桐谷美玲', '/idols/kiritani_mirei.jpg', 10]
    ]
  end

end
