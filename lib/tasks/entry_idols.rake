namespace :idols do
  desc '初期データ用のアイドルを登録する'
  task :entry_idols => :environment do
    # TODO
    idol = Idol.new(
          name: '広瀬すず',
          img_url: '/idols/hirose_suzu.jpg',
          max_issuance: 10
        )
    idol.save

    idol = Idol.new(
          name: '川口春奈',
          img_url: '/idols/kawaguti_haruna.jpg',
          max_issuance: 3
        )
    idol.save
  end
end
