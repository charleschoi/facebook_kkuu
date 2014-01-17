class HomeController < ApplicationController
  def index
  end

  def analyze
    #페이스북 엑세스 토큰이 없을 경우 화면 보여주지 않기
    return if params[:code].nil?

    #페이스북 앱 설정
    app_id = "523945371055601"
    app_secret = "8c3f4560ac9a92c6c1f2e5d343976baa"
    callback_url = "http://jk1804.com/home/analyze"

    #페이스북 연동
    oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    access_token = oauth.get_access_token(params[:code])

    #페이스북 feed 긁어오기
    graph = Koala::Facebook::API.new(access_token)
    feed = graph.get_connections("me", "feed")

    #포스트와 코멘트를 담을 배열 선언
    @kk_total_count = 0
    @uu_total_count = 0

    #최고의 순간을 담을 해쉬 선언
    @top_kk = {count: 0, id: 0, message: ""}
    @top_uu = {count: 0, id: 0, message: ""}
    @top_kkuu = {count: 0, id: 0, message: ""}

    #feed가 없을때까지 다음 feed를 모두 검색하여 포스트 내용과 코멘트 내용을 배열에 넣기
    while !feed.nil?
      feed.each do |f|
        kk_count = 0
        uu_count = 0
        kkuu_count = 0
        kk_count = f["message"].scan(/ㅋ|ㅎ/).count unless f["message"].nil?
        uu_count = f["message"].scan(/ㅠ|ㅜ/).count unless f["message"].nil?
        kkuu_count = f["message"].scan(/ㅋ|ㅎ|ㅠ|ㅜ/).count unless f["message"].nil?
        @top_kk = {:count => kk_count, :id => f["id"], :message => f["message"]} if @top_kk[:count] < kk_count
        @top_uu = {:count => uu_count, :id => f["id"], :message => f["message"]} if @top_uu[:count] < uu_count
        @top_kkuu = {:count => kkuu_count, :id => f["id"], :message => f["message"]} if @top_kkuu[:count]/((@top_kk[:count] - @top_uu[:count]).abs + 1) < kkuu_count/((kk_count - uu_count).abs + 1)
        @kk_total_count += kk_count
        @uu_total_count += uu_count
        unless f["comments"].nil?
          f["comments"]["data"].each do |c|
            kk_count = c["message"].scan(/ㅋ|ㅎ/).count unless c["message"].nil?
            uu_count = c["message"].scan(/ㅠ|ㅜ/).count unless c["message"].nil?
            @top_kk = {:count => kk_count, :id => f["id"], :message => c["message"]} if @top_kk[:count] < kk_count
            @top_uu = {:count => uu_count, :id => f["id"], :message => c["message"]} if @top_uu[:count] < uu_count
            @top_kkuu = {:count => kkuu_count, :id => f["id"], :message => f["message"]} if @top_kkuu[:count]/((@top_kk[:count] - @top_uu[:count]).abs + 1) < kkuu_count/((kk_count - uu_count + 1).abs + 1)
            @kk_total_count += kk_count
            @uu_total_count += uu_count
          end
        end
      end
      feed = feed.next_page
    end
  end
end
