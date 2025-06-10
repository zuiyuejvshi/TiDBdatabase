require 'sinatra'
require 'sinatra/json'
require_relative '_lib/database'

# 启用 CORS
before do
  response.headers["Access-Control-Allow-Origin"] = "*"
  response.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS"
  response.headers["Access-Control-Allow-Headers"] = "Content-Type"
end

# 运单列表
get '/api/shipments' do
  content_type :json
  shipments = Database.get_shipments
  json shipments
end

# 单个运单
get '/api/shipments/:id' do
  content_type :json
  shipment = Database.get_shipment(params[:id])
  json shipment
end

# 创建运单
post '/api/shipments' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  Database.create_shipment(data)
  json success: true
end

# 更新运单
put '/api/shipments/:id' do
  content_type :json
  data = JSON.parse(request.body.read, symbolize_names: true)
  Database.update_shipment(params[:id], data)
  json success: true
end

# 删除运单
delete '/api/shipments/:id' do
  content_type :json
  Database.delete_shipment(params[:id])
  json success: true
end 