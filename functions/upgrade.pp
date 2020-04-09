

function downtime::upgrade(String $to_version = 'latest') >> String {
  if downtime::in_window() {
    $to_version
  } else {
    'present'
  }
}
