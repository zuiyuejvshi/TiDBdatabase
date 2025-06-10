require 'mysql2'
require 'dotenv'

class Database
  def self.connection
    @connection ||= Mysql2::Client.new(
      host: ENV['DB_HOST'],
      username: ENV['DB_USER'],
      password: ENV['DB_PASSWORD'],
      database: ENV['DB_NAME'],
      port: ENV['PORT'].to_i,
      ssl_mode: :verify_identity
    )
  end

  def self.get_shipments
    connection.query("SELECT * FROM shipments ORDER BY created_at DESC")
  end

  def self.get_shipment(id)
    connection.query("SELECT * FROM shipments WHERE id = #{id}").first
  end

  def self.create_shipment(data)
    connection.query("""
      INSERT INTO shipments (
        tracking_number, client_code, transport_mode, status,
        goods_description, package_count, estimated_days,
        created_at, shipped_date, estimated_arrival
      ) VALUES (
        '#{data[:tracking_number]}', '#{data[:client_code]}',
        '#{data[:transport_mode]}', '#{data[:status]}',
        '#{data[:goods_description]}', #{data[:package_count]},
        #{data[:estimated_days]}, NOW(),
        #{data[:shipped_date] ? "'#{data[:shipped_date]}'" : 'NULL'},
        #{data[:estimated_arrival] ? "'#{data[:estimated_arrival]}'" : 'NULL'}
      )
    """)
  end

  def self.update_shipment(id, data)
    connection.query("""
      UPDATE shipments SET
        status = '#{data[:status]}',
        shipped_date = #{data[:shipped_date] ? "'#{data[:shipped_date]}'" : 'NULL'},
        arrival_date = #{data[:arrival_date] ? "'#{data[:arrival_date]}'" : 'NULL'},
        pickup_date = #{data[:pickup_date] ? "'#{data[:pickup_date]}'" : 'NULL'}
      WHERE id = #{id}
    """)
  end

  def self.delete_shipment(id)
    connection.query("DELETE FROM shipments WHERE id = #{id}")
  end
end 