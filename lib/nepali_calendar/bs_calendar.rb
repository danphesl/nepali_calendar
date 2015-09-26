module NepaliCalendar
  class BsCalendar < NepaliCalendar::Calendar
    
    MONTHNAMES = %w{nil Baisakh Jestha Ashad Shrawn Bhadra Ashwin Kartik Mangshir Poush Magh Falgun Chaitra}
    DAYNAMES = %w{nil Aitabar Sombar Mangalbar Budhbar Bihibar Sukrabar Sanibar}

    def self.ad_to_bs(year, month, day)
      fail 'Invalid date!' unless valid_date?(year, month, day)

      ref_day_eng = Date.parse(ref_date['ad_to_bs']['ad'])
      date_ad = Date.parse("#{year}/#{month}/#{day}")
      return unless date_in_range?(date_ad, ref_day_eng)

      days = total_days(date_ad, ref_day_eng)
      get_bs_date(days, ref_date['ad_to_bs']['bs'])
    end

    def self.get_bs_date(days, ref_day_nep)
      year, month, day = ref_day_nep.split('/').map(&:to_i)
      i = year
      j = month
      wday = 7

      while days != 0
        bs_month_days = NepaliCalendar::BS[i][j - 1]
        day += 1
        wday += 1

        if day > bs_month_days
          month += 1
          day = 1
          j += 1
        end

        wday = 1 if wday > 7

        if month > 12
          year += 1
          month = 1
        end

        if j > 12
          j  = 1
          i += 1
        end
        days -= 1
      end

      month_name = MONTHNAMES[month]
      wday_name = DAYNAMES[wday]
      {
        bs_year: "#{year}", bs_month: "#{format_initial(month)}",
        bs_day: "#{format_initial(day)}", bs_wday: "#{wday}",
        bs_month_name: "#{month_name}", bs_wday_name: "#{wday_name}"
      }
    end
  end
end