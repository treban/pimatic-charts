module.exports = {
  title: "chart"
  ChartDevice :
    title: "Chart Properties"
    type: "object"
    extensions: ["xLink","xAttributeOptions"]
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
              description: "Name for the corresponding variable"
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
      yaxis:
        description: "yAxis"
        type: "array"
        required: ["label", "unit"]
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
  GaugeDevice :
    title: "Gauge Properties"
    type: "object"
    extensions: ["xLink","xAttributeOptions"]
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
          required: ["name", "expression", "type", "min", "max", "unit", "showRange"]
          properties:
            name:
              description: "Name for the corresponding variable"
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
}
