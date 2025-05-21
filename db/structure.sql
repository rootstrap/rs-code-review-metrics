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
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: department_name; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.department_name AS ENUM (
    'mobile',
    'frontend',
    'backend'
);


--
-- Name: environment; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.environment AS ENUM (
    'not_assigned',
    'local',
    'development',
    'qa',
    'staging',
    'production'
);


--
-- Name: external_pull_request_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.external_pull_request_state AS ENUM (
    'open',
    'closed',
    'merged'
);


--
-- Name: issue_type; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.issue_type AS ENUM (
    'bug',
    'task',
    'epic',
    'story'
);


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
    'unassigned',
    'vuejs',
    'react_native'
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
-- Name: metric_name; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.metric_name AS ENUM (
    'review_turnaround',
    'blog_visits',
    'merge_time',
    'blog_post_count',
    'open_source_visits',
    'defect_escape_rate',
    'pull_request_size',
    'development_cycle',
    'planned_to_done',
    'review_coverage'
);


--
-- Name: project_relevance; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.project_relevance AS ENUM (
    'commercial',
    'internal',
    'ignored',
    'unassigned'
);


--
-- Name: pull_request_comment_state; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.pull_request_comment_state AS ENUM (
    'created',
    'edited',
    'deleted'
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
-- Name: alerts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alerts (
    id bigint NOT NULL,
    name character varying,
    metric_name character varying NOT NULL,
    threshold integer NOT NULL,
    emails character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    frequency integer NOT NULL,
    last_sent_date timestamp without time zone,
    active boolean DEFAULT false NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    repository_id bigint,
    department_id bigint
);


--
-- Name: alerts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.alerts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: alerts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.alerts_id_seq OWNED BY public.alerts.id;


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
-- Name: blog_post_technologies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_post_technologies (
    id bigint NOT NULL,
    blog_post_id bigint NOT NULL,
    technology_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: blog_post_technologies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blog_post_technologies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_post_technologies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blog_post_technologies_id_seq OWNED BY public.blog_post_technologies.id;


--
-- Name: blog_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_posts (
    id bigint NOT NULL,
    blog_id integer,
    slug character varying,
    published_at timestamp without time zone,
    url character varying,
    status character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: blog_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blog_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_posts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blog_posts_id_seq OWNED BY public.blog_posts.id;


--
-- Name: code_climate_repository_metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.code_climate_repository_metrics (
    id bigint NOT NULL,
    repository_id bigint NOT NULL,
    code_climate_rate character varying,
    invalid_issues_count integer,
    wont_fix_issues_count integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    open_issues_count integer,
    snapshot_time timestamp without time zone,
    cc_repository_id character varying,
    test_coverage numeric,
    deleted_at timestamp without time zone
);


--
-- Name: code_climate_repository_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.code_climate_repository_metrics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: code_climate_repository_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.code_climate_repository_metrics_id_seq OWNED BY public.code_climate_repository_metrics.id;


--
-- Name: code_owner_repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.code_owner_repositories (
    id bigint NOT NULL,
    repository_id bigint NOT NULL,
    user_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: code_owner_repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.code_owner_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: code_owner_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.code_owner_repositories_id_seq OWNED BY public.code_owner_repositories.id;


--
-- Name: completed_review_turnarounds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.completed_review_turnarounds (
    id bigint NOT NULL,
    review_request_id bigint NOT NULL,
    value integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    deleted_at timestamp without time zone,
    pull_request_id bigint
);


--
-- Name: completed_review_turnarounds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.completed_review_turnarounds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: completed_review_turnarounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.completed_review_turnarounds_id_seq OWNED BY public.completed_review_turnarounds.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.departments (
    id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    name public.department_name NOT NULL
);


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.departments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


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
    repository_id bigint NOT NULL
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
-- Name: events_pull_request_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events_pull_request_comments (
    id bigint NOT NULL,
    github_id bigint,
    body character varying,
    opened_at timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    pull_request_id bigint NOT NULL,
    owner_id bigint,
    review_request_id bigint,
    state public.pull_request_comment_state DEFAULT 'created'::public.pull_request_comment_state
);


--
-- Name: events_pull_request_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_pull_request_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_pull_request_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_pull_request_comments_id_seq OWNED BY public.events_pull_request_comments.id;


--
-- Name: events_pull_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events_pull_requests (
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
    repository_id bigint,
    owner_id bigint,
    html_url character varying,
    branch character varying,
    size integer
);


--
-- Name: events_pull_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_pull_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_pull_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_pull_requests_id_seq OWNED BY public.events_pull_requests.id;


--
-- Name: events_pushes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events_pushes (
    id bigint NOT NULL,
    repository_id bigint NOT NULL,
    pull_request_id bigint,
    sender_id bigint NOT NULL,
    ref character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: events_pushes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_pushes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_pushes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_pushes_id_seq OWNED BY public.events_pushes.id;


--
-- Name: events_repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events_repositories (
    id bigint NOT NULL,
    action character varying,
    html_url character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    sender_id bigint NOT NULL,
    repository_id bigint NOT NULL
);


--
-- Name: events_repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_repositories_id_seq OWNED BY public.events_repositories.id;


--
-- Name: events_review_comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events_review_comments (
    id bigint NOT NULL,
    github_id bigint,
    body character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    pull_request_id bigint NOT NULL,
    owner_id bigint,
    state public.review_comment_state DEFAULT 'active'::public.review_comment_state
);


--
-- Name: events_review_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_review_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_review_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_review_comments_id_seq OWNED BY public.events_review_comments.id;


--
-- Name: events_reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.events_reviews (
    id bigint NOT NULL,
    pull_request_id bigint NOT NULL,
    owner_id bigint,
    github_id bigint,
    body character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    state public.review_state NOT NULL,
    opened_at timestamp without time zone NOT NULL,
    review_request_id bigint,
    repository_id bigint
);


--
-- Name: events_reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.events_reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: events_reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.events_reviews_id_seq OWNED BY public.events_reviews.id;


--
-- Name: exception_hunter_error_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exception_hunter_error_groups (
    id bigint NOT NULL,
    error_class_name character varying NOT NULL,
    message character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    status integer DEFAULT 0,
    tags text[] DEFAULT '{}'::text[]
);


--
-- Name: exception_hunter_error_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exception_hunter_error_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exception_hunter_error_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exception_hunter_error_groups_id_seq OWNED BY public.exception_hunter_error_groups.id;


--
-- Name: exception_hunter_errors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.exception_hunter_errors (
    id bigint NOT NULL,
    class_name character varying NOT NULL,
    message character varying,
    occurred_at timestamp without time zone NOT NULL,
    environment_data json,
    custom_data json,
    user_data json,
    backtrace character varying[] DEFAULT '{}'::character varying[],
    error_group_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: exception_hunter_errors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.exception_hunter_errors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: exception_hunter_errors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.exception_hunter_errors_id_seq OWNED BY public.exception_hunter_errors.id;


--
-- Name: external_pull_requests; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.external_pull_requests (
    id bigint NOT NULL,
    body text,
    html_url character varying NOT NULL,
    title text,
    github_id bigint,
    owner_id bigint,
    external_repository_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    opened_at timestamp without time zone,
    state public.external_pull_request_state,
    number integer
);


--
-- Name: external_pull_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.external_pull_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: external_pull_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.external_pull_requests_id_seq OWNED BY public.external_pull_requests.id;


--
-- Name: external_repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.external_repositories (
    id bigint NOT NULL,
    description character varying,
    name character varying,
    full_name character varying NOT NULL,
    github_id bigint NOT NULL,
    language_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    enabled boolean DEFAULT true NOT NULL
);


--
-- Name: external_repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.external_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: external_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.external_repositories_id_seq OWNED BY public.external_repositories.id;


--
-- Name: file_ignoring_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.file_ignoring_rules (
    id bigint NOT NULL,
    language_id bigint NOT NULL,
    regex character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: file_ignoring_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.file_ignoring_rules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_ignoring_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.file_ignoring_rules_id_seq OWNED BY public.file_ignoring_rules.id;


--
-- Name: jira_boards; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jira_boards (
    id bigint NOT NULL,
    jira_project_key character varying NOT NULL,
    project_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    deleted_at timestamp without time zone,
    product_id bigint,
    jira_board_id integer,
    jira_self_url character varying
);


--
-- Name: jira_boards_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jira_boards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jira_boards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jira_boards_id_seq OWNED BY public.jira_boards.id;


--
-- Name: jira_issues; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jira_issues (
    id bigint NOT NULL,
    informed_at timestamp without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    issue_type public.issue_type NOT NULL,
    environment public.environment,
    key character varying,
    deleted_at timestamp without time zone,
    resolved_at timestamp without time zone,
    in_progress_at timestamp without time zone,
    jira_board_id bigint
);


--
-- Name: jira_issues_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jira_issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jira_issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jira_issues_id_seq OWNED BY public.jira_issues.id;


--
-- Name: jira_sprints; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.jira_sprints (
    id bigint NOT NULL,
    jira_id integer NOT NULL,
    name character varying,
    points_committed integer,
    points_completed integer,
    started_at timestamp without time zone NOT NULL,
    ended_at timestamp without time zone,
    active boolean,
    deleted_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    jira_board_id bigint NOT NULL
);


--
-- Name: jira_sprints_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jira_sprints_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: jira_sprints_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.jira_sprints_id_seq OWNED BY public.jira_sprints.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.languages (
    id bigint NOT NULL,
    name character varying NOT NULL,
    department_id bigint
);


--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;


--
-- Name: merge_times; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.merge_times (
    id bigint NOT NULL,
    pull_request_id bigint NOT NULL,
    value integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    deleted_at timestamp without time zone
);


--
-- Name: merge_times_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.merge_times_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: merge_times_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.merge_times_id_seq OWNED BY public.merge_times.id;


--
-- Name: metric_definitions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metric_definitions (
    id bigint NOT NULL,
    name character varying NOT NULL,
    explanation character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    code public.metric_name NOT NULL
);


--
-- Name: metric_definitions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.metric_definitions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: metric_definitions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.metric_definitions_id_seq OWNED BY public.metric_definitions.id;


--
-- Name: metrics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metrics (
    id bigint NOT NULL,
    value numeric,
    value_timestamp timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    ownable_type character varying NOT NULL,
    ownable_id bigint NOT NULL,
    name public.metric_name,
    "interval" public.metric_interval DEFAULT 'daily'::public.metric_interval,
    deleted_at timestamp without time zone
);


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
-- Name: metrics_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.metrics_products (
    product_id bigint NOT NULL,
    metric_id bigint NOT NULL
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    created_at timestamp(6) without time zone,
    updated_at timestamp(6) without time zone,
    deleted_at timestamp without time zone,
    enabled boolean DEFAULT true NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.repositories (
    id bigint NOT NULL,
    github_id bigint NOT NULL,
    name character varying,
    description character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    language_id bigint,
    is_private boolean,
    relevance public.project_relevance DEFAULT 'unassigned'::public.project_relevance NOT NULL,
    deleted_at timestamp without time zone,
    product_id bigint
);


--
-- Name: repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.repositories_id_seq OWNED BY public.repositories.id;


--
-- Name: review_coverages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.review_coverages (
    id bigint NOT NULL,
    pull_request_id bigint NOT NULL,
    total_files_changed integer NOT NULL,
    files_with_comments_count integer NOT NULL,
    coverage_percentage numeric NOT NULL,
    deleted_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: review_coverages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.review_coverages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_coverages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.review_coverages_id_seq OWNED BY public.review_coverages.id;


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
    state public.review_request_state DEFAULT 'active'::public.review_request_state,
    repository_id bigint,
    deleted_at timestamp without time zone
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
-- Name: review_turnarounds; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.review_turnarounds (
    id bigint NOT NULL,
    review_request_id bigint NOT NULL,
    value integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    pull_request_id bigint
);


--
-- Name: review_turnarounds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.review_turnarounds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: review_turnarounds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.review_turnarounds_id_seq OWNED BY public.review_turnarounds.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.settings (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value character varying,
    description character varying DEFAULT ''::character varying
);


--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: technologies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.technologies (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    keyword_string text
);


--
-- Name: technologies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.technologies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: technologies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.technologies_id_seq OWNED BY public.technologies.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    login character varying NOT NULL,
    node_id character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    github_id bigint NOT NULL,
    company_member_since date,
    company_member_until date
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
-- Name: users_repositories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_repositories (
    id bigint NOT NULL,
    user_id bigint,
    repository_id bigint,
    deleted_at timestamp without time zone
);


--
-- Name: users_repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_repositories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_repositories_id_seq OWNED BY public.users_repositories.id;


--
-- Name: active_admin_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_admin_comments ALTER COLUMN id SET DEFAULT nextval('public.active_admin_comments_id_seq'::regclass);


--
-- Name: admin_users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admin_users ALTER COLUMN id SET DEFAULT nextval('public.admin_users_id_seq'::regclass);


--
-- Name: alerts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerts ALTER COLUMN id SET DEFAULT nextval('public.alerts_id_seq'::regclass);


--
-- Name: blog_post_technologies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_post_technologies ALTER COLUMN id SET DEFAULT nextval('public.blog_post_technologies_id_seq'::regclass);


--
-- Name: blog_posts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_posts ALTER COLUMN id SET DEFAULT nextval('public.blog_posts_id_seq'::regclass);


--
-- Name: code_climate_repository_metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_climate_repository_metrics ALTER COLUMN id SET DEFAULT nextval('public.code_climate_repository_metrics_id_seq'::regclass);


--
-- Name: code_owner_repositories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_owner_repositories ALTER COLUMN id SET DEFAULT nextval('public.code_owner_repositories_id_seq'::regclass);


--
-- Name: completed_review_turnarounds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.completed_review_turnarounds ALTER COLUMN id SET DEFAULT nextval('public.completed_review_turnarounds_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events ALTER COLUMN id SET DEFAULT nextval('public.events_id_seq'::regclass);


--
-- Name: events_pull_request_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pull_request_comments ALTER COLUMN id SET DEFAULT nextval('public.events_pull_request_comments_id_seq'::regclass);


--
-- Name: events_pull_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pull_requests ALTER COLUMN id SET DEFAULT nextval('public.events_pull_requests_id_seq'::regclass);


--
-- Name: events_pushes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pushes ALTER COLUMN id SET DEFAULT nextval('public.events_pushes_id_seq'::regclass);


--
-- Name: events_repositories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_repositories ALTER COLUMN id SET DEFAULT nextval('public.events_repositories_id_seq'::regclass);


--
-- Name: events_review_comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_review_comments ALTER COLUMN id SET DEFAULT nextval('public.events_review_comments_id_seq'::regclass);


--
-- Name: events_reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_reviews ALTER COLUMN id SET DEFAULT nextval('public.events_reviews_id_seq'::regclass);


--
-- Name: exception_hunter_error_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exception_hunter_error_groups ALTER COLUMN id SET DEFAULT nextval('public.exception_hunter_error_groups_id_seq'::regclass);


--
-- Name: exception_hunter_errors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exception_hunter_errors ALTER COLUMN id SET DEFAULT nextval('public.exception_hunter_errors_id_seq'::regclass);


--
-- Name: external_pull_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_pull_requests ALTER COLUMN id SET DEFAULT nextval('public.external_pull_requests_id_seq'::regclass);


--
-- Name: external_repositories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_repositories ALTER COLUMN id SET DEFAULT nextval('public.external_repositories_id_seq'::regclass);


--
-- Name: file_ignoring_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_ignoring_rules ALTER COLUMN id SET DEFAULT nextval('public.file_ignoring_rules_id_seq'::regclass);


--
-- Name: jira_boards id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_boards ALTER COLUMN id SET DEFAULT nextval('public.jira_boards_id_seq'::regclass);


--
-- Name: jira_issues id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_issues ALTER COLUMN id SET DEFAULT nextval('public.jira_issues_id_seq'::regclass);


--
-- Name: jira_sprints id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_sprints ALTER COLUMN id SET DEFAULT nextval('public.jira_sprints_id_seq'::regclass);


--
-- Name: languages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);


--
-- Name: merge_times id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_times ALTER COLUMN id SET DEFAULT nextval('public.merge_times_id_seq'::regclass);


--
-- Name: metric_definitions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_definitions ALTER COLUMN id SET DEFAULT nextval('public.metric_definitions_id_seq'::regclass);


--
-- Name: metrics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics ALTER COLUMN id SET DEFAULT nextval('public.metrics_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: repositories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories ALTER COLUMN id SET DEFAULT nextval('public.repositories_id_seq'::regclass);


--
-- Name: review_coverages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_coverages ALTER COLUMN id SET DEFAULT nextval('public.review_coverages_id_seq'::regclass);


--
-- Name: review_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests ALTER COLUMN id SET DEFAULT nextval('public.review_requests_id_seq'::regclass);


--
-- Name: review_turnarounds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_turnarounds ALTER COLUMN id SET DEFAULT nextval('public.review_turnarounds_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: technologies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technologies ALTER COLUMN id SET DEFAULT nextval('public.technologies_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_repositories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_repositories ALTER COLUMN id SET DEFAULT nextval('public.users_repositories_id_seq'::regclass);


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
-- Name: alerts alerts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT alerts_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blog_post_technologies blog_post_technologies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_post_technologies
    ADD CONSTRAINT blog_post_technologies_pkey PRIMARY KEY (id);


--
-- Name: blog_posts blog_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_pkey PRIMARY KEY (id);


--
-- Name: code_climate_repository_metrics code_climate_repository_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_climate_repository_metrics
    ADD CONSTRAINT code_climate_repository_metrics_pkey PRIMARY KEY (id);


--
-- Name: code_owner_repositories code_owner_repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_owner_repositories
    ADD CONSTRAINT code_owner_repositories_pkey PRIMARY KEY (id);


--
-- Name: completed_review_turnarounds completed_review_turnarounds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.completed_review_turnarounds
    ADD CONSTRAINT completed_review_turnarounds_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: events_pull_request_comments events_pull_request_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pull_request_comments
    ADD CONSTRAINT events_pull_request_comments_pkey PRIMARY KEY (id);


--
-- Name: events_pull_requests events_pull_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pull_requests
    ADD CONSTRAINT events_pull_requests_pkey PRIMARY KEY (id);


--
-- Name: events_pushes events_pushes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pushes
    ADD CONSTRAINT events_pushes_pkey PRIMARY KEY (id);


--
-- Name: events_repositories events_repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_repositories
    ADD CONSTRAINT events_repositories_pkey PRIMARY KEY (id);


--
-- Name: events_review_comments events_review_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_review_comments
    ADD CONSTRAINT events_review_comments_pkey PRIMARY KEY (id);


--
-- Name: events_reviews events_reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_reviews
    ADD CONSTRAINT events_reviews_pkey PRIMARY KEY (id);


--
-- Name: exception_hunter_error_groups exception_hunter_error_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exception_hunter_error_groups
    ADD CONSTRAINT exception_hunter_error_groups_pkey PRIMARY KEY (id);


--
-- Name: exception_hunter_errors exception_hunter_errors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exception_hunter_errors
    ADD CONSTRAINT exception_hunter_errors_pkey PRIMARY KEY (id);


--
-- Name: external_pull_requests external_pull_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_pull_requests
    ADD CONSTRAINT external_pull_requests_pkey PRIMARY KEY (id);


--
-- Name: external_repositories external_repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_repositories
    ADD CONSTRAINT external_repositories_pkey PRIMARY KEY (id);


--
-- Name: file_ignoring_rules file_ignoring_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_ignoring_rules
    ADD CONSTRAINT file_ignoring_rules_pkey PRIMARY KEY (id);


--
-- Name: jira_boards jira_boards_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_boards
    ADD CONSTRAINT jira_boards_pkey PRIMARY KEY (id);


--
-- Name: jira_issues jira_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_issues
    ADD CONSTRAINT jira_issues_pkey PRIMARY KEY (id);


--
-- Name: jira_sprints jira_sprints_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_sprints
    ADD CONSTRAINT jira_sprints_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: merge_times merge_times_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_times
    ADD CONSTRAINT merge_times_pkey PRIMARY KEY (id);


--
-- Name: metric_definitions metric_definitions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metric_definitions
    ADD CONSTRAINT metric_definitions_pkey PRIMARY KEY (id);


--
-- Name: metrics metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.metrics
    ADD CONSTRAINT metrics_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: repositories repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_pkey PRIMARY KEY (id);


--
-- Name: review_coverages review_coverages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_coverages
    ADD CONSTRAINT review_coverages_pkey PRIMARY KEY (id);


--
-- Name: review_requests review_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT review_requests_pkey PRIMARY KEY (id);


--
-- Name: review_turnarounds review_turnarounds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_turnarounds
    ADD CONSTRAINT review_turnarounds_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: technologies technologies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.technologies
    ADD CONSTRAINT technologies_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_repositories users_repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_repositories
    ADD CONSTRAINT users_repositories_pkey PRIMARY KEY (id);


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
-- Name: index_alerts_on_department_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alerts_on_department_id ON public.alerts USING btree (department_id);


--
-- Name: index_alerts_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_alerts_on_repository_id ON public.alerts USING btree (repository_id);


--
-- Name: index_blog_post_technologies_on_blog_post_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blog_post_technologies_on_blog_post_id ON public.blog_post_technologies USING btree (blog_post_id);


--
-- Name: index_blog_post_technologies_on_technology_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_blog_post_technologies_on_technology_id ON public.blog_post_technologies USING btree (technology_id);


--
-- Name: index_code_climate_repository_metrics_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_code_climate_repository_metrics_on_repository_id ON public.code_climate_repository_metrics USING btree (repository_id);


--
-- Name: index_code_owner_repositories_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_code_owner_repositories_on_repository_id ON public.code_owner_repositories USING btree (repository_id);


--
-- Name: index_code_owner_repositories_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_code_owner_repositories_on_user_id ON public.code_owner_repositories USING btree (user_id);


--
-- Name: index_completed_review_turnarounds_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_completed_review_turnarounds_on_pull_request_id ON public.completed_review_turnarounds USING btree (pull_request_id);


--
-- Name: index_completed_review_turnarounds_on_review_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_completed_review_turnarounds_on_review_request_id ON public.completed_review_turnarounds USING btree (review_request_id);


--
-- Name: index_departments_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_departments_on_name ON public.departments USING btree (name);


--
-- Name: index_events_on_handleable_type_and_handleable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_handleable_type_and_handleable_id ON public.events USING btree (handleable_type, handleable_id);


--
-- Name: index_events_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_on_repository_id ON public.events USING btree (repository_id);


--
-- Name: index_events_pull_request_comments_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pull_request_comments_on_owner_id ON public.events_pull_request_comments USING btree (owner_id);


--
-- Name: index_events_pull_request_comments_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pull_request_comments_on_pull_request_id ON public.events_pull_request_comments USING btree (pull_request_id);


--
-- Name: index_events_pull_request_comments_on_review_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pull_request_comments_on_review_request_id ON public.events_pull_request_comments USING btree (review_request_id);


--
-- Name: index_events_pull_request_comments_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pull_request_comments_on_state ON public.events_pull_request_comments USING btree (state);


--
-- Name: index_events_pull_requests_on_github_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_events_pull_requests_on_github_id ON public.events_pull_requests USING btree (github_id);


--
-- Name: index_events_pull_requests_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pull_requests_on_owner_id ON public.events_pull_requests USING btree (owner_id);


--
-- Name: index_events_pull_requests_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pull_requests_on_repository_id ON public.events_pull_requests USING btree (repository_id);


--
-- Name: index_events_pull_requests_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pull_requests_on_state ON public.events_pull_requests USING btree (state);


--
-- Name: index_events_pushes_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pushes_on_pull_request_id ON public.events_pushes USING btree (pull_request_id);


--
-- Name: index_events_pushes_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pushes_on_repository_id ON public.events_pushes USING btree (repository_id);


--
-- Name: index_events_pushes_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_pushes_on_sender_id ON public.events_pushes USING btree (sender_id);


--
-- Name: index_events_repositories_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_repositories_on_repository_id ON public.events_repositories USING btree (repository_id);


--
-- Name: index_events_repositories_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_repositories_on_sender_id ON public.events_repositories USING btree (sender_id);


--
-- Name: index_events_review_comments_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_review_comments_on_owner_id ON public.events_review_comments USING btree (owner_id);


--
-- Name: index_events_review_comments_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_review_comments_on_pull_request_id ON public.events_review_comments USING btree (pull_request_id);


--
-- Name: index_events_review_comments_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_review_comments_on_state ON public.events_review_comments USING btree (state);


--
-- Name: index_events_reviews_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_reviews_on_owner_id ON public.events_reviews USING btree (owner_id);


--
-- Name: index_events_reviews_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_reviews_on_pull_request_id ON public.events_reviews USING btree (pull_request_id);


--
-- Name: index_events_reviews_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_reviews_on_repository_id ON public.events_reviews USING btree (repository_id);


--
-- Name: index_events_reviews_on_review_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_reviews_on_review_request_id ON public.events_reviews USING btree (review_request_id);


--
-- Name: index_events_reviews_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_events_reviews_on_state ON public.events_reviews USING btree (state);


--
-- Name: index_exception_hunter_error_groups_on_message; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exception_hunter_error_groups_on_message ON public.exception_hunter_error_groups USING gin (message public.gin_trgm_ops);


--
-- Name: index_exception_hunter_error_groups_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exception_hunter_error_groups_on_status ON public.exception_hunter_error_groups USING btree (status);


--
-- Name: index_exception_hunter_errors_on_error_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_exception_hunter_errors_on_error_group_id ON public.exception_hunter_errors USING btree (error_group_id);


--
-- Name: index_external_pull_requests_on_external_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_external_pull_requests_on_external_repository_id ON public.external_pull_requests USING btree (external_repository_id);


--
-- Name: index_external_pull_requests_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_external_pull_requests_on_owner_id ON public.external_pull_requests USING btree (owner_id);


--
-- Name: index_external_repositories_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_external_repositories_on_language_id ON public.external_repositories USING btree (language_id);


--
-- Name: index_file_ignoring_rules_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_file_ignoring_rules_on_language_id ON public.file_ignoring_rules USING btree (language_id);


--
-- Name: index_jira_boards_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jira_boards_on_product_id ON public.jira_boards USING btree (product_id);


--
-- Name: index_jira_issues_on_jira_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jira_issues_on_jira_board_id ON public.jira_issues USING btree (jira_board_id);


--
-- Name: index_jira_sprints_on_jira_board_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_jira_sprints_on_jira_board_id ON public.jira_sprints USING btree (jira_board_id);


--
-- Name: index_languages_on_department_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_languages_on_department_id ON public.languages USING btree (department_id);


--
-- Name: index_merge_times_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_merge_times_on_pull_request_id ON public.merge_times USING btree (pull_request_id);


--
-- Name: index_metrics_on_ownable_type_and_ownable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metrics_on_ownable_type_and_ownable_id ON public.metrics USING btree (ownable_type, ownable_id);


--
-- Name: index_metrics_products_on_product_id_and_metric_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_metrics_products_on_product_id_and_metric_id ON public.metrics_products USING btree (product_id, metric_id);


--
-- Name: index_products_on_deleted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_deleted_at ON public.products USING btree (deleted_at);


--
-- Name: index_products_on_enabled; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_enabled ON public.products USING btree (enabled);


--
-- Name: index_products_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_products_on_name ON public.products USING btree (name);


--
-- Name: index_repositories_on_github_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_repositories_on_github_id ON public.repositories USING btree (github_id);


--
-- Name: index_repositories_on_language_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_repositories_on_language_id ON public.repositories USING btree (language_id);


--
-- Name: index_repositories_on_product_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_repositories_on_product_id ON public.repositories USING btree (product_id);


--
-- Name: index_review_coverages_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_coverages_on_pull_request_id ON public.review_coverages USING btree (pull_request_id);


--
-- Name: index_review_requests_on_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_requests_on_owner_id ON public.review_requests USING btree (owner_id);


--
-- Name: index_review_requests_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_requests_on_pull_request_id ON public.review_requests USING btree (pull_request_id);


--
-- Name: index_review_requests_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_requests_on_repository_id ON public.review_requests USING btree (repository_id);


--
-- Name: index_review_requests_on_reviewer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_requests_on_reviewer_id ON public.review_requests USING btree (reviewer_id);


--
-- Name: index_review_requests_on_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_requests_on_state ON public.review_requests USING btree (state);


--
-- Name: index_review_turnarounds_on_pull_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_turnarounds_on_pull_request_id ON public.review_turnarounds USING btree (pull_request_id);


--
-- Name: index_review_turnarounds_on_review_request_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_review_turnarounds_on_review_request_id ON public.review_turnarounds USING btree (review_request_id);


--
-- Name: index_settings_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_settings_on_key ON public.settings USING btree (key);


--
-- Name: index_users_on_github_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_github_id ON public.users USING btree (github_id);


--
-- Name: index_users_repositories_on_repository_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_repositories_on_repository_id ON public.users_repositories USING btree (repository_id);


--
-- Name: index_users_repositories_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_repositories_on_user_id ON public.users_repositories USING btree (user_id);


--
-- Name: events fk_rails_022a085166; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT fk_rails_022a085166 FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: events_review_comments fk_rails_04feb57025; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_review_comments
    ADD CONSTRAINT fk_rails_04feb57025 FOREIGN KEY (pull_request_id) REFERENCES public.events_pull_requests(id);


--
-- Name: completed_review_turnarounds fk_rails_07677ca690; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.completed_review_turnarounds
    ADD CONSTRAINT fk_rails_07677ca690 FOREIGN KEY (review_request_id) REFERENCES public.review_requests(id);


--
-- Name: jira_issues fk_rails_14a08e0e6d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_issues
    ADD CONSTRAINT fk_rails_14a08e0e6d FOREIGN KEY (jira_board_id) REFERENCES public.jira_boards(id);


--
-- Name: events_pull_request_comments fk_rails_161aa5ffd0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pull_request_comments
    ADD CONSTRAINT fk_rails_161aa5ffd0 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: completed_review_turnarounds fk_rails_200ab21dcf; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.completed_review_turnarounds
    ADD CONSTRAINT fk_rails_200ab21dcf FOREIGN KEY (pull_request_id) REFERENCES public.events_pull_requests(id);


--
-- Name: repositories fk_rails_21e11c2480; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT fk_rails_21e11c2480 FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: code_owner_repositories fk_rails_22881d1001; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_owner_repositories
    ADD CONSTRAINT fk_rails_22881d1001 FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: events_pushes fk_rails_2981d8bb5a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pushes
    ADD CONSTRAINT fk_rails_2981d8bb5a FOREIGN KEY (pull_request_id) REFERENCES public.events_pull_requests(id);


--
-- Name: blog_post_technologies fk_rails_2b02d61b04; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_post_technologies
    ADD CONSTRAINT fk_rails_2b02d61b04 FOREIGN KEY (blog_post_id) REFERENCES public.blog_posts(id);


--
-- Name: external_pull_requests fk_rails_2c98f94e16; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_pull_requests
    ADD CONSTRAINT fk_rails_2c98f94e16 FOREIGN KEY (external_repository_id) REFERENCES public.external_repositories(id);


--
-- Name: review_turnarounds fk_rails_33c3053604; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_turnarounds
    ADD CONSTRAINT fk_rails_33c3053604 FOREIGN KEY (review_request_id) REFERENCES public.review_requests(id);


--
-- Name: events_repositories fk_rails_36d1823ddd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_repositories
    ADD CONSTRAINT fk_rails_36d1823ddd FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: events_pull_requests fk_rails_3c427fd106; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pull_requests
    ADD CONSTRAINT fk_rails_3c427fd106 FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: events_pushes fk_rails_3f633d82fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pushes
    ADD CONSTRAINT fk_rails_3f633d82fd FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: review_coverages fk_rails_40af85f049; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_coverages
    ADD CONSTRAINT fk_rails_40af85f049 FOREIGN KEY (pull_request_id) REFERENCES public.events_pull_requests(id);


--
-- Name: events_pushes fk_rails_4767e99b87; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pushes
    ADD CONSTRAINT fk_rails_4767e99b87 FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: blog_post_technologies fk_rails_47acaaf20e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_post_technologies
    ADD CONSTRAINT fk_rails_47acaaf20e FOREIGN KEY (technology_id) REFERENCES public.technologies(id);


--
-- Name: events_reviews fk_rails_4862a15e3a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_reviews
    ADD CONSTRAINT fk_rails_4862a15e3a FOREIGN KEY (pull_request_id) REFERENCES public.events_pull_requests(id);


--
-- Name: events_review_comments fk_rails_4a92157916; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_review_comments
    ADD CONSTRAINT fk_rails_4a92157916 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: review_requests fk_rails_4f74da58c1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT fk_rails_4f74da58c1 FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: external_pull_requests fk_rails_51325610fd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_pull_requests
    ADD CONSTRAINT fk_rails_51325610fd FOREIGN KEY (external_repository_id) REFERENCES public.external_repositories(id);


--
-- Name: code_climate_repository_metrics fk_rails_58be219c6d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_climate_repository_metrics
    ADD CONSTRAINT fk_rails_58be219c6d FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: events_pull_requests fk_rails_5df700b412; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pull_requests
    ADD CONSTRAINT fk_rails_5df700b412 FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: events_pull_requests fk_rails_658eb0bfb4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pull_requests
    ADD CONSTRAINT fk_rails_658eb0bfb4 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: events_reviews fk_rails_65b0ea4a71; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_reviews
    ADD CONSTRAINT fk_rails_65b0ea4a71 FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: review_turnarounds fk_rails_7bc2fb6ebc; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_turnarounds
    ADD CONSTRAINT fk_rails_7bc2fb6ebc FOREIGN KEY (pull_request_id) REFERENCES public.events_pull_requests(id);


--
-- Name: languages fk_rails_822295ed05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT fk_rails_822295ed05 FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: code_climate_repository_metrics fk_rails_8af0265fff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_climate_repository_metrics
    ADD CONSTRAINT fk_rails_8af0265fff FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: code_owner_repositories fk_rails_8b5e8dfa3f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_owner_repositories
    ADD CONSTRAINT fk_rails_8b5e8dfa3f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: code_owner_repositories fk_rails_98029d380a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.code_owner_repositories
    ADD CONSTRAINT fk_rails_98029d380a FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: users_repositories fk_rails_9bab11adb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_repositories
    ADD CONSTRAINT fk_rails_9bab11adb3 FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: events_repositories fk_rails_9dbb09e26a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_repositories
    ADD CONSTRAINT fk_rails_9dbb09e26a FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: review_requests fk_rails_9ece0f7518; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT fk_rails_9ece0f7518 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: alerts fk_rails_b50bec0cc6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_rails_b50bec0cc6 FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: events_pushes fk_rails_bc14f07184; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pushes
    ADD CONSTRAINT fk_rails_bc14f07184 FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: events_reviews fk_rails_bcf65590e4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_reviews
    ADD CONSTRAINT fk_rails_bcf65590e4 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: events_repositories fk_rails_bd0a1859aa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_repositories
    ADD CONSTRAINT fk_rails_bd0a1859aa FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: file_ignoring_rules fk_rails_c0f919d112; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_ignoring_rules
    ADD CONSTRAINT fk_rails_c0f919d112 FOREIGN KEY (language_id) REFERENCES public.languages(id);


--
-- Name: external_pull_requests fk_rails_c13d1ac6a7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.external_pull_requests
    ADD CONSTRAINT fk_rails_c13d1ac6a7 FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: jira_sprints fk_rails_d195b736d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_sprints
    ADD CONSTRAINT fk_rails_d195b736d0 FOREIGN KEY (jira_board_id) REFERENCES public.jira_boards(id);


--
-- Name: review_requests fk_rails_d83bae1089; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT fk_rails_d83bae1089 FOREIGN KEY (reviewer_id) REFERENCES public.users(id);


--
-- Name: review_requests fk_rails_dd17aeab6c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT fk_rails_dd17aeab6c FOREIGN KEY (repository_id) REFERENCES public.repositories(id);


--
-- Name: events_pull_request_comments fk_rails_e74e223f63; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.events_pull_request_comments
    ADD CONSTRAINT fk_rails_e74e223f63 FOREIGN KEY (pull_request_id) REFERENCES public.events_pull_requests(id);


--
-- Name: jira_boards fk_rails_eaa3060e1c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.jira_boards
    ADD CONSTRAINT fk_rails_eaa3060e1c FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: exception_hunter_errors fk_rails_ee1d3d35a2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.exception_hunter_errors
    ADD CONSTRAINT fk_rails_ee1d3d35a2 FOREIGN KEY (error_group_id) REFERENCES public.exception_hunter_error_groups(id);


--
-- Name: merge_times fk_rails_f002296adb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.merge_times
    ADD CONSTRAINT fk_rails_f002296adb FOREIGN KEY (pull_request_id) REFERENCES public.events_pull_requests(id);


--
-- Name: alerts fk_rails_f5c2609558; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alerts
    ADD CONSTRAINT fk_rails_f5c2609558 FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: review_requests fk_rails_feb865e207; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.review_requests
    ADD CONSTRAINT fk_rails_feb865e207 FOREIGN KEY (pull_request_id) REFERENCES public.events_pull_requests(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20250430195706'),
('20250430195700'),
('20250430195657'),
('20250430195652'),
('20250430151601'),
('20250429002929'),
('20240829142623'),
('20240627133952'),
('20221228121949'),
('20221228101900'),
('20220412181602'),
('20210916151310'),
('20210915145551'),
('20210902182225'),
('20210902140638'),
('20210830211654'),
('20210830200129'),
('20210830200109'),
('20210827172747'),
('20210811165206'),
('20210810202705'),
('20210810184003'),
('20210810123929'),
('20210810122756'),
('20210726184449'),
('20210723184744'),
('20210722152015'),
('20210720212026'),
('20210714155857'),
('20210714143812'),
('20210712190532'),
('20210708153602'),
('20210707225815'),
('20210707221342'),
('20210707210306'),
('20210707194545'),
('20210706143943'),
('20210318034939'),
('20210317024356'),
('20210316150725'),
('20210315154031'),
('20210118145940'),
('20210115132729'),
('20201214192048'),
('20201211133046'),
('20201201193101'),
('20201201184505'),
('20201102203739'),
('20201029141417'),
('20200929205630'),
('20200925174541'),
('20200922131539'),
('20200911143301'),
('20200908173642'),
('20200908121903'),
('20200901185355'),
('20200825151321'),
('20200824202901'),
('20200820180521'),
('20200819142237'),
('20200813162522'),
('20200806131024'),
('20200730142418'),
('20200723174621'),
('20200720155715'),
('20200714160138'),
('20200713152004'),
('20200703141617'),
('20200701133311'),
('20200630165139'),
('20200625144922'),
('20200622221729'),
('20200622221651'),
('20200622221335'),
('20200622214544'),
('20200618174209'),
('20200617145408'),
('20200616154910'),
('20200612195323'),
('20200611190026'),
('20200611153414'),
('20200605192032'),
('20200602181502'),
('20200518160851'),
('20200518155136'),
('20200518155135'),
('20200511180927'),
('20200507174834'),
('20200507135524'),
('20200506182951'),
('20200504143532'),
('20200424155835'),
('20200423185715'),
('20200423175049'),
('20200423170720'),
('20200423134541'),
('20200422173907'),
('20200421172329'),
('20200416212440'),
('20200415162514'),
('20200414205816'),
('20200403140307'),
('20200402175059'),
('20200401205154'),
('20200401200520'),
('20200330162011'),
('20200327172924'),
('20200318171820'),
('20200318160321'),
('20200318125243'),
('20200312161141'),
('20200312144232'),
('20200311132103'),
('20200305171608'),
('20200305150445'),
('20200305150412'),
('20200305142724'),
('20200305141203'),
('20200303210031'),
('20200302120947'),
('20200219141137'),
('20200217165218'),
('20200212151614'),
('20200206203850'),
('20200206203510'),
('20200204202145'),
('20200204201145'),
('20200204140453'),
('20200204134315'),
('20200204134248'),
('20200203141336'),
('20200131153056'),
('20200131153049'),
('20200128190806'),
('20200122180806'),
('20200122143238'),
('20191231134130'),
('20191231130959'),
('20191230180053'),
('20191227203014'),
('20191227202204'),
('20191226195441'),
('20191226190938'),
('20191226185853'),
('20191223145416'),
('20191223145336'),
('20191223141540'),
('20191223133712'),
('20191223133115'),
('20191220192022'),
('20191220190613'),
('20191220183838'),
('20191220183808');

