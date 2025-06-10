#!/bin/bash

# 安装依赖
bundle install

# 启动 Sinatra API 服务器
ruby server.rb &
API_PID=$!

# 启动 Jekyll 服务器
bundle exec jekyll serve --host 0.0.0.0 --port 4000

# 当 Jekyll 服务器停止时，也停止 API 服务器
kill $API_PID 