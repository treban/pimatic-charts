module.exports = (env) ->

  Promise = env.require 'bluebird'
  assert = env.require 'cassert'

  class ChartPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      deviceConfigDef = require("./device-config-schema.coffee")
      @framework.deviceManager.registerDeviceClass("ChartDevice",{
        configDef : deviceConfigDef.ChartDevice,
        createCallback : (config, lastState) => new ChartDevice(config,lastState, @framework)
      })
      @framework.deviceManager.registerDeviceClass("GaugeDevice",{
        configDef : deviceConfigDef.GaugeDevice,
        createCallback : (config, lastState) => new GaugeDevice(config,lastState, @framework)
      })
      @framework.on "after init", =>
        mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
        if mobileFrontend?
      #    mobileFrontend.registerAssetFile 'js', "pimatic-charts/app/highcharts-more.js"
          mobileFrontend.registerAssetFile 'js', "pimatic-charts/app/chart-page.coffee"
          mobileFrontend.registerAssetFile 'js', "pimatic-charts/app/highcharts.js"
          mobileFrontend.registerAssetFile 'html', "pimatic-charts/app/chart-template.jade"
          mobileFrontend.registerAssetFile 'css', "pimatic-charts/app/chart.css"
          mobileFrontend.registerAssetFile 'js', "pimatic-charts/app/solid-gauge.js"
      @framework.on('destroy', (context) =>
        env.logger.info("Speichere RRD Graphen...")
      )

  class ChartDevice extends env.devices.VariablesDevice

    template: 'chart'

    constructor: (@config, lastState, @framework) ->
      super(@config, lastState, @framework)

    destroy: ->
      super()

  class GaugeDevice extends env.devices.VariablesDevice

    template: 'gauge'

    constructor: (@config, lastState, @framework) ->
      super(@config, lastState, @framework)

    destroy: ->
      super()

  mychartplugin = new ChartPlugin()
  return mychartplugin
