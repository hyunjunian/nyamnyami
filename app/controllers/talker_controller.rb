class TalkerController < ApplicationController
  def index
    @chats =Chat.all
  end
  
  
  def create
    Chat.create(chat_type: "user",chat_content: params[:ask])
    require 'nokogiri'
    require 'open-uri'
    
    if params[:ask].index("#")==0
      page = Nokogiri::HTML(open("http://calorie-app.com/?search="+URI.encode(params[:ask].delete "#")+"&language=ko"))
      cals = page.css('.main_calorie')
      cals2 = page.css('.result_text')
      bot = ""
      Chat.create(chat_type: "bot",chat_content: cals[0].text)
      if cals2!=nil
        cals2.each_with_index do |cal,x|
          bot << cal.text+"\n"
          
        end
        Chat.create(chat_type: "bot",chat_content: bot)
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
