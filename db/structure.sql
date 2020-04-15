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
-- Name: lang; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.lang AS ENUM (
    'ruby',
    'python',
    'nodejs',
    'react',
    'ios',
    'android',
    'others',
    'unassigned'
);


--
-- Name: metric_interval; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.metric_interval AS ENUM (
    'daily',
    'weekly',
    'monthly',
    'all_times'
);


--
-- Name: metric_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.metric_type AS ENUM (
    'review_turnaround'
);


--
-- Name: pull_request_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.pull_request_state AS ENUM (
    'open',
    'closed'
);


--
-- Name: review_comment_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.review_comment_state AS ENUM (
    'active',
    'removed'
);


--
-- Name: review_request_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.review_request_state AS ENUM (
    'active',
    'removed'
);


--
-- Name: review_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.review_state AS ENUM (
    'approved',
    'commented',
    'changes_requested',
    'dismissed'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_admin_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_admin_comments (
    id bigint NOT NULL,
    namespace character varying,
    body text,
    resource_type character varying,
    resource_id bigint,
    author_type character varying,
    author_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_admin_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_admin_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_admin_comments_id_seq OWNED BY public.active_admin_comments.id;


--
-- Name: admin_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admin_users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: admin_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.admin_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.admin_users_id_seq OWNED BY public.admin_users.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events (
    id bigint NOT NULL,
    handleable_type character varying,
    handleable_id bigint,
    name character varying,
    type character varying,
    data jsonb,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    project_id bigint NOT NULL,
    occurred_at timestamp without time zone
);


--
-- Name: events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_id_seq OWNED BY public.events.id;


--
-- Name: metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metrics (
    id bigint NOT NULL,
    value numeric,
    value_timestamp timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    metrics_definition_id bigint NOT NULL,
    ownable_type character varying NOT NULL,
    ownable_id bigint NOT NULL,
    name public.metric_type,
    "interval" public.metric_interval
);


--
-- Name: metrics_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metrics_definitions (
    id bigint NOT NULL,
    metrics_name character varying NOT NULL,
    time_interval character varying NOT NULL,
    metrics_processor character varying NOT NULL,
    last_processed_event_time timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: metrics_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metrics_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metrics_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metrics_definitions_id_seq OWNED BY public.metrics_definitions.id;


--
-- Name: metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metrics_id_seq OWNED BY public.metrics.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.projects (
    id bigint NOT NULL,
    github_id integer NOT NULL,
    name character varying,
    description character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lang public.lang DEFAULT 'unassigned'::public.lang
);


--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: pull_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pull_requests (
    id bigint NOT NULL,
    github_id bigint NOT NULL,
    number integer NOT NULL,
    locked boolean NOT NULL,
    title text NOT NULL,
    body text,
    closed_at timestamp without time zone,
    merged_at timestamp without time zone,
    draft boolean NOT NULL,
    node_id character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state public.pull_request_state,
    opened_at timestamp without time zone,
    project_id bigint NOT NULL,
    owner_id bigint
);


--
-- Name: pull_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pull_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pull_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pull_requests_id_seq OWNED BY public.pull_requests.id;


--
-- Name: review_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.review_comments (
    id bigint NOT NULL,
    github_id integer,
    body character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    pull_request_id bigint NOT NULL,
    owner_id bigint,
    state public.review_comment_state DEFAULT 'active'::public.review_comment_state
);


--
-- Name: review_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.review_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.review_comments_id_seq OWNED BY public.review_comments.id;


--
-- Name: review_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.review_requests (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    owner_id bigint,
    pull_request_id bigint NOT NULL,
    reviewer_id bigint NOT NULL,
    node_id character varying NOT NULL,
    login character varying NOT NULL,
    state public.review_request_state DEFAULT 'active'::public.review_request_state
);


--
-- Name: review_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.review_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.review_requests_id_seq OWNED BY public.review_requests.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    pull_request_id bigint NOT NULL,
    owner_id bigint,
    github_id integer,
    body character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state public.review_state NOT NULL,
    opened_at timestamp without time zone NOT NULL,
    review_request_id bigint
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    login character varying NOT NULL,
    node_id character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    github_id bigint NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_projects; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_projects (
    id bigint NOT NULL,
    user_id bigint,
    project_id bigint
);


--
-- Name: users_projects_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_projects_id_seq OWNED BY public.users_projects.id;


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics ALTER COLUMN id SET DEFAULT nextval('public.metrics_id_seq'::regclass);


--
-- Name: metrics_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics_definitions ALTER COLUMN id SET DEFAULT nextval('public.metrics_definitions_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: pull_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pull_requests ALTER COLUMN id SET DEFAULT nextval('public.pull_requests_id_seq'::regclass);


--
-- Name: review_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_comments ALTER COLUMN id SET DEFAULT nextval('public.review_comments_id_seq'::regclass);


--
-- Name: review_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests ALTER COLUMN id SET DEFAULT nextval('public.review_requests_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_projects id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_projects ALTER COLUMN id SET DEFAULT nextval('public.users_projects_id_seq'::regclass);


--
-- Name: active_admin_comments active_admin_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments
    ADD CONSTRAINT active_admin_comments_pkey PRIMARY KEY (id);


--
-- Name: admin_users admin_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users
    ADD CONSTRAINT admin_users_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: metrics_definitions metrics_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics_definitions
    ADD CONSTRAINT metrics_definitions_pkey PRIMARY KEY (id);


--
-- Name: metrics metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: pull_requests pull_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pull_requests
    ADD CONSTRAINT pull_requests_pkey PRIMARY KEY (id);


--
-- Name: review_comments review_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_comments
    ADD CONSTRAINT review_comments_pkey PRIMARY KEY (id);


--
-- Name: review_requests review_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT review_requests_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_projects users_projects_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_projects
    ADD CONSTRAINT users_projects_pkey PRIMARY KEY (id);


--
-- Name: index_active_admin_comments_on_author_type_and_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_author_type_and_author_id ON public.active_admin_comments USING btree (author_type, author_id);


--
-- Name: index_active_admin_comments_on_namespace; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_namespace ON public.active_admin_comments USING btree (namespace);


--
-- Name: index_active_admin_comments_on_resource_type_and_resource_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_admin_comments_on_resource_type_and_resource_id ON public.active_admin_comments USING btree (resource_type, resource_id);


--
-- Name: index_admin_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_email ON public.admin_users USING btree (email);


--
-- Name: index_admin_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_admin_users_on_reset_password_token ON public.admin_users USING btree (reset_password_token);


--
-- Name: index_events_on_handleable_type_and_handleable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_handleable_type_and_handleable_id ON public.events USING btree (handleable_type, handleable_id);


--
-- Name: index_events_on_occurred_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_occurred_at ON public.events USING btree (occurred_at);


--
-- Name: index_events_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_project_id ON public.events USING btree (project_id);


--
-- Name: index_metrics_on_metrics_definition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metrics_on_metrics_definition_id ON public.metrics USING btree (metrics_definition_id);


--
-- Name: index_metrics_on_ownable_type_and_ownable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metrics_on_ownable_type_and_ownable_id ON public.metrics USING btree (ownable_type, ownable_id);


--
-- Name: index_pull_requests_on_github_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_pull_requests_on_github_id ON public.pull_requests USING btree (github_id);


--
-- Name: index_pull_requests_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pull_requests_on_owner_id ON public.pull_requests USING btree (owner_id);


--
-- Name: index_pull_requests_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pull_requests_on_project_id ON public.pull_requests USING btree (project_id);


--
-- Name: index_pull_requests_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pull_requests_on_state ON public.pull_requests USING btree (state);


--
-- Name: index_review_comments_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_comments_on_owner_id ON public.review_comments USING btree (owner_id);


--
-- Name: index_review_comments_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_comments_on_pull_request_id ON public.review_comments USING btree (pull_request_id);


--
-- Name: index_review_comments_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_comments_on_state ON public.review_comments USING btree (state);


--
-- Name: index_review_requests_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_requests_on_owner_id ON public.review_requests USING btree (owner_id);


--
-- Name: index_review_requests_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_requests_on_pull_request_id ON public.review_requests USING btree (pull_request_id);


--
-- Name: index_review_requests_on_reviewer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_requests_on_reviewer_id ON public.review_requests USING btree (reviewer_id);


--
-- Name: index_review_requests_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_requests_on_state ON public.review_requests USING btree (state);


--
-- Name: index_reviews_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_owner_id ON public.reviews USING btree (owner_id);


--
-- Name: index_reviews_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_pull_request_id ON public.reviews USING btree (pull_request_id);


--
-- Name: index_reviews_on_review_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_review_request_id ON public.reviews USING btree (review_request_id);


--
-- Name: index_reviews_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_state ON public.reviews USING btree (state);


--
-- Name: index_users_on_github_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_github_id ON public.users USING btree (github_id);


--
-- Name: index_users_projects_on_project_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_projects_on_project_id ON public.users_projects USING btree (project_id);


--
-- Name: index_users_projects_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_projects_on_user_id ON public.users_projects USING btree (user_id);


--
-- Name: review_comments fk_rails_04feb57025; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_comments
    ADD CONSTRAINT fk_rails_04feb57025 FOREIGN KEY (pull_request_id) REFERENCES public.pull_requests(id);


--
-- Name: reviews fk_rails_4862a15e3a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_4862a15e3a FOREIGN KEY (pull_request_id) REFERENCES public.pull_requests(id);


--
-- Name: review_comments fk_rails_4a92157916; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_comments
    ADD CONSTRAINT fk_rails_4a92157916 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: pull_requests fk_rails_5df700b412; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pull_requests
    ADD CONSTRAINT fk_rails_5df700b412 FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: pull_requests fk_rails_658eb0bfb4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pull_requests
    ADD CONSTRAINT fk_rails_658eb0bfb4 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: review_requests fk_rails_9ece0f7518; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT fk_rails_9ece0f7518 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: metrics fk_rails_a828ab15c4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT fk_rails_a828ab15c4 FOREIGN KEY (metrics_definition_id) REFERENCES public.metrics_definitions(id);


--
-- Name: reviews fk_rails_bcf65590e4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_rails_bcf65590e4 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: review_requests fk_rails_d83bae1089; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT fk_rails_d83bae1089 FOREIGN KEY (reviewer_id) REFERENCES public.users(id);


--
-- Name: review_requests fk_rails_feb865e207; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT fk_rails_feb865e207 FOREIGN KEY (pull_request_id) REFERENCES public.pull_requests(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20191220183808'),
('20191220183838'),
('20191220190613'),
('20191220192022'),
('20191223133115'),
('20191223133712'),
('20191223141540'),
('20191223145336'),
('20191223145416'),
('20191226185853'),
('20191226190938'),
('20191226195441'),
('20191227202204'),
('20191227203014'),
('20191230180053'),
('20191231130959'),
('20191231134130'),
('20200122143238'),
('20200122180806'),
('20200128190806'),
('20200131153049'),
('20200131153056'),
('20200203141336'),
('20200204134248'),
('20200204134315'),
('20200204140453'),
('20200204201145'),
('20200204202145'),
('20200206203510'),
('20200206203850'),
('20200212151614'),
('20200217165218'),
('20200219141137'),
('20200302120947'),
('20200303210031'),
('20200305141203'),
('20200305142724'),
('20200305150412'),
('20200305150445'),
('20200305171608'),
('20200311132103'),
('20200312144232'),
('20200312161141'),
('20200318125243'),
('20200318160321'),
('20200318171820'),
('20200327172924'),
('20200330162011'),
('20200401200520'),
('20200401205154'),
('20200402175059'),
('20200403140307'),
('20200415162514');


