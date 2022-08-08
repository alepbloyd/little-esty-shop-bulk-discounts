class HolidaySearch

  def holiday_information
    @_holiday_information ||= service.upcoming_us_holidays.map do |data|
      UpcomingHoliday.new(data)
    end
  end

  def next_holiday_one
    holiday_information[0]
  end

  def next_holiday_two
    holiday_information[1]
  end

  def next_holiday_three
    holiday_information[2]
  end
  
  def service
    HolidayCalendarService.new
  end

end