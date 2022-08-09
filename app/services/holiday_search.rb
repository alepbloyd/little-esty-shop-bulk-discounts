class HolidaySearch

  def holiday_information
    @_holiday_information ||= service.upcoming_us_holidays.map do |data|
      UpcomingHoliday.new(data)
    end
  end

  def holiday(soonness_index)
    holiday_information[soonness_index]
  end

  def holiday_count
    holiday_information.count
  end

  def service
    HolidayCalendarService.new
  end

end