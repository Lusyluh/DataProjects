--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-07-09 15:55:39

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
-- TOC entry 218 (class 1259 OID 16389)
-- Name: dim_customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dim_customer (
    customer_pk integer NOT NULL,
    customer_id character varying(255) NOT NULL,
    gender character varying(10),
    is_senior_citizen boolean,
    has_partner boolean,
    has_dependents boolean,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dim_customer OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16388)
-- Name: dim_customer_customer_pk_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dim_customer_customer_pk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dim_customer_customer_pk_seq OWNER TO postgres;

--
-- TOC entry 4876 (class 0 OID 0)
-- Dependencies: 217
-- Name: dim_customer_customer_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dim_customer_customer_pk_seq OWNED BY public.dim_customer.customer_pk;


--
-- TOC entry 222 (class 1259 OID 16408)
-- Name: fact_churn_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fact_churn_events (
    event_pk integer NOT NULL,
    customer_pk integer NOT NULL,
    phone_service character varying(10),
    multiple_lines character varying(10),
    internet_service character varying(50),
    online_security boolean,
    online_backup boolean,
    device_protection boolean,
    tech_support boolean,
    streaming_tv boolean,
    streaming_movies boolean,
    contract_type character varying(50),
    paperless_billing boolean,
    payment_method character varying(50),
    monthly_charges numeric(10,2),
    total_charges numeric(10,2),
    tenure_months integer,
    churned boolean,
    processed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.fact_churn_events OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16407)
-- Name: fact_churn_events_event_pk_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fact_churn_events_event_pk_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fact_churn_events_event_pk_seq OWNER TO postgres;

--
-- TOC entry 4877 (class 0 OID 0)
-- Dependencies: 221
-- Name: fact_churn_events_event_pk_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fact_churn_events_event_pk_seq OWNED BY public.fact_churn_events.event_pk;


--
-- TOC entry 220 (class 1259 OID 16404)
-- Name: stg_customer_demographics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stg_customer_demographics (
    customerid character varying(255),
    gender character varying(10),
    seniorcitizen character varying(10),
    partner character varying(10),
    dependents character varying(10)
);


ALTER TABLE public.stg_customer_demographics OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16399)
-- Name: stg_customer_services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stg_customer_services (
    customerid character varying(225),
    phoneservice character varying(10),
    multiplelines character varying(10),
    internetservice character varying(50),
    onlinesecurity character varying(10),
    onlinebackup character varying(10),
    deviceprotection character varying(10),
    techsupport character varying(10),
    streamingtv character varying(10),
    streamingmovies character varying(10),
    contract character varying(50),
    paperlessbilling character varying(10),
    paymentmethod character varying(50),
    monthlycharges numeric(10,2),
    totalcharges numeric(10,2),
    tenure character varying(10),
    churn character varying(10)
);


ALTER TABLE public.stg_customer_services OWNER TO postgres;

--
-- TOC entry 4708 (class 2604 OID 16392)
-- Name: dim_customer customer_pk; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_customer ALTER COLUMN customer_pk SET DEFAULT nextval('public.dim_customer_customer_pk_seq'::regclass);


--
-- TOC entry 4711 (class 2604 OID 16411)
-- Name: fact_churn_events event_pk; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_churn_events ALTER COLUMN event_pk SET DEFAULT nextval('public.fact_churn_events_event_pk_seq'::regclass);


--
-- TOC entry 4866 (class 0 OID 16389)
-- Dependencies: 218
-- Data for Name: dim_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dim_customer (customer_pk, customer_id, gender, is_senior_citizen, has_partner, has_dependents, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4870 (class 0 OID 16408)
-- Dependencies: 222
-- Data for Name: fact_churn_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fact_churn_events (event_pk, customer_pk, phone_service, multiple_lines, internet_service, online_security, online_backup, device_protection, tech_support, streaming_tv, streaming_movies, contract_type, paperless_billing, payment_method, monthly_charges, total_charges, tenure_months, churned, processed_at) FROM stdin;
\.


--
-- TOC entry 4868 (class 0 OID 16404)
-- Dependencies: 220
-- Data for Name: stg_customer_demographics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stg_customer_demographics (customerid, gender, seniorcitizen, partner, dependents) FROM stdin;
\.


--
-- TOC entry 4867 (class 0 OID 16399)
-- Dependencies: 219
-- Data for Name: stg_customer_services; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stg_customer_services (customerid, phoneservice, multiplelines, internetservice, onlinesecurity, onlinebackup, deviceprotection, techsupport, streamingtv, streamingmovies, contract, paperlessbilling, paymentmethod, monthlycharges, totalcharges, tenure, churn) FROM stdin;
\.


--
-- TOC entry 4878 (class 0 OID 0)
-- Dependencies: 217
-- Name: dim_customer_customer_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dim_customer_customer_pk_seq', 1, false);


--
-- TOC entry 4879 (class 0 OID 0)
-- Dependencies: 221
-- Name: fact_churn_events_event_pk_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fact_churn_events_event_pk_seq', 1, false);


--
-- TOC entry 4714 (class 2606 OID 16398)
-- Name: dim_customer dim_customer_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_customer
    ADD CONSTRAINT dim_customer_customer_id_key UNIQUE (customer_id);


--
-- TOC entry 4716 (class 2606 OID 16396)
-- Name: dim_customer dim_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dim_customer
    ADD CONSTRAINT dim_customer_pkey PRIMARY KEY (customer_pk);


--
-- TOC entry 4718 (class 2606 OID 16414)
-- Name: fact_churn_events fact_churn_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_churn_events
    ADD CONSTRAINT fact_churn_events_pkey PRIMARY KEY (event_pk);


--
-- TOC entry 4719 (class 2606 OID 16415)
-- Name: fact_churn_events fact_churn_events_customer_pk_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fact_churn_events
    ADD CONSTRAINT fact_churn_events_customer_pk_fkey FOREIGN KEY (customer_pk) REFERENCES public.dim_customer(customer_pk);


-- Completed on 2025-07-09 15:55:39

--
-- PostgreSQL database dump complete
--

