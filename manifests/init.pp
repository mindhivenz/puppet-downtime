class downtime (
  Boolean $restricted = false,
  Struct[{
    start_time          => Pattern[/[012]?\d:\d\d/],
    Optional[week_days] => Array[Enum['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']],
    Optional[hours]     => Variant[Float, Integer],
  }] $window          = { start_time => '3:00' },
) {

  include timezone

  if $restricted {
    if $timezone::timezone == 'Etc/UTC' {
      fail('You need to specify timezone::timezone to restrict downtime')
    } elsif $facts['timezone'] == 'UTC' {
      warning(
        'Reported timezone is UTC, assuming timezone not applied to facts yet but will be next run, will report as outside window'
      )
    }
    if !$timezone::autoupgrade {
      notice('Suggest set timezone::autoupgrade to keep timezone data up to date')
    }
  }

}
