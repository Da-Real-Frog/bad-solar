CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Site Energy Table
CREATE TABLE IF NOT EXISTS site_energy_history (
    time TIMESTAMPTZ NOT NULL,
    solar_kwh NUMERIC,
    home_kwh NUMERIC,
    grid_import_kwh NUMERIC,
    grid_export_kwh NUMERIC,
    battery_charge_kwh NUMERIC,
    battery_discharge_kwh NUMERIC,
    battery_soc_percent NUMERIC,
    PRIMARY KEY (time)
);
SELECT create_hypertable('site_energy_history', 'time', if_not_exists => TRUE);

-- String Metrics Table
CREATE TABLE IF NOT EXISTS inverter_string_metrics (
    time TIMESTAMPTZ NOT NULL,
    string_id VARCHAR(50) NOT NULL,
    voltage_v NUMERIC,
    current_a NUMERIC,
    power_w NUMERIC,
    PRIMARY KEY (time, string_id)
);
SELECT create_hypertable('inverter_string_metrics', 'time', if_not_exists => TRUE);

-- Continuous Aggregate for Daily Rollups
CREATE MATERIALIZED VIEW IF NOT EXISTS daily_energy_summary
WITH (timescaledb.continuous) AS
SELECT 
    time_bucket('1 day', time) AS bucket,
    SUM(solar_kwh) AS daily_solar_kwh,
    SUM(home_kwh) AS daily_home_kwh,
    SUM(grid_import_kwh) AS daily_grid_import,
    SUM(grid_export_kwh) AS daily_grid_export
FROM site_energy_history
GROUP BY bucket;