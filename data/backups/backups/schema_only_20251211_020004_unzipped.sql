--
-- PostgreSQL database dump
--

\restrict pLyWuCromGKZOdcLSOgvlgWf3OApAXaBIAa19IBel6vr2TpcYqDzaaQTKNlxox2

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1 (Debian 18.1-1.pgdg13+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dashboard_performance_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dashboard_performance_log (
    log_id integer NOT NULL,
    session_id character varying(100),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    load_time_seconds numeric(5,2),
    query_time_seconds numeric(5,2),
    render_time_seconds numeric(5,2),
    page_views integer,
    interactions_count integer,
    dwell_time_seconds integer,
    error_occurred boolean DEFAULT false,
    error_message text,
    user_agent text,
    screen_width integer,
    screen_height integer,
    filters_applied jsonb,
    status character varying(20) DEFAULT 'success'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: dashboard_performance_log_log_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dashboard_performance_log_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dashboard_performance_log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dashboard_performance_log_log_id_seq OWNED BY public.dashboard_performance_log.log_id;


--
-- Name: dim_objek_wisata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_objek_wisata (
    objek_wisata_id integer NOT NULL,
    nama_objek character varying(200) NOT NULL,
    alamat text,
    longitude numeric(10,7),
    latitude numeric(10,7),
    wilayah character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: dim_objek_wisata_objek_wisata_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dim_objek_wisata_objek_wisata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_objek_wisata_objek_wisata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_objek_wisata_objek_wisata_id_seq OWNED BY public.dim_objek_wisata.objek_wisata_id;


--
-- Name: dim_price; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_price (
    price_id integer NOT NULL,
    objek_wisata_id integer NOT NULL,
    harga_tiket_dewasa integer DEFAULT 0,
    harga_tiket_anak integer DEFAULT 0,
    mata_uang character varying(10) DEFAULT 'IDR'::character varying,
    sumber_platform character varying(100),
    tanggal_update date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE dim_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.dim_price IS 'Dimension table untuk harga tiket objek wisata';


--
-- Name: COLUMN dim_price.harga_tiket_dewasa; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dim_price.harga_tiket_dewasa IS 'Harga tiket untuk dewasa (sama untuk WNI & WNA)';


--
-- Name: COLUMN dim_price.harga_tiket_anak; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dim_price.harga_tiket_anak IS 'Harga tiket untuk anak (sama untuk WNI & WNA)';


--
-- Name: COLUMN dim_price.sumber_platform; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dim_price.sumber_platform IS 'Sumber data harga (Website Resmi, Survey Manual, dll)';


--
-- Name: dim_price_price_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dim_price_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_price_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_price_price_id_seq OWNED BY public.dim_price.price_id;


--
-- Name: dim_time; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_time (
    time_id integer NOT NULL,
    periode character varying(6) NOT NULL,
    bulan integer NOT NULL,
    tahun integer NOT NULL,
    kuartal integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: dim_time_time_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dim_time_time_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_time_time_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_time_time_id_seq OWNED BY public.dim_time.time_id;


--
-- Name: dim_wisatawan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_wisatawan (
    wisatawan_id integer NOT NULL,
    jenis_wisatawan character varying(50),
    kode_jenis character varying(5),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: dim_wisatawan_wisatawan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dim_wisatawan_wisatawan_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dim_wisatawan_wisatawan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_wisatawan_wisatawan_id_seq OWNED BY public.dim_wisatawan.wisatawan_id;


--
-- Name: fact_kunjungan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fact_kunjungan (
    fact_id bigint NOT NULL,
    time_id integer NOT NULL,
    objek_wisata_id integer NOT NULL,
    wisatawan_id integer NOT NULL,
    jumlah_kunjungan integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_jumlah_valid CHECK ((jumlah_kunjungan >= 0))
);


--
-- Name: fact_kunjungan_fact_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fact_kunjungan_fact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fact_kunjungan_fact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fact_kunjungan_fact_id_seq OWNED BY public.fact_kunjungan.fact_id;


--
-- Name: staging_harga_tiket_raw; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.staging_harga_tiket_raw (
    id integer NOT NULL,
    nama_objek_wisata character varying(255),
    harga_tiket_dewasa numeric(10,2),
    harga_tiket_anak numeric(10,2),
    gratis character varying(10),
    mata_uang character varying(10),
    sumber_platform character varying(100),
    tanggal_update date,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: staging_harga_tiket_raw_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.staging_harga_tiket_raw_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: staging_harga_tiket_raw_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.staging_harga_tiket_raw_id_seq OWNED BY public.staging_harga_tiket_raw.id;


--
-- Name: staging_kunjungan_raw; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.staging_kunjungan_raw (
    id integer NOT NULL,
    periode_data character varying(50),
    obyek_wisata character varying(255),
    alamat text,
    longitude numeric(10,7),
    latitude numeric(10,7),
    jenis_wisatawan character varying(50),
    jumlah_kunjungan integer,
    is_processed boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    processed_at timestamp without time zone
);


--
-- Name: staging_kunjungan_raw_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.staging_kunjungan_raw_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: staging_kunjungan_raw_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.staging_kunjungan_raw_id_seq OWNED BY public.staging_kunjungan_raw.id;


--
-- Name: user_journey_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_journey_log (
    journey_id integer NOT NULL,
    session_id character varying(100),
    stage character varying(50),
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    duration_seconds integer,
    completed boolean DEFAULT true
);


--
-- Name: user_journey_log_journey_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_journey_log_journey_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_journey_log_journey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_journey_log_journey_id_seq OWNED BY public.user_journey_log.journey_id;


--
-- Name: v_dashboard_performance_daily; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_dashboard_performance_daily AS
 SELECT date((("timestamp" AT TIME ZONE 'UTC'::text) AT TIME ZONE 'Asia/Makassar'::text)) AS date,
    count(*) AS total_sessions,
    avg(load_time_seconds) AS avg_load_time,
    max(load_time_seconds) AS max_load_time,
    avg(query_time_seconds) AS avg_query_time,
    sum(
        CASE
            WHEN error_occurred THEN 1
            ELSE 0
        END) AS error_count,
    round((((sum(
        CASE
            WHEN error_occurred THEN 1
            ELSE 0
        END))::numeric / (count(*))::numeric) * (100)::numeric), 2) AS error_rate_pct,
    avg(dwell_time_seconds) AS avg_dwell_time,
    avg(interactions_count) AS avg_interactions
   FROM public.dashboard_performance_log
  WHERE ("timestamp" >= (CURRENT_DATE - '30 days'::interval))
  GROUP BY (date((("timestamp" AT TIME ZONE 'UTC'::text) AT TIME ZONE 'Asia/Makassar'::text)))
  ORDER BY (date((("timestamp" AT TIME ZONE 'UTC'::text) AT TIME ZONE 'Asia/Makassar'::text))) DESC;


--
-- Name: v_funnel_analysis; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_funnel_analysis AS
 WITH stage_counts AS (
         SELECT user_journey_log.stage,
            count(DISTINCT user_journey_log.session_id) AS users,
                CASE user_journey_log.stage
                    WHEN 'landing'::text THEN 1
                    WHEN 'view_kpis'::text THEN 2
                    WHEN 'apply_filters'::text THEN 3
                    WHEN 'analyze_charts'::text THEN 4
                    WHEN 'download_data'::text THEN 5
                    ELSE NULL::integer
                END AS stage_order
           FROM public.user_journey_log
          WHERE (user_journey_log."timestamp" >= (CURRENT_DATE - '30 days'::interval))
          GROUP BY user_journey_log.stage
        ), total_users AS (
         SELECT stage_counts.users AS total
           FROM stage_counts
          WHERE ((stage_counts.stage)::text = 'landing'::text)
        )
 SELECT sc.stage,
    sc.users,
    round((((sc.users)::numeric / (tu.total)::numeric) * (100)::numeric), 2) AS conversion_rate
   FROM (stage_counts sc
     CROSS JOIN total_users tu)
  ORDER BY sc.stage_order;


--
-- Name: v_kunjungan_summary; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.v_kunjungan_summary AS
 SELECT dt.tahun,
    dt.bulan,
    dt.periode,
    obj.nama_objek,
    obj.wilayah,
    dw.jenis_wisatawan,
    sum(f.jumlah_kunjungan) AS total_kunjungan
   FROM (((public.fact_kunjungan f
     JOIN public.dim_time dt ON ((f.time_id = dt.time_id)))
     JOIN public.dim_objek_wisata obj ON ((f.objek_wisata_id = obj.objek_wisata_id)))
     JOIN public.dim_wisatawan dw ON ((f.wisatawan_id = dw.wisatawan_id)))
  GROUP BY dt.tahun, dt.bulan, dt.periode, obj.nama_objek, obj.wilayah, dw.jenis_wisatawan;


--
-- Name: dashboard_performance_log log_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dashboard_performance_log ALTER COLUMN log_id SET DEFAULT nextval('public.dashboard_performance_log_log_id_seq'::regclass);


--
-- Name: dim_objek_wisata objek_wisata_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_objek_wisata ALTER COLUMN objek_wisata_id SET DEFAULT nextval('public.dim_objek_wisata_objek_wisata_id_seq'::regclass);


--
-- Name: dim_price price_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_price ALTER COLUMN price_id SET DEFAULT nextval('public.dim_price_price_id_seq'::regclass);


--
-- Name: dim_time time_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_time ALTER COLUMN time_id SET DEFAULT nextval('public.dim_time_time_id_seq'::regclass);


--
-- Name: dim_wisatawan wisatawan_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_wisatawan ALTER COLUMN wisatawan_id SET DEFAULT nextval('public.dim_wisatawan_wisatawan_id_seq'::regclass);


--
-- Name: fact_kunjungan fact_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan ALTER COLUMN fact_id SET DEFAULT nextval('public.fact_kunjungan_fact_id_seq'::regclass);


--
-- Name: staging_harga_tiket_raw id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staging_harga_tiket_raw ALTER COLUMN id SET DEFAULT nextval('public.staging_harga_tiket_raw_id_seq'::regclass);


--
-- Name: staging_kunjungan_raw id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staging_kunjungan_raw ALTER COLUMN id SET DEFAULT nextval('public.staging_kunjungan_raw_id_seq'::regclass);


--
-- Name: user_journey_log journey_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journey_log ALTER COLUMN journey_id SET DEFAULT nextval('public.user_journey_log_journey_id_seq'::regclass);


--
-- Name: dashboard_performance_log dashboard_performance_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dashboard_performance_log
    ADD CONSTRAINT dashboard_performance_log_pkey PRIMARY KEY (log_id);


--
-- Name: dim_objek_wisata dim_objek_wisata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_objek_wisata
    ADD CONSTRAINT dim_objek_wisata_pkey PRIMARY KEY (objek_wisata_id);


--
-- Name: dim_price dim_price_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_price
    ADD CONSTRAINT dim_price_pkey PRIMARY KEY (price_id);


--
-- Name: dim_time dim_time_periode_data_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_time
    ADD CONSTRAINT dim_time_periode_data_key UNIQUE (periode);


--
-- Name: dim_time dim_time_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_time
    ADD CONSTRAINT dim_time_pkey PRIMARY KEY (time_id);


--
-- Name: dim_wisatawan dim_wisatawan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_wisatawan
    ADD CONSTRAINT dim_wisatawan_pkey PRIMARY KEY (wisatawan_id);


--
-- Name: fact_kunjungan fact_kunjungan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT fact_kunjungan_pkey PRIMARY KEY (fact_id);


--
-- Name: staging_harga_tiket_raw staging_harga_tiket_raw_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staging_harga_tiket_raw
    ADD CONSTRAINT staging_harga_tiket_raw_pkey PRIMARY KEY (id);


--
-- Name: staging_kunjungan_raw staging_kunjungan_raw_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staging_kunjungan_raw
    ADD CONSTRAINT staging_kunjungan_raw_pkey PRIMARY KEY (id);


--
-- Name: dim_price unique_objek_price; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_price
    ADD CONSTRAINT unique_objek_price UNIQUE (objek_wisata_id);


--
-- Name: fact_kunjungan uq_fact_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT uq_fact_key UNIQUE (time_id, objek_wisata_id, wisatawan_id);


--
-- Name: user_journey_log user_journey_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journey_log
    ADD CONSTRAINT user_journey_log_pkey PRIMARY KEY (journey_id);


--
-- Name: idx_dim_objek_nama; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dim_objek_nama ON public.dim_objek_wisata USING btree (nama_objek);


--
-- Name: idx_dim_time_periode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dim_time_periode ON public.dim_time USING btree (periode);


--
-- Name: idx_fact_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fact_created ON public.fact_kunjungan USING btree (created_at);


--
-- Name: idx_fact_objek; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fact_objek ON public.fact_kunjungan USING btree (objek_wisata_id);


--
-- Name: idx_fact_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fact_time ON public.fact_kunjungan USING btree (time_id);


--
-- Name: idx_fact_wisatawan; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fact_wisatawan ON public.fact_kunjungan USING btree (wisatawan_id);


--
-- Name: idx_journey_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_journey_session ON public.user_journey_log USING btree (session_id);


--
-- Name: idx_journey_stage; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_journey_stage ON public.user_journey_log USING btree (stage);


--
-- Name: idx_journey_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_journey_timestamp ON public.user_journey_log USING btree ("timestamp");


--
-- Name: idx_perf_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_perf_session ON public.dashboard_performance_log USING btree (session_id);


--
-- Name: idx_perf_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_perf_status ON public.dashboard_performance_log USING btree (status);


--
-- Name: idx_perf_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_perf_timestamp ON public.dashboard_performance_log USING btree ("timestamp");


--
-- Name: idx_price_objek; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_price_objek ON public.dim_price USING btree (objek_wisata_id);


--
-- Name: idx_staging_harga_nama; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_staging_harga_nama ON public.staging_harga_tiket_raw USING btree (nama_objek_wisata);


--
-- Name: idx_staging_kunjungan_obyek; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_staging_kunjungan_obyek ON public.staging_kunjungan_raw USING btree (obyek_wisata);


--
-- Name: idx_staging_kunjungan_processed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_staging_kunjungan_processed ON public.staging_kunjungan_raw USING btree (is_processed);


--
-- Name: fact_kunjungan fk_fact_objek; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT fk_fact_objek FOREIGN KEY (objek_wisata_id) REFERENCES public.dim_objek_wisata(objek_wisata_id) ON DELETE CASCADE;


--
-- Name: fact_kunjungan fk_fact_time; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT fk_fact_time FOREIGN KEY (time_id) REFERENCES public.dim_time(time_id) ON DELETE CASCADE;


--
-- Name: fact_kunjungan fk_fact_wisatawan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT fk_fact_wisatawan FOREIGN KEY (wisatawan_id) REFERENCES public.dim_wisatawan(wisatawan_id) ON DELETE CASCADE;


--
-- Name: dim_price fk_objek_wisata; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_price
    ADD CONSTRAINT fk_objek_wisata FOREIGN KEY (objek_wisata_id) REFERENCES public.dim_objek_wisata(objek_wisata_id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict pLyWuCromGKZOdcLSOgvlgWf3OApAXaBIAa19IBel6vr2TpcYqDzaaQTKNlxox2

