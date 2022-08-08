class UpcomingHoliday

  attr_reader :date,
              :name

  def initialize(data)
    @date = data[:date]
    if data[:localName] == "Columbus Day"
      @name = "Indigenous Peoples' Day"
    else
      @name = data[:localName]
    end
  end

end