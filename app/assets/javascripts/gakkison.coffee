window.is_active = false
window.dateDiff = 0

window.jsont = (data) ->
  console.log data
  nowDate = Date.now()
  window.dateDiff = ((data.st * 1000) + ((nowDate - (data.it * 1000)) / 2)) - nowDate
  console.log window.dateDiff
  init()

exactTime = () ->
  serverList = [
    'https://ntp-a1.nict.go.jp/cgi-bin/jsont',
    'http://ntp-a1.nict.go.jp/cgi-bin/jsont',
    'https://ntp-b1.nict.go.jp/cgi-bin/jsont',
    'http://ntp-b1.nict.go.jp/cgi-bin/jsont'
  ];
  scriptE = document.createElement('script')
  serverUrl = serverList[Math.floor(Math.random() * serverList.length)]
  scriptE.src = serverUrl + '?' + (Date.now() / 1000);
  document.body.appendChild(scriptE);

$ ->
  if $('#gakkison').length
    exactTime()

window.key = () ->
  exec(window.is_active)
  setTimeout("window.key()", 1)

exec = (is_active=true) ->
  #console.log is_active
  #now = new Date()
  now = new Date(Date.now() + window.dateDiff)

  #sec8 = now.getTime() % (8 * 1000)
  #is_break = sec8 < 6 * 1000
  is_break = false

  #msec = now.getMilliseconds() * window.bpm / 120
  msec = now.getMilliseconds()

  if msec % (500 / 2 ) < 50 && !is_break && is_active
    console.log 333
    audio = document.getElementById('hh')
    audio.pause()
    audio.currentTime = 0
    audio.play()

  if msec % 1000 < 50 && is_active
    audio = document.getElementById('bd')
    audio.pause()
    audio.currentTime = 0
    audio.play()

  if (msec + 500) % 1000 < 50 && !is_break && is_active
    audio = document.getElementById('sd')
    audio.pause()
    audio.currentTime = 0
    audio.play()

exec2 = (is_active=true) ->
  now = new Date(Date.now() + window.dateDiff)
  msec = now.getMilliseconds()
  if msec % 1000 < 50 && is_active
    audio = document.getElementById('cc')
    audio.pause()
    audio.currentTime = 0
    audio.play()



init = ()->
  if $('#gakkison').length
    for key in ['bd', 'hh', 'sd', 'cc']
      $audio = $('<audio></audio>')
      $audio.css('width', '1px')
      $audio.attr('id', key)
      $audio.attr('src', "/audio/gakkison/dr1/#{key}.mp3")
      $('#gakkison').append($audio)
      $("#gakkison a").on('click', (e) ->
        console.log $(e.currentTarget).attr('id')
        key = $(e.currentTarget).attr('id').replace(/link_/, '')
        audio = document.getElementById(key)
        audio.pause()
        audio.currentTime = 0
        audio.play()
      )
      $(document).on('keydown', (e) ->
        window.is_active = true
      )
      $(document).on('keyup', (e) ->
        window.is_active = false
      )

  Leap.loop({
    hand: (hand)->
      height = hand.screenPosition()[0]
      console.log height
      exec2(height < 1000)
  }).use('screenPosition')

  window.key()

