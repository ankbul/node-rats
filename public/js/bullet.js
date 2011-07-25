var w = 960,
    h = 50,
    m = [5, 40, 20, 120]; // top right bottom left

var chart = d3.chart.bullet()
    .width(w - m[1] - m[3])
    .height(h - m[0] - m[2]);



drawGraph = function(data) {
    $("#chart").empty();
      var vis = d3.select("#chart").selectAll("svg")
          .data(data)
        .enter().append("svg:svg")
          .attr("class", "bullet")
          .attr("width", w)
          .attr("height", h)
          .attr("id", function(d) { return d.title; })
          .on('click', function(d) { drawGraph(d.obj.toJson()) })
        .append("svg:g")
          .attr("transform", "translate(" + m[3] + "," + m[0] + ")")
          .call(chart);

      var title = vis.append("svg:g")
          .attr("text-anchor", "end")
          .attr("transform", "translate(-6," + (h - m[0] - m[2]) / 2 + ")");

      title.append("svg:text")
          .attr("class", "title")
          .text(function(d) { return d.title; });

      title.append("svg:text")
          .attr("class", "subtitle")
          .attr("dy", "1em")
          .text(function(d) { return d.subtitle; });

      chart.duration(500);
      window.transition = function(data) {

          vis.data(data);
//        vis.map(function(d, i) {
//              return data[i];
//        });
        vis.call(chart);

        d3.select("#chart").selectAll("svg").selectAll("text.title").remove();
        d3.select("#chart").selectAll("svg").selectAll("text.subtitle").remove();

        var title = vis.append("svg:g")
          .attr("text-anchor", "end")
          .attr("transform", "translate(-6," + (h - m[0] - m[2]) / 2 + ")");

      title.append("svg:text")
          .attr("class", "title")
          .text(function(d) { return d.title; });

      title.append("svg:text")
          .attr("class", "subtitle")
          .attr("dy", "1em")
          .text(function(d) { return d.subtitle; });
      };
};

function randomize(d) {
  if (!d.randomizer) d.randomizer = randomizer(d);
  d.ranges = d.ranges.map(d.randomizer);
  d.markers = d.markers.map(d.randomizer);
  d.measures = d.measures.map(d.randomizer);
  return d;
}

function randomizer(d) {
  var k = d3.max(d.ranges) * .2;
  return function(d) {
    return Math.max(0, d + k * (Math.random() - .5));
  };
}
