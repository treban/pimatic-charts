pimatic-charts
=======================

This plugin provides a chart device for the [pimatic](https://pimatic.org/) frontend.
It is based on [highcharts](https://www.highcharts.com/demo).

Please make feature requests!

#### Features
* Chart device
* Gauge device
* Many customization options

### Installation

Just activate the plugin in your pimatic config. The plugin manager automatically installs the package with his dependencys.

### Configuration

You can load the plugin by adding following in the config.json from your pimatic server:

    {
      "plugin": "charts"
    }

### Usages

The devices are based on the built-in variable device from pimatic.

#### Chart device

The device needs only one configured variable.
The config has a default y axis definition.
You can assign each variable to one y axis.
But also all variables to the same axis.


![chart image](https://raw.githubusercontent.com/treban/pimatic-charts/master/doc/chart.png)

Example chart device:
```
{
  "variables": [
    {
      "name": "temperature",
      "expression": "$wetter.temperature",
      "type": "number",
      "step": false,
      "chart": "areaspline",
      "yaxis": 0
    },
    {
      "name": "humidity",
      "expression": "$wetter.humidity",
      "type": "number",
      "step": false,
      "chart": "spline",
      "yaxis": 1
    },
    {
      "name": "pressure",
      "expression": "$wetter.pressure",
      "type": "number",
      "chart": "spline",
      "yaxis": 2
    },
    {
      "name": "windspeed",
      "expression": "$wetter.windspeed",
      "type": "number",
      "chart": "spline",
      "yaxis": 3
    }
  ],
  "xAttributeOptions": [],
  "echo": {
    "additionalNames": []
  },
  "id": "testchart",
  "name": "Weather",
  "class": "ChartDevice",
  "xlabel": "x-label",
  "height": 250,
  "subtitle": "Subtitle",
  "timerange": "1d",
  "legend": true,
  "interval": 5,
  "yaxis": [
    {
      "label": "Temperature",
      "unit": "°C"
    },
    {
      "label": "humidity",
      "opposite": true,
      "unit": "%"
    },
    {
      "label": "pressure",
      "unit": "mbar"
    },
    {
      "label": "windspeed",
      "unit": "m/s",
      "opposite": true
    }
  ]
},

```

#### Gauge device

![gauge image](https://raw.githubusercontent.com/treban/pimatic-charts/master/doc/gauge.png)

Example gauge device:
```
{
  "scale": 0.8,
  "variables": [
    {
      "name": "Tank",
      "expression": "$kosta-20000",
      "type": "number",
      "min": 0,
      "max": 30000,
      "unit": "liter",
      "showRange": true,
      "label": "Tank level"
    },
    {
      "name": "Power",
      "expression": "$kosta-39000",
      "type": "number",
      "min": 0,
      "max": 5000,
      "unit": "kW/h",
      "showRange": true,
      "label": "Power"
    }
  ],
  "xAttributeOptions": [],
  "echo": {
    "additionalNames": []
  },
  "id": "gauge",
  "name": "Gauge Device",
  "class": "GaugeDevice"
},

```
### ChangeLog
* 0.0.1 : First public version
