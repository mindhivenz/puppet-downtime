class downtime (
  Variant[
    Enum[always, never],
    Struct[{
      start_time          => Pattern[/[012]?\d:\d\d/],
      Optional[week_days] => Array[Enum[monday, tuesday, wednesday, thursday, friday, saturday, sunday]],
      Optional[hours]     => Variant[Float, Integer],
    }]
  ] $when = always,
) {

  include timezone

  $is_downtime = case $when {
    always: { true }
    never: { false }
    default: {
      if !$timezone::autoupgrade {
        notice('Suggest set timezone::autoupgrade to keep timezone data up to date')
      }
      $tz = $facts['timezone']
      if $timezone::timezone == 'Etc/UTC' {
        fail('You need to specify timezone::timezone to restrict downtime')
      } elsif $tz == 'UTC' {
        warning(
          'Reported timezone is UTC, assuming timezone being applied this run and not in facts yet, treating as not downtime'
        )
        false
      } else {
        $now = Timestamp(time())
        debug('Now', $now)

        $today_date = $now.strftime('%F', $tz)
        $hours = if 'hours' in $when {
          $when['hours']
        } else {
          1.1  # Ensure run twice each window
        }
        $week_days = if 'week_days' in $when {
          $when['week_days']
        } else {
          [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        }
        $duration = Timespan($hours * 60 * 60)
        $today_start = Timestamp.new("${today_date} ${$when['start_time']}", '%F %k:%M', $tz)
        $today_end = $today_start + $duration
        $today_week_day = $today_start.strftime('%A', $tz).downcase
        debug('Today', $today_week_day, $today_start, $today_end)

        if $today_start <= $now and $today_end > $now and $today_week_day in $week_days {
          true
        } else {
          $today_begin = Timestamp.new($today_date, '%F', $tz)
          $yesterday_date = ($today_begin - 1).strftime('%F', $tz)
          $yesterday_start = Timestamp.new("${yesterday_date} ${$when['start_time']}", '%F %k:%M', $tz)
          $yesterday_end = $yesterday_start + $duration
          $yesterday_week_day = $yesterday_start.strftime('%A', $tz).downcase
          debug('Yesterday', $yesterday_week_day, $yesterday_start, $yesterday_end)

          $yesterday_start <= $now and $yesterday_end > $now and $yesterday_week_day in $week_days
        }
      }
    }
  }

}
