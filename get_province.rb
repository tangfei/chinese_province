require 'nokogiri'
require 'rest-client'
require 'csv'

url = 'http://www.mca.gov.cn/article/sj/xzqh/2020/2020/202003301019.html'
doc = Nokogiri.HTML(RestClient.get(url))
CSV.open("#{Dir.pwd}/chinese_province.csv", "wb") do |csv|
  csv << ['行政区划代码', '省', '市', '区' ]
  province = ''
  city = ''
  doc.search('tr').each do |doc_tr|
    doc_td_array = []
    doc_tr.search('td.xl7130721','td.xl7030721').each do |doc_td|
      if doc_td.inner_text != ''
        doc_td_array << doc_td.inner_text
      end
    end
    if doc_td_array.length > 0
      province = doc_td_array[1] if doc_td_array[0].to_i % 10000 == 0
      city = doc_td_array[1] if doc_td_array[0].to_i % 10000 != 0 && doc_td_array[0].to_i % 100 == 0
      if doc_td_array[0].to_i % 10000 == 0
        csv << [doc_td_array[0], province]
      elsif ['北京市','天津市', '上海市','重庆市'].include?(province)
        csv << [doc_td_array[0], province, province, doc_td_array[1].gsub(/\s+/,'')]
      else
        csv << [doc_td_array[0], province, city, doc_td_array[1].gsub(/\s+/,'')]
      end
    end
  end
end