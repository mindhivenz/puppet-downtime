function downtime::in_window () >> Boolean {

  include downtime

  if !$downtime::restricted {
    debug('Not restricted')
    true
  } elsif $facts['timezone'] == 'UTC' {
    debug('Timezone is UTC, reporting as not in window until facts represent requested timezone')
    false
  } else {
    $tz = $facts['timezone']
    $window = $downtime::window

    $now = Timestamp(time())

    notice('Now', $now)

    $today_date = $now.strftime('%F', $tz)
    $hours = if 'hours' in $window {
      $window['hours']
    } else {
      1.1  # Ensure run twice each window
    }
    $week_days = if 'week_days' in $window {
      $window['week_days']
    } else {
      ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
    }
    $duration = Timespan($hours * 60 * 60)
    $today_start = Timestamp.new("${today_date} ${$window['start_time']}", '%F %k:%M', $tz)
    $today_end = $today_start + $duration
    $today_week_day = $today_start.strftime('%A', $tz)

    debug('Today', $today_week_day, $today_start, $today_end)

    if $today_start <= $now and $today_end > $now and $today_week_day in $week_days {
      true
    } else {
      $today_begin = Timestamp.new($today_date, '%F', $tz)
      $yesterday_date = ($today_begin - 1).strftime('%F', $tz)
      $yesterday_start = Timestamp.new("${yesterday_date} ${$window['start_time']}", '%F %k:%M', $tz)
      $yesterday_end = $yesterday_start + $duration
      $yesterday_week_day = $yesterday_start.strftime('%A', $tz)

      debug('Yesterday', $yesterday_week_day, $yesterday_start, $yesterday_end)

      $yesterday_start <= $now and $yesterday_end > $now and $yesterday_week_day in $week_days
    }
  }

}
