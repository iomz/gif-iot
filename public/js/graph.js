$(function() {
    $(document).ready(function() {
        Highcharts.setOptions({
            global: {
                useUTC: false
            }
        });
        var windowHeight = $(window).height();
        $("#container").height(windowHeight);
        $("#container").highcharts({
            chart: {
                type: "spline",
                animation: Highcharts.svg,
                // don't animate in old IE
                marginRight: 10,
                events: {
                    load: function() {
                        // set up the updating of the chart each second
                        var series = this.series;
                        setInterval(function() {
                            var x = new Date().getTime();
                            // current time
                            for (var i in series) {
                                series[i].addPoint([ x, Math.random() ], true, true);
                                series[i].update({name: hoge});
                            }
                        }, 1e3);
                    }
                }
            },
            title: {
                text: "Live data from OpenBlocks: " + id
            },
            xAxis: {
                type: "datetime"
            },
            yAxis: {
                title: {
                    text: "Value"
                },
                plotLines: [ {
                    value: 0,
                    width: 1,
                    color: "#808080"
                } ]
            },
            tooltip: {
                formatter: function() {
                    return "<b>" + this.series.name + "</b><br/>" + Highcharts.dateFormat("%Y-%m-%d %H:%M:%S", this.x) + "<br/>" + Highcharts.numberFormat(this.y, 2);
                }
            },
            legend: {
                enabled: true
            },
            exporting: {
                enabled: false
            },
            series: [ {
                name: "Random data",
                data: function() {
                    // generate an array of random data
                    var data = [], time = new Date().getTime(), i;
                    for (i = -29; i <= 0; i += 1) {
                        data.push({
                            x: time + i * 1e3,
                            y: Math.random()
                        });
                    }
                    return data;
                }()
            }, {
                name: "Random data2",
                data: function() {
                    // generate an array of random data
                    var data = [], time = new Date().getTime(), i;
                    for (i = -29; i <= 0; i += 1) {
                        data.push({
                            x: time + i * 1e3,
                            y: Math.random()
                        });
                    }
                    return data;
                }()
            }, {
                name: "Random data3",
                data: function() {
                    // generate an array of random data
                    var data = [], time = new Date().getTime(), i;
                    for (i = -29; i <= 0; i += 1) {
                        data.push({
                            x: time + i * 1e3,
                            y: Math.random()
                        });
                    }
                    return data;
                }()
            } ],
            plotOptions: {
                series: {
                    marker: {
                        enabled: false
                    }
                }
            }
        });
    });

    var chart = $('#container').highcharts();
    $('#resizer').resizable({
        // On resize, set the chart size to that of the
        // resizer minus padding. If your chart has a lot of data or other
        // content, the redrawing might be slow. In that case, we recommend
        // that you use the 'stop' event instead of 'resize'.
        resize: function () {
            chart.setSize(
                this.offsetWidth - 20,
                this.offsetHeight - 20,
                false
            );
        }
    });
});
