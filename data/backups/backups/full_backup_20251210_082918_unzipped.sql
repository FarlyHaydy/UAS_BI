--
-- PostgreSQL database dump
--

\restrict GLz27nDaB13jadpAJLbGTzAM2OPfrBi22n2KVroKHy9MSBFxyS1ffucKP8EDRf4

-- Dumped from database version 18.1
-- Dumped by pg_dump version 18.1 (Debian 18.1-1.pgdg13+2)

-- Started on 2025-12-10 08:29:18 WITA

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
-- TOC entry 220 (class 1259 OID 16386)
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
-- TOC entry 219 (class 1259 OID 16385)
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
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 219
-- Name: dashboard_performance_log_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dashboard_performance_log_log_id_seq OWNED BY public.dashboard_performance_log.log_id;


--
-- TOC entry 230 (class 1259 OID 16445)
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
-- TOC entry 229 (class 1259 OID 16444)
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
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 229
-- Name: dim_objek_wisata_objek_wisata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_objek_wisata_objek_wisata_id_seq OWNED BY public.dim_objek_wisata.objek_wisata_id;


--
-- TOC entry 234 (class 1259 OID 16467)
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
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE dim_price; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.dim_price IS 'Dimension table untuk harga tiket objek wisata';


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN dim_price.harga_tiket_dewasa; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dim_price.harga_tiket_dewasa IS 'Harga tiket untuk dewasa (sama untuk WNI & WNA)';


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN dim_price.harga_tiket_anak; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dim_price.harga_tiket_anak IS 'Harga tiket untuk anak (sama untuk WNI & WNA)';


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 234
-- Name: COLUMN dim_price.sumber_platform; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.dim_price.sumber_platform IS 'Sumber data harga (Website Resmi, Survey Manual, dll)';


--
-- TOC entry 233 (class 1259 OID 16466)
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
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 233
-- Name: dim_price_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_price_price_id_seq OWNED BY public.dim_price.price_id;


--
-- TOC entry 228 (class 1259 OID 16431)
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
-- TOC entry 227 (class 1259 OID 16430)
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
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 227
-- Name: dim_time_time_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_time_time_id_seq OWNED BY public.dim_time.time_id;


--
-- TOC entry 232 (class 1259 OID 16458)
-- Name: dim_wisatawan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dim_wisatawan (
    wisatawan_id integer NOT NULL,
    jenis_wisatawan character varying(50),
    kode_jenis character varying(5),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- TOC entry 231 (class 1259 OID 16457)
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
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 231
-- Name: dim_wisatawan_wisatawan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dim_wisatawan_wisatawan_id_seq OWNED BY public.dim_wisatawan.wisatawan_id;


--
-- TOC entry 236 (class 1259 OID 16482)
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
-- TOC entry 235 (class 1259 OID 16481)
-- Name: fact_kunjungan_fact_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fact_kunjungan_fact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 235
-- Name: fact_kunjungan_fact_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fact_kunjungan_fact_id_seq OWNED BY public.fact_kunjungan.fact_id;


--
-- TOC entry 226 (class 1259 OID 16422)
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
-- TOC entry 225 (class 1259 OID 16421)
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
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 225
-- Name: staging_harga_tiket_raw_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.staging_harga_tiket_raw_id_seq OWNED BY public.staging_harga_tiket_raw.id;


--
-- TOC entry 224 (class 1259 OID 16410)
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
-- TOC entry 223 (class 1259 OID 16409)
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
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 223
-- Name: staging_kunjungan_raw_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.staging_kunjungan_raw_id_seq OWNED BY public.staging_kunjungan_raw.id;


--
-- TOC entry 222 (class 1259 OID 16400)
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
-- TOC entry 221 (class 1259 OID 16399)
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
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 221
-- Name: user_journey_log_journey_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_journey_log_journey_id_seq OWNED BY public.user_journey_log.journey_id;


--
-- TOC entry 239 (class 1259 OID 16545)
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
-- TOC entry 238 (class 1259 OID 16540)
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
-- TOC entry 237 (class 1259 OID 16535)
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
-- TOC entry 3338 (class 2604 OID 16389)
-- Name: dashboard_performance_log log_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dashboard_performance_log ALTER COLUMN log_id SET DEFAULT nextval('public.dashboard_performance_log_log_id_seq'::regclass);


--
-- TOC entry 3353 (class 2604 OID 16448)
-- Name: dim_objek_wisata objek_wisata_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_objek_wisata ALTER COLUMN objek_wisata_id SET DEFAULT nextval('public.dim_objek_wisata_objek_wisata_id_seq'::regclass);


--
-- TOC entry 3358 (class 2604 OID 16470)
-- Name: dim_price price_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_price ALTER COLUMN price_id SET DEFAULT nextval('public.dim_price_price_id_seq'::regclass);


--
-- TOC entry 3351 (class 2604 OID 16434)
-- Name: dim_time time_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_time ALTER COLUMN time_id SET DEFAULT nextval('public.dim_time_time_id_seq'::regclass);


--
-- TOC entry 3356 (class 2604 OID 16461)
-- Name: dim_wisatawan wisatawan_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_wisatawan ALTER COLUMN wisatawan_id SET DEFAULT nextval('public.dim_wisatawan_wisatawan_id_seq'::regclass);


--
-- TOC entry 3363 (class 2604 OID 16485)
-- Name: fact_kunjungan fact_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan ALTER COLUMN fact_id SET DEFAULT nextval('public.fact_kunjungan_fact_id_seq'::regclass);


--
-- TOC entry 3349 (class 2604 OID 16425)
-- Name: staging_harga_tiket_raw id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staging_harga_tiket_raw ALTER COLUMN id SET DEFAULT nextval('public.staging_harga_tiket_raw_id_seq'::regclass);


--
-- TOC entry 3346 (class 2604 OID 16413)
-- Name: staging_kunjungan_raw id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staging_kunjungan_raw ALTER COLUMN id SET DEFAULT nextval('public.staging_kunjungan_raw_id_seq'::regclass);


--
-- TOC entry 3343 (class 2604 OID 16403)
-- Name: user_journey_log journey_id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journey_log ALTER COLUMN journey_id SET DEFAULT nextval('public.user_journey_log_journey_id_seq'::regclass);


--
-- TOC entry 3563 (class 0 OID 16386)
-- Dependencies: 220
-- Data for Name: dashboard_performance_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dashboard_performance_log (log_id, session_id, "timestamp", load_time_seconds, query_time_seconds, render_time_seconds, page_views, interactions_count, dwell_time_seconds, error_occurred, error_message, user_agent, screen_width, screen_height, filters_applied, status, created_at) FROM stdin;
1	67d0bbcb-e7d9-4eb9-a8c5-f0308e1c3f6d	2025-12-09 02:09:35.264998	0.05	0.04	0.32	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:09:35.264998
2	67d0bbcb-e7d9-4eb9-a8c5-f0308e1c3f6d	2025-12-09 02:10:22.799805	0.00	0.04	0.02	2	1	48	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:22.799805
3	67d0bbcb-e7d9-4eb9-a8c5-f0308e1c3f6d	2025-12-09 02:10:26.152926	0.00	0.04	0.02	3	2	51	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:26.152926
4	7769505b-794a-49f8-b6ac-1ae73fb2a680	2025-12-09 02:10:27.477416	0.00	0.04	0.02	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:27.477416
5	7769505b-794a-49f8-b6ac-1ae73fb2a680	2025-12-09 02:10:32.95877	0.01	0.04	0.03	2	1	5	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara"]}	success	2025-12-09 02:10:32.95877
6	7769505b-794a-49f8-b6ac-1ae73fb2a680	2025-12-09 02:10:34.826004	0.00	0.04	0.02	3	2	7	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:34.826004
7	7769505b-794a-49f8-b6ac-1ae73fb2a680	2025-12-09 02:10:38.182829	0.00	0.04	0.01	4	2	10	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:38.182829
8	994dae3e-b022-41dc-9a9e-18301fecf7c7	2025-12-09 02:10:43.138853	0.00	0.04	0.02	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:43.138853
9	994dae3e-b022-41dc-9a9e-18301fecf7c7	2025-12-09 02:10:50.398655	0.00	0.04	0.02	2	1	7	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:50.398655
10	994dae3e-b022-41dc-9a9e-18301fecf7c7	2025-12-09 02:10:52.315812	0.00	0.04	0.03	3	2	9	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:52.315812
11	1853eef8-f5dd-4503-837a-6677bcb21fa3	2025-12-09 02:10:54.536569	0.00	0.04	0.02	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:54.536569
12	b721753c-6d1c-4f60-a548-100855df32c9	2025-12-09 02:10:55.817806	0.00	0.04	0.02	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:10:55.817806
13	b721753c-6d1c-4f60-a548-100855df32c9	2025-12-09 02:11:44.938481	0.00	0.04	0.02	2	1	49	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:11:44.938481
14	b721753c-6d1c-4f60-a548-100855df32c9	2025-12-09 02:11:47.87802	0.00	0.04	0.02	3	2	52	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:11:47.87802
15	b721753c-6d1c-4f60-a548-100855df32c9	2025-12-09 02:11:57.212167	0.00	0.04	0.02	4	2	61	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:11:57.212167
16	c737ac54-60ef-43f9-a6a3-a31cdc3ec9a6	2025-12-09 02:11:58.617683	0.00	0.04	0.02	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:11:58.617683
17	3ead2969-b3c6-4e8d-82b1-e1a94e38adf9	2025-12-09 02:12:03.580904	0.00	0.04	0.02	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:12:03.580904
18	3ead2969-b3c6-4e8d-82b1-e1a94e38adf9	2025-12-09 02:12:09.591619	0.00	0.04	0.01	2	1	6	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:12:09.591619
19	3ead2969-b3c6-4e8d-82b1-e1a94e38adf9	2025-12-09 02:12:24.770177	0.00	0.04	0.02	3	1	21	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:12:24.770177
20	11442bc9-b334-46bc-9870-6c5cec0ffb93	2025-12-09 02:12:27.465544	0.00	0.04	0.02	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:12:27.465544
21	11442bc9-b334-46bc-9870-6c5cec0ffb93	2025-12-09 02:59:07.814029	0.03	0.02	0.05	2	1	2800	f	\N	\N	\N	\N	{"year": "2025", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 02:59:07.814029
22	4d33f9ef-0170-4279-992b-97c65a5fd6ff	2025-12-09 03:04:20.19407	0.00	0.02	0.02	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 03:04:20.19407
23	a1bf21b9-354e-409c-bab5-ee9c4e425ce1	2025-12-09 03:45:03.091082	0.02	0.01	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 03:45:03.091082
24	4d33f9ef-0170-4279-992b-97c65a5fd6ff	2025-12-09 03:45:53.171251	0.00	0.01	0.02	2	1	2493	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 03:45:53.171251
25	55e319fc-0f15-498d-a428-b25e05360c5e	2025-12-09 06:30:16.096736	0.16	0.13	0.29	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 06:30:16.096736
26	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 06:33:36.527292	0.01	0.13	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 06:33:36.527292
27	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 06:41:25.488674	0.01	0.13	0.04	2	0	469	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 06:41:25.488674
28	55e319fc-0f15-498d-a428-b25e05360c5e	2025-12-09 06:41:25.665564	0.02	0.13	0.10	2	0	670	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 06:41:25.665564
29	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 07:04:13.853286	0.02	0.01	0.03	3	0	1837	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 07:04:13.853286
30	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 07:12:33.360929	0.01	0.01	0.02	4	0	2336	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 07:12:33.360929
31	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 07:23:01.943331	0.03	0.02	0.06	5	1	2965	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 07:23:01.943331
32	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 07:23:04.937279	0.02	0.02	0.04	6	2	2968	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 5, 6, 7, 4], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 07:23:04.937279
33	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 07:23:06.226633	0.00	0.02	0.03	7	3	2969	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 5, 6, 7, 4, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 07:23:06.226633
34	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 07:49:47.465292	0.02	0.01	0.03	8	3	4570	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 5, 6, 7, 4, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 07:49:47.465292
35	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 13:53:59.405425	0.03	0.01	0.04	9	3	26422	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 5, 6, 7, 4, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 13:53:59.405425
36	77979e84-4e02-48a1-8038-07fa9a9e29cf	2025-12-09 14:29:41.837929	0.03	0.01	0.04	10	3	28565	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 5, 6, 7, 4, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 14:29:41.837929
37	38a90d35-b7c7-41d8-a14e-1fb7584d782b	2025-12-09 14:30:19.687787	0.01	0.01	0.05	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 14:30:19.687787
38	d172adb2-978b-43be-a8da-283c98a8608e	2025-12-09 14:32:55.632389	0.08	0.06	0.23	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 14:32:55.632389
39	cb2cb0c5-af14-4532-8e65-4609df6c99e9	2025-12-09 14:33:42.36706	0.05	0.04	0.32	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 14:33:42.36706
40	b6880fbc-f576-4e5b-998f-917c9658dfee	2025-12-09 14:33:42.367913	0.00	0.04	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 14:33:42.367913
41	841df00d-b17f-43de-8c8e-cd6d02f029bf	2025-12-09 14:34:42.417938	0.06	0.05	0.29	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 14:34:42.417938
42	2b484e2f-1f40-4354-92b9-fcfe5cf40ba6	2025-12-09 14:34:53.925356	0.00	0.05	0.03	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 14:34:53.925356
43	7d593bc5-9dbe-45f2-a444-a4b4028e4307	2025-12-09 14:35:16.440979	0.01	0.05	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 14:35:16.440979
44	7d593bc5-9dbe-45f2-a444-a4b4028e4307	2025-12-09 15:23:14.165954	0.03	0.02	0.05	2	0	2877	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 15:23:14.165954
45	0bf0cd12-e087-470d-8243-746e9d842b83	2025-12-09 15:23:38.650043	0.00	0.02	0.03	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 15:23:38.650043
46	0bf0cd12-e087-470d-8243-746e9d842b83	2025-12-09 18:33:45.126504	0.17	0.13	0.20	2	0	11406	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:33:45.126504
47	0bf0cd12-e087-470d-8243-746e9d842b83	2025-12-09 18:33:49.785729	0.00	0.13	0.02	3	1	11411	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:33:49.785729
48	0bf0cd12-e087-470d-8243-746e9d842b83	2025-12-09 18:33:52.276536	0.00	0.13	0.03	4	2	11413	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:33:52.276536
49	4a1f081d-1eef-4877-b7f2-dc9b2035f226	2025-12-09 18:42:13.110211	0.01	0.13	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:42:13.110211
50	e5f70ad8-5f45-4ec6-9474-70e7000d7a1e	2025-12-09 18:45:35.696076	0.02	0.01	0.05	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:45:35.696076
51	2d199208-5be1-4f95-b43a-791b71b9cc6e	2025-12-09 18:46:44.870164	0.01	0.01	0.08	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:46:44.870164
52	ba64c2f7-e108-49d8-a399-202491c780e9	2025-12-09 18:47:31.123207	0.00	0.01	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:47:31.123207
53	d9531051-5726-4aa3-9035-55bfb822d9de	2025-12-09 18:48:54.415864	0.01	0.01	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:48:54.415864
54	6e0ba51d-dcad-4b25-aaf1-9ebb048352c9	2025-12-09 18:49:43.203357	0.00	0.01	0.03	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:49:43.203357
55	d2bcff96-8345-4663-82d0-eeb8e0c3eeb0	2025-12-09 18:49:53.518007	0.00	0.01	0.03	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:49:53.518007
56	e95e65d5-b480-408c-aba9-2863d3a58a34	2025-12-09 18:50:41.98079	0.06	0.04	0.30	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:50:41.98079
57	848ed285-0955-4b1f-a397-ee9496d37935	2025-12-09 18:50:42.0033	0.05	0.04	0.10	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:50:42.0033
58	bab7f8e8-abd5-4e8e-8b52-7b00e34d83bd	2025-12-09 18:50:42.539561	0.00	0.04	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:50:42.539561
59	d3e04485-0f04-4715-b40d-b820dc3a49e8	2025-12-09 18:55:19.71914	0.01	0.04	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:55:19.71914
60	9c605443-4a75-4dce-91f7-ce5ea4538d9f	2025-12-09 18:55:43.354667	0.00	0.04	0.03	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:55:43.354667
61	dc11edd2-fb36-4370-91d4-f1b81c6ab49e	2025-12-09 18:55:43.363116	0.05	0.04	0.26	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:55:43.363116
62	361f700e-f14e-4d95-aef7-6d3a072e003a	2025-12-09 18:55:44.60203	0.00	0.04	0.05	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:55:44.60203
63	73950bb8-fad0-41f2-b680-bea7581253a5	2025-12-09 18:56:13.497543	0.01	0.04	0.03	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:56:13.497543
64	051aa330-923c-4d16-8fad-c18d768f57df	2025-12-09 18:56:29.414581	0.00	0.04	0.03	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 18:56:29.414581
65	ab4e95de-8974-4871-be97-5ba24c077033	2025-12-09 19:00:40.777364	0.06	0.05	0.27	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 19:00:40.777364
66	ab4e95de-8974-4871-be97-5ba24c077033	2025-12-09 19:01:05.3578	0.01	0.05	0.03	2	1	24	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 19:01:05.3578
67	ab4e95de-8974-4871-be97-5ba24c077033	2025-12-09 19:01:08.487425	0.00	0.05	0.03	3	2	28	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 19:01:08.487425
68	79a866d7-5b5b-4dac-b1b1-dbeaaf84429b	2025-12-09 19:01:13.70773	0.00	0.05	0.03	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 19:01:13.70773
69	ff34dbe4-c948-4233-83ec-23e2cf074804	2025-12-09 19:02:14.10882	0.01	0.05	0.04	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 19:02:14.10882
70	ff34dbe4-c948-4233-83ec-23e2cf074804	2025-12-09 19:06:14.551802	0.01	0.05	0.02	2	0	240	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Mancanegara", "Wisatawan Nusantara"]}	success	2025-12-09 19:06:14.551802
71	0202aa3a-3fea-4b1e-bd83-f110dbd0803b	2025-12-09 19:11:44.22323	0.05	0.04	0.24	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Nusantara", "Wisatawan Mancanegara"]}	success	2025-12-09 19:11:44.22323
72	aab0eb38-d69a-40d9-8208-ac938d3516c4	2025-12-09 19:12:06.70762	0.01	0.04	0.05	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Nusantara", "Wisatawan Mancanegara"]}	success	2025-12-09 19:12:06.70762
73	cca5aed7-8341-4c6f-9278-2c706b55979f	2025-12-09 19:12:28.150809	0.00	0.04	0.03	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Nusantara", "Wisatawan Mancanegara"]}	success	2025-12-09 19:12:28.150809
74	b31fc00a-f491-4df2-95a2-350596c576a0	2025-12-09 19:12:59.237328	0.00	0.04	0.05	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Nusantara", "Wisatawan Mancanegara"]}	success	2025-12-09 19:12:59.237328
75	65198f5d-1d71-4fd3-b813-05cbb11f0418	2025-12-09 19:26:59.855359	0.05	0.03	0.10	1	0	0	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Nusantara", "Wisatawan Mancanegara"]}	success	2025-12-09 19:26:59.855359
76	65198f5d-1d71-4fd3-b813-05cbb11f0418	2025-12-10 00:23:26.406538	0.00	0.03	0.01	2	0	17786	f	\N	\N	\N	\N	{"year": "Semua", "months": [1, 2, 3, 4, 5, 6, 7, 8], "wilayah": ["Jakarta Barat", "Jakarta Pusat", "Jakarta Selatan", "Jakarta Timur", "Jakarta Utara", "Kepulauan Seribu"], "wisatawan": ["Wisatawan Nusantara", "Wisatawan Mancanegara"]}	success	2025-12-10 00:23:26.406538
\.


--
-- TOC entry 3573 (class 0 OID 16445)
-- Dependencies: 230
-- Data for Name: dim_objek_wisata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dim_objek_wisata (objek_wisata_id, nama_objek, alamat, longitude, latitude, wilayah, created_at, updated_at) FROM stdin;
1	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Kepulauan Seribu	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
2	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Jakarta Selatan	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
3	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
4	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Jakarta Selatan	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
5	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Jakarta Utara	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
6	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
7	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
8	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
9	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Jakarta Barat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
10	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Jakarta Selatan	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
11	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Jakarta Barat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
12	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
13	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
14	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Jakarta Timur	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
15	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Kepulauan Seribu	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
16	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
17	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Jakarta Utara	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
18	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Jakarta Selatan	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
19	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Jakarta Utara	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
20	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Jakarta Timur	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
21	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
22	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
23	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Jakarta Selatan	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
24	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
25	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Jakarta Barat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
26	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Jakarta Utara	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
27	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Jakarta Pusat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
28	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Jakarta Barat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
29	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Jakarta Barat	2025-12-09 02:09:15.462392	2025-12-09 02:09:15.462392
\.


--
-- TOC entry 3577 (class 0 OID 16467)
-- Dependencies: 234
-- Data for Name: dim_price; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dim_price (price_id, objek_wisata_id, harga_tiket_dewasa, harga_tiket_anak, mata_uang, sumber_platform, tanggal_update, created_at) FROM stdin;
1	11	0	0	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.620119
2	1	0	0	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.620119
3	27	20000	10000	IDR	Website Resmi	2025-12-09	2025-12-09 19:12:46.620119
4	15	0	0	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
5	17	5000	3000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
6	10	10000	5000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
7	7	2000	1000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
8	6	5000	2000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
9	24	0	0	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
10	8	10000	5000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
11	12	0	0	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
12	3	5000	3000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
13	18	5000	2000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
14	25	5000	3000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
15	9	5000	3000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
16	21	5000	2000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
17	28	5000	3000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
18	29	5000	3000	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.620119
19	20	0	0	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.620119
20	5	5000	3000	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.620119
21	4	0	0	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.620119
22	22	12000	7000	IDR	Website Resmi	2025-12-09	2025-12-09 19:12:46.620119
23	16	0	0	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.620119
24	23	0	0	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.620119
25	19	0	0	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.620119
26	26	25000	25000	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:12:46.620119
27	13	0	0	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:12:46.620119
28	2	4000	3000	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:12:46.620119
29	14	15000	10000	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:12:46.620119
\.


--
-- TOC entry 3571 (class 0 OID 16431)
-- Dependencies: 228
-- Data for Name: dim_time; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dim_time (time_id, periode, bulan, tahun, kuartal, created_at) FROM stdin;
1	202507	7	2025	3	2025-12-09 02:09:15.442241
2	202502	2	2025	1	2025-12-09 02:09:15.442241
3	202505	5	2025	2	2025-12-09 02:09:15.442241
4	202504	4	2025	2	2025-12-09 02:09:15.442241
5	202508	8	2025	3	2025-12-09 02:09:15.442241
6	202501	1	2025	1	2025-12-09 02:09:15.442241
7	202503	3	2025	1	2025-12-09 02:09:15.442241
8	202506	6	2025	2	2025-12-09 02:09:15.442241
\.


--
-- TOC entry 3575 (class 0 OID 16458)
-- Dependencies: 232
-- Data for Name: dim_wisatawan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dim_wisatawan (wisatawan_id, jenis_wisatawan, kode_jenis, created_at) FROM stdin;
1	Wisatawan Nusantara	WNI	2025-12-09 02:08:54.233948
2	Wisatawan Mancanegara	WNA	2025-12-09 02:08:54.233948
\.


--
-- TOC entry 3579 (class 0 OID 16482)
-- Dependencies: 236
-- Data for Name: fact_kunjungan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.fact_kunjungan (fact_id, time_id, objek_wisata_id, wisatawan_id, jumlah_kunjungan, created_at, updated_at) FROM stdin;
358	1	24	1	65	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
309	1	24	2	3	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
104	1	25	1	37931	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
352	1	25	2	3304	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
300	1	26	1	793791	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
395	1	27	1	483014	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
367	1	27	2	5902	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
267	1	28	1	1645	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
121	1	28	2	300	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
195	1	29	1	32710	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
18	1	29	2	1368	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
136	2	1	1	16773	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
149	2	1	2	1031	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
185	2	2	1	237150	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
57	2	2	2	282	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
304	2	3	1	330	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
208	2	3	2	9	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
50	2	4	1	26088	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
338	2	4	2	21	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
3	2	5	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
227	2	5	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
332	2	6	1	5156	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
113	2	6	2	18	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
180	2	7	1	1032	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
152	2	7	2	5	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
305	2	8	1	59454	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
246	2	8	2	5674	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
382	2	9	1	12878	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
56	2	9	2	388	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
258	2	10	1	1006	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
202	2	10	2	6	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
175	2	11	1	186237	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
155	2	11	2	4086	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
144	2	12	1	1994	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
379	2	12	2	74	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
35	2	13	1	25457	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
206	2	14	1	291801	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
211	2	15	1	398	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
154	2	15	2	28	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
22	2	16	1	39051	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
183	2	17	1	3256	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
64	2	17	2	174	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
373	2	18	1	1950	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
189	2	19	1	673	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
293	2	20	1	58800	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
301	2	21	1	1096	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
213	2	21	2	2	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
231	2	22	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
383	2	22	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
13	2	23	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
128	2	24	1	269	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
363	2	24	2	3	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
12	2	25	1	28763	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
240	2	25	2	1260	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
165	2	26	1	934260	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
264	2	27	1	324043	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
364	2	27	2	4963	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
89	2	28	1	3442	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
287	2	28	2	135	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
170	2	29	1	35227	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
234	2	29	2	1290	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
82	3	1	1	51667	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
108	3	1	2	1431	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
368	3	2	1	463797	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
88	3	2	2	216	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
27	3	3	1	477	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
249	3	3	2	26	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
75	3	4	1	37363	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
125	3	4	2	16	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
216	3	5	1	1900	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
204	3	5	2	407	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
103	3	6	1	4404	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
6	3	6	2	28	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
317	3	7	1	1166	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
288	3	7	2	6	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
162	3	8	1	84273	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
45	3	8	2	1143	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
95	3	9	1	11424	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
212	3	9	2	464	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
141	3	10	1	668	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
197	3	10	2	3	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
153	3	11	1	177784	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
299	3	11	2	3360	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
97	3	12	1	1863	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
348	3	12	2	63	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
38	3	13	1	21727	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
266	3	14	1	258260	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
235	3	15	1	1308	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
253	3	15	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
321	3	16	1	45511	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
245	3	17	1	3537	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
375	3	17	2	354	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
291	3	18	1	2020	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
297	3	19	1	990	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
343	3	20	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
29	3	21	1	1090	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
307	3	21	2	1	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
65	3	22	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
46	3	22	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
319	3	23	1	125091	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
263	3	24	1	715	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
118	3	24	2	1	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
157	3	25	1	37267	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
256	3	25	2	2393	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
238	3	26	1	732626	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
192	3	27	1	351648	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
193	3	27	2	5313	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
194	3	28	1	2333	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
351	3	28	2	120	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
326	3	29	1	35328	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
107	3	29	2	769	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
339	4	1	1	63936	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
316	4	1	2	1217	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
86	4	2	1	806612	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
93	4	2	2	247	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
327	4	3	1	424	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
2	4	3	2	7	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
232	4	4	1	36170	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
24	4	4	2	18	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
280	4	5	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
333	4	5	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
71	4	6	1	3922	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
271	4	6	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
85	4	7	1	592	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
80	4	7	2	1	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
53	4	8	1	85000	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
77	4	8	2	4920	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
70	4	9	1	14191	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
122	4	9	2	400	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
7	4	10	1	287	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
30	4	10	2	4	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
87	4	11	1	741745	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
143	4	11	2	18604	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
106	4	12	1	1289	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
184	4	12	2	61	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
44	4	13	1	15360	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
260	4	14	1	353954	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
132	4	15	1	2007	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
353	4	15	2	1	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
199	4	16	1	34689	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
99	4	17	1	4048	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
140	4	17	2	320	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
111	4	18	1	1630	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
276	4	19	1	1940	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
329	4	20	1	97323	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
289	4	21	1	769	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
337	4	21	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
207	4	22	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
285	4	22	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
257	4	23	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
313	4	24	1	95	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
8	4	24	2	3	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
244	4	25	1	37584	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
109	4	25	2	1613	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
92	4	26	1	914254	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
248	4	27	1	760112	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
310	4	27	2	6753	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
96	4	28	1	2627	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
360	4	28	2	72	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
115	4	29	1	41637	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
296	4	29	2	1364	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
28	5	1	1	30953	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
365	5	1	2	1826	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
320	5	2	1	269418	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
286	5	2	2	264	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
323	5	3	1	233	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
228	5	3	2	21	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
33	5	4	1	27228	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
63	5	4	2	19	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
275	5	5	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
229	5	5	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
23	5	6	1	2788	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
372	5	6	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
224	5	7	1	760	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
277	5	7	2	16	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
274	5	8	1	35353	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
394	5	8	2	7098	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
230	5	9	1	7419	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
282	5	9	2	842	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
341	5	10	1	296	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
32	5	10	2	12	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
233	5	11	1	174862	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
61	5	11	2	6545	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
17	5	12	1	3771	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
284	5	12	2	40	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
55	5	13	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
190	5	14	1	182893	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
236	5	15	1	1908	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
79	5	15	2	17	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
359	5	16	1	39578	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
102	5	17	1	4720	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
34	5	17	2	548	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
172	5	18	1	2685	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
335	5	19	1	1310	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
150	5	20	1	50178	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
215	5	21	1	798	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
72	5	21	2	7	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
138	5	22	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
318	5	22	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
324	5	23	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
90	5	24	1	206	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
210	5	24	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
25	5	25	1	19175	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
101	5	25	2	2878	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
386	5	26	1	717446	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
325	5	27	1	579917	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
294	5	27	2	7849	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
295	5	28	1	2067	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
100	5	28	2	267	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
314	5	29	1	15216	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
393	5	29	2	1631	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
242	6	1	1	24712	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
331	6	1	2	1208	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
200	6	2	1	563393	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
214	6	2	2	277	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
120	6	3	1	400	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
201	6	3	2	17	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
311	6	4	1	31806	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
292	6	4	2	4	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
110	6	5	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
186	6	5	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
298	6	6	1	3012	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
178	6	6	2	26	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
168	6	7	1	738	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
47	6	7	2	5	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
66	6	8	1	83451	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
278	6	8	2	4170	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
167	6	9	1	15154	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
123	6	9	2	368	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
255	6	10	1	599	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
389	6	10	2	2	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
380	6	11	1	202461	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
127	6	11	2	4602	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
142	6	12	1	1720	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
315	6	12	2	70	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
134	6	13	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
378	6	14	1	351588	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
177	6	15	1	877	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
139	6	15	2	7	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
151	6	16	1	38007	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
41	6	17	1	2186	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
164	6	17	2	190	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
290	6	18	1	2059	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
336	6	19	1	1057	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
182	6	20	1	69748	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
176	6	21	1	1787	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
76	6	21	2	3	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
390	6	22	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
399	6	22	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
73	6	23	1	74824	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
218	6	24	1	106	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
81	6	24	2	3	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
43	6	25	1	36478	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
261	6	25	2	1371	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
237	6	26	1	760497	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
94	6	27	1	5372	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
131	6	27	2	360209	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
259	6	28	1	2152	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
78	6	28	2	78	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
220	6	29	1	23526	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
37	6	29	2	559	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
398	7	1	1	10719	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
52	7	1	2	1229	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
281	7	2	1	37287	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
74	7	2	2	118	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
322	7	3	1	183	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
145	7	3	2	12	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
31	7	4	1	8210	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
312	7	4	2	42	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
198	7	5	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
159	7	5	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
369	7	6	1	779	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
273	7	6	2	19	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
191	7	7	1	147	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
345	7	7	2	8	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
396	7	8	1	21990	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
219	7	8	2	3828	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
342	7	9	1	2073	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
40	7	9	2	216	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
306	7	10	1	129	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
171	7	10	2	2	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
252	8	6	1	2881	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
247	8	6	2	19	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
203	8	7	1	739	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
130	8	7	2	27	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
340	8	8	1	63798	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
114	8	8	2	4279	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
116	8	9	1	14871	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
126	8	9	2	489	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
146	8	10	1	442	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
62	8	10	2	3	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
147	8	11	1	211916	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
226	8	11	2	5705	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
51	8	12	1	759	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
15	8	12	2	43	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
179	8	13	1	45582	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
391	8	14	1	248533	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
135	8	15	1	1382	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
356	8	15	2	4	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
209	8	16	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
355	8	17	1	4447	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
385	8	17	2	240	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
98	8	18	1	2240	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
49	8	19	1	1105	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
251	8	20	1	49184	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
328	8	21	1	754	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
117	8	21	2	1	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
397	8	22	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
221	8	22	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
302	8	23	1	88770	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
36	8	24	1	290	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
303	8	24	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
91	8	25	1	18052	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
346	8	25	2	1204	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
376	8	26	1	776476	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
361	8	27	1	483014	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
334	8	27	2	5902	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
392	8	28	1	1816	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
173	8	28	2	98	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
112	8	29	1	36867	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
387	8	29	2	1169	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
366	1	1	1	37744	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
48	1	1	2	1672	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
243	1	2	1	468655	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
384	1	2	2	87	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
14	1	3	1	317	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
349	1	3	2	26	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
272	1	4	1	22495	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
10	1	4	2	18	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
196	1	5	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
354	1	5	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
156	1	6	1	3421	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
330	1	6	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
400	1	7	1	321	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
181	1	7	2	19	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
4	1	8	1	67125	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
39	1	8	2	6722	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
58	1	9	1	13957	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
371	1	9	2	662	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
374	1	10	1	324	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
269	1	10	2	16	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
60	1	11	1	231247	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
148	1	11	2	6523	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
166	1	12	1	499	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
222	1	12	2	72	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
205	1	13	1	22439	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
350	1	14	1	260449	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
133	1	15	1	2013	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
225	1	15	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
21	1	16	1	71137	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
161	1	17	1	3099	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
9	1	17	2	402	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
347	1	18	1	2180	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
187	1	19	1	902	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
5	1	20	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
377	1	21	1	338	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
119	1	21	2	7	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
268	1	22	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
68	1	22	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
26	1	23	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
67	7	11	1	94469	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
344	7	11	2	4466	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
129	7	12	1	575	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
262	7	12	2	62	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
362	7	13	1	15393	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
174	7	14	1	114553	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
381	7	15	1	316	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
137	7	15	2	2	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
239	7	16	1	55088	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
11	7	17	1	861	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
308	7	17	2	221	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
250	7	18	1	1420	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
69	7	19	1	176	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
16	7	20	1	73223	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
124	7	21	1	327	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
20	7	21	2	1	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
217	7	22	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
357	7	22	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
42	7	23	1	28182	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
158	7	24	1	54	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
84	7	24	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
265	7	25	1	4515	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
163	7	25	2	912	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
83	7	26	1	568580	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
54	7	27	1	64083	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
388	7	27	2	2655	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
105	7	28	1	791	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
241	7	28	2	142	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
59	7	29	1	6236	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
283	7	29	2	1065	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
160	8	1	1	41191	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
223	8	1	2	1157	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
254	8	2	1	417950	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
1	8	2	2	97	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
19	8	3	1	378	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
169	8	3	2	6	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
270	8	4	1	26071	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
370	8	4	2	7	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
188	8	5	1	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
279	8	5	2	0	2025-12-09 02:09:15.556353	2025-12-09 19:12:46.674976
\.


--
-- TOC entry 3569 (class 0 OID 16422)
-- Dependencies: 226
-- Data for Name: staging_harga_tiket_raw; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.staging_harga_tiket_raw (id, nama_objek_wisata, harga_tiket_dewasa, harga_tiket_anak, gratis, mata_uang, sumber_platform, tanggal_update, created_at) FROM stdin;
1	Kawasan Kota Tua	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 02:09:15.41065
2	Kepulauan Seribu	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 02:09:15.41065
3	Monumen Nasional	20000.00	10000.00	Tidak	IDR	Website Resmi	2025-12-09	2025-12-09 02:09:15.41065
4	Museum Arkeologi Onrust	0.00	0.00	Ya	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
5	Museum Bahari	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
6	Museum Basoeki Abdullah	10000.00	5000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
7	Museum Joang '45	2000.00	1000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
8	Museum Kebangkitan Nasional	5000.00	2000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
9	Museum Mohammad Hoesni Thamrin	0.00	0.00	Ya	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
10	Museum Nasional	10000.00	5000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
11	Museum Perumusan Naskah Proklamasi	0.00	0.00	Ya	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
12	Museum Prasasti	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
13	Museum Satria Mandala	5000.00	2000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
14	Museum Sejarah Jakarta	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
15	Museum Seni Rupa dan Keramik	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
16	Museum Sumpah Pemuda	5000.00	2000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
17	Museum Tekstil	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
18	Museum Wayang	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 02:09:15.41065
19	Old Shanghai	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 02:09:15.41065
20	Pelabuhan Sunda Kelapa	5000.00	3000.00	Tidak	IDR	Survey Manual	2025-12-09	2025-12-09 02:09:15.41065
21	Perkampungan Budaya Betawi Setu Babakan	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 02:09:15.41065
22	Planetarium	12000.00	7000.00	Tidak	IDR	Website Resmi	2025-12-09	2025-12-09 02:09:15.41065
23	Pos Bloc	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 02:09:15.41065
24	Ruang Terbuka Hijau Tebet Eco Park	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 02:09:15.41065
25	Rumah Si Pitung (Situs Marunda)	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 02:09:15.41065
26	Taman Impian Jaya Ancol	25000.00	25000.00	Tidak	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 02:09:15.41065
27	Taman Lapangan Banteng	0.00	0.00	Ya	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 02:09:15.41065
28	Taman Marga Satwa Ragunan	4000.00	3000.00	Tidak	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 02:09:15.41065
29	Taman Mini Indonesia Indah	15000.00	10000.00	Tidak	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 02:09:15.41065
30	Kawasan Kota Tua	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:01:53.27719
31	Kepulauan Seribu	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:01:53.27719
32	Monumen Nasional	20000.00	10000.00	Tidak	IDR	Website Resmi	2025-12-09	2025-12-09 19:01:53.27719
33	Museum Arkeologi Onrust	0.00	0.00	Ya	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
34	Museum Bahari	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
35	Museum Basoeki Abdullah	10000.00	5000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
36	Museum Joang '45	2000.00	1000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
37	Museum Kebangkitan Nasional	5000.00	2000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
38	Museum Mohammad Hoesni Thamrin	0.00	0.00	Ya	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
39	Museum Nasional	10000.00	5000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
40	Museum Perumusan Naskah Proklamasi	0.00	0.00	Ya	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
41	Museum Prasasti	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
42	Museum Satria Mandala	5000.00	2000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
43	Museum Sejarah Jakarta	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
44	Museum Seni Rupa dan Keramik	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
45	Museum Sumpah Pemuda	5000.00	2000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
46	Museum Tekstil	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
47	Museum Wayang	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:01:53.27719
48	Old Shanghai	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:01:53.27719
49	Pelabuhan Sunda Kelapa	5000.00	3000.00	Tidak	IDR	Survey Manual	2025-12-09	2025-12-09 19:01:53.27719
50	Perkampungan Budaya Betawi Setu Babakan	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:01:53.27719
51	Planetarium	12000.00	7000.00	Tidak	IDR	Website Resmi	2025-12-09	2025-12-09 19:01:53.27719
52	Pos Bloc	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:01:53.27719
53	Ruang Terbuka Hijau Tebet Eco Park	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:01:53.27719
54	Rumah Si Pitung (Situs Marunda)	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:01:53.27719
55	Taman Impian Jaya Ancol	25000.00	25000.00	Tidak	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:01:53.27719
56	Taman Lapangan Banteng	0.00	0.00	Ya	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:01:53.27719
57	Taman Marga Satwa Ragunan	4000.00	3000.00	Tidak	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:01:53.27719
58	Taman Mini Indonesia Indah	15000.00	10000.00	Tidak	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:01:53.27719
59	Kawasan Kota Tua	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.498755
60	Kepulauan Seribu	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.498755
61	Monumen Nasional	20000.00	10000.00	Tidak	IDR	Website Resmi	2025-12-09	2025-12-09 19:12:46.498755
62	Museum Arkeologi Onrust	0.00	0.00	Ya	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
63	Museum Bahari	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
64	Museum Basoeki Abdullah	10000.00	5000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
65	Museum Joang '45	2000.00	1000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
66	Museum Kebangkitan Nasional	5000.00	2000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
67	Museum Mohammad Hoesni Thamrin	0.00	0.00	Ya	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
68	Museum Nasional	10000.00	5000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
69	Museum Perumusan Naskah Proklamasi	0.00	0.00	Ya	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
70	Museum Prasasti	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
71	Museum Satria Mandala	5000.00	2000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
72	Museum Sejarah Jakarta	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
73	Museum Seni Rupa dan Keramik	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
74	Museum Sumpah Pemuda	5000.00	2000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
75	Museum Tekstil	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
76	Museum Wayang	5000.00	3000.00	Tidak	IDR	Website Museum Jakarta	2025-12-09	2025-12-09 19:12:46.498755
77	Old Shanghai	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.498755
78	Pelabuhan Sunda Kelapa	5000.00	3000.00	Tidak	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.498755
79	Perkampungan Budaya Betawi Setu Babakan	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.498755
80	Planetarium	12000.00	7000.00	Tidak	IDR	Website Resmi	2025-12-09	2025-12-09 19:12:46.498755
81	Pos Bloc	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.498755
82	Ruang Terbuka Hijau Tebet Eco Park	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.498755
83	Rumah Si Pitung (Situs Marunda)	0.00	0.00	Ya	IDR	Survey Manual	2025-12-09	2025-12-09 19:12:46.498755
84	Taman Impian Jaya Ancol	25000.00	25000.00	Tidak	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:12:46.498755
85	Taman Lapangan Banteng	0.00	0.00	Ya	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:12:46.498755
86	Taman Marga Satwa Ragunan	4000.00	3000.00	Tidak	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:12:46.498755
87	Taman Mini Indonesia Indah	15000.00	10000.00	Tidak	IDR	Website Resmi Pengelola	2025-12-09	2025-12-09 19:12:46.498755
\.


--
-- TOC entry 3567 (class 0 OID 16410)
-- Dependencies: 224
-- Data for Name: staging_kunjungan_raw; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.staging_kunjungan_raw (id, periode_data, obyek_wisata, alamat, longitude, latitude, jenis_wisatawan, jumlah_kunjungan, is_processed, created_at, processed_at) FROM stdin;
468	202503	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	327	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
400	202507	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
348	202508	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
1	202501	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1208	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
2	202502	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	324043	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
3	202502	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	4963	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
4	202502	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
5	202502	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
6	202502	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	25457	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
7	202502	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	39051	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
8	202502	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	59454	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
9	202502	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	5674	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
10	202502	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	1032	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
11	202502	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	5	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
12	202502	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	330	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
13	202502	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	9	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
14	202502	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	269	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
15	202502	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
16	202502	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	5156	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
17	202502	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	18	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
18	202502	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	1096	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
19	202502	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	2	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
20	202502	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1994	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
21	202502	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	74	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
22	202502	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	934260	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
23	202502	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
24	202502	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
25	202502	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	673	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
26	202502	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	3256	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
27	202502	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	174	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
28	202502	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	186237	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
29	202502	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	4086	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
30	202502	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	28763	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
31	202502	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1260	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
32	202502	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	12878	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
33	202502	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	388	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
34	202502	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	35227	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
35	202502	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1290	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
36	202502	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	3442	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
37	202502	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	135	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
38	202502	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	237150	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
39	202502	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	282	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
40	202502	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	26088	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
41	202502	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	21	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
42	202502	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
43	202502	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	1950	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
44	202502	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	1006	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
45	202502	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	6	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
46	202502	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	291801	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
47	202502	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	58800	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
48	202502	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	398	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
49	202502	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	28	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
50	202502	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	16773	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
51	202502	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1031	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
52	202503	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	64083	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
53	202503	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	2655	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
54	202503	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
55	202503	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
56	202503	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	15393	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
57	202503	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	55088	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
58	202503	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	21990	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
59	202503	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	3828	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
60	202503	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	147	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
61	202503	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	8	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
62	202503	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	183	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
63	202503	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	12	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
64	202503	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	54	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
65	202503	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
66	202503	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	779	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
67	202503	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	19	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
68	202503	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	327	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
69	202503	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	1	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
70	202503	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	575	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
71	202503	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	62	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
72	202503	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	568580	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
73	202503	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
74	202503	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
75	202503	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	176	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
76	202501	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	5372	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
77	202501	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	360209	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
78	202501	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
79	202501	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
80	202501	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
81	202501	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	38007	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
82	202501	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	83451	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
83	202501	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	4170	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
84	202501	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	738	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
85	202501	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	5	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
86	202501	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	400	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
87	202501	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	17	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
88	202501	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	106	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
89	202501	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
90	202501	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	3012	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
91	202501	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	26	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
92	202501	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	1787	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
93	202501	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	3	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
94	202501	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1720	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
95	202501	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	70	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
96	202501	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	760497	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
97	202501	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
98	202501	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
99	202501	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1057	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
100	202501	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	2186	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
101	202501	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	190	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
102	202501	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	24712	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
103	202501	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	202461	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
104	202501	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	4602	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
105	202501	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	36478	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
106	202501	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1371	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
107	202501	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	15154	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
108	202501	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	368	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
109	202501	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	23526	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
110	202501	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	559	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
111	202501	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2152	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
112	202501	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	78	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
113	202501	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	563393	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
114	202501	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	277	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
115	202501	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	31806	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
116	202501	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	4	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
117	202501	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	74824	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
118	202501	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2059	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
119	202501	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	599	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
120	202501	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	2	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
121	202501	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	351588	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
122	202501	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	69748	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
123	202501	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	877	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
124	202501	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	7	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
125	202505	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1431	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
126	202506	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	4447	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
127	202506	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	240	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
128	202506	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	211916	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
129	202506	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	5705	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
130	202506	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	18052	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
131	202506	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1204	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
132	202506	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	14871	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
133	202506	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	489	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
134	202506	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	36867	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
135	202506	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1169	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
136	202506	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	1816	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
137	202506	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	98	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
138	202506	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	417950	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
139	202506	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	97	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
140	202506	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	26071	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
141	202506	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	7	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
142	202506	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	88770	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
143	202506	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2240	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
144	202506	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	442	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
145	202506	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	3	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
146	202506	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	248533	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
147	202506	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	49184	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
148	202506	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	1382	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
149	202506	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	4	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
150	202506	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	41191	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
151	202506	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1157	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
152	202504	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	760112	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
153	202504	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	6753	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
154	202504	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
155	202504	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
156	202504	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	15360	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
157	202504	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	34689	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
158	202504	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	85000	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
159	202504	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	4920	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
160	202504	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	592	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
161	202504	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	1	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
162	202504	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	424	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
163	202504	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	7	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
164	202504	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	95	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
165	202504	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
166	202504	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	3922	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
167	202504	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
168	202504	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	769	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
169	202504	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
170	202504	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1289	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
171	202504	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	61	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
172	202504	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	914254	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
173	202504	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
174	202504	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
175	202504	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1940	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
176	202504	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	4048	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
177	202504	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	320	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
178	202504	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	741745	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
179	202504	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	18604	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
180	202504	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	37584	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
181	202504	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1613	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
182	202504	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	14191	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
183	202504	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	400	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
184	202504	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	41637	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
185	202504	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1364	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
186	202504	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2627	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
187	202504	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	72	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
188	202504	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	806612	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
189	202504	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	247	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
190	202504	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	36170	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
191	202504	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	18	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
192	202504	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
193	202504	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	1630	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
194	202504	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	287	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
195	202504	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	4	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
196	202504	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	353954	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
197	202504	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	97323	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
198	202504	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	2007	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
199	202504	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	1	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
200	202504	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	63936	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
201	202504	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1217	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
202	202506	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	483014	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
203	202506	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	5902	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
204	202506	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
205	202506	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
206	202506	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	45582	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
207	202506	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
208	202506	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	63798	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
209	202506	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	4279	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
210	202506	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	739	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
211	202506	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	27	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
212	202506	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	378	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
213	202506	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	6	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
214	202506	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	290	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
215	202506	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
216	202506	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	2881	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
217	202506	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	19	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
218	202506	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	754	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
219	202506	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	1	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
220	202506	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	759	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
221	202506	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	43	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
222	202506	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	776476	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
223	202506	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
224	202506	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
225	202506	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1105	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
226	202503	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	861	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
227	202503	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	221	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
228	202503	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	94469	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
229	202503	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	4466	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
230	202503	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	4515	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
231	202503	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	912	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
232	202503	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	2073	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
233	202503	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	216	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
234	202503	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	6236	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
235	202503	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1065	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
236	202503	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	791	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
237	202503	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	142	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
238	202503	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	37287	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
239	202503	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	118	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
240	202503	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	8210	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
241	202503	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	42	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
242	202503	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	28182	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
243	202503	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	1420	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
244	202503	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	129	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
245	202503	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	2	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
246	202503	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	114553	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
247	202503	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	73223	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
248	202503	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	316	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
249	202503	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	2	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
250	202503	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	10719	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
251	202503	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1229	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
252	202505	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	351648	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
253	202505	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	5313	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
254	202505	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
255	202505	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
256	202505	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	21727	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
257	202505	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	45511	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
258	202505	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	84273	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
259	202505	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	1143	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
260	202505	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	1166	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
261	202505	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	6	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
262	202505	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	477	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
263	202505	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	26	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
264	202505	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	715	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
265	202505	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	1	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
266	202505	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	4404	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
267	202505	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	28	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
268	202505	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	1090	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
269	202505	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	1	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
270	202505	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1863	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
271	202505	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	63	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
272	202505	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	732626	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
273	202505	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	1900	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
274	202505	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	407	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
275	202505	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	990	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
276	202505	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	3537	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
277	202505	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	354	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
278	202505	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	177784	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
279	202505	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	3360	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
280	202505	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	37267	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
281	202505	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	2393	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
282	202505	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	11424	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
283	202505	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	464	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
284	202505	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	35328	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
285	202505	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	769	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
286	202505	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2333	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
287	202505	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	120	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
288	202505	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	463797	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
289	202505	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	216	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
290	202505	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	37363	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
291	202505	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	16	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
292	202505	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	125091	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
293	202505	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2020	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
294	202505	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	668	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
295	202505	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	3	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
296	202505	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	258260	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
297	202505	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
298	202505	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	1308	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
299	202505	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
300	202505	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	51667	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
301	202507	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	402	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
302	202507	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	231247	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
303	202507	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	6523	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
304	202507	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	37931	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
305	202507	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	3304	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
306	202507	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	13957	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
307	202507	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	662	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
308	202507	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	32710	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
309	202507	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1368	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
310	202507	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	1645	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
311	202507	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	300	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
312	202507	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	468655	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
313	202507	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	87	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
314	202507	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	22495	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
315	202507	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	18	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
316	202507	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
317	202507	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2180	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
318	202507	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	324	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
319	202507	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	16	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
320	202507	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	260449	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
321	202507	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
322	202507	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	2013	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
323	202507	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
324	202507	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	37744	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
325	202508	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1826	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
326	202507	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1672	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
327	202508	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	579917	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
328	202508	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	7849	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
329	202508	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
330	202508	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
331	202508	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
332	202508	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	39578	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
333	202508	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	35353	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
334	202508	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	7098	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
335	202508	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	760	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
336	202508	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	16	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
337	202508	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	233	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
338	202508	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	21	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
339	202508	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	206	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
340	202508	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
341	202508	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	2788	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
342	202508	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
343	202508	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	798	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
344	202508	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	7	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
345	202508	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	3771	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
346	202508	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	40	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
347	202508	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	717446	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
349	202508	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
350	202508	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1310	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
351	202508	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	4720	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
352	202508	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	548	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
353	202508	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	174862	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
354	202508	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	6545	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
355	202508	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	19175	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
356	202508	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	2878	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
357	202508	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	7419	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
358	202508	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	842	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
359	202508	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	15216	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
360	202508	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1631	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
361	202508	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2067	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
362	202508	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	267	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
363	202508	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	269418	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
364	202508	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	264	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
365	202508	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	27228	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
366	202508	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	19	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
367	202508	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
368	202508	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2685	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
369	202508	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	296	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
370	202508	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	12	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
371	202508	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	182893	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
372	202508	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	50178	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
373	202508	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	1908	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
374	202508	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	17	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
375	202508	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	30953	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
376	202507	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	902	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
377	202507	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	3099	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
378	202507	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	483014	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
379	202507	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	5902	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
380	202507	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
381	202507	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
382	202507	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	22439	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
383	202507	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	71137	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
384	202507	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	67125	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
385	202507	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	6722	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
386	202507	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	321	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
387	202507	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	19	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
388	202507	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	317	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
389	202507	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	26	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
390	202507	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	65	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
391	202507	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
392	202507	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	3421	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
393	202507	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	0	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
394	202507	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	338	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
395	202507	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	7	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
396	202507	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	499	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
397	202507	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	72	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
398	202507	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	793791	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
399	202507	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 02:09:15.356456	2025-12-09 02:09:15.556353
401	202501	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1208	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
402	202502	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	324043	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
403	202502	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	4963	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
404	202502	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
405	202502	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
406	202502	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	25457	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
407	202502	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	39051	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
408	202502	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	59454	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
409	202502	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	5674	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
410	202502	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	1032	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
411	202502	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	5	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
412	202502	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	330	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
413	202502	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	9	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
414	202502	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	269	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
415	202502	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
416	202502	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	5156	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
417	202502	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	18	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
418	202502	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	1096	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
419	202502	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	2	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
420	202502	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1994	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
421	202502	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	74	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
422	202502	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	934260	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
423	202502	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
424	202502	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
425	202502	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	673	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
426	202502	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	3256	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
427	202502	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	174	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
428	202502	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	186237	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
429	202502	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	4086	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
430	202502	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	28763	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
431	202502	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1260	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
432	202502	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	12878	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
433	202502	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	388	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
434	202502	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	35227	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
435	202502	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1290	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
436	202502	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	3442	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
437	202502	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	135	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
438	202502	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	237150	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
439	202502	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	282	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
440	202502	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	26088	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
441	202502	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	21	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
442	202502	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
443	202502	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	1950	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
444	202502	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	1006	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
445	202502	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	6	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
446	202502	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	291801	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
447	202502	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	58800	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
448	202502	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	398	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
449	202502	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	28	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
450	202502	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	16773	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
451	202502	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1031	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
452	202503	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	64083	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
453	202503	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	2655	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
454	202503	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
455	202503	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
456	202503	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	15393	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
457	202503	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	55088	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
458	202503	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	21990	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
459	202503	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	3828	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
460	202503	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	147	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
461	202503	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	8	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
462	202503	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	183	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
463	202503	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	12	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
464	202503	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	54	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
465	202503	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
466	202503	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	779	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
467	202503	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	19	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
469	202503	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	1	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
470	202503	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	575	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
471	202503	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	62	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
472	202503	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	568580	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
473	202503	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
474	202503	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
475	202503	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	176	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
476	202501	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	5372	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
477	202501	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	360209	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
478	202501	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
479	202501	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
480	202501	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
481	202501	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	38007	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
482	202501	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	83451	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
483	202501	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	4170	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
484	202501	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	738	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
485	202501	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	5	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
486	202501	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	400	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
487	202501	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	17	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
488	202501	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	106	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
489	202501	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
490	202501	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	3012	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
491	202501	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	26	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
492	202501	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	1787	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
493	202501	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	3	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
494	202501	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1720	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
495	202501	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	70	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
496	202501	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	760497	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
497	202501	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
498	202501	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
499	202501	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1057	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
500	202501	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	2186	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
501	202501	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	190	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
502	202501	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	24712	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
503	202501	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	202461	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
504	202501	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	4602	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
505	202501	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	36478	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
506	202501	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1371	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
507	202501	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	15154	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
508	202501	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	368	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
509	202501	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	23526	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
510	202501	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	559	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
511	202501	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2152	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
512	202501	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	78	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
513	202501	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	563393	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
514	202501	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	277	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
515	202501	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	31806	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
516	202501	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	4	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
517	202501	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	74824	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
518	202501	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2059	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
519	202501	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	599	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
520	202501	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	2	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
521	202501	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	351588	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
522	202501	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	69748	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
523	202501	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	877	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
524	202501	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	7	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
525	202505	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1431	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
526	202506	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	4447	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
527	202506	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	240	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
528	202506	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	211916	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
529	202506	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	5705	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
530	202506	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	18052	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
531	202506	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1204	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
532	202506	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	14871	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
533	202506	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	489	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
534	202506	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	36867	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
535	202506	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1169	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
536	202506	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	1816	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
537	202506	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	98	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
538	202506	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	417950	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
539	202506	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	97	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
540	202506	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	26071	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
541	202506	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	7	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
542	202506	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	88770	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
543	202506	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2240	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
544	202506	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	442	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
545	202506	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	3	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
546	202506	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	248533	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
547	202506	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	49184	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
548	202506	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	1382	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
549	202506	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	4	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
550	202506	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	41191	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
551	202506	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1157	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
552	202504	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	760112	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
553	202504	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	6753	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
554	202504	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
555	202504	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
556	202504	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	15360	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
557	202504	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	34689	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
558	202504	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	85000	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
559	202504	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	4920	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
560	202504	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	592	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
561	202504	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	1	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
562	202504	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	424	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
563	202504	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	7	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
564	202504	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	95	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
565	202504	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
566	202504	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	3922	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
567	202504	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
568	202504	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	769	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
569	202504	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
570	202504	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1289	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
571	202504	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	61	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
572	202504	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	914254	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
573	202504	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
574	202504	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
575	202504	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1940	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
576	202504	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	4048	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
577	202504	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	320	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
578	202504	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	741745	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
579	202504	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	18604	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
580	202504	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	37584	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
581	202504	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1613	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
582	202504	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	14191	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
583	202504	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	400	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
584	202504	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	41637	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
585	202504	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1364	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
586	202504	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2627	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
587	202504	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	72	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
588	202504	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	806612	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
589	202504	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	247	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
590	202504	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	36170	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
591	202504	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	18	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
592	202504	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
593	202504	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	1630	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
594	202504	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	287	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
595	202504	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	4	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
596	202504	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	353954	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
597	202504	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	97323	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
598	202504	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	2007	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
599	202504	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	1	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
600	202504	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	63936	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
601	202504	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1217	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
602	202506	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	483014	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
603	202506	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	5902	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
604	202506	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
605	202506	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
606	202506	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	45582	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
607	202506	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
608	202506	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	63798	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
609	202506	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	4279	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
610	202506	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	739	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
611	202506	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	27	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
612	202506	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	378	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
613	202506	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	6	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
614	202506	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	290	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
615	202506	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
616	202506	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	2881	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
617	202506	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	19	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
618	202506	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	754	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
619	202506	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	1	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
620	202506	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	759	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
621	202506	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	43	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
622	202506	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	776476	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
623	202506	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
624	202506	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
625	202506	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1105	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
626	202503	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	861	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
627	202503	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	221	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
628	202503	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	94469	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
629	202503	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	4466	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
630	202503	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	4515	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
631	202503	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	912	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
632	202503	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	2073	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
633	202503	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	216	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
634	202503	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	6236	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
635	202503	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1065	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
636	202503	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	791	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
637	202503	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	142	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
638	202503	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	37287	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
639	202503	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	118	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
640	202503	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	8210	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
641	202503	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	42	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
642	202503	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	28182	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
643	202503	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	1420	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
644	202503	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	129	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
645	202503	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	2	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
646	202503	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	114553	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
647	202503	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	73223	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
648	202503	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	316	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
649	202503	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	2	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
650	202503	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	10719	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
651	202503	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1229	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
652	202505	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	351648	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
653	202505	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	5313	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
654	202505	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
655	202505	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
656	202505	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	21727	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
657	202505	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	45511	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
658	202505	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	84273	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
659	202505	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	1143	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
660	202505	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	1166	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
661	202505	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	6	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
662	202505	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	477	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
663	202505	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	26	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
664	202505	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	715	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
665	202505	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	1	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
666	202505	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	4404	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
667	202505	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	28	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
668	202505	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	1090	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
669	202505	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	1	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
670	202505	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1863	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
671	202505	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	63	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
672	202505	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	732626	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
673	202505	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	1900	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
674	202505	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	407	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
675	202505	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	990	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
676	202505	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	3537	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
677	202505	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	354	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
678	202505	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	177784	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
679	202505	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	3360	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
680	202505	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	37267	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
681	202505	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	2393	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
682	202505	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	11424	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
683	202505	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	464	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
684	202505	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	35328	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
685	202505	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	769	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
686	202505	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2333	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
687	202505	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	120	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
688	202505	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	463797	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
689	202505	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	216	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
690	202505	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	37363	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
691	202505	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	16	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
692	202505	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	125091	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
693	202505	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2020	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
694	202505	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	668	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
695	202505	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	3	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
696	202505	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	258260	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
697	202505	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
698	202505	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	1308	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
699	202505	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
700	202505	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	51667	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
701	202507	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	402	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
702	202507	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	231247	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
703	202507	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	6523	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
704	202507	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	37931	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
705	202507	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	3304	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
706	202507	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	13957	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
707	202507	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	662	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
708	202507	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	32710	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
709	202507	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1368	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
710	202507	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	1645	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
711	202507	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	300	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
712	202507	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	468655	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
713	202507	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	87	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
714	202507	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	22495	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
715	202507	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	18	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
716	202507	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
717	202507	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2180	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
718	202507	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	324	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
719	202507	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	16	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
720	202507	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	260449	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
721	202507	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
722	202507	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	2013	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
723	202507	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
724	202507	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	37744	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
725	202508	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1826	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
726	202507	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1672	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
727	202508	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	579917	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
728	202508	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	7849	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
729	202508	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
730	202508	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
731	202508	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
732	202508	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	39578	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
733	202508	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	35353	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
734	202508	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	7098	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
735	202508	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	760	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
736	202508	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	16	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
737	202508	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	233	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
738	202508	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	21	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
739	202508	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	206	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
740	202508	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
741	202508	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	2788	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
742	202508	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
743	202508	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	798	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
744	202508	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	7	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
745	202508	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	3771	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
746	202508	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	40	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
747	202508	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	717446	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
748	202508	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
749	202508	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
750	202508	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1310	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
751	202508	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	4720	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
752	202508	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	548	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
753	202508	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	174862	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
754	202508	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	6545	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
755	202508	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	19175	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
756	202508	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	2878	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
757	202508	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	7419	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
758	202508	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	842	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
759	202508	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	15216	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
760	202508	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1631	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
761	202508	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2067	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
762	202508	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	267	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
763	202508	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	269418	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
764	202508	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	264	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
765	202508	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	27228	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
766	202508	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	19	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
767	202508	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
768	202508	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2685	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
769	202508	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	296	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
770	202508	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	12	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
771	202508	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	182893	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
772	202508	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	50178	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
773	202508	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	1908	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
774	202508	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	17	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
775	202508	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	30953	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
776	202507	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	902	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
777	202507	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	3099	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
778	202507	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	483014	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
779	202507	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	5902	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
780	202507	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
781	202507	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
782	202507	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	22439	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
783	202507	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	71137	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
784	202507	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	67125	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
785	202507	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	6722	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
786	202507	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	321	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
787	202507	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	19	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
788	202507	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	317	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
789	202507	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	26	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
790	202507	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	65	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
791	202507	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
792	202507	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	3421	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
793	202507	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	0	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
794	202507	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	338	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
795	202507	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	7	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
796	202507	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	499	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
797	202507	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	72	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
798	202507	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	793791	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
799	202507	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
800	202507	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:01:53.202756	2025-12-09 19:01:53.446947
801	202501	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1208	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
802	202502	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	324043	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
803	202502	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	4963	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
804	202502	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
805	202502	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
806	202502	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	25457	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
807	202502	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	39051	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
808	202502	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	59454	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
809	202502	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	5674	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
810	202502	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	1032	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
811	202502	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	5	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
812	202502	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	330	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
813	202502	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	9	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
814	202502	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	269	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
815	202502	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
816	202502	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	5156	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
817	202502	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	18	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
818	202502	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	1096	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
819	202502	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	2	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
820	202502	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1994	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
821	202502	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	74	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
822	202502	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	934260	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
823	202502	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
824	202502	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
825	202502	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	673	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
826	202502	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	3256	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
827	202502	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	174	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
828	202502	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	186237	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
829	202502	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	4086	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
830	202502	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	28763	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
831	202502	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1260	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
832	202502	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	12878	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
833	202502	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	388	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
834	202502	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	35227	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
835	202502	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1290	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
836	202502	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	3442	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
837	202502	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	135	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
838	202502	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	237150	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
839	202502	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	282	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
840	202502	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	26088	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
841	202502	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	21	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
842	202502	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
843	202502	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	1950	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
844	202502	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	1006	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
845	202502	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	6	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
846	202502	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	291801	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
847	202502	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	58800	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
848	202502	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	398	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
849	202502	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	28	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
850	202502	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	16773	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
851	202502	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1031	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
852	202503	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	64083	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
853	202503	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	2655	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
854	202503	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
855	202503	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
856	202503	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	15393	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
857	202503	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	55088	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
858	202503	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	21990	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
859	202503	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	3828	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
860	202503	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	147	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
861	202503	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	8	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
862	202503	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	183	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
863	202503	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	12	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
864	202503	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	54	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
865	202503	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
866	202503	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	779	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
867	202503	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	19	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
868	202503	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	327	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
869	202503	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	1	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
870	202503	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	575	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
871	202503	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	62	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
872	202503	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	568580	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
873	202503	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
874	202503	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
875	202503	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	176	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
876	202501	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	5372	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
877	202501	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	360209	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
878	202501	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
879	202501	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
880	202501	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
881	202501	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	38007	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
882	202501	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	83451	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
883	202501	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	4170	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
884	202501	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	738	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
885	202501	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	5	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
886	202501	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	400	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
887	202501	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	17	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
888	202501	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	106	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
889	202501	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
890	202501	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	3012	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
891	202501	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	26	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
892	202501	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	1787	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
893	202501	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	3	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
894	202501	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1720	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
895	202501	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	70	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
896	202501	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	760497	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
897	202501	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
898	202501	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
899	202501	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1057	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
900	202501	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	2186	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
901	202501	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	190	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
902	202501	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	24712	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
903	202501	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	202461	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
904	202501	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	4602	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
905	202501	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	36478	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
906	202501	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1371	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
907	202501	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	15154	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
908	202501	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	368	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
909	202501	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	23526	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
910	202501	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	559	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
911	202501	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2152	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
912	202501	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	78	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
913	202501	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	563393	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
914	202501	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	277	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
915	202501	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	31806	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
916	202501	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	4	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
917	202501	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	74824	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
918	202501	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2059	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
919	202501	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	599	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
920	202501	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	2	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
921	202501	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	351588	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
922	202501	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	69748	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
923	202501	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	877	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
924	202501	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	7	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
925	202505	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1431	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
926	202506	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	4447	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
927	202506	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	240	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
928	202506	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	211916	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
929	202506	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	5705	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
930	202506	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	18052	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
931	202506	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1204	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
932	202506	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	14871	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
933	202506	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	489	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
934	202506	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	36867	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
935	202506	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1169	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
936	202506	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	1816	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
937	202506	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	98	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
938	202506	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	417950	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
939	202506	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	97	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
940	202506	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	26071	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
941	202506	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	7	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
942	202506	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	88770	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
943	202506	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2240	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
944	202506	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	442	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
945	202506	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	3	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
946	202506	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	248533	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
947	202506	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	49184	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
948	202506	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	1382	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
949	202506	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	4	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
950	202506	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	41191	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
951	202506	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1157	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
952	202504	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	760112	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
953	202504	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	6753	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
954	202504	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
955	202504	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
956	202504	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	15360	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
957	202504	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	34689	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
958	202504	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	85000	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
959	202504	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	4920	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
960	202504	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	592	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
961	202504	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	1	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
962	202504	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	424	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
963	202504	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	7	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
964	202504	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	95	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
965	202504	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
966	202504	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	3922	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
967	202504	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
968	202504	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	769	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
969	202504	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
970	202504	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1289	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
971	202504	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	61	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
972	202504	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	914254	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
973	202504	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
974	202504	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
975	202504	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1940	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
976	202504	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	4048	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
977	202504	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	320	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
978	202504	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	741745	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
979	202504	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	18604	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
980	202504	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	37584	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
981	202504	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	1613	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
982	202504	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	14191	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
983	202504	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	400	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
984	202504	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	41637	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
985	202504	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1364	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
986	202504	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2627	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
987	202504	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	72	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
988	202504	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	806612	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
989	202504	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	247	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
990	202504	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	36170	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
991	202504	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	18	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
992	202504	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
993	202504	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	1630	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
994	202504	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	287	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
995	202504	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	4	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
996	202504	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	353954	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
997	202504	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	97323	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
998	202504	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	2007	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
999	202504	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	1	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1000	202504	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	63936	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1001	202504	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1217	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1002	202506	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	483014	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1003	202506	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	5902	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1004	202506	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1005	202506	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1006	202506	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	45582	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1007	202506	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1008	202506	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	63798	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1009	202506	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	4279	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1010	202506	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	739	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1011	202506	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	27	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1012	202506	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	378	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1013	202506	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	6	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1014	202506	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	290	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1015	202506	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1016	202506	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	2881	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1017	202506	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	19	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1018	202506	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	754	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1019	202506	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	1	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1020	202506	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	759	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1021	202506	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	43	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1022	202506	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	776476	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1023	202506	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1024	202506	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1025	202506	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1105	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1026	202503	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	861	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1027	202503	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	221	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1028	202503	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	94469	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1029	202503	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	4466	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1030	202503	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	4515	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1031	202503	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	912	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1032	202503	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	2073	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1033	202503	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	216	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1034	202503	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	6236	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1035	202503	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1065	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1036	202503	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	791	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1037	202503	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	142	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1038	202503	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	37287	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1039	202503	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	118	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1040	202503	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	8210	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1041	202503	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	42	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1042	202503	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	28182	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1043	202503	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	1420	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1044	202503	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	129	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1045	202503	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	2	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1046	202503	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	114553	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1047	202503	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	73223	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1048	202503	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	316	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1049	202503	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	2	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1050	202503	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	10719	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1051	202503	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1229	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1052	202505	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	351648	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1053	202505	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	5313	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1054	202505	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1055	202505	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1056	202505	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	21727	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1057	202505	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	45511	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1058	202505	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	84273	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1059	202505	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	1143	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1060	202505	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	1166	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1061	202505	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	6	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1062	202505	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	477	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1063	202505	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	26	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1064	202505	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	715	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1065	202505	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	1	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1066	202505	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	4404	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1067	202505	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	28	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1068	202505	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	1090	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1069	202505	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	1	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1070	202505	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	1863	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1071	202505	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	63	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1072	202505	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	732626	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1073	202505	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	1900	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1074	202505	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	407	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1075	202505	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	990	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1076	202505	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	3537	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1077	202505	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	354	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1078	202505	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	177784	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1079	202505	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	3360	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1080	202505	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	37267	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1081	202505	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	2393	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1082	202505	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	11424	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1083	202505	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	464	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1084	202505	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	35328	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1085	202505	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	769	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1086	202505	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2333	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1087	202505	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	120	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1088	202505	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	463797	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1089	202505	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	216	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1090	202505	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	37363	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1091	202505	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	16	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1092	202505	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	125091	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1093	202505	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2020	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1094	202505	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	668	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1095	202505	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	3	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1096	202505	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	258260	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1097	202505	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1098	202505	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	1308	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1099	202505	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1100	202505	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	51667	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1101	202507	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	402	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1102	202507	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	231247	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1103	202507	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	6523	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1104	202507	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	37931	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1105	202507	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	3304	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1106	202507	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	13957	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1107	202507	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	662	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1108	202507	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	32710	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1109	202507	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1368	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1110	202507	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	1645	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1111	202507	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	300	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1112	202507	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	468655	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1113	202507	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	87	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1114	202507	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	22495	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1115	202507	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	18	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1116	202507	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1117	202507	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2180	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1118	202507	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	324	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1119	202507	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	16	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1120	202507	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	260449	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1121	202507	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1122	202507	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	2013	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1123	202507	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1124	202507	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	37744	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1125	202508	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1826	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1126	202507	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Mancanegara	1672	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1127	202508	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	579917	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1128	202508	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	7849	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1129	202508	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1130	202508	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1131	202508	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1132	202508	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	39578	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1133	202508	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	35353	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1134	202508	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	7098	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1135	202508	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	760	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1136	202508	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	16	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1137	202508	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	233	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1138	202508	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	21	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1139	202508	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	206	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1140	202508	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1141	202508	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	2788	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1142	202508	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1143	202508	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	798	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1144	202508	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	7	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1145	202508	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	3771	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1146	202508	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	40	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1147	202508	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	717446	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1148	202508	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1149	202508	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1150	202508	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	1310	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1151	202508	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	4720	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1152	202508	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Mancanegara	548	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1153	202508	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Nusantara	174862	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1154	202508	Kawasan Kota Tua	Kawasan Kota Tua, Taman Fatahillah No.1 7, RT.7/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349514	106.8146451	Wisatawan Mancanegara	6545	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1155	202508	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Nusantara	19175	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1156	202508	Museum Sejarah Jakarta	Taman Fatahillah No.1, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1349760	106.8142870	Wisatawan Mancanegara	2878	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1157	202508	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Nusantara	7419	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1158	202508	Museum Seni Rupa dan Keramik	Jl. Pos Kota No.2 9, RT.9/RW.7, Pinangsia, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1342491	106.8149060	Wisatawan Mancanegara	842	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1159	202508	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Nusantara	15216	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1160	202508	Museum Wayang	Jalan Pintu Besar Utara No.27 Pinangsia, RT.3/RW.6, Kota Tua, Kec. Taman Sari, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11110	-6.1347258	106.8131962	Wisatawan Mancanegara	1631	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1161	202508	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Nusantara	2067	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1162	202508	Museum Tekstil	No 2-4, Jl. K.S. Tubun, Kota Bambu Selatan, Kec. Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420	-6.1880837	106.8107302	Wisatawan Mancanegara	267	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1163	202508	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Nusantara	269418	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1164	202508	Taman Marga Satwa Ragunan	Jl. Harsono Rm Dalam No.1, Ragunan, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550	-6.3045974	106.8210269	Wisatawan Mancanegara	264	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1165	202508	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Nusantara	27228	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1166	202508	Perkampungan Budaya Betawi Setu Babakan	Jl. Situ Babakan No.18 13, RT.13/RW.8, Srengseng Sawah, Kec. Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12630	-6.3392553	106.8250668	Wisatawan Mancanegara	19	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1167	202508	Ruang Terbuka Hijau Tebet Eco Park	Jl. Tebet Barat Raya, RT.1/RW.10, Tebet Barat, Kec. Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12820	-6.2372102	106.8534290	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1168	202508	Museum Satria Mandala	Jl. Gatot Subroto No.14, RT.6/RW.1, Kuningan Barat, Kec. Mampang Prapatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710	-6.2316899	106.8192872	Wisatawan Nusantara	2685	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1169	202508	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Nusantara	296	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1170	202508	Museum Basoeki Abdullah	Jl. Keuangan Raya No.19, Cilandak Barat, Kec. Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430	-6.2897189	106.7936438	Wisatawan Mancanegara	12	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1171	202508	Taman Mini Indonesia Indah	Jl. Taman Mini Indonesia Indah, Ceger, Kec. Cipayung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta 13820	-6.3019000	106.8904181	Wisatawan Nusantara	182893	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1172	202508	Old Shanghai	Cakung Barat, Kec. Cakung, Kota Jakarta Timur, Daerah Khusus Ibukota Jakarta	-6.1645270	106.9245255	Wisatawan Nusantara	50178	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1173	202508	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Nusantara	1908	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1174	202508	Museum Arkeologi Onrust	Pulau Onrust, Kec. Kepulauan Seribu Selatan, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14510	-6.0341906	106.7355295	Wisatawan Mancanegara	17	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1175	202508	Kepulauan Seribu	Pulau Pramuka, Pulau Panggang, Kepulauan Seribu Utara, Kab. Administrasi Kepulauan Seribu, Daerah Khusus Ibukota Jakarta 14530	-5.7452702	106.6156112	Wisatawan Nusantara	30953	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1176	202507	Rumah Si Pitung (Situs Marunda)	Jl. Kampung Marunda Pulo, 2, RT.2/RW.7, Marunda, Kec. Cilincing, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14150	-6.0968037	106.9588842	Wisatawan Nusantara	902	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1177	202507	Museum Bahari	Jl. Pasar Ikan No.1, RT.11/RW.4, Penjaringan, Kec. Penjaringan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14440	-6.1264949	106.8082563	Wisatawan Nusantara	3099	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1178	202507	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Nusantara	483014	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1179	202507	Monumen Nasional	Merdeka Square, Jalan Lapangan Monas, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1751897	106.8273888	Wisatawan Mancanegara	5902	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1180	202507	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Nusantara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1181	202507	Planetarium	Jalan Cikini Raya No.73, RT.8/RW.2, Cikini, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10330	-6.1901946	106.8389179	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1182	202507	Taman Lapangan Banteng	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1703843	106.8354348	Wisatawan Nusantara	22439	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1183	202507	Pos Bloc	RRJM+4W5, Pasar Baru, Kecamatan Sawah Besar, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10710	-6.1661029	106.8361441	Wisatawan Nusantara	71137	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1184	202507	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Nusantara	67125	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1185	202507	Museum Nasional	Jl. Medan Merdeka Barat No.12, Gambir, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10110	-6.1761728	106.8215150	Wisatawan Mancanegara	6722	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1186	202507	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Nusantara	321	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1187	202507	Museum Joang '45	Jl. Menteng Raya No.31 1, RT.1/RW.10, Kebon Sirih, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10340	-6.1857868	106.8370903	Wisatawan Mancanegara	19	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1188	202507	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Nusantara	317	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1189	202507	Museum Prasasti	Jl. Tanah Abang I No.1, RT.11/RW.8, Petojo Selatan, Kecamatan Gambir, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10160	-6.1722280	106.8191788	Wisatawan Mancanegara	26	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1190	202507	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Nusantara	65	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1191	202507	Museum Mohammad Hoesni Thamrin	Jl. Kenari 2 No.15, RW.4, Kenari, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10430	-6.1937697	106.8456782	Wisatawan Mancanegara	3	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1192	202507	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Nusantara	3421	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1193	202507	Museum Kebangkitan Nasional	Jl. Abdul Rachman Saleh No.26, Senen, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10410	-6.1785723	106.8379842	Wisatawan Mancanegara	0	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1194	202507	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Nusantara	338	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1195	202507	Museum Sumpah Pemuda	Jl. Kramat Raya No.106, RT.2/RW.9, Kwitang, Kec. Senen, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10420	-6.1836041	106.8430829	Wisatawan Mancanegara	7	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1196	202507	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Nusantara	499	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1197	202507	Museum Perumusan Naskah Proklamasi	Jl. Imam Bonjol No.1, RT.9/RW.4, Menteng, Kec. Menteng, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10310	-6.2002139	106.8310637	Wisatawan Mancanegara	72	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1198	202507	Taman Impian Jaya Ancol	Jl. Lodan Timur No.7, RT.14/RW.10, Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta 14430	-6.1226706	106.8331808	Wisatawan Nusantara	793791	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1199	202507	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Nusantara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
1200	202507	Pelabuhan Sunda Kelapa	Ancol, Kec. Pademangan, Jakarta Utara, Daerah Khusus Ibukota Jakarta	-6.1188442	106.8122886	Wisatawan Mancanegara	\N	t	2025-12-09 19:12:46.42405	2025-12-09 19:12:46.674976
\.


--
-- TOC entry 3565 (class 0 OID 16400)
-- Dependencies: 222
-- Data for Name: user_journey_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_journey_log (journey_id, session_id, stage, "timestamp", duration_seconds, completed) FROM stdin;
1	67d0bbcb-e7d9-4eb9-a8c5-f0308e1c3f6d	landing	2025-12-09 02:09:35.186521	\N	t
2	67d0bbcb-e7d9-4eb9-a8c5-f0308e1c3f6d	view_kpis	2025-12-09 02:09:35.255169	\N	t
3	67d0bbcb-e7d9-4eb9-a8c5-f0308e1c3f6d	analyze_charts	2025-12-09 02:09:35.358258	\N	t
4	67d0bbcb-e7d9-4eb9-a8c5-f0308e1c3f6d	apply_filters	2025-12-09 02:10:22.791513	\N	t
5	67d0bbcb-e7d9-4eb9-a8c5-f0308e1c3f6d	apply_filters	2025-12-09 02:10:26.142783	\N	t
6	7769505b-794a-49f8-b6ac-1ae73fb2a680	landing	2025-12-09 02:10:27.459532	\N	t
7	7769505b-794a-49f8-b6ac-1ae73fb2a680	view_kpis	2025-12-09 02:10:27.471434	\N	t
8	7769505b-794a-49f8-b6ac-1ae73fb2a680	analyze_charts	2025-12-09 02:10:27.493507	\N	t
9	7769505b-794a-49f8-b6ac-1ae73fb2a680	apply_filters	2025-12-09 02:10:32.936667	\N	t
10	7769505b-794a-49f8-b6ac-1ae73fb2a680	apply_filters	2025-12-09 02:10:34.816516	\N	t
11	7769505b-794a-49f8-b6ac-1ae73fb2a680	download_data	2025-12-09 02:10:38.489873	\N	t
12	994dae3e-b022-41dc-9a9e-18301fecf7c7	landing	2025-12-09 02:10:43.121965	\N	t
13	994dae3e-b022-41dc-9a9e-18301fecf7c7	view_kpis	2025-12-09 02:10:43.131188	\N	t
14	994dae3e-b022-41dc-9a9e-18301fecf7c7	analyze_charts	2025-12-09 02:10:43.151074	\N	t
15	994dae3e-b022-41dc-9a9e-18301fecf7c7	apply_filters	2025-12-09 02:10:50.385585	\N	t
16	994dae3e-b022-41dc-9a9e-18301fecf7c7	apply_filters	2025-12-09 02:10:52.289512	\N	t
17	1853eef8-f5dd-4503-837a-6677bcb21fa3	landing	2025-12-09 02:10:54.513268	\N	t
18	1853eef8-f5dd-4503-837a-6677bcb21fa3	view_kpis	2025-12-09 02:10:54.530467	\N	t
19	1853eef8-f5dd-4503-837a-6677bcb21fa3	analyze_charts	2025-12-09 02:10:54.554975	\N	t
20	b721753c-6d1c-4f60-a548-100855df32c9	landing	2025-12-09 02:10:55.798434	\N	t
21	b721753c-6d1c-4f60-a548-100855df32c9	view_kpis	2025-12-09 02:10:55.810718	\N	t
22	b721753c-6d1c-4f60-a548-100855df32c9	analyze_charts	2025-12-09 02:10:55.829304	\N	t
23	b721753c-6d1c-4f60-a548-100855df32c9	apply_filters	2025-12-09 02:11:44.923876	\N	t
24	b721753c-6d1c-4f60-a548-100855df32c9	apply_filters	2025-12-09 02:11:47.865426	\N	t
25	b721753c-6d1c-4f60-a548-100855df32c9	download_data	2025-12-09 02:11:57.509154	\N	t
26	c737ac54-60ef-43f9-a6a3-a31cdc3ec9a6	landing	2025-12-09 02:11:58.597619	\N	t
27	c737ac54-60ef-43f9-a6a3-a31cdc3ec9a6	view_kpis	2025-12-09 02:11:58.610861	\N	t
28	c737ac54-60ef-43f9-a6a3-a31cdc3ec9a6	analyze_charts	2025-12-09 02:11:58.629965	\N	t
29	3ead2969-b3c6-4e8d-82b1-e1a94e38adf9	landing	2025-12-09 02:12:03.559509	\N	t
30	3ead2969-b3c6-4e8d-82b1-e1a94e38adf9	view_kpis	2025-12-09 02:12:03.574536	\N	t
31	3ead2969-b3c6-4e8d-82b1-e1a94e38adf9	analyze_charts	2025-12-09 02:12:03.59257	\N	t
32	3ead2969-b3c6-4e8d-82b1-e1a94e38adf9	apply_filters	2025-12-09 02:12:09.582054	\N	t
33	3ead2969-b3c6-4e8d-82b1-e1a94e38adf9	download_data	2025-12-09 02:12:25.126534	\N	t
34	11442bc9-b334-46bc-9870-6c5cec0ffb93	landing	2025-12-09 02:12:27.445298	\N	t
35	11442bc9-b334-46bc-9870-6c5cec0ffb93	view_kpis	2025-12-09 02:12:27.456579	\N	t
36	11442bc9-b334-46bc-9870-6c5cec0ffb93	analyze_charts	2025-12-09 02:12:27.47678	\N	t
37	11442bc9-b334-46bc-9870-6c5cec0ffb93	apply_filters	2025-12-09 02:59:07.802315	\N	t
38	4d33f9ef-0170-4279-992b-97c65a5fd6ff	landing	2025-12-09 03:04:20.174534	\N	t
39	4d33f9ef-0170-4279-992b-97c65a5fd6ff	view_kpis	2025-12-09 03:04:20.187211	\N	t
40	4d33f9ef-0170-4279-992b-97c65a5fd6ff	analyze_charts	2025-12-09 03:04:20.208198	\N	t
41	a1bf21b9-354e-409c-bab5-ee9c4e425ce1	landing	2025-12-09 03:45:03.054855	\N	t
42	a1bf21b9-354e-409c-bab5-ee9c4e425ce1	view_kpis	2025-12-09 03:45:03.085286	\N	t
43	a1bf21b9-354e-409c-bab5-ee9c4e425ce1	analyze_charts	2025-12-09 03:45:03.108409	\N	t
44	4d33f9ef-0170-4279-992b-97c65a5fd6ff	apply_filters	2025-12-09 03:45:53.15922	\N	t
45	55e319fc-0f15-498d-a428-b25e05360c5e	landing	2025-12-09 06:30:15.835225	\N	t
46	55e319fc-0f15-498d-a428-b25e05360c5e	view_kpis	2025-12-09 06:30:16.078054	\N	t
47	55e319fc-0f15-498d-a428-b25e05360c5e	analyze_charts	2025-12-09 06:30:16.18194	\N	t
48	77979e84-4e02-48a1-8038-07fa9a9e29cf	landing	2025-12-09 06:33:36.490011	\N	t
49	77979e84-4e02-48a1-8038-07fa9a9e29cf	view_kpis	2025-12-09 06:33:36.515789	\N	t
50	77979e84-4e02-48a1-8038-07fa9a9e29cf	analyze_charts	2025-12-09 06:33:36.549329	\N	t
51	77979e84-4e02-48a1-8038-07fa9a9e29cf	apply_filters	2025-12-09 07:23:01.92631	\N	t
52	77979e84-4e02-48a1-8038-07fa9a9e29cf	apply_filters	2025-12-09 07:23:04.909962	\N	t
53	77979e84-4e02-48a1-8038-07fa9a9e29cf	apply_filters	2025-12-09 07:23:06.209023	\N	t
54	38a90d35-b7c7-41d8-a14e-1fb7584d782b	landing	2025-12-09 14:30:19.640483	\N	t
55	38a90d35-b7c7-41d8-a14e-1fb7584d782b	view_kpis	2025-12-09 14:30:19.673944	\N	t
56	38a90d35-b7c7-41d8-a14e-1fb7584d782b	analyze_charts	2025-12-09 14:30:19.722943	\N	t
57	d172adb2-978b-43be-a8da-283c98a8608e	landing	2025-12-09 14:32:55.52328	\N	t
58	d172adb2-978b-43be-a8da-283c98a8608e	view_kpis	2025-12-09 14:32:55.622741	\N	t
59	d172adb2-978b-43be-a8da-283c98a8608e	analyze_charts	2025-12-09 14:32:55.673913	\N	t
60	cb2cb0c5-af14-4532-8e65-4609df6c99e9	landing	2025-12-09 14:33:42.260492	\N	t
61	b6880fbc-f576-4e5b-998f-917c9658dfee	landing	2025-12-09 14:33:42.332093	\N	t
62	cb2cb0c5-af14-4532-8e65-4609df6c99e9	view_kpis	2025-12-09 14:33:42.347748	\N	t
63	b6880fbc-f576-4e5b-998f-917c9658dfee	view_kpis	2025-12-09 14:33:42.352514	\N	t
64	b6880fbc-f576-4e5b-998f-917c9658dfee	analyze_charts	2025-12-09 14:33:42.442531	\N	t
65	cb2cb0c5-af14-4532-8e65-4609df6c99e9	analyze_charts	2025-12-09 14:33:42.443209	\N	t
66	841df00d-b17f-43de-8c8e-cd6d02f029bf	landing	2025-12-09 14:34:42.325519	\N	t
67	841df00d-b17f-43de-8c8e-cd6d02f029bf	view_kpis	2025-12-09 14:34:42.408106	\N	t
68	841df00d-b17f-43de-8c8e-cd6d02f029bf	analyze_charts	2025-12-09 14:34:42.459332	\N	t
69	2b484e2f-1f40-4354-92b9-fcfe5cf40ba6	landing	2025-12-09 14:34:53.888518	\N	t
70	2b484e2f-1f40-4354-92b9-fcfe5cf40ba6	view_kpis	2025-12-09 14:34:53.906166	\N	t
71	2b484e2f-1f40-4354-92b9-fcfe5cf40ba6	analyze_charts	2025-12-09 14:34:53.947168	\N	t
72	7d593bc5-9dbe-45f2-a444-a4b4028e4307	landing	2025-12-09 14:35:16.399656	\N	t
73	7d593bc5-9dbe-45f2-a444-a4b4028e4307	view_kpis	2025-12-09 14:35:16.427779	\N	t
74	7d593bc5-9dbe-45f2-a444-a4b4028e4307	analyze_charts	2025-12-09 14:35:16.464624	\N	t
75	0bf0cd12-e087-470d-8243-746e9d842b83	landing	2025-12-09 15:23:38.619662	\N	t
76	0bf0cd12-e087-470d-8243-746e9d842b83	view_kpis	2025-12-09 15:23:38.639969	\N	t
77	0bf0cd12-e087-470d-8243-746e9d842b83	analyze_charts	2025-12-09 15:23:38.669378	\N	t
78	0bf0cd12-e087-470d-8243-746e9d842b83	apply_filters	2025-12-09 18:33:49.770883	\N	t
79	0bf0cd12-e087-470d-8243-746e9d842b83	apply_filters	2025-12-09 18:33:52.262391	\N	t
80	4a1f081d-1eef-4877-b7f2-dc9b2035f226	landing	2025-12-09 18:42:13.075234	\N	t
81	4a1f081d-1eef-4877-b7f2-dc9b2035f226	view_kpis	2025-12-09 18:42:13.097524	\N	t
82	4a1f081d-1eef-4877-b7f2-dc9b2035f226	analyze_charts	2025-12-09 18:42:13.13974	\N	t
83	e5f70ad8-5f45-4ec6-9474-70e7000d7a1e	landing	2025-12-09 18:45:35.642645	\N	t
84	e5f70ad8-5f45-4ec6-9474-70e7000d7a1e	view_kpis	2025-12-09 18:45:35.684159	\N	t
85	e5f70ad8-5f45-4ec6-9474-70e7000d7a1e	analyze_charts	2025-12-09 18:45:35.715598	\N	t
86	2d199208-5be1-4f95-b43a-791b71b9cc6e	landing	2025-12-09 18:46:44.788921	\N	t
87	2d199208-5be1-4f95-b43a-791b71b9cc6e	view_kpis	2025-12-09 18:46:44.823117	\N	t
88	2d199208-5be1-4f95-b43a-791b71b9cc6e	analyze_charts	2025-12-09 18:46:44.902902	\N	t
89	ba64c2f7-e108-49d8-a399-202491c780e9	landing	2025-12-09 18:47:31.08237	\N	t
90	ba64c2f7-e108-49d8-a399-202491c780e9	view_kpis	2025-12-09 18:47:31.106041	\N	t
91	ba64c2f7-e108-49d8-a399-202491c780e9	analyze_charts	2025-12-09 18:47:31.172486	\N	t
92	d9531051-5726-4aa3-9035-55bfb822d9de	landing	2025-12-09 18:48:54.376793	\N	t
93	d9531051-5726-4aa3-9035-55bfb822d9de	view_kpis	2025-12-09 18:48:54.400842	\N	t
94	d9531051-5726-4aa3-9035-55bfb822d9de	analyze_charts	2025-12-09 18:48:54.445942	\N	t
95	6e0ba51d-dcad-4b25-aaf1-9ebb048352c9	landing	2025-12-09 18:49:43.172177	\N	t
96	6e0ba51d-dcad-4b25-aaf1-9ebb048352c9	view_kpis	2025-12-09 18:49:43.19308	\N	t
97	6e0ba51d-dcad-4b25-aaf1-9ebb048352c9	analyze_charts	2025-12-09 18:49:43.228416	\N	t
98	d2bcff96-8345-4663-82d0-eeb8e0c3eeb0	landing	2025-12-09 18:49:53.486858	\N	t
99	d2bcff96-8345-4663-82d0-eeb8e0c3eeb0	view_kpis	2025-12-09 18:49:53.507512	\N	t
100	d2bcff96-8345-4663-82d0-eeb8e0c3eeb0	analyze_charts	2025-12-09 18:49:53.540643	\N	t
101	e95e65d5-b480-408c-aba9-2863d3a58a34	landing	2025-12-09 18:50:41.887399	\N	t
102	848ed285-0955-4b1f-a397-ee9496d37935	landing	2025-12-09 18:50:41.898205	\N	t
103	e95e65d5-b480-408c-aba9-2863d3a58a34	view_kpis	2025-12-09 18:50:41.967462	\N	t
104	848ed285-0955-4b1f-a397-ee9496d37935	view_kpis	2025-12-09 18:50:41.98275	\N	t
105	e95e65d5-b480-408c-aba9-2863d3a58a34	analyze_charts	2025-12-09 18:50:42.061518	\N	t
106	848ed285-0955-4b1f-a397-ee9496d37935	analyze_charts	2025-12-09 18:50:42.064188	\N	t
107	bab7f8e8-abd5-4e8e-8b52-7b00e34d83bd	landing	2025-12-09 18:50:42.503632	\N	t
108	bab7f8e8-abd5-4e8e-8b52-7b00e34d83bd	view_kpis	2025-12-09 18:50:42.523867	\N	t
109	bab7f8e8-abd5-4e8e-8b52-7b00e34d83bd	analyze_charts	2025-12-09 18:50:42.558337	\N	t
110	d3e04485-0f04-4715-b40d-b820dc3a49e8	landing	2025-12-09 18:55:19.679506	\N	t
111	d3e04485-0f04-4715-b40d-b820dc3a49e8	view_kpis	2025-12-09 18:55:19.70392	\N	t
112	d3e04485-0f04-4715-b40d-b820dc3a49e8	analyze_charts	2025-12-09 18:55:19.74989	\N	t
113	dc11edd2-fb36-4370-91d4-f1b81c6ab49e	landing	2025-12-09 18:55:43.263754	\N	t
114	9c605443-4a75-4dce-91f7-ce5ea4538d9f	landing	2025-12-09 18:55:43.327628	\N	t
115	9c605443-4a75-4dce-91f7-ce5ea4538d9f	view_kpis	2025-12-09 18:55:43.344597	\N	t
116	dc11edd2-fb36-4370-91d4-f1b81c6ab49e	view_kpis	2025-12-09 18:55:43.343636	\N	t
117	9c605443-4a75-4dce-91f7-ce5ea4538d9f	analyze_charts	2025-12-09 18:55:43.424517	\N	t
118	dc11edd2-fb36-4370-91d4-f1b81c6ab49e	analyze_charts	2025-12-09 18:55:43.425128	\N	t
119	361f700e-f14e-4d95-aef7-6d3a072e003a	landing	2025-12-09 18:55:44.552744	\N	t
120	361f700e-f14e-4d95-aef7-6d3a072e003a	view_kpis	2025-12-09 18:55:44.579792	\N	t
121	361f700e-f14e-4d95-aef7-6d3a072e003a	analyze_charts	2025-12-09 18:55:44.630509	\N	t
122	73950bb8-fad0-41f2-b680-bea7581253a5	landing	2025-12-09 18:56:13.465794	\N	t
123	73950bb8-fad0-41f2-b680-bea7581253a5	view_kpis	2025-12-09 18:56:13.486941	\N	t
124	73950bb8-fad0-41f2-b680-bea7581253a5	analyze_charts	2025-12-09 18:56:13.516978	\N	t
125	051aa330-923c-4d16-8fad-c18d768f57df	landing	2025-12-09 18:56:29.386027	\N	t
126	051aa330-923c-4d16-8fad-c18d768f57df	view_kpis	2025-12-09 18:56:29.403572	\N	t
127	051aa330-923c-4d16-8fad-c18d768f57df	analyze_charts	2025-12-09 18:56:29.434147	\N	t
128	ab4e95de-8974-4871-be97-5ba24c077033	landing	2025-12-09 19:00:40.688299	\N	t
129	ab4e95de-8974-4871-be97-5ba24c077033	view_kpis	2025-12-09 19:00:40.766687	\N	t
130	ab4e95de-8974-4871-be97-5ba24c077033	analyze_charts	2025-12-09 19:00:40.830207	\N	t
131	ab4e95de-8974-4871-be97-5ba24c077033	apply_filters	2025-12-09 19:01:05.334958	\N	t
132	ab4e95de-8974-4871-be97-5ba24c077033	apply_filters	2025-12-09 19:01:08.461633	\N	t
133	79a866d7-5b5b-4dac-b1b1-dbeaaf84429b	landing	2025-12-09 19:01:13.676308	\N	t
134	79a866d7-5b5b-4dac-b1b1-dbeaaf84429b	view_kpis	2025-12-09 19:01:13.695939	\N	t
135	79a866d7-5b5b-4dac-b1b1-dbeaaf84429b	analyze_charts	2025-12-09 19:01:13.733595	\N	t
136	ff34dbe4-c948-4233-83ec-23e2cf074804	landing	2025-12-09 19:02:14.070733	\N	t
137	ff34dbe4-c948-4233-83ec-23e2cf074804	view_kpis	2025-12-09 19:02:14.096266	\N	t
138	ff34dbe4-c948-4233-83ec-23e2cf074804	analyze_charts	2025-12-09 19:02:14.1533	\N	t
139	0202aa3a-3fea-4b1e-bd83-f110dbd0803b	landing	2025-12-10 03:11:44.142948	\N	t
140	0202aa3a-3fea-4b1e-bd83-f110dbd0803b	view_kpis	2025-12-10 03:11:44.208379	\N	t
141	0202aa3a-3fea-4b1e-bd83-f110dbd0803b	analyze_charts	2025-12-10 03:11:44.265166	\N	t
142	aab0eb38-d69a-40d9-8208-ac938d3516c4	landing	2025-12-10 03:12:06.656087	\N	t
143	aab0eb38-d69a-40d9-8208-ac938d3516c4	view_kpis	2025-12-10 03:12:06.687771	\N	t
144	aab0eb38-d69a-40d9-8208-ac938d3516c4	analyze_charts	2025-12-10 03:12:06.733065	\N	t
145	cca5aed7-8341-4c6f-9278-2c706b55979f	landing	2025-12-10 03:12:28.123001	\N	t
146	cca5aed7-8341-4c6f-9278-2c706b55979f	view_kpis	2025-12-10 03:12:28.142946	\N	t
147	cca5aed7-8341-4c6f-9278-2c706b55979f	analyze_charts	2025-12-10 03:12:28.16941	\N	t
148	b31fc00a-f491-4df2-95a2-350596c576a0	landing	2025-12-10 03:12:59.18981	\N	t
149	b31fc00a-f491-4df2-95a2-350596c576a0	view_kpis	2025-12-10 03:12:59.226448	\N	t
150	b31fc00a-f491-4df2-95a2-350596c576a0	analyze_charts	2025-12-10 03:12:59.258824	\N	t
151	65198f5d-1d71-4fd3-b813-05cbb11f0418	landing	2025-12-10 03:26:59.781281	\N	t
152	65198f5d-1d71-4fd3-b813-05cbb11f0418	view_kpis	2025-12-10 03:26:59.842921	\N	t
153	65198f5d-1d71-4fd3-b813-05cbb11f0418	analyze_charts	2025-12-10 03:26:59.884177	\N	t
\.


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 219
-- Name: dashboard_performance_log_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dashboard_performance_log_log_id_seq', 76, true);


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 229
-- Name: dim_objek_wisata_objek_wisata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dim_objek_wisata_objek_wisata_id_seq', 29, true);


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 233
-- Name: dim_price_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dim_price_price_id_seq', 29, true);


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 227
-- Name: dim_time_time_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dim_time_time_id_seq', 24, true);


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 231
-- Name: dim_wisatawan_wisatawan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.dim_wisatawan_wisatawan_id_seq', 2, true);


--
-- TOC entry 3603 (class 0 OID 0)
-- Dependencies: 235
-- Name: fact_kunjungan_fact_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.fact_kunjungan_fact_id_seq', 1200, true);


--
-- TOC entry 3604 (class 0 OID 0)
-- Dependencies: 225
-- Name: staging_harga_tiket_raw_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.staging_harga_tiket_raw_id_seq', 87, true);


--
-- TOC entry 3605 (class 0 OID 0)
-- Dependencies: 223
-- Name: staging_kunjungan_raw_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.staging_kunjungan_raw_id_seq', 1200, true);


--
-- TOC entry 3606 (class 0 OID 0)
-- Dependencies: 221
-- Name: user_journey_log_journey_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_journey_log_journey_id_seq', 153, true);


--
-- TOC entry 3369 (class 2606 OID 16398)
-- Name: dashboard_performance_log dashboard_performance_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dashboard_performance_log
    ADD CONSTRAINT dashboard_performance_log_pkey PRIMARY KEY (log_id);


--
-- TOC entry 3391 (class 2606 OID 16456)
-- Name: dim_objek_wisata dim_objek_wisata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_objek_wisata
    ADD CONSTRAINT dim_objek_wisata_pkey PRIMARY KEY (objek_wisata_id);


--
-- TOC entry 3396 (class 2606 OID 16478)
-- Name: dim_price dim_price_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_price
    ADD CONSTRAINT dim_price_pkey PRIMARY KEY (price_id);


--
-- TOC entry 3386 (class 2606 OID 16443)
-- Name: dim_time dim_time_periode_data_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_time
    ADD CONSTRAINT dim_time_periode_data_key UNIQUE (periode);


--
-- TOC entry 3388 (class 2606 OID 16441)
-- Name: dim_time dim_time_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_time
    ADD CONSTRAINT dim_time_pkey PRIMARY KEY (time_id);


--
-- TOC entry 3394 (class 2606 OID 16465)
-- Name: dim_wisatawan dim_wisatawan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_wisatawan
    ADD CONSTRAINT dim_wisatawan_pkey PRIMARY KEY (wisatawan_id);


--
-- TOC entry 3401 (class 2606 OID 16496)
-- Name: fact_kunjungan fact_kunjungan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT fact_kunjungan_pkey PRIMARY KEY (fact_id);


--
-- TOC entry 3384 (class 2606 OID 16429)
-- Name: staging_harga_tiket_raw staging_harga_tiket_raw_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staging_harga_tiket_raw
    ADD CONSTRAINT staging_harga_tiket_raw_pkey PRIMARY KEY (id);


--
-- TOC entry 3381 (class 2606 OID 16420)
-- Name: staging_kunjungan_raw staging_kunjungan_raw_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.staging_kunjungan_raw
    ADD CONSTRAINT staging_kunjungan_raw_pkey PRIMARY KEY (id);


--
-- TOC entry 3399 (class 2606 OID 16480)
-- Name: dim_price unique_objek_price; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_price
    ADD CONSTRAINT unique_objek_price UNIQUE (objek_wisata_id);


--
-- TOC entry 3407 (class 2606 OID 16498)
-- Name: fact_kunjungan uq_fact_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT uq_fact_key UNIQUE (time_id, objek_wisata_id, wisatawan_id);


--
-- TOC entry 3377 (class 2606 OID 16408)
-- Name: user_journey_log user_journey_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_journey_log
    ADD CONSTRAINT user_journey_log_pkey PRIMARY KEY (journey_id);


--
-- TOC entry 3392 (class 1259 OID 16520)
-- Name: idx_dim_objek_nama; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dim_objek_nama ON public.dim_objek_wisata USING btree (nama_objek);


--
-- TOC entry 3389 (class 1259 OID 16519)
-- Name: idx_dim_time_periode; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dim_time_periode ON public.dim_time USING btree (periode);


--
-- TOC entry 3402 (class 1259 OID 16525)
-- Name: idx_fact_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fact_created ON public.fact_kunjungan USING btree (created_at);


--
-- TOC entry 3403 (class 1259 OID 16523)
-- Name: idx_fact_objek; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fact_objek ON public.fact_kunjungan USING btree (objek_wisata_id);


--
-- TOC entry 3404 (class 1259 OID 16522)
-- Name: idx_fact_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fact_time ON public.fact_kunjungan USING btree (time_id);


--
-- TOC entry 3405 (class 1259 OID 16524)
-- Name: idx_fact_wisatawan; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fact_wisatawan ON public.fact_kunjungan USING btree (wisatawan_id);


--
-- TOC entry 3373 (class 1259 OID 16532)
-- Name: idx_journey_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_journey_session ON public.user_journey_log USING btree (session_id);


--
-- TOC entry 3374 (class 1259 OID 16533)
-- Name: idx_journey_stage; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_journey_stage ON public.user_journey_log USING btree (stage);


--
-- TOC entry 3375 (class 1259 OID 16534)
-- Name: idx_journey_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_journey_timestamp ON public.user_journey_log USING btree ("timestamp");


--
-- TOC entry 3370 (class 1259 OID 16529)
-- Name: idx_perf_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_perf_session ON public.dashboard_performance_log USING btree (session_id);


--
-- TOC entry 3371 (class 1259 OID 16531)
-- Name: idx_perf_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_perf_status ON public.dashboard_performance_log USING btree (status);


--
-- TOC entry 3372 (class 1259 OID 16530)
-- Name: idx_perf_timestamp; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_perf_timestamp ON public.dashboard_performance_log USING btree ("timestamp");


--
-- TOC entry 3397 (class 1259 OID 16521)
-- Name: idx_price_objek; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_price_objek ON public.dim_price USING btree (objek_wisata_id);


--
-- TOC entry 3382 (class 1259 OID 16528)
-- Name: idx_staging_harga_nama; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_staging_harga_nama ON public.staging_harga_tiket_raw USING btree (nama_objek_wisata);


--
-- TOC entry 3378 (class 1259 OID 16527)
-- Name: idx_staging_kunjungan_obyek; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_staging_kunjungan_obyek ON public.staging_kunjungan_raw USING btree (obyek_wisata);


--
-- TOC entry 3379 (class 1259 OID 16526)
-- Name: idx_staging_kunjungan_processed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_staging_kunjungan_processed ON public.staging_kunjungan_raw USING btree (is_processed);


--
-- TOC entry 3409 (class 2606 OID 16509)
-- Name: fact_kunjungan fk_fact_objek; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT fk_fact_objek FOREIGN KEY (objek_wisata_id) REFERENCES public.dim_objek_wisata(objek_wisata_id) ON DELETE CASCADE;


--
-- TOC entry 3410 (class 2606 OID 16504)
-- Name: fact_kunjungan fk_fact_time; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT fk_fact_time FOREIGN KEY (time_id) REFERENCES public.dim_time(time_id) ON DELETE CASCADE;


--
-- TOC entry 3411 (class 2606 OID 16514)
-- Name: fact_kunjungan fk_fact_wisatawan; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fact_kunjungan
    ADD CONSTRAINT fk_fact_wisatawan FOREIGN KEY (wisatawan_id) REFERENCES public.dim_wisatawan(wisatawan_id) ON DELETE CASCADE;


--
-- TOC entry 3408 (class 2606 OID 16499)
-- Name: dim_price fk_objek_wisata; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dim_price
    ADD CONSTRAINT fk_objek_wisata FOREIGN KEY (objek_wisata_id) REFERENCES public.dim_objek_wisata(objek_wisata_id) ON DELETE CASCADE;


-- Completed on 2025-12-10 08:29:20 WITA

--
-- PostgreSQL database dump complete
--

\unrestrict GLz27nDaB13jadpAJLbGTzAM2OPfrBi22n2KVroKHy9MSBFxyS1ffucKP8EDRf4

