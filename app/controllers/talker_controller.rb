class TalkerController < ApplicationController
  def index
    @chats =Chat.all
  end
  
  
  def create
    require 'nokogiri'
    require 'open-uri'
    
    if params[:ask].index("#")==0
    page = Nokogiri::HTML(open("http://www.fatsecret.kr/%EC%B9%BC%EB%A1%9C%EB%A6%AC-%EC%98%81%EC%96%91%EC%86%8C/search?q="+URI.encode(params[:ask])))
    cals = page.css('.prominent')
    Chat.create(chat_type: "user",chat_content: params[:ask])
    postfix=["칼로리는 ","지방은 ","탄수화물은 ","단백질은 "]
    cals.each_with_index do |cal,x|
      break if x==1
      Chat.create(chat_type: "bot",chat_content: params[:ask]+"의")
      page2=Nokogiri::HTML(open("http://www.fatsecret.kr/%EC%B9%BC%EB%A1%9C%EB%A6%AC-%EC%98%81%EC%96%91%EC%86%8C"+URI.encode(cal['href'])))
      cals2=page2.css('.factValue')
      cals2.each_with_index do |cal2,i|
      Chat.create(chat_type: "bot",chat_content: postfix[i%4]+cal2.text+" ")
      end
      Chat.create(chat_type: "bot",chat_content: "입니다")
    end
    redirect_to :root
    else
    talk=Talk.where(ask: params[:ask]).sample
    
    unless talk.nil?
      Chat.create(chat_type: "user",chat_content: talk.ask)
      Chat.create(chat_type: "bot",chat_content: talk.answer)
      redirect_to :root
    else
      redirect_to '/learn'
    end
  end
  end
end
