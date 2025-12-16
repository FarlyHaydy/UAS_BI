-- ============================================================================
-- Data Warehouse Pariwisata Jakarta 2025 - Database Schema
-- FIXED VERSION - Match dengan ETL Code (Nama Kolom dari Excel)
-- ============================================================================

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET search_path = public, pg_catalog;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';
SET default_table_access_method = heap;

-- ============================================================================
-- DROP EXISTING TABLES (if recreating)
-- ============================================================================

DROP TABLE IF EXISTS public.fact_kunjungan CASCADE;
DROP TABLE IF EXISTS public.dim_price CASCADE;
DROP TABLE IF EXISTS public.dim_wisatawan CASCADE;
DROP TABLE IF EXISTS public.dim_objek_wisata CASCADE;
DROP TABLE IF EXISTS public.dim_time CASCADE;
DROP TABLE IF EXISTS public.staging_harga_tiket_raw CASCADE;
DROP TABLE IF EXISTS public.staging_kunjungan_raw CASCADE;
DROP TABLE IF EXISTS public.dashboard_performance_log CASCADE;
DROP TABLE IF EXISTS public.user_journey_log CASCADE;

DROP VIEW IF EXISTS public.v_kunjungan_summary CASCADE;
DROP VIEW IF EXISTS public.v_funnel_analysis CASCADE;
DROP VIEW IF EXISTS public.v_dashboard_performance_daily CASCADE;

-- ============================================================================
-- TABLES: Dashboard Logging
-- ============================================================================

CREATE TABLE public.dashboard_performance_log (
    log_id SERIAL PRIMARY KEY,
    session_id VARCHAR(100),
    "timestamp" TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    load_time_seconds NUMERIC(5,2),
    query_time_seconds NUMERIC(5,2),
    render_time_seconds NUMERIC(5,2),
    page_views INTEGER,
    interactions_count INTEGER,
    dwell_time_seconds INTEGER,
    error_occurred BOOLEAN DEFAULT false,
    error_message TEXT,
    user_agent TEXT,
    screen_width INTEGER,
    screen_height INTEGER,
    filters_applied JSONB,
    status VARCHAR(20) DEFAULT 'success',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.user_journey_log (
    journey_id SERIAL PRIMARY KEY,
    session_id VARCHAR(100),
    stage VARCHAR(50),
    "timestamp" TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    duration_seconds INTEGER,
    completed BOOLEAN DEFAULT true
);

-- ============================================================================
-- TABLES: Staging (MATCH dengan Nama Kolom Excel)
-- ============================================================================

CREATE TABLE public.staging_kunjungan_raw (
    id SERIAL PRIMARY KEY,
    periode_data VARCHAR(50),
    obyek_wisata VARCHAR(255),
    alamat TEXT,
    longitude NUMERIC(10,7),
    latitude NUMERIC(10,7),
    jenis_wisatawan VARCHAR(50),
    jumlah_kunjungan INTEGER,
    is_processed BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    processed_at TIMESTAMP WITHOUT TIME ZONE
);

CREATE TABLE public.staging_harga_tiket_raw (
    id SERIAL PRIMARY KEY,
    nama_objek_wisata VARCHAR(255),
    harga_tiket_dewasa NUMERIC(10,2),
    harga_tiket_anak NUMERIC(10,2),
    gratis VARCHAR(10),
    mata_uang VARCHAR(10),
    sumber_platform VARCHAR(100),
    tanggal_update DATE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- TABLES: Dimensions
-- ============================================================================

CREATE TABLE public.dim_time (
    time_id SERIAL PRIMARY KEY,
    periode VARCHAR(6) NOT NULL,
    bulan INTEGER NOT NULL,
    tahun INTEGER NOT NULL,
    kuartal INTEGER,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT dim_time_periode_data_key UNIQUE (periode)
);

CREATE TABLE public.dim_objek_wisata (
    objek_wisata_id SERIAL PRIMARY KEY,
    nama_objek VARCHAR(200) NOT NULL,
    alamat TEXT,
    longitude NUMERIC(10,7),
    latitude NUMERIC(10,7),
    wilayah VARCHAR(100),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.dim_wisatawan (
    wisatawan_id SERIAL PRIMARY KEY,
    jenis_wisatawan VARCHAR(50),
    kode_jenis VARCHAR(5),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.dim_price (
    price_id SERIAL PRIMARY KEY,
    objek_wisata_id INTEGER NOT NULL,
    harga_tiket_dewasa INTEGER DEFAULT 0,
    harga_tiket_anak INTEGER DEFAULT 0,
    mata_uang VARCHAR(10) DEFAULT 'IDR',
    sumber_platform VARCHAR(100),
    tanggal_update DATE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_objek_price UNIQUE (objek_wisata_id)
);

COMMENT ON TABLE public.dim_price IS 'Dimension table untuk harga tiket objek wisata';
COMMENT ON COLUMN public.dim_price.harga_tiket_dewasa IS 'Harga tiket untuk dewasa (sama untuk WNI & WNA)';
COMMENT ON COLUMN public.dim_price.harga_tiket_anak IS 'Harga tiket untuk anak (sama untuk WNI & WNA)';
COMMENT ON COLUMN public.dim_price.sumber_platform IS 'Sumber data harga (Website Resmi, Survey Manual, dll)';

-- ============================================================================
-- TABLES: Fact
-- ============================================================================

CREATE TABLE public.fact_kunjungan (
    fact_id BIGSERIAL PRIMARY KEY,
    time_id INTEGER NOT NULL,
    objek_wisata_id INTEGER NOT NULL,
    wisatawan_id INTEGER NOT NULL,
    jumlah_kunjungan INTEGER DEFAULT 0 NOT NULL,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_jumlah_valid CHECK (jumlah_kunjungan >= 0),
    CONSTRAINT uq_fact_key UNIQUE (time_id, objek_wisata_id, wisatawan_id)
);

-- ============================================================================
-- FOREIGN KEYS
-- ============================================================================

ALTER TABLE public.dim_price
    ADD CONSTRAINT fk_objek_wisata 
    FOREIGN KEY (objek_wisata_id) 
    REFERENCES public.dim_objek_wisata(objek_wisata_id) 
    ON DELETE CASCADE;

ALTER TABLE public.fact_kunjungan
    ADD CONSTRAINT fk_fact_time 
    FOREIGN KEY (time_id) 
    REFERENCES public.dim_time(time_id) 
    ON DELETE CASCADE;

ALTER TABLE public.fact_kunjungan
    ADD CONSTRAINT fk_fact_objek 
    FOREIGN KEY (objek_wisata_id) 
    REFERENCES public.dim_objek_wisata(objek_wisata_id) 
    ON DELETE CASCADE;

ALTER TABLE public.fact_kunjungan
    ADD CONSTRAINT fk_fact_wisatawan 
    FOREIGN KEY (wisatawan_id) 
    REFERENCES public.dim_wisatawan(wisatawan_id) 
    ON DELETE CASCADE;

-- ============================================================================
-- INDEXES
-- ============================================================================

-- Dimension indexes
CREATE INDEX idx_dim_time_periode ON public.dim_time(periode);
CREATE INDEX idx_dim_objek_nama ON public.dim_objek_wisata(nama_objek);
CREATE INDEX idx_price_objek ON public.dim_price(objek_wisata_id);

-- Fact indexes
CREATE INDEX idx_fact_time ON public.fact_kunjungan(time_id);
CREATE INDEX idx_fact_objek ON public.fact_kunjungan(objek_wisata_id);
CREATE INDEX idx_fact_wisatawan ON public.fact_kunjungan(wisatawan_id);
CREATE INDEX idx_fact_created ON public.fact_kunjungan(created_at);

-- Staging indexes
CREATE INDEX idx_staging_kunjungan_processed ON public.staging_kunjungan_raw(is_processed);
CREATE INDEX idx_staging_kunjungan_obyek ON public.staging_kunjungan_raw(obyek_wisata);
CREATE INDEX idx_staging_harga_nama ON public.staging_harga_tiket_raw(nama_objek_wisata);

-- Dashboard indexes
CREATE INDEX idx_perf_session ON public.dashboard_performance_log(session_id);
CREATE INDEX idx_perf_timestamp ON public.dashboard_performance_log("timestamp");
CREATE INDEX idx_perf_status ON public.dashboard_performance_log(status);

CREATE INDEX idx_journey_session ON public.user_journey_log(session_id);
CREATE INDEX idx_journey_stage ON public.user_journey_log(stage);
CREATE INDEX idx_journey_timestamp ON public.user_journey_log("timestamp");

-- ============================================================================
-- VIEWS
-- ============================================================================

CREATE OR REPLACE VIEW public.v_kunjungan_summary AS
SELECT 
    dt.tahun,
    dt.bulan,
    dt.periode,
    obj.nama_objek,
    obj.wilayah,
    dw.jenis_wisatawan,
    SUM(f.jumlah_kunjungan) AS total_kunjungan
FROM public.fact_kunjungan f
JOIN public.dim_time dt ON f.time_id = dt.time_id
JOIN public.dim_objek_wisata obj ON f.objek_wisata_id = obj.objek_wisata_id
JOIN public.dim_wisatawan dw ON f.wisatawan_id = dw.wisatawan_id
GROUP BY dt.tahun, dt.bulan, dt.periode, obj.nama_objek, obj.wilayah, dw.jenis_wisatawan;

CREATE OR REPLACE VIEW public.v_funnel_analysis AS
WITH stage_counts AS (
    SELECT 
        stage,
        COUNT(DISTINCT session_id) AS users,
        CASE stage
            WHEN 'landing' THEN 1
            WHEN 'view_kpis' THEN 2
            WHEN 'apply_filters' THEN 3
            WHEN 'analyze_charts' THEN 4
            WHEN 'download_data' THEN 5
            ELSE NULL
        END AS stage_order
    FROM public.user_journey_log
    WHERE "timestamp" >= CURRENT_DATE - INTERVAL '30 days'
    GROUP BY stage
),
total_users AS (
    SELECT users AS total
    FROM stage_counts
    WHERE stage = 'landing'
)
SELECT 
    sc.stage,
    sc.users,
    ROUND((sc.users::NUMERIC / tu.total::NUMERIC) * 100, 2) AS conversion_rate
FROM stage_counts sc
CROSS JOIN total_users tu
ORDER BY sc.stage_order;

CREATE OR REPLACE VIEW public.v_dashboard_performance_daily AS
SELECT 
    DATE("timestamp") AS date,
    COUNT(*) AS total_sessions,
    AVG(load_time_seconds) AS avg_load_time,
    MAX(load_time_seconds) AS max_load_time,
    AVG(query_time_seconds) AS avg_query_time,
    SUM(CASE WHEN error_occurred THEN 1 ELSE 0 END) AS error_count,
    ROUND(
        (SUM(CASE WHEN error_occurred THEN 1 ELSE 0 END)::NUMERIC / COUNT(*)::NUMERIC) * 100,
        2
    ) AS error_rate_pct,
    AVG(dwell_time_seconds) AS avg_dwell_time,
    AVG(interactions_count) AS avg_interactions
FROM public.dashboard_performance_log
WHERE "timestamp" >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY DATE("timestamp")
ORDER BY DATE("timestamp") DESC;

-- ============================================================================
-- INITIAL DATA
-- ============================================================================

INSERT INTO public.dim_wisatawan (jenis_wisatawan, kode_jenis)
VALUES 
    ('Wisatawan Nusantara', 'WNI'),
    ('Wisatawan Mancanegara', 'WNA')
ON CONFLICT DO NOTHING;

-- ============================================================================
-- SUCCESS MESSAGE
-- ============================================================================

DO $$
BEGIN
    RAISE NOTICE '========================================';
    RAISE NOTICE 'Database Schema Initialized Successfully!';
    RAISE NOTICE 'Tables: 9 | Views: 3 | Initial Records: 2';
    RAISE NOTICE 'Columns match with Excel source data';
    RAISE NOTICE '========================================';
END $$;
