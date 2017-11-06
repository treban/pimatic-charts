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
      ylabel:
        description: "Y - label"
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
              default: "number"
              enum: ["number"]
            chart:
              description: "The type of the chart for this variable"
              type: "string"
              default: "line"
              enum: ["line" , "spline", "area", "areaspline", "column", "scatter" ]
            step:
              description: "Draw steps instead lines."
              type: "boolean"
              default: false
              required: false
        yAxis:
        description: "yAxis"
        type: "array"
        default: []
        format: "table"
        items:
          type: "object"
          required: ["name", "expression", "type", "chart"]
          properties:
            label:
              description: "Label for y-axis"
              type: "string"
            unit:
              description: "The unit of the value"
              type: "string"
              default: ""
              required: false
            opposit:
              description: "Draw y-axis on the right side"
              type: "boolean"
              default: false
              required: false
  GaugeDevice :
    title: "Gauge Properties"
    type: "object"
    required: ["scale"]
    extensions: ["xLink","xAttributeOptions"]
    properties:
      scale:
        description: "scale factor"
        type: "number"
        default: 1.0
        required: true
      variables:
        description: "Variables to display"
        type: "array"
        default: []
        format: "table"
        items:
          type: "object"
          required: ["name", "expression", "type", "min", "max"]
          properties:
            name:
              description: "Name for the corresponding variable"
              type: "string"
            expression:
              description: "
                The expression to use to get the value. Can be just a variable name ($myVar),
                a calculation ($myVar + 10)"
              type: "string"
            type:
              description: "The type of the variable is fix"
              type: "string"
              default: "number"
              enum: ["number"]
            min:
              description: "The min value"
              type: "number"
              default: 0
            max:
              description: "The max value"
              type: "number"
              default: 100
            unit:
              description: "A custom unit label"
              type: "string"
              required: false
              default: ""
            showRange:
              description: "Show range"
              type: "boolean"
              required: false
              default: false
}
