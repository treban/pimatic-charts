
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

      @height = @device.config.height ? @device.configDefaults.height
      @xlabel = @device.config.xlabel ? @device.configDefaults.xlabel
      @ylabel = @device.config.ylabel ? @device.configDefaults.ylabel
      @rollperiod = @device.config.rollperiod ? @device.configDefaults.rollperiod
      @fillGraph = @device.config.fillGraph ? @device.configDefaults.fillGraph
      @legend = @device.config.legend ? @device.configDefaults.legend
      @timerange = @device.config.timerange ? @device.configDefaults.timerange
      @subtitle = @device.config.subtitle ? @device.configDefaults.subtitle

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

      @chartoptions =
        {
          chart: {
              height: @height
              zoomType: 'x'
          },
          title: {
              text: ''
          },
          subtitle: {
              text: @subtitle
          },
          xAxis: {
              type: 'datetime'
          },
          yAxis: {
              title: {
                  text: @ylabel
              }
          },
          legend: {
              enabled: @legend
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
                  threshold: null
              }
          },
          series: []
        }

    afterRender: (elements) =>
      @chartobj = $(elements).find('#' + @chartId)
      @myChart = Highcharts.chart(@chartobj[0],@chartoptions)
      @drawSeries()
      window.addEventListener("resize", @resize , true)
      setInterval () =>
        @refresh()
      , 10000
      super(elements)

    getData: (attr) =>
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
            data: @data,
            step: attr.step,
            tooltip: {
                valueDecimals: 2
            }
          }
          @myChart.addSeries(update)
      ).fail( ->
        onError()
      )

    convertData: (rawdata) =>
      @resu = new Array()
      for i,v in rawdata
        toPush = new Array()
        toPush[0]=(i['time'])
        toPush[1]=(i['value'])
        @resu.splice(i['time'], 0, toPush);
      return @resu

    drawSeries: () =>
      for attr in @devattr
        if attr.type in ["number", "boolean"]
          @getData(attr)

    refresh: () =>
      console.log "refresh"

    resize: () =>
      setTimeout =>
        @myChart.reflow()
      , 500


  class GaugeDeviceItem extends pimatic.DeviceItem

    @chartobj = []
    @myChart = null
    @dateval = 0
    @drawseries = null

    constructor: (templData, @device) ->
      super(templData,@device)
      @deviceConfig = @device.config
      @devattr = @device.config.variables
      @chartId = "chart-#{templData.deviceId}"

      super(templData, @device)

      for attr in @device.attributes()
        if attr.type in ["number"]
          @getAttribute(attr.name).value.subscribe( () =>
            @updateGauges()
          )

      @gaugeOptions = {

        chart: {
            height: 600
            width: 400
            type: 'solidgauge'
        },
        title: null,
        pane: {
            center: ['50%', '85%'],
            size: '140%',
            startAngle: -90,
            endAngle: 90,
            background: {
                backgroundColor: (Highcharts.theme && Highcharts.theme.background2) || '#EEE',
                innerRadius: '60%',
                outerRadius: '100%',
                shape: 'arc'
            }
        },
        tooltip: {
            enabled: false
        },
        yAxis: {
            stops: [
                [0.1, '#55BF3B'],
                [0.5, '#DDDF0D'],
                [0.9, '#DF5353']
            ],
            lineWidth: 0,
            minorTickInterval: null,
            tickAmount: 2,
            title: {
                y: -70
            },
            labels: {
                y: 16
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
          console.log attr
          console.log value


    afterRender: (elements) =>
      for attr in @devattr
        if attr.type in ["number", "boolean"]
          obj=$(elements).find('#gauge-' + attr.name)
          console.log obj
          #@chartobj.push(obj)
          @gauge=Highcharts.chart(obj[0], Highcharts.merge(@gaugeOptions, {
            yAxis: {
                min: 0,
                max: 200,
                title: {
                    text: 'Speed'
                }
            },

            credits: {
                enabled: false
            },

            series: [{
                name: 'Speed',
                data: [80],
                tooltip: {
                    valueSuffix: ' km/h'
                }
            }]
          }))
    #  window.addEventListener("resize", @resize , true)
      setInterval () =>
        @refresh()
      , 10000
      super(elements)

    drawSeries: (elements) =>


    refresh: () =>
      console.log "refresh"

    resize: () =>
      setTimeout =>
        @myChart.reflow()
      , 500





  pimatic.templateClasses['chart'] = ChartDeviceItem
  pimatic.templateClasses['gauge'] = GaugeDeviceItem
