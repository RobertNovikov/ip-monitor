# frozen_string_literal: true

# Returns statistics calculation query
class AvailabilityStatsQuery
  def initialize(ip_id:, time_from: nil, time_to: nil)
    @ip_id = ip_id
    @time_from = time_from
    @time_to = time_to
  end

  def call
    where_sql = build_where_sql

    DB.fetch(
      <<-SQL
        SELECT MAX(rtt) as max, MIN(rtt) as min, AVG(rtt) as avg, stddev_pop(rtt) as standard_deviation,
          PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY rtt) as median,
          avg((is_packet_lost)::int)::double precision as packet_lost_percent
        FROM availability_reports
        WHERE availability_reports.ip_id = #{ip_id} #{where_sql.presence && "AND #{where_sql}"}
      SQL
    )
  end

  private

  attr_reader :ip_id, :time_from, :time_to

  def build_where_sql
    queries = []
    queries << "created_at > '#{time_from}'" if time_from
    queries << "created_at < '#{time_to}'" if time_to
    queries.join(' AND ')
  end
end
