class HomeController < ApplicationController
  def index
    #페이스북 엑세스 토큰이 없을 경우 화면 보여주지 않기
    return if params[:code].nil?

    #페이스북 앱 설정
    app_id = "523945371055601"
    app_secret = "8c3f4560ac9a92c6c1f2e5d343976baa"
    callback_url = "http://jk1804.com/home/index"

    #페이스북 연동
    @oauth = Koala::Facebook::OAuth.new(app_id, app_secret, callback_url)
    access_token = @oauth.get_access_token(params[:code])

    #페이스북 feed 긁어오기
    @graph = Koala::Facebook::API.new(access_token)
    feed = @graph.get_connections("me", "feed")

    #포스트와 코멘트를 담을 배열 선언
    @messages = Array.new
    @comments = Array.new
    @kk_cnt = 0
    @uu_cnt = 0

    #feed가 없을때까지 다음 feed를 모두 검색하여 포스트 내용과 코멘트 내용을 배열에 넣기
    while !feed.nil?
      feed.each do |f|
        @messages << f["message"] if !f["message"].nil?
        if !f["comments"].nil?
          f["comments"]["data"].each do |c|
           @comments << c["message"] if !c["message"].nil?
          end
        end
      end
      feed = feed.next_page
    end
    @messages.each do |m|
      @kk_cnt += m.scan(/ㅋ|ㅎ/).count
    end
    @comments.each do |c|
      @kk_cnt += c.scan(/ㅋ|ㅎ/).count
    end
    @messages.each do |m|
      @kk_cnt += m.scan(/ㅜ|ㅠ/).count
    end
    @comments.each do |c|
      @kk_cnt += c.scan(/ㅜ|ㅠ/).count
    end

  end

  def laugh
  end

  def sorrow
  end
end
