--
-- PostgreSQL database dump
--

-- Dumped from database version 10.12
-- Dumped by pg_dump version 10.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: cluster; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cluster (
    id integer NOT NULL,
    gateway_ip inet NOT NULL
);


--
-- Name: cluster_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.cluster_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cluster_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.cluster_id_seq OWNED BY public.cluster.id;


--
-- Name: measurement; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.measurement (
    id integer NOT NULL,
    sensor integer,
    "time" timestamp without time zone,
    value bytea
);


--
-- Name: measurement_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measurement_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurement_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measurement_id_seq OWNED BY public.measurement.id;


--
-- Name: node; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.node (
    id integer NOT NULL,
    friendly_name text,
    cluster integer
);


--
-- Name: node_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.node_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: node_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.node_id_seq OWNED BY public.node.id;


--
-- Name: sensor; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sensor (
    id integer NOT NULL,
    sensor_type integer,
    node integer
);


--
-- Name: sensor_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sensor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sensor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sensor_id_seq OWNED BY public.sensor.id;


--
-- Name: sensor_type; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sensor_type (
    id integer NOT NULL,
    name text,
    unit text
);


--
-- Name: sensor_type_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sensor_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sensor_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sensor_type_id_seq OWNED BY public.sensor_type.id;


--
-- Name: cluster id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster ALTER COLUMN id SET DEFAULT nextval('public.cluster_id_seq'::regclass);


--
-- Name: measurement id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement ALTER COLUMN id SET DEFAULT nextval('public.measurement_id_seq'::regclass);


--
-- Name: node id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node ALTER COLUMN id SET DEFAULT nextval('public.node_id_seq'::regclass);


--
-- Name: sensor id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensor ALTER COLUMN id SET DEFAULT nextval('public.sensor_id_seq'::regclass);


--
-- Name: sensor_type id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensor_type ALTER COLUMN id SET DEFAULT nextval('public.sensor_type_id_seq'::regclass);


--
-- Name: cluster pk_cluster; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cluster
    ADD CONSTRAINT pk_cluster PRIMARY KEY (id);


--
-- Name: measurement pk_measurement; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT pk_measurement PRIMARY KEY (id);


--
-- Name: node pk_node; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node
    ADD CONSTRAINT pk_node PRIMARY KEY (id);


--
-- Name: sensor pk_sensor; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT pk_sensor PRIMARY KEY (id);


--
-- Name: sensor_type pk_sensor_type; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensor_type
    ADD CONSTRAINT pk_sensor_type PRIMARY KEY (id);


--
-- Name: measurement fk_measurement_sensor; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.measurement
    ADD CONSTRAINT fk_measurement_sensor FOREIGN KEY (sensor) REFERENCES public.sensor(id);


--
-- Name: node fk_node_cluster; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.node
    ADD CONSTRAINT fk_node_cluster FOREIGN KEY (cluster) REFERENCES public.cluster(id);


--
-- Name: sensor fk_sensor__sensor_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT fk_sensor__sensor_type FOREIGN KEY (sensor_type) REFERENCES public.sensor_type(id);


--
-- Name: sensor fk_sensor_node; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sensor
    ADD CONSTRAINT fk_sensor_node FOREIGN KEY (node) REFERENCES public.node(id);


--
-- PostgreSQL database dump complete
--

