class RLive

  @EVENT_NAVIGATE : "rlive-navigate"

  constructor: (path, timeSlice) ->
    @path = path
    @timeSlice = timeSlice

    @w = 960
    @h = 50
    @m = [5, 40, 20, 120]
    @chart = d3.chart.bullet().width(@w - @m[1] - @m[3]).height(@h - @m[0] - @m[2])

  drawGraph: (data) ->
    $("#chart").empty()
    @vis = d3.select("#chart").selectAll("svg")
      .data(data)
      .enter().append("svg:svg")
      .attr("class", "bullet")
      .attr("width", @w)
      .attr("height", @h)
      .attr("id", (d) -> return d.title)
      .on('click', (d) =>
        console.log 'Trying to trigger an event'
        console.log "path " + d.obj.path
        $(@).trigger(RLive.EVENT_NAVIGATE, {path: d.obj.path, type: RServer.EVENT_TYPE_LIVE, interval: @timeSlice})
#        drawGraph(d.obj.toJson())
      )
      .append("svg:g")
      .attr("transform", "translate(" + @m[3] + "," + @m[0] + ")")
      .call(@chart)

    title = @vis.append("svg:g")
      .attr("text-anchor", "end")
      .attr("transform", "translate(-6," + (@h - @m[0] - @m[2]) / 2 + ")")

    title.append("svg:text")
      .attr("class", "title")
      .text( (d) -> return d.title)

    title.append("svg:text")
      .attr("class", "subtitle")
      .attr("dy", "1em")
      .text((d) -> return d.subtitle)

    @chart.duration(500)

  updateGraph: (data) ->
    @vis.data(data)
    @vis.call(@chart)

    d3.select("#chart").selectAll("svg").selectAll("text.title").remove()
    d3.select("#chart").selectAll("svg").selectAll("text.subtitle").remove()

    title = @vis.append("svg:g")
      .attr("text-anchor", "end")
      .attr("transform", "translate(-6," + (@h - @m[0] - @m[2]) / 2 + ")")

    title.append("svg:text")
      .attr("class", "title")
      .text((d) -> return d.title )

    title.append("svg:text")
      .attr("class", "subtitle")
      .attr("dy", "1em")
      .text((d) -> return d.subtitle )

window.RLive = RLive




