require('./../../lib/core/extensions')
UdpSource = require('./../../lib/sources/udp_source').UdpSource
http = require 'http'

class TwitterDemo
  @udpSend: (msg) ->
    udp = new UdpSource()
    udp.loopback msg

  @refreshUrls = {}

  @searchTwitter: (keyword) ->
    options = {
      host: 'search.twitter.com',
      port: 80,
      path: "/search.json?q=#{keyword}&rpp=100"
    }

    if @refreshUrls[keyword] != undefined
      options.path = "/search.json#{@refreshUrls[keyword]}&rpp=100"

    http.get(options, (response) =>
      body = ''
      response.on('data', (chunk) =>
        body += chunk
      )
      response.on('end', () =>
        twitterResponse = JSON.parse(body)
        resultCount = twitterResponse.results.length
        console.log "keyword: #{keyword}, refresh url: #{twitterResponse.refresh_url}, count: #{resultCount}"
        TwitterDemo.refreshUrls[keyword] = twitterResponse.refresh_url
        TwitterDemo.udpSend("/?e=twitter/#{keyword}&v=#{resultCount}")
      )
    ).on('error', (e) ->
      console.log e
    )


setInterval( () ->
  TwitterDemo.searchTwitter 'lebron'
  TwitterDemo.searchTwitter 'bieber'
  TwitterDemo.searchTwitter 'scopely'
 , 1000
)
