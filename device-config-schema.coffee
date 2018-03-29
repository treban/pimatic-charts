module.exports = {
  title: "chart"
  ChartDevice :
    title: "Chart Properties"
    type: "object"
    extensions: ["xLink"]
    properties:
      subtitle:
        description: "Subtitle"
        type: "string"
        default: ""
        required: false
      xlabel:
        description: "X - label"
        type: "string"
        default: ""
      height:
        description: "Chart height"
        type: "number"
        default: 150
      timerange:
        description: "Time-range to display"
        type: "string"
        enum: ["30min", "1h", "3h", "12h", "1d", "3d", "7d", "14d", "1month" ]
        default: "1d"
        required: false
      legend:
        description: "Show legend"
        type: "boolean"
        default: false
        required: false
      allowzoom:
        description: "Allow zoom"
        type: "boolean"
        default: false
        required: false
      allowtrace:
        description: "Allow mouse trace"
        type: "boolean"
        default: false
        required: false
      showdatalabels:
        description: "Show data labels"
        type: "boolean"
        default: false
        required: false
      interval:
        description: "Refresh interval in seconds. 0 = never"
        type: "number"
        default: 0
      variables:
        description: "Variables to display"
        type: "array"
        default: []
        format: "table"
        items:
          type: "object"
          required: ["name", "expression", "type", "chart"]
          properties:
            name:
              description: "Name for the corresponding variable *without spaces*"
              type: "string"
            expression:
              description: "
                The expression to use to get the value. Can be just a variable name ($myVar),
                or a calculation ($myVar + 10)"
              type: "string"
            type:
              description: "The type of the variable is fix"
              type: "string"
              enum: ["number"]
            chart:
              description: "The type of the chart for this variable"
              type: "string"
              enum: ["line" , "spline", "area", "areaspline", "column", "scatter" ]
            dashstyle:
              description: "The type of dash style."
              type: "string"
              enum: ["Solid" , "ShortDash", "ShortDot", "ShortDashDot", "Dot", "Dash" ]
            yaxis:
              description: "The yAxis reference"
              type: "number"
              default: 0
            step:
              description: "Draw steps instead lines."
              type: "boolean"
              default: false
              required: false
            color:
              description: "The line color"
              type: "string"
              required: false
      yaxis:
        description: "yAxis"
        type: "array"
        default: [{"label": "","unit": ""}]
        format: "table"
        items:
          type: "object"
          required: ["label"]
          properties:
            label:
              description: "Label for y-axis"
              type: "string"
            unit:
              description: "The unit of the value"
              type: "string"
            opposite:
              description: "Draw y-axis on the right side"
              type: "boolean"
              default: false
              required: false
      showdatepicker:
        description: "If datepicker is enabled, you must define the date buttons"
        type: "boolean"
        default: false
        required: false
      datebuttons:
        description: "Date picker buttons"
        type: "array"
        default: [{"label": "1min","count":1,"unit": "minute","datagrouping":false},{"label": "1day","count":1,"unit": "day","datagrouping":false},{"label": "ALL","count":0,"unit": "all","datagrouping":false}]
        format: "table"
        items:
          type: "object"
          required: ["label", "unit", "count", "datagrouping"]
          properties:
            label:
              description: "Label for date button"
              type: "string"
            count:
              description: "The count of the picker"
              type: "number"
            unit:
              description: "The unit of the picker"
              type: "string"
              enum: ["minute", "hour", "day", "week", "month", "ytd", "all" ]
            datagrouping:
              description: "Group Data per unit"
              type: "boolean"
  GaugeDevice :
    title: "Gauge Properties"
    type: "object"
    extensions: ["xLink"]
    properties:
      scale:
        description: "scale factor"
        type: "number"
        default: 1.0
        required: false
      variables:
        description: "Variables to display"
        type: "array"
        default: []
        format: "table"
        items:
          type: "object"
          required: ["name", "expression", "type", "min", "max", "unit", "showRange", "showPointer"]
          properties:
            name:
              description: "Name for the corresponding variable *without spaces*"
              type: "string"
              required: true
            label:
              description: "Label"
              type: "string"
              required: true
            expression:
              description: "
                The expression to use to get the value. Can be just a variable name ($myVar),
                a calculation ($myVar + 10)"
              type: "string"
              required: true
            type:
              description: "The type of the variable is fix"
              type: "string"
              enum: ["number"]
              required: true
            min:
              description: "The min value"
              type: "number"
              required: true
            max:
              description: "The max value"
              type: "number"
              required: true
            unit:
              description: "A custom unit label"
              type: "string"
              required: true
            showRange:
              description: "Show range"
              type: "boolean"
              required: true
            showPointer:
              description: "Show pointer"
              type: "boolean"
              required: true  
            showReverse:
              description: "Show reverse"
              type: "boolean"
              required: true
            decimals:
              description: "The number of digits after floating point"
              type: "number"
              required: true  
            showDonut:
              description: "Show full donut gauge "
              type: "boolean"
              required: true  
}
