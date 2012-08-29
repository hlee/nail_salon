class Korea < ActiveRecord::Base
  attr_accessible :address, :city, :description, :email, :fax, :level, :phone_num, :state, :street, :title, :website, :zipcode, :uuid
  PAGE = 22# est 22 hea 76
  class << self
    def grasp 
      require 'open-uri'
      code_list = Korea.pluck :uuid
      PAGE.times.each do |page|
        doc = retryable(tries: 3) do 
          Nokogiri::HTML(open('http://ny.koreaportal.com/yp/yp_list.php?mcode=est&page=' + (page + 1).to_s))
        end
        doc.css("table[width='545']").each do |order| 
          unique_code = order.parent.parent.parent.css('td.yp_title a').attr('href').value[/\d+/]
          unless code_list.include? unique_code
            #order.parent.parent.parent.css('td.yp_text')[1].text
            email =       order.parent.parent.parent.css('td.yp_gray_sm a').first.attr('href') rescue ''
            website =     order.parent.parent.parent.css('td.yp_gray_sm a').last.attr('href') rescue ''
            flag =  order.parent.parent.parent.css('img').attr('src').value[/[?=_][^_]*$/]
            Korea.create(
              uuid:        unique_code,
              title:       order.parent.parent.parent.css('td.yp_title a').text.delete(" "),
              address:     order.parent.parent.parent.css('td.yp_text')[1].text,
              phone_num:   order.parent.parent.parent.css('td.yp_text')[2].text,
              email:       email,
              website:     website,
              level:       flag == '_premium.gif' ? 'premium' : 'general',
              zipcode:     order.parent.parent.parent.css('td.yp_text')[1].text[/\d+$/],
              description: order.parent.parent.parent.css("td[style='padding-bottom:5px;padding-left:15px;color:#339933']").text.delete("\"\r\n"),
              state:       'estate',
              fax:         order.parent.parent.parent.css('td.yp_text')[3].text
            )
          end
        end
      end
    end

    def retryable(options = {}, &block)
      opts = { :tries => 2, :on => Exception }.merge(options)

      retry_exception, retries = opts[:on], opts[:tries]

      begin
        return yield
      rescue retry_exception
        retry if (retries -= 1) > 0
      end

      yield
    end

    def export
      File.open('ny_nail.txt', 'w'){|f| Korea.all.each{|n| f.puts "#{n.state}|#{n.title}|#{n.address}|#{n.phone_num}|#{n.website}|#{n.email}|#{n.level}|#{n.description}"}} 
    end

  end
end
