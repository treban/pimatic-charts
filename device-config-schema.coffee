module.exports = {
  title: "chart"
  ChartDevice :
    title: "Chart Properties"
    type: "object"
    extensions: ["xLink","xAttributeOptions"]
    properties:
      subtitle:
        description: "Chart type"
        type: "string"
        default: ""
        required: false
      xlabel:
        description: "Chart xlabel"
        type: "string"
        default: ""
      ylabel:
        description: "Chart ylabel"
        type: "string"
        default: ""
      height:
        description: "Chart height"
        type: "number"
        default: 150
      timerange:
        description: "Chart height"
        type: "string"
        enum: ["30min", "1h", "3h", "12h", "1d", "3d", "7d", "14d", "1month" ]
        default: "1d"
        required: false
      rollperiod:
        description: "Chart height"
        type: "number"
        default: 0
        required: false
      fillgraph:
        description: "Chart height"
        type: "boolean"
        default: false
        required: false
      legend:
        description: "Chart legend"
        type: "boolean"
        default: false
        required: false
      allowzoom:
        description: "Allow zoom"
        type: "boolean"
        default: false
        required: false
      variables:
        description: "Variables to display"
        type: "array"
        default: []
        format: "table"
        items:
          type: "object"
          required: ["name", "expression", "type"]
          properties:
            name:
              description: "Name for the corresponding attribute."
              type: "string"
            expression:
              description: "
                The expression to use to get the value. Can be just a variable name ($myVar),
                a calculation ($myVar + 10) or a string interpolation (\"Test: {$myVar}!\")
                "
              type: "string"
            type:
              description: "The type of the variable."
              type: "string"
              default: "number"
              enum: ["boolean", "number"]
            label:
              description: "A custom label to use in the frontend."
              type: "string"
              required: false
              default: ""
            step:
              description: "Chart type"
              type: "boolean"
              default: false
              required: false
            discrete:
              description: "
                Should be set to true if the value does not change continuously over time."
              type: "boolean"
              required: false
}
