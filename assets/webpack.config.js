const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = (env, options) => {
  const devMode = options.mode !== "production";

  return {
    entry: {
      app: ["./js/app.js", "./css/app.css"]
    },
    output: {
      filename: "app.js",
      path: path.resolve(__dirname, "../priv/static/assets")
    },
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: "babel-loader"
          }
        },
        {
          test: /\.css$/,
          use: [
            MiniCssExtractPlugin.loader,
            "css-loader",
            "postcss-loader"
          ]
        }
      ]
    },
    plugins: [
      new MiniCssExtractPlugin({ filename: "app.css" })
    ],
    mode: devMode ? "development" : "production",
    devtool: devMode ? "source-map" : undefined
  };
}; 