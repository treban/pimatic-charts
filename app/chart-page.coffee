
merge = Array.prototype.concat

$(document).on 'templateinit', (event) ->

  class ChartDeviceItem extends pimatic.DeviceItem

    @chartobj = null
    @myChart = null
    @dateval = 0
    @drawseries = null

    colors: [
      '#7cb5ec', '#434348', '#90ed7d', '#f7a35c', '#8085e9',
      '#f15c80', '#e4d354', '#8085e8', '#8d4653', '#91e8e1'
    ]

    constructor: (templData, @device) ->
      super(templData,@device)
      @deviceConfig = @device.config
      @devattr = @device.config.variables
      @chartId = "chart-#{templData.deviceId}"

      @subtitle = @device.config.subtitle ? @device.configDefaults.subtitle
      @height = @device.config.height ? @device.configDefaults.height
      @xlabel = @device.config.xlabel ? @device.configDefaults.xlabel
      @ylabel = @device.config.ylabel ? @device.configDefaults.ylabel
      @legend = @device.config.legend ? @device.configDefaults.legend
      @interval = @device.config.interval ? @device.configDefaults.interval
      @timerange = @device.config.timerange ? @device.configDefaults.timerange
      @allowzoom = @device.config.allowzoom ? @device.configDefaults.allowzoom
      @devyaxis = @device.config.yaxis ? @device.configDefaults.yaxis
      @allowtrace = @device.config.allowtrace ? @device.configDefaults.allowtrace
      @showdatalabels = @device.config.showdatalabels ? @device.configDefaults.showdatalabels


      @dateval = new Date()
      @dateval = switch
        when @timerange=="30min" then @dateval.setMinutes(@dateval.getMinutes() - 30)
        when @timerange=="1h" then @dateval.setMinutes(@dateval.getMinutes() - 60)
        when @timerange=="3h" then @dateval.setMinutes(@dateval.getMinutes() - 180)
        when @timerange=="12h" then @dateval.setMinutes(@dateval.getMinutes() -720)
        when @timerange=="1d" then @dateval.setDate(@dateval.getDate() - 1)
        when @timerange=="3d" then @dateval.setDate(@dateval.getDate() - 3)
        when @timerange=="7d" then @dateval.setDate(@dateval.getDate() - 7)
        when @timerange=="14d" then @dateval.setDate(@dateval.getDate() - 14)
        when @timerange=="1month" then @dateval.setDate(@dateval.getDate() - 30)

      @yaxis = []
      for ya in @devyaxis
        @yaxis.push({
          labels: {
              format: '{value}'+ya.unit,
          },
          title: {
              text: ya.label,
          },
          opposite: ya.opposite
          })
      console.log @yaxis
      @chartoptions =
        {
          chart: {
              height: @height
              zoomType: if @allowzoom then 'x' else 'none'
          },
          title: {
              text: null
          },
          subtitle: {
              text: @subtitle
          },
          xAxis: {
              type: 'datetime',
              title: {
                  text: @xlabel
              }
          },
          yAxis: @yaxis,
          legend: {
              enabled: @legend
          },
          credits: {
              enabled: false
          },
          plotOptions: {
              area: {
                  marker: {
                      radius: 2
                  },
                  lineWidth: 1,
                  states: {
                      hover: {
                          lineWidth: 1
                      }
                  },
                  threshold: null,
                  dataLabels: {
                    enabled: @showdatalabels
                  },
                  enableMouseTracking: @allowtrace
              },
              line: {
                dataLabels: {
                        enabled: @showdatalabels
                    },
                enableMouseTracking:  @allowtrace
              },
              spline: {
                dataLabels: {
                        enabled: @showdatalabels
                    },
                enableMouseTracking:  @allowtrace
              },
              areaspline: {
                dataLabels: {
                        enabled: @showdatalabels
                    },
                enableMouseTracking:  @allowtrace
              },
              column: {
                dataLabels: {
                        enabled: @showdatalabels
                    },
                enableMouseTracking:  @allowtrace
              },
          },
          series: []
        }

    afterRender: (elements) =>

      @chartobj = $(elements).find('#' + @chartId)
      Highcharts.setOptions({
        global: {
          useUTC: false
        }
      })
      @myChart = Highcharts.chart(@chartobj[0],@chartoptions)
      @drawSeries()
      window.addEventListener("resize", @resize , true)
      console.log @interval
      if (@interval > 0 )
        setInterval () =>
          @refresh()
        , @interval*1000
      super(elements)

    drawSeries: () =>
      for attr in @devattr
        if attr.type in ["number"]
          @getData(attr)

    getData: (attr,refresh,series) =>
      @crit = {}
      @crit.after = @dateval
      pimatic.client.rest.querySingleDeviceAttributeEvents({
        deviceId: @deviceId
        attributeName: attr.name
        criteria: @crit
      }, {global: no}).done( (result) =>
        if result.success
          @data = @convertData(result.events)
          update = {
            name: attr.name,
            yAxis: attr.yaxis,
            data: @data,
            type: attr.chart,
            step: attr.step,
            dashStyle: attr.dashstyle,
            tooltip: {
                valueDecimals: 2
            }
          }
          if (!refresh)
            @myChart.addSeries(update)
          else
            @myChart.series[series].setData(@data)
      ).fail(ajaxAlertFail)

    convertData: (rawdata) =>
      @resu = new Array()
      for i,v in rawdata
        toPush = new Array()
        toPush[0]=(i['time'])
        toPush[1]=(i['value'])
        @resu.splice(i['time'], 0, toPush);
      return @resu

    refresh: () =>
      i = 0
      for attr in @devattr
        if attr.type in ["number"]
          @getData(attr,true,i++)

    resize: () =>
      setTimeout =>
        @myChart.reflow()
      , 500


  class GaugeDeviceItem extends pimatic.DeviceItem

    @chartobj = []
    @myChart = null
    @dateval = 0
    @drawseries = null
    @gauge = []

    constructor: (templData, @device) ->
      super(templData,@device)
      @deviceConfig = @device.config
      @devattr = @device.config.variables
      @scale = @device.config.scale ? @device.configDefaults.scale
      @scale = @scale - 0.2
      @chartId = "chart-#{templData.deviceId}"

      super(templData, @device)

      for attr in @device.attributes()
        @cache = attr.name
        if attr.type in ["number"]
          @getAttribute(attr.name).value.subscribe( (val) =>
            @updateGauges()
          )

      @gaugeOptions = {
        chart: {
          type: 'solidgauge',
          height: 175*@scale,
          width: 250*@scale
        },
        title: null,
        pane: {
            center: ['50%', '80%'],
            size: '130%',
            startAngle: -90,
            endAngle: 90,
            background: {
                backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || '#EEE',
                innerRadius: '60%',
                outerRadius: '100%',
                shape: 'arc'
            }
        },
        credits: {
            enabled: false
        },
        tooltip: {
            enabled: false
        },
        yAxis: {
            stops: [
                [0.2, '#55BF3B'],
                [0.4, '#DDDF0D'],
                [0.8, '#DF5353']
            ],
            lineWidth: 0,
            minorTickInterval: null,
            tickAmount: 2,
            title: {
                y: -1*(60*@scale)
            },
            labels: {
                enabled: true,
                y: 18
            }
        },
        plotOptions: {
            solidgauge: {
                dataLabels: {
                    y: 5,
                    borderWidth: 0,
                    useHTML: true
                }
            }
        }
      }

    updateGauges: () =>
      for attr in @device.attributes()
        if attr.type in ["number"]
          value = @getAttribute(attr.name).value()
          @myChart[attr.name].series[0].points[0].update(value)

    afterRender: (elements) =>
      @myChart = {}
      for attr in @devattr
        if attr.type in ["number", "boolean"]
          obj=$(elements).find('#gauge-' + attr.name)
          @myChart[attr.name] = Highcharts.chart(obj[0], Highcharts.merge(@gaugeOptions, {
            yAxis: {
                min: attr.min,
                max: attr.max,
                title: {
                    text: attr.label
                }
                labels: {
                  enabled: attr.showRange
                }
            },
            series: [{
                name: attr.name,
                data: [0],
                dataLabels: {
                  format: '<div style="text-align:center"><span style="font-size:'+@scale*17+'px;color:' +
                      ((Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black') + '">{y:.0f}</span><br/>' +
                         '<span style="font-size:'+@scale*14+'px;color:silver">'+attr.unit+'</span></div>',
                  y: +12
                }
            }]
          }))
      @updateGauges()
    #  window.addEventListener("resize", @resize , true)
      super(elements)

#    resize: () =>
#     setTimeout =>
#        @myChart.reflow()
#      , 500

  pimatic.templateClasses['chart'] = ChartDeviceItem
  pimatic.templateClasses['gauge'] = GaugeDeviceItem
