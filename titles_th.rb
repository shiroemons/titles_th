class TitlesTh
  attr_accessor :errors

  def initialize
    @errors = nil
    if File.exist?('./musiccmt.txt') && File.exist?('./thbgm.fmt')
      @musiccmt = "musiccmt.txt"
      @content = File.read('./thbgm.fmt')
    elsif File.exist?('./musiccmt_tr.txt') && File.exist?('./thbgm_tr.fmt')
      @tr = "_tr"
      @musiccmt = "musiccmt_tr.txt"
      @content = File.read('./thbgm_tr.fmt')
    else
      @errors = []
      @errors << "musiccmt.txtまたは、musiccmt_tr.txtを配置してください" unless File.exist?('./musiccmt.txt') && File.exist?('./musiccmt_tr.txt')
      @errors << "thbgm.fmtまたは、thbgm_tr.fmtを配置してください" unless File.exist?('./thbgm.fmt') && File.exist?('./thbgm_tr.fmt')
    end
  end

  def titles
    bgm_titles = {}
    File.foreach("./#{@musiccmt}", encoding: 'cp932:utf-8') do |line|
      if line.start_with?('@bgm')
        @bgm_file_name = line.gsub('@bgm/', '').strip
      end
      bgm_titles[@bgm_file_name] = line.gsub('♪', '').strip if line.start_with?('♪')
    end
    bgm_titles["th128_08"] = "プレイヤーズスコア"
    bgm_titles
  end

  def thbgm_fmt
    records = []
    bgm_file_names = @content.scrub('').scan(/th\d{1,3}_\d{1,2}/)

    contents = @content.chars.map { |c| c.unpack("h*")[0].scan(/.{1,2}/) }.flatten
    contents.each_with_index do |c, i|
      if c == "t".unpack("h*")[0]
        start_byte = ''
        (i+16).upto(i+19) do |index|
          start_byte << contents[index]
        end

        intro_byte = ''
        (i+24).upto(i+27) do |index|
          intro_byte << contents[index]
        end

        start_byte_hex = start_byte.reverse.upcase
        intro_byte_hex = intro_byte.reverse.upcase
        records << [start_byte_hex, intro_byte_hex]
      end
    end

    records.each_with_index do |record, i|
      loop_byte_hex = 
        if i == records.size - 1
          "004A2FF8"
        else
          (records[i+1][0].hex - record[1].hex - record[0].hex).to_s(16).upcase.rjust(8, '0')
        end
      record.push(loop_byte_hex)
    end

    bgm_file_names.zip(records).to_h
  end

  def export
    File.open("titles_th#{@tr}.txt", "w") do |file|
      thbgm_fmt.keys.each do |bgm_title|
        title = titles[bgm_title]
        record = thbgm_fmt[bgm_title]
        file <<  "#{record[0]},#{record[1]},#{record[2]},#{title}\n"
      end
    end
    puts "Exported: titles_th#{@tr}.txt"
  end
end

titles_th = TitlesTh.new
if titles_th.errors
  titles_th.errors.each do |error|
    puts error
  end
else
  titles_th.export
end
