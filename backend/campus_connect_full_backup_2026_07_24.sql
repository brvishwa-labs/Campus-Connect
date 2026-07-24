--
-- PostgreSQL database dump
--

\restrict fWXnkXNz6U3ThQ7ck2fWbnqLfDdfmSJgy4ahkhrpOHnBh1qqAR5RwUY8Qbslj77

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

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

--
-- Name: actionstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.actionstatus AS ENUM (
    'INFORMED',
    'NOT_INFORMED',
    'LETTER_GIVEN'
);


ALTER TYPE public.actionstatus OWNER TO postgres;

--
-- Name: actiontype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.actiontype AS ENUM (
    'CREATE',
    'UPDATE',
    'DELETE',
    'LOGIN',
    'LOGOUT',
    'VIEW',
    'EXPORT',
    'IMPORT',
    'APPROVE',
    'REJECT'
);


ALTER TYPE public.actiontype OWNER TO postgres;

--
-- Name: arrangementstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.arrangementstatus AS ENUM (
    'PENDING',
    'ACCEPTED',
    'REJECTED'
);


ALTER TYPE public.arrangementstatus OWNER TO postgres;

--
-- Name: attendancestatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.attendancestatus AS ENUM (
    'PRESENT',
    'ABSENT',
    'ON_DUTY',
    'LATE',
    'holiday'
);


ALTER TYPE public.attendancestatus OWNER TO postgres;

--
-- Name: coursetype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.coursetype AS ENUM (
    'THEORY',
    'LAB',
    'ELECTIVE',
    'PROJECT',
    'open_elective',
    'OPEN_ELECTIVE',
    'seminar',
    'SEMINAR',
    'project',
    'theory',
    'lab',
    'elective'
);


ALTER TYPE public.coursetype OWNER TO postgres;

--
-- Name: dayofweek; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.dayofweek AS ENUM (
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
    'SAT'
);


ALTER TYPE public.dayofweek OWNER TO postgres;

--
-- Name: facultyattendancestatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.facultyattendancestatus AS ENUM (
    'present',
    'absent',
    'on_leave'
);


ALTER TYPE public.facultyattendancestatus OWNER TO postgres;

--
-- Name: facultygatepassstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.facultygatepassstatus AS ENUM (
    'PENDING_HOD',
    'PENDING_DEAN',
    'PENDING_OM',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE public.facultygatepassstatus OWNER TO postgres;

--
-- Name: gatepassstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gatepassstatus AS ENUM (
    'PENDING_MENTOR',
    'PENDING_HOD',
    'PENDING_OM',
    'APPROVED',
    'REJECTED'
);


ALTER TYPE public.gatepassstatus OWNER TO postgres;

--
-- Name: gradetype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.gradetype AS ENUM (
    'INTERNAL_1',
    'INTERNAL_2',
    'INTERNAL_3',
    'ASSIGNMENT',
    'LAB',
    'EXTERNAL',
    'MODEL_EXAM',
    'retest'
);


ALTER TYPE public.gradetype OWNER TO postgres;

--
-- Name: incidentcategory; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.incidentcategory AS ENUM (
    'NO_SHOE',
    'NO_ID_CARD',
    'IMPROPER_HAIRCUT',
    'IMPROPER_DRESS_CODE',
    'OTHER'
);


ALTER TYPE public.incidentcategory OWNER TO postgres;

--
-- Name: leavestatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.leavestatus AS ENUM (
    'pending_substitute',
    'pending_alternate_hod',
    'pending_hod',
    'pending_dean',
    'pending_om',
    'approved',
    'rejected',
    'withdrawn',
    'pending',
    'pending_compensation_verification',
    'pending_principal'
);


ALTER TYPE public.leavestatus OWNER TO postgres;

--
-- Name: leavetype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.leavetype AS ENUM (
    'SICK',
    'PERSONAL',
    'ON_DUTY',
    'EMERGENCY'
);


ALTER TYPE public.leavetype OWNER TO postgres;

--
-- Name: meetingstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.meetingstatus AS ENUM (
    'PENDING',
    'APPROVED',
    'COMPLETED',
    'REJECTED'
);


ALTER TYPE public.meetingstatus OWNER TO postgres;

--
-- Name: messagetype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.messagetype AS ENUM (
    'TEXT',
    'IMAGE'
);


ALTER TYPE public.messagetype OWNER TO postgres;

--
-- Name: paymentmode; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.paymentmode AS ENUM (
    'CASH',
    'DD',
    'CHEQUE',
    'BANK_TRANSFER',
    'TALLY_SYNC'
);


ALTER TYPE public.paymentmode OWNER TO postgres;

--
-- Name: paymentsource; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.paymentsource AS ENUM (
    'MANUAL',
    'TALLY_UPLOAD'
);


ALTER TYPE public.paymentsource OWNER TO postgres;

--
-- Name: resourcetype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.resourcetype AS ENUM (
    'NOTES',
    'SYLLABUS',
    'ASSIGNMENT',
    'REFERENCE',
    'VIDEO'
);


ALTER TYPE public.resourcetype OWNER TO postgres;

--
-- Name: sendertype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.sendertype AS ENUM (
    'STUDENT',
    'HOD',
    'dean',
    'DEAN'
);


ALTER TYPE public.sendertype OWNER TO postgres;

--
-- Name: studentleavestatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.studentleavestatus AS ENUM (
    'PENDING_CLASS_ADVISOR',
    'PENDING_MENTOR',
    'PENDING_HOD',
    'APPROVED',
    'REJECTED',
    'WITHDRAWN'
);


ALTER TYPE public.studentleavestatus OWNER TO postgres;

--
-- Name: unmappedstatus; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.unmappedstatus AS ENUM (
    'PENDING',
    'RESOLVED',
    'SKIPPED'
);


ALTER TYPE public.unmappedstatus OWNER TO postgres;

--
-- Name: userrole; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.userrole AS ENUM (
    'ADMIN',
    'HOD',
    'FACULTY',
    'STUDENT',
    'AUTHORITY',
    'late_tracker',
    'LATE_TRACKER',
    'accountant',
    'ACCOUNTANT'
);


ALTER TYPE public.userrole OWNER TO postgres;

--
-- Name: notify_audit_log_insert(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.notify_audit_log_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM pg_notify(
        'audit_logs_channel',
        row_to_json(NEW)::text
    );
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.notify_audit_log_insert() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: advising_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.advising_logs (
    id integer NOT NULL,
    mentor_id integer NOT NULL,
    student_id integer NOT NULL,
    note text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.advising_logs OWNER TO postgres;

--
-- Name: advising_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.advising_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.advising_logs_id_seq OWNER TO postgres;

--
-- Name: advising_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.advising_logs_id_seq OWNED BY public.advising_logs.id;


--
-- Name: alumni; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alumni (
    id integer NOT NULL,
    user_id integer NOT NULL,
    department_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    register_number character varying(50) NOT NULL,
    gender character varying(10),
    date_of_birth date,
    blood_group character varying(5),
    nationality character varying(50),
    community character varying(50),
    photo_url character varying(500),
    batch character varying(20) NOT NULL,
    graduation_year integer NOT NULL,
    college_email character varying(255) NOT NULL,
    personal_email character varying(255),
    phone character varying(15) NOT NULL,
    address_line1 character varying(255),
    address_line2 character varying(255),
    city character varying(100),
    state character varying(100),
    pincode character varying(10),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.alumni OWNER TO postgres;

--
-- Name: alumni_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alumni_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alumni_id_seq OWNER TO postgres;

--
-- Name: alumni_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alumni_id_seq OWNED BY public.alumni.id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.announcements (
    id integer NOT NULL,
    course_id integer,
    department_id integer,
    posted_by_id integer NOT NULL,
    title character varying(255) NOT NULL,
    content text NOT NULL,
    is_global boolean,
    created_at timestamp with time zone DEFAULT now(),
    category character varying(50) DEFAULT 'General'::character varying NOT NULL,
    target_audience character varying(50) DEFAULT 'Everyone'::character varying NOT NULL
);


ALTER TABLE public.announcements OWNER TO postgres;

--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.announcements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.announcements_id_seq OWNER TO postgres;

--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.announcements_id_seq OWNED BY public.announcements.id;


--
-- Name: assignment_grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.assignment_grades (
    id integer NOT NULL,
    assignment_id integer NOT NULL,
    student_id integer NOT NULL,
    marks_obtained numeric(6,2),
    max_marks numeric(6,2) DEFAULT 100 NOT NULL,
    is_absent boolean DEFAULT false NOT NULL,
    is_published boolean DEFAULT false NOT NULL,
    remarks text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.assignment_grades OWNER TO postgres;

--
-- Name: assignment_grades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.assignment_grades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.assignment_grades_id_seq OWNER TO postgres;

--
-- Name: assignment_grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.assignment_grades_id_seq OWNED BY public.assignment_grades.id;


--
-- Name: attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.attendance (
    id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    date date NOT NULL,
    hour integer,
    status public.attendancestatus NOT NULL,
    marked_by_id integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.attendance OWNER TO postgres;

--
-- Name: attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.attendance_id_seq OWNER TO postgres;

--
-- Name: attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.attendance_id_seq OWNED BY public.attendance.id;


--
-- Name: authorities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.authorities (
    id integer NOT NULL,
    user_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    title character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(15) NOT NULL,
    employee_id character varying(50) NOT NULL,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.authorities OWNER TO postgres;

--
-- Name: authorities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.authorities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.authorities_id_seq OWNER TO postgres;

--
-- Name: authorities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.authorities_id_seq OWNED BY public.authorities.id;


--
-- Name: compensation_registry_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.compensation_registry_requests (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    peer_faculty_id integer NOT NULL,
    date_worked date NOT NULL,
    classes_substituted character varying(500),
    status character varying(50),
    is_used boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.compensation_registry_requests OWNER TO postgres;

--
-- Name: compensation_registry_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.compensation_registry_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.compensation_registry_requests_id_seq OWNER TO postgres;

--
-- Name: compensation_registry_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.compensation_registry_requests_id_seq OWNED BY public.compensation_registry_requests.id;


--
-- Name: course_assignment_units; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_assignment_units (
    id integer NOT NULL,
    course_assignment_id integer NOT NULL,
    unit_number integer NOT NULL,
    title character varying(500),
    is_completed boolean DEFAULT false,
    updated_at timestamp with time zone
);


ALTER TABLE public.course_assignment_units OWNER TO postgres;

--
-- Name: course_assignment_units_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_assignment_units_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_assignment_units_id_seq OWNER TO postgres;

--
-- Name: course_assignment_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_assignment_units_id_seq OWNED BY public.course_assignment_units.id;


--
-- Name: course_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_assignments (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    course_id integer NOT NULL,
    section_id integer NOT NULL,
    academic_year character varying(20) NOT NULL,
    semester integer NOT NULL,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.course_assignments OWNER TO postgres;

--
-- Name: course_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_assignments_id_seq OWNER TO postgres;

--
-- Name: course_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_assignments_id_seq OWNED BY public.course_assignments.id;


--
-- Name: course_plan_topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_plan_topics (
    id integer NOT NULL,
    course_plan_id integer NOT NULL,
    sequence_no integer NOT NULL,
    proposed_date date,
    hours integer NOT NULL,
    unit character varying(50) NOT NULL,
    topic character varying(500) NOT NULL,
    cognitive_level character varying(100) NOT NULL,
    mode_of_delivery character varying(50) NOT NULL,
    actual_date date,
    reason_for_deviation text,
    is_signed boolean,
    signed_at timestamp with time zone,
    co character varying(100),
    po character varying(200),
    experiment_name character varying(500),
    resources character varying(500)
);


ALTER TABLE public.course_plan_topics OWNER TO postgres;

--
-- Name: course_plan_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_plan_topics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_plan_topics_id_seq OWNER TO postgres;

--
-- Name: course_plan_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_plan_topics_id_seq OWNED BY public.course_plan_topics.id;


--
-- Name: course_plans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.course_plans (
    id integer NOT NULL,
    course_assignment_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.course_plans OWNER TO postgres;

--
-- Name: course_plans_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.course_plans_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.course_plans_id_seq OWNER TO postgres;

--
-- Name: course_plans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.course_plans_id_seq OWNED BY public.course_plans.id;


--
-- Name: courses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.courses (
    id integer NOT NULL,
    department_id integer NOT NULL,
    code character varying(20) NOT NULL,
    name character varying(200) NOT NULL,
    credits integer NOT NULL,
    course_type public.coursetype,
    semester integer,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    short_name character varying(20),
    syllabus text,
    objectives text,
    outcomes text,
    textbooks text,
    "references" text,
    prerequisites text,
    co_po_mapping text,
    co_k_levels text,
    project_guidelines text,
    project_teams_data text,
    seminar_topics_data text
);


ALTER TABLE public.courses OWNER TO postgres;

--
-- Name: courses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.courses_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.courses_id_seq OWNER TO postgres;

--
-- Name: courses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.courses_id_seq OWNED BY public.courses.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    code character varying(20) NOT NULL,
    hod_id integer,
    vision text,
    mission text,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    current_sem_start_date timestamp with time zone,
    attendance_closed boolean DEFAULT false,
    peos text,
    psos text,
    is_common_first_year boolean DEFAULT false
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_id_seq OWNER TO postgres;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: discipline_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.discipline_records (
    id integer NOT NULL,
    student_id integer NOT NULL,
    reported_by_id integer NOT NULL,
    incident_type public.incidentcategory NOT NULL,
    incident_date date NOT NULL,
    remarks text,
    action_status public.actionstatus,
    action_taken text,
    is_locked boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.discipline_records OWNER TO postgres;

--
-- Name: discipline_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.discipline_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.discipline_records_id_seq OWNER TO postgres;

--
-- Name: discipline_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.discipline_records_id_seq OWNED BY public.discipline_records.id;


--
-- Name: enrollments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.enrollments (
    id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    academic_year character varying(20) NOT NULL,
    semester integer NOT NULL,
    enrolled_at timestamp with time zone DEFAULT now(),
    section_id integer
);


ALTER TABLE public.enrollments OWNER TO postgres;

--
-- Name: enrollments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.enrollments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.enrollments_id_seq OWNER TO postgres;

--
-- Name: enrollments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.enrollments_id_seq OWNED BY public.enrollments.id;


--
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty (
    id integer NOT NULL,
    user_id integer NOT NULL,
    department_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    gender character varying(10),
    date_of_birth date,
    blood_group character varying(5),
    nationality character varying(50),
    community character varying(50),
    photo_url character varying(500),
    college_email character varying(255) NOT NULL,
    personal_email character varying(255),
    phone character varying(15) NOT NULL,
    alternate_phone character varying(15),
    address_line1 character varying(255),
    address_line2 character varying(255),
    city character varying(100),
    state character varying(100),
    pincode character varying(10),
    employee_id character varying(50) NOT NULL,
    designation character varying(100),
    qualification character varying(200),
    specialization character varying(200),
    experience_years integer,
    date_of_joining date,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    religion character varying(100),
    aadhar_number character varying(12),
    pan_card character varying(10),
    accommodation character varying(50),
    transportation character varying(50),
    father_name character varying(150),
    mother_name character varying(150),
    family_persons text,
    bus_number character varying(50),
    emergency_contacts json,
    academic_history json,
    employment_type character varying(50),
    past_experience json
);


ALTER TABLE public.faculty OWNER TO postgres;

--
-- Name: faculty_attendance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty_attendance (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    date date NOT NULL,
    status public.facultyattendancestatus DEFAULT 'present'::public.facultyattendancestatus NOT NULL,
    leave_request_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.faculty_attendance OWNER TO postgres;

--
-- Name: faculty_attendance_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_attendance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_attendance_id_seq OWNER TO postgres;

--
-- Name: faculty_attendance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_attendance_id_seq OWNED BY public.faculty_attendance.id;


--
-- Name: faculty_duty_arrangements; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty_duty_arrangements (
    id integer NOT NULL,
    leave_request_id integer NOT NULL,
    substitute_faculty_id integer NOT NULL,
    subject character varying(100) NOT NULL,
    class_section character varying(50) NOT NULL,
    period character varying(50) NOT NULL,
    status public.arrangementstatus,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    day character varying(10),
    compensation_date date,
    compensation_period character varying(50),
    section_id integer
);


ALTER TABLE public.faculty_duty_arrangements OWNER TO postgres;

--
-- Name: faculty_duty_arrangements_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_duty_arrangements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_duty_arrangements_id_seq OWNER TO postgres;

--
-- Name: faculty_duty_arrangements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_duty_arrangements_id_seq OWNED BY public.faculty_duty_arrangements.id;


--
-- Name: faculty_gate_passes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty_gate_passes (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    reason text NOT NULL,
    out_time timestamp with time zone NOT NULL,
    expected_in_time timestamp with time zone,
    actual_in_time timestamp with time zone,
    status public.facultygatepassstatus NOT NULL,
    viewed_by_hod boolean NOT NULL,
    viewed_by_dean boolean NOT NULL,
    viewed_by_om boolean NOT NULL,
    hod_id integer,
    hod_approved_at timestamp with time zone,
    dean_id integer,
    dean_approved_at timestamp with time zone,
    om_id integer,
    om_approved_at timestamp with time zone,
    rejection_reason text,
    is_deleted_by_faculty boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.faculty_gate_passes OWNER TO postgres;

--
-- Name: faculty_gate_passes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_gate_passes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_gate_passes_id_seq OWNER TO postgres;

--
-- Name: faculty_gate_passes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_gate_passes_id_seq OWNED BY public.faculty_gate_passes.id;


--
-- Name: faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_id_seq OWNER TO postgres;

--
-- Name: faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_id_seq OWNED BY public.faculty.id;


--
-- Name: faculty_leave_balances; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty_leave_balances (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    academic_year character varying(20) NOT NULL,
    casual_leaves_total integer DEFAULT 12,
    casual_leaves_used integer,
    sick_leaves_total integer,
    sick_leaves_used integer,
    earned_leaves_total integer,
    earned_leaves_used integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    restricted_leaves_total integer DEFAULT 2,
    restricted_leaves_used integer DEFAULT 0,
    vacation_leaves_total integer DEFAULT 14,
    vacation_leaves_used integer DEFAULT 0,
    compensation_leaves_total integer DEFAULT 5,
    compensation_leaves_used integer DEFAULT 0,
    academic_leaves_total integer DEFAULT 10,
    academic_leaves_used integer DEFAULT 0
);


ALTER TABLE public.faculty_leave_balances OWNER TO postgres;

--
-- Name: faculty_leave_balances_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_leave_balances_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_leave_balances_id_seq OWNER TO postgres;

--
-- Name: faculty_leave_balances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_leave_balances_id_seq OWNED BY public.faculty_leave_balances.id;


--
-- Name: faculty_leave_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.faculty_leave_requests (
    id integer NOT NULL,
    faculty_id integer NOT NULL,
    leave_type character varying(50) NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    duration_days integer NOT NULL,
    reason character varying(500) NOT NULL,
    attachment_url character varying(500),
    status public.leavestatus,
    hod_approved_by integer,
    dean_approved_by integer,
    om_approved_by integer,
    rejection_reason character varying(500),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    viewed_by_hod boolean DEFAULT false,
    viewed_by_dean boolean DEFAULT false,
    compensation_verifier_id integer,
    compensation_date date,
    compensation_purpose character varying(500),
    hour_permission_session character varying(50),
    hour_permission_period character varying(50),
    proof_link character varying(255),
    principal_approved_by integer,
    compensation_registry_id integer,
    alternate_hod_faculty_id integer
);


ALTER TABLE public.faculty_leave_requests OWNER TO postgres;

--
-- Name: faculty_leave_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_leave_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.faculty_leave_requests_id_seq OWNER TO postgres;

--
-- Name: faculty_leave_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_leave_requests_id_seq OWNED BY public.faculty_leave_requests.id;


--
-- Name: fee_structures; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fee_structures (
    id integer NOT NULL,
    department_id integer NOT NULL,
    semester integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    academic_year character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.fee_structures OWNER TO postgres;

--
-- Name: fee_structures_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fee_structures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fee_structures_id_seq OWNER TO postgres;

--
-- Name: fee_structures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fee_structures_id_seq OWNED BY public.fee_structures.id;


--
-- Name: gate_passes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gate_passes (
    id integer NOT NULL,
    student_id integer NOT NULL,
    reason text NOT NULL,
    out_time timestamp with time zone NOT NULL,
    expected_in_time timestamp with time zone,
    actual_in_time timestamp with time zone,
    status public.gatepassstatus NOT NULL,
    mentor_id integer,
    mentor_approved_at timestamp with time zone,
    hod_id integer,
    hod_approved_at timestamp with time zone,
    om_id integer,
    om_approved_at timestamp with time zone,
    rejection_reason text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    is_deleted_by_student boolean DEFAULT false,
    viewed_by_mentor boolean DEFAULT false,
    viewed_by_hod boolean DEFAULT false,
    viewed_by_om boolean DEFAULT false
);


ALTER TABLE public.gate_passes OWNER TO postgres;

--
-- Name: gate_passes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gate_passes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gate_passes_id_seq OWNER TO postgres;

--
-- Name: gate_passes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gate_passes_id_seq OWNED BY public.gate_passes.id;


--
-- Name: grades; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.grades (
    id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    grade_type public.gradetype NOT NULL,
    marks_obtained numeric(6,2),
    max_marks numeric(6,2) NOT NULL,
    academic_year character varying(20) NOT NULL,
    semester integer NOT NULL,
    graded_by_id integer,
    remarks text,
    created_at timestamp with time zone DEFAULT now(),
    is_published boolean DEFAULT false NOT NULL,
    is_absent boolean DEFAULT false NOT NULL,
    updated_at timestamp with time zone,
    test_date date
);


ALTER TABLE public.grades OWNER TO postgres;

--
-- Name: grades_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.grades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grades_id_seq OWNER TO postgres;

--
-- Name: grades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.grades_id_seq OWNED BY public.grades.id;


--
-- Name: holidays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.holidays (
    id integer NOT NULL,
    date date NOT NULL,
    name character varying(200) NOT NULL,
    created_by_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.holidays OWNER TO postgres;

--
-- Name: holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.holidays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.holidays_id_seq OWNER TO postgres;

--
-- Name: holidays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.holidays_id_seq OWNED BY public.holidays.id;


--
-- Name: lab_marks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lab_marks (
    id integer NOT NULL,
    course_assignment_id integer NOT NULL,
    student_id integer NOT NULL,
    record_marks numeric(5,2),
    ia1_marks numeric(5,2),
    ia2_marks numeric(5,2),
    viva_marks numeric(5,2),
    is_published boolean DEFAULT false NOT NULL,
    graded_by_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.lab_marks OWNER TO postgres;

--
-- Name: lab_marks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lab_marks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lab_marks_id_seq OWNER TO postgres;

--
-- Name: lab_marks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lab_marks_id_seq OWNED BY public.lab_marks.id;


--
-- Name: late_entry_notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.late_entry_notifications (
    id integer NOT NULL,
    student_id integer NOT NULL,
    mentor_id integer,
    date date NOT NULL,
    expected_arrival_time time without time zone NOT NULL,
    reason text NOT NULL,
    acknowledged_by_security boolean DEFAULT false,
    acknowledged_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    viewed_by_mentor boolean DEFAULT false,
    viewed_at timestamp with time zone,
    mentor_comment text,
    mentor_comment_at timestamp with time zone,
    is_approved boolean DEFAULT false,
    approved_by_id integer,
    approved_at timestamp with time zone,
    class_advisor_id integer,
    approval_status character varying(20) DEFAULT 'pending'::character varying
);


ALTER TABLE public.late_entry_notifications OWNER TO postgres;

--
-- Name: late_entry_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.late_entry_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.late_entry_notifications_id_seq OWNER TO postgres;

--
-- Name: late_entry_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.late_entry_notifications_id_seq OWNED BY public.late_entry_notifications.id;


--
-- Name: late_records; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.late_records (
    id integer NOT NULL,
    student_id integer NOT NULL,
    recorded_by_id integer NOT NULL,
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    reason character varying(255),
    remarks text,
    created_at timestamp with time zone DEFAULT now(),
    action_status public.actionstatus DEFAULT 'NOT_INFORMED'::public.actionstatus
);


ALTER TABLE public.late_records OWNER TO postgres;

--
-- Name: late_records_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.late_records_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.late_records_id_seq OWNER TO postgres;

--
-- Name: late_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.late_records_id_seq OWNED BY public.late_records.id;


--
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_requests (
    id integer NOT NULL,
    student_id integer NOT NULL,
    leave_type public.leavetype NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    reason text NOT NULL,
    status public.leavestatus,
    mentor_approved_by integer,
    mentor_approved_at timestamp with time zone,
    hod_approved_by integer,
    hod_approved_at timestamp with time zone,
    rejection_reason text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.leave_requests OWNER TO postgres;

--
-- Name: leave_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leave_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leave_requests_id_seq OWNER TO postgres;

--
-- Name: leave_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leave_requests_id_seq OWNED BY public.leave_requests.id;


--
-- Name: lms_resources; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lms_resources (
    id integer NOT NULL,
    course_id integer NOT NULL,
    uploaded_by_id integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    resource_type public.resourcetype NOT NULL,
    file_url character varying(500),
    external_link character varying(500),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lms_resources OWNER TO postgres;

--
-- Name: lms_resources_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lms_resources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.lms_resources_id_seq OWNER TO postgres;

--
-- Name: lms_resources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lms_resources_id_seq OWNED BY public.lms_resources.id;


--
-- Name: mentor_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentor_assignments (
    id integer NOT NULL,
    mentor_id integer NOT NULL,
    student_id integer NOT NULL,
    academic_year character varying(20) NOT NULL,
    assigned_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.mentor_assignments OWNER TO postgres;

--
-- Name: mentor_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mentor_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mentor_assignments_id_seq OWNER TO postgres;

--
-- Name: mentor_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mentor_assignments_id_seq OWNED BY public.mentor_assignments.id;


--
-- Name: mentoring_meetings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mentoring_meetings (
    id integer NOT NULL,
    mentor_id integer NOT NULL,
    student_id integer NOT NULL,
    topic character varying(255) NOT NULL,
    description text,
    status public.meetingstatus NOT NULL,
    requested_by_student boolean,
    scheduled_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.mentoring_meetings OWNER TO postgres;

--
-- Name: mentoring_meetings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mentoring_meetings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mentoring_meetings_id_seq OWNER TO postgres;

--
-- Name: mentoring_meetings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mentoring_meetings_id_seq OWNED BY public.mentoring_meetings.id;


--
-- Name: msg_conversations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.msg_conversations (
    id integer NOT NULL,
    student_id integer NOT NULL,
    dean_id integer CONSTRAINT msg_conversations_hod_id_not_null NOT NULL,
    department_id integer NOT NULL,
    last_message text,
    last_message_time timestamp with time zone,
    dean_unread_count integer CONSTRAINT msg_conversations_hod_unread_count_not_null NOT NULL,
    student_unread_count integer NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    is_pinned boolean DEFAULT false NOT NULL,
    pinned_at timestamp with time zone,
    is_marked_for_review boolean DEFAULT false NOT NULL,
    review_marked_at timestamp with time zone
);


ALTER TABLE public.msg_conversations OWNER TO postgres;

--
-- Name: msg_conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.msg_conversations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.msg_conversations_id_seq OWNER TO postgres;

--
-- Name: msg_conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.msg_conversations_id_seq OWNED BY public.msg_conversations.id;


--
-- Name: msg_messages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.msg_messages (
    id integer NOT NULL,
    conversation_id integer NOT NULL,
    sender_type public.sendertype NOT NULL,
    message_type public.messagetype NOT NULL,
    message_text text,
    image_url character varying(500),
    is_read boolean NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.msg_messages OWNER TO postgres;

--
-- Name: msg_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.msg_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.msg_messages_id_seq OWNER TO postgres;

--
-- Name: msg_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.msg_messages_id_seq OWNED BY public.msg_messages.id;


--
-- Name: notification_views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_views (
    id integer NOT NULL,
    user_id integer NOT NULL,
    sector character varying(50) NOT NULL,
    last_viewed_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notification_views OWNER TO postgres;

--
-- Name: notification_views_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_views_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notification_views_id_seq OWNER TO postgres;

--
-- Name: notification_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_views_id_seq OWNED BY public.notification_views.id;


--
-- Name: password_reset_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_requests (
    id integer NOT NULL,
    role character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    college_id character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    status character varying(50),
    created_at timestamp with time zone DEFAULT now(),
    resolved_at timestamp with time zone,
    department character varying(100) DEFAULT ''::character varying
);


ALTER TABLE public.password_reset_requests OWNER TO postgres;

--
-- Name: password_reset_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.password_reset_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.password_reset_requests_id_seq OWNER TO postgres;

--
-- Name: password_reset_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.password_reset_requests_id_seq OWNED BY public.password_reset_requests.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    student_id integer NOT NULL,
    amount numeric(12,2) NOT NULL,
    payment_date date NOT NULL,
    mode public.paymentmode NOT NULL,
    receipt_no character varying(100),
    voucher_no character varying(100),
    ledger_name_raw character varying(500),
    source public.paymentsource NOT NULL,
    uploaded_by integer,
    notes text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: program_outcomes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.program_outcomes (
    id integer NOT NULL,
    outcomes text,
    updated_by_id integer,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.program_outcomes OWNER TO postgres;

--
-- Name: restricted_holidays; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.restricted_holidays (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    date date NOT NULL,
    description character varying(500),
    academic_year character varying(20) NOT NULL,
    created_by_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.restricted_holidays OWNER TO postgres;

--
-- Name: restricted_holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.restricted_holidays_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.restricted_holidays_id_seq OWNER TO postgres;

--
-- Name: restricted_holidays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.restricted_holidays_id_seq OWNED BY public.restricted_holidays.id;


--
-- Name: retest_marks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.retest_marks (
    id integer NOT NULL,
    grade_id integer NOT NULL,
    student_id integer NOT NULL,
    course_id integer NOT NULL,
    marks_obtained numeric(6,2),
    max_marks numeric(6,2) NOT NULL,
    entered_by_id integer,
    remarks text,
    is_published boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.retest_marks OWNER TO postgres;

--
-- Name: retest_marks_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.retest_marks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.retest_marks_id_seq OWNER TO postgres;

--
-- Name: retest_marks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.retest_marks_id_seq OWNED BY public.retest_marks.id;


--
-- Name: sections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sections (
    id integer NOT NULL,
    department_id integer NOT NULL,
    name character varying(10) NOT NULL,
    year integer NOT NULL,
    class_advisor_id integer,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sections OWNER TO postgres;

--
-- Name: sections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sections_id_seq OWNER TO postgres;

--
-- Name: sections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sections_id_seq OWNED BY public.sections.id;


--
-- Name: seminars; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.seminars (
    id integer NOT NULL,
    course_assignment_id integer NOT NULL,
    student_id integer NOT NULL,
    seminar_date date,
    seminar_topic text,
    marks_obtained numeric(6,2),
    max_marks numeric(6,2) DEFAULT 100 NOT NULL,
    is_topic_published boolean DEFAULT false NOT NULL,
    is_marks_published boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    rubric_content_relevance numeric(4,2),
    rubric_presentation_skills numeric(4,2),
    rubric_resources_used numeric(4,2),
    rubric_time_management numeric(4,2),
    rubric_question_handling numeric(4,2),
    rubric_team_coordination numeric(4,2)
);


ALTER TABLE public.seminars OWNER TO postgres;

--
-- Name: seminars_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.seminars_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seminars_id_seq OWNER TO postgres;

--
-- Name: seminars_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.seminars_id_seq OWNED BY public.seminars.id;


--
-- Name: student_fee_assignments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_fee_assignments (
    id integer NOT NULL,
    student_id integer NOT NULL,
    fee_structure_id integer,
    amount_due numeric(12,2) NOT NULL,
    semester integer NOT NULL,
    academic_year character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.student_fee_assignments OWNER TO postgres;

--
-- Name: student_fee_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_fee_assignments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_fee_assignments_id_seq OWNER TO postgres;

--
-- Name: student_fee_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_fee_assignments_id_seq OWNED BY public.student_fee_assignments.id;


--
-- Name: student_leave_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_leave_requests (
    id integer NOT NULL,
    student_id integer NOT NULL,
    from_date date NOT NULL,
    to_date date NOT NULL,
    duration_days integer NOT NULL,
    reason character varying(1000) NOT NULL,
    status public.studentleavestatus NOT NULL,
    mentor_id integer,
    mentor_remarks character varying(500),
    mentor_actioned_at timestamp with time zone,
    class_advisor_id integer,
    class_advisor_remarks character varying(500),
    class_advisor_actioned_at timestamp with time zone,
    hod_id integer,
    hod_remarks character varying(500),
    hod_actioned_at timestamp with time zone,
    rejection_reason character varying(500),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    viewed_by_mentor boolean DEFAULT false,
    viewed_by_ca boolean DEFAULT false,
    viewed_by_hod boolean DEFAULT false,
    leave_type character varying(20) DEFAULT 'Regular'::character varying NOT NULL
);


ALTER TABLE public.student_leave_requests OWNER TO postgres;

--
-- Name: student_leave_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_leave_requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_leave_requests_id_seq OWNER TO postgres;

--
-- Name: student_leave_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_leave_requests_id_seq OWNED BY public.student_leave_requests.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.students (
    id integer NOT NULL,
    user_id integer NOT NULL,
    department_id integer NOT NULL,
    section_id integer,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    register_number character varying(50) NOT NULL,
    gender character varying(10),
    date_of_birth date,
    blood_group character varying(5),
    nationality character varying(50),
    community character varying(50),
    photo_url character varying(500),
    batch character varying(20) NOT NULL,
    current_year integer,
    current_semester integer,
    college_email character varying(255) NOT NULL,
    personal_email character varying(255),
    phone character varying(15) NOT NULL,
    father_name character varying(150),
    father_phone character varying(15),
    father_occupation character varying(100),
    mother_name character varying(150),
    mother_phone character varying(15),
    mother_occupation character varying(100),
    annual_income numeric(12,2),
    address_line1 character varying(255),
    address_line2 character varying(255),
    city character varying(100),
    state character varying(100),
    pincode character varying(10),
    tenth_school character varying(255),
    tenth_board character varying(100),
    tenth_marks numeric(6,2),
    tenth_percentage numeric(5,2),
    twelfth_school character varying(255),
    twelfth_board character varying(100),
    twelfth_marks numeric(6,2),
    twelfth_percentage numeric(5,2),
    admission_date date,
    admission_type character varying(50),
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone,
    religion character varying(100),
    aadhar_number character varying(12),
    accommodation character varying(50),
    transportation character varying(50),
    bus_number character varying(50),
    is_alumni boolean DEFAULT false,
    intended_department_id integer,
    guardian_name character varying(150),
    guardian_phone character varying(15),
    guardian_occupation character varying(100),
    primary_contact character varying(20)
);


ALTER TABLE public.students OWNER TO postgres;

--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.students_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.students_id_seq OWNER TO postgres;

--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.students_id_seq OWNED BY public.students.id;


--
-- Name: tally_ledger_mappings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tally_ledger_mappings (
    id integer NOT NULL,
    ledger_name_raw character varying(500) NOT NULL,
    student_id integer NOT NULL,
    confirmed_by integer,
    confirmed_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tally_ledger_mappings OWNER TO postgres;

--
-- Name: tally_ledger_mappings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tally_ledger_mappings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tally_ledger_mappings_id_seq OWNER TO postgres;

--
-- Name: tally_ledger_mappings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tally_ledger_mappings_id_seq OWNED BY public.tally_ledger_mappings.id;


--
-- Name: timetable_slots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.timetable_slots (
    id integer NOT NULL,
    course_assignment_id integer NOT NULL,
    day public.dayofweek NOT NULL,
    start_time time without time zone NOT NULL,
    end_time time without time zone NOT NULL,
    room character varying(50),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.timetable_slots OWNER TO postgres;

--
-- Name: timetable_slots_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.timetable_slots_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.timetable_slots_id_seq OWNER TO postgres;

--
-- Name: timetable_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.timetable_slots_id_seq OWNED BY public.timetable_slots.id;


--
-- Name: unmapped_ledger_entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.unmapped_ledger_entries (
    id integer NOT NULL,
    ledger_name_raw character varying(500) NOT NULL,
    amount numeric(12,2) NOT NULL,
    payment_date date,
    voucher_no character varying(100),
    status public.unmappedstatus NOT NULL,
    suggested_student_id integer,
    upload_batch character varying(100),
    created_at timestamp with time zone DEFAULT now(),
    entry_type character varying(50) DEFAULT 'payment'::character varying NOT NULL
);


ALTER TABLE public.unmapped_ledger_entries OWNER TO postgres;

--
-- Name: unmapped_ledger_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.unmapped_ledger_entries_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.unmapped_ledger_entries_id_seq OWNER TO postgres;

--
-- Name: unmapped_ledger_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.unmapped_ledger_entries_id_seq OWNED BY public.unmapped_ledger_entries.id;


--
-- Name: upload_batches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.upload_batches (
    id integer NOT NULL,
    upload_batch character varying(100) NOT NULL,
    filename character varying(500),
    upload_type character varying(50) NOT NULL,
    rows_processed integer NOT NULL,
    auto_matched integer NOT NULL,
    newly_auto_matched_count integer NOT NULL,
    unmapped_count integer NOT NULL,
    skipped_duplicate integer NOT NULL,
    uploaded_by integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.upload_batches OWNER TO postgres;

--
-- Name: upload_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.upload_batches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.upload_batches_id_seq OWNER TO postgres;

--
-- Name: upload_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.upload_batches_id_seq OWNED BY public.upload_batches.id;


--
-- Name: user_page_views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_page_views (
    id integer NOT NULL,
    user_id integer NOT NULL,
    page_path character varying(255) NOT NULL,
    last_viewed_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_page_views OWNER TO postgres;

--
-- Name: user_page_views_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_page_views_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_page_views_id_seq OWNER TO postgres;

--
-- Name: user_page_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_page_views_id_seq OWNED BY public.user_page_views.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    hashed_password character varying(255) NOT NULL,
    role public.userrole NOT NULL,
    is_active boolean,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: whatsapp_sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.whatsapp_sessions (
    phone_number character varying(20) NOT NULL,
    language character varying(50),
    current_menu character varying(50)
);


ALTER TABLE public.whatsapp_sessions OWNER TO postgres;

--
-- Name: advising_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advising_logs ALTER COLUMN id SET DEFAULT nextval('public.advising_logs_id_seq'::regclass);


--
-- Name: alumni id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumni ALTER COLUMN id SET DEFAULT nextval('public.alumni_id_seq'::regclass);


--
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements ALTER COLUMN id SET DEFAULT nextval('public.announcements_id_seq'::regclass);


--
-- Name: assignment_grades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_grades ALTER COLUMN id SET DEFAULT nextval('public.assignment_grades_id_seq'::regclass);


--
-- Name: attendance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance ALTER COLUMN id SET DEFAULT nextval('public.attendance_id_seq'::regclass);


--
-- Name: authorities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorities ALTER COLUMN id SET DEFAULT nextval('public.authorities_id_seq'::regclass);


--
-- Name: compensation_registry_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_registry_requests ALTER COLUMN id SET DEFAULT nextval('public.compensation_registry_requests_id_seq'::regclass);


--
-- Name: course_assignment_units id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignment_units ALTER COLUMN id SET DEFAULT nextval('public.course_assignment_units_id_seq'::regclass);


--
-- Name: course_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignments ALTER COLUMN id SET DEFAULT nextval('public.course_assignments_id_seq'::regclass);


--
-- Name: course_plan_topics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_plan_topics ALTER COLUMN id SET DEFAULT nextval('public.course_plan_topics_id_seq'::regclass);


--
-- Name: course_plans id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_plans ALTER COLUMN id SET DEFAULT nextval('public.course_plans_id_seq'::regclass);


--
-- Name: courses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses ALTER COLUMN id SET DEFAULT nextval('public.courses_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: discipline_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_records ALTER COLUMN id SET DEFAULT nextval('public.discipline_records_id_seq'::regclass);


--
-- Name: enrollments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments ALTER COLUMN id SET DEFAULT nextval('public.enrollments_id_seq'::regclass);


--
-- Name: faculty id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty ALTER COLUMN id SET DEFAULT nextval('public.faculty_id_seq'::regclass);


--
-- Name: faculty_attendance id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_attendance ALTER COLUMN id SET DEFAULT nextval('public.faculty_attendance_id_seq'::regclass);


--
-- Name: faculty_duty_arrangements id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_duty_arrangements ALTER COLUMN id SET DEFAULT nextval('public.faculty_duty_arrangements_id_seq'::regclass);


--
-- Name: faculty_gate_passes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_gate_passes ALTER COLUMN id SET DEFAULT nextval('public.faculty_gate_passes_id_seq'::regclass);


--
-- Name: faculty_leave_balances id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_balances ALTER COLUMN id SET DEFAULT nextval('public.faculty_leave_balances_id_seq'::regclass);


--
-- Name: faculty_leave_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_requests ALTER COLUMN id SET DEFAULT nextval('public.faculty_leave_requests_id_seq'::regclass);


--
-- Name: fee_structures id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_structures ALTER COLUMN id SET DEFAULT nextval('public.fee_structures_id_seq'::regclass);


--
-- Name: gate_passes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate_passes ALTER COLUMN id SET DEFAULT nextval('public.gate_passes_id_seq'::regclass);


--
-- Name: grades id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades ALTER COLUMN id SET DEFAULT nextval('public.grades_id_seq'::regclass);


--
-- Name: holidays id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.holidays ALTER COLUMN id SET DEFAULT nextval('public.holidays_id_seq'::regclass);


--
-- Name: lab_marks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_marks ALTER COLUMN id SET DEFAULT nextval('public.lab_marks_id_seq'::regclass);


--
-- Name: late_entry_notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_entry_notifications ALTER COLUMN id SET DEFAULT nextval('public.late_entry_notifications_id_seq'::regclass);


--
-- Name: late_records id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_records ALTER COLUMN id SET DEFAULT nextval('public.late_records_id_seq'::regclass);


--
-- Name: leave_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests ALTER COLUMN id SET DEFAULT nextval('public.leave_requests_id_seq'::regclass);


--
-- Name: lms_resources id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lms_resources ALTER COLUMN id SET DEFAULT nextval('public.lms_resources_id_seq'::regclass);


--
-- Name: mentor_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_assignments ALTER COLUMN id SET DEFAULT nextval('public.mentor_assignments_id_seq'::regclass);


--
-- Name: mentoring_meetings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentoring_meetings ALTER COLUMN id SET DEFAULT nextval('public.mentoring_meetings_id_seq'::regclass);


--
-- Name: msg_conversations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_conversations ALTER COLUMN id SET DEFAULT nextval('public.msg_conversations_id_seq'::regclass);


--
-- Name: msg_messages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_messages ALTER COLUMN id SET DEFAULT nextval('public.msg_messages_id_seq'::regclass);


--
-- Name: notification_views id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_views ALTER COLUMN id SET DEFAULT nextval('public.notification_views_id_seq'::regclass);


--
-- Name: password_reset_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_requests ALTER COLUMN id SET DEFAULT nextval('public.password_reset_requests_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: restricted_holidays id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restricted_holidays ALTER COLUMN id SET DEFAULT nextval('public.restricted_holidays_id_seq'::regclass);


--
-- Name: retest_marks id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retest_marks ALTER COLUMN id SET DEFAULT nextval('public.retest_marks_id_seq'::regclass);


--
-- Name: sections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections ALTER COLUMN id SET DEFAULT nextval('public.sections_id_seq'::regclass);


--
-- Name: seminars id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seminars ALTER COLUMN id SET DEFAULT nextval('public.seminars_id_seq'::regclass);


--
-- Name: student_fee_assignments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fee_assignments ALTER COLUMN id SET DEFAULT nextval('public.student_fee_assignments_id_seq'::regclass);


--
-- Name: student_leave_requests id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_requests ALTER COLUMN id SET DEFAULT nextval('public.student_leave_requests_id_seq'::regclass);


--
-- Name: students id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students ALTER COLUMN id SET DEFAULT nextval('public.students_id_seq'::regclass);


--
-- Name: tally_ledger_mappings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tally_ledger_mappings ALTER COLUMN id SET DEFAULT nextval('public.tally_ledger_mappings_id_seq'::regclass);


--
-- Name: timetable_slots id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable_slots ALTER COLUMN id SET DEFAULT nextval('public.timetable_slots_id_seq'::regclass);


--
-- Name: unmapped_ledger_entries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unmapped_ledger_entries ALTER COLUMN id SET DEFAULT nextval('public.unmapped_ledger_entries_id_seq'::regclass);


--
-- Name: upload_batches id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload_batches ALTER COLUMN id SET DEFAULT nextval('public.upload_batches_id_seq'::regclass);


--
-- Name: user_page_views id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_page_views ALTER COLUMN id SET DEFAULT nextval('public.user_page_views_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: advising_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.advising_logs (id, mentor_id, student_id, note, created_at) FROM stdin;
\.


--
-- Data for Name: alumni; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alumni (id, user_id, department_id, first_name, last_name, register_number, gender, date_of_birth, blood_group, nationality, community, photo_url, batch, graduation_year, college_email, personal_email, phone, address_line1, address_line2, city, state, pincode, created_at) FROM stdin;
\.


--
-- Data for Name: announcements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.announcements (id, course_id, department_id, posted_by_id, title, content, is_global, created_at, category, target_audience) FROM stdin;
\.


--
-- Data for Name: assignment_grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.assignment_grades (id, assignment_id, student_id, marks_obtained, max_marks, is_absent, is_published, remarks, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.attendance (id, student_id, course_id, date, hour, status, marked_by_id, created_at) FROM stdin;
945	1265	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
946	1267	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
947	1269	73	2026-07-14	\N	ABSENT	74	2026-07-14 12:30:58.75695+05:30
948	1270	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
949	1271	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
950	1272	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
951	1274	73	2026-07-14	\N	ABSENT	74	2026-07-14 12:30:58.75695+05:30
952	1275	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
953	1277	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
954	1279	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
955	1282	73	2026-07-14	\N	ABSENT	74	2026-07-14 12:30:58.75695+05:30
956	1283	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
957	1286	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
958	1287	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
959	1290	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
960	1291	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
961	1292	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
962	1293	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
963	1295	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
964	1298	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
965	1302	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
966	1303	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
967	1306	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
968	1307	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
969	1310	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
970	1312	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
971	1313	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
972	1319	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
973	1320	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
974	1321	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
975	1322	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
976	1325	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
977	1326	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
978	1327	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
979	1328	73	2026-07-14	\N	ABSENT	74	2026-07-14 12:30:58.75695+05:30
980	1335	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
981	1337	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
982	1339	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
983	1340	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
984	1342	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
985	1343	73	2026-07-14	\N	ABSENT	74	2026-07-14 12:30:58.75695+05:30
986	1346	73	2026-07-14	\N	PRESENT	74	2026-07-14 12:30:58.75695+05:30
987	1263	73	2026-07-14	\N	ABSENT	82	2026-07-14 12:34:49.712713+05:30
988	1264	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
989	1266	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
990	1268	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
991	1273	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
992	1276	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
993	1278	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
994	1280	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
995	1281	73	2026-07-14	\N	ABSENT	82	2026-07-14 12:34:49.712713+05:30
996	1284	73	2026-07-14	\N	ABSENT	82	2026-07-14 12:34:49.712713+05:30
997	1285	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
998	1288	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
999	1289	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1000	1294	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1001	1296	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1002	1297	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1003	1299	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1005	1301	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1006	1305	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1007	1308	73	2026-07-14	\N	ABSENT	82	2026-07-14 12:34:49.712713+05:30
1008	1309	73	2026-07-14	\N	ABSENT	82	2026-07-14 12:34:49.712713+05:30
1009	1311	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1010	1314	73	2026-07-14	\N	ABSENT	82	2026-07-14 12:34:49.712713+05:30
1011	1315	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1012	1316	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1013	1317	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1014	1318	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1015	1323	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1016	1324	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1017	1329	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1018	1330	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1019	1331	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1020	1332	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1021	1333	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1022	1334	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1023	1336	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1024	1338	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1025	1341	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1026	1344	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1027	1345	73	2026-07-14	\N	PRESENT	82	2026-07-14 12:34:49.712713+05:30
1028	1304	73	2026-07-14	\N	ABSENT	82	2026-07-14 12:34:49.712713+05:30
1029	1407	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1030	1408	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1031	1409	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1032	1410	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1033	1411	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1034	1412	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1035	1413	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1036	1414	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1037	1415	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1038	1416	83	2026-07-16	1	PRESENT	67	2026-07-14 15:14:29.479926+05:30
1039	1407	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1040	1408	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1041	1409	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1042	1410	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1043	1411	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1044	1412	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1045	1413	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1046	1414	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1047	1415	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1048	1416	87	2026-07-16	5	PRESENT	67	2026-07-14 15:24:48.572362+05:30
1049	1263	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1050	1264	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1051	1266	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1052	1268	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1053	1273	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1054	1276	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1055	1278	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1056	1280	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1057	1281	73	2026-07-15	\N	ABSENT	82	2026-07-15 10:11:06.48112+05:30
1058	1284	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1059	1285	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1060	1288	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1061	1289	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1062	1294	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1063	1296	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1064	1297	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1065	1299	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1067	1301	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1068	1305	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1069	1308	73	2026-07-15	\N	ABSENT	82	2026-07-15 10:11:06.48112+05:30
1070	1309	73	2026-07-15	\N	ABSENT	82	2026-07-15 10:11:06.48112+05:30
1071	1311	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1072	1314	73	2026-07-15	\N	ABSENT	82	2026-07-15 10:11:06.48112+05:30
1073	1315	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1074	1316	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1075	1317	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1076	1318	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1077	1323	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1078	1324	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1079	1329	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1080	1330	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1081	1331	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1082	1332	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1083	1333	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1084	1334	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1085	1336	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1086	1338	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1087	1341	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1088	1344	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1089	1345	73	2026-07-15	\N	PRESENT	82	2026-07-15 10:11:06.48112+05:30
1090	1304	73	2026-07-15	\N	ABSENT	82	2026-07-15 10:11:06.48112+05:30
1101	1407	87	2026-07-15	5	PRESENT	67	2026-07-15 14:36:06.41844+05:30
1102	1408	87	2026-07-15	5	PRESENT	67	2026-07-15 14:36:06.41844+05:30
1103	1409	87	2026-07-15	5	ABSENT	67	2026-07-15 14:36:06.41844+05:30
1104	1410	87	2026-07-15	5	ABSENT	67	2026-07-15 14:36:06.41844+05:30
1105	1411	87	2026-07-15	5	ABSENT	67	2026-07-15 14:36:06.41844+05:30
1106	1412	87	2026-07-15	5	ABSENT	67	2026-07-15 14:36:06.41844+05:30
1107	1413	87	2026-07-15	5	PRESENT	67	2026-07-15 14:36:06.41844+05:30
1108	1414	87	2026-07-15	5	PRESENT	67	2026-07-15 14:36:06.41844+05:30
1109	1415	87	2026-07-15	5	PRESENT	67	2026-07-15 14:36:06.41844+05:30
1110	1416	87	2026-07-15	5	PRESENT	67	2026-07-15 14:36:06.41844+05:30
1091	1407	83	2026-07-15	1	PRESENT	62	2026-07-15 11:29:59.125901+05:30
1092	1408	83	2026-07-15	1	ABSENT	62	2026-07-15 11:29:59.125901+05:30
1093	1409	83	2026-07-15	1	ABSENT	62	2026-07-15 11:29:59.125901+05:30
1094	1410	83	2026-07-15	1	ABSENT	62	2026-07-15 11:29:59.125901+05:30
1095	1411	83	2026-07-15	1	ABSENT	62	2026-07-15 11:29:59.125901+05:30
1096	1412	83	2026-07-15	1	PRESENT	62	2026-07-15 11:29:59.125901+05:30
1097	1413	83	2026-07-15	1	PRESENT	62	2026-07-15 11:29:59.125901+05:30
1098	1414	83	2026-07-15	1	PRESENT	62	2026-07-15 11:29:59.125901+05:30
1099	1415	83	2026-07-15	1	PRESENT	62	2026-07-15 11:29:59.125901+05:30
1100	1416	83	2026-07-15	1	PRESENT	62	2026-07-15 11:29:59.125901+05:30
1111	1263	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1113	1266	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1114	1268	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1115	1273	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1116	1276	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1117	1278	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1118	1280	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1119	1281	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1120	1284	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1121	1285	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1122	1288	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1123	1289	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1124	1294	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1125	1296	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1126	1297	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1127	1299	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1129	1301	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1130	1305	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1131	1308	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1132	1309	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1133	1311	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1134	1314	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1135	1315	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1136	1316	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1137	1317	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1138	1318	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1139	1323	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1140	1324	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1141	1329	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1142	1330	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1143	1331	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1144	1332	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1145	1333	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1146	1334	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1147	1336	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1148	1338	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1149	1341	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1150	1344	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1151	1345	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1152	1304	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1112	1264	73	2026-07-16	\N	PRESENT	82	2026-07-16 10:45:20.654432+05:30
1153	1265	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1154	1267	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1155	1269	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1156	1270	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1157	1271	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1158	1272	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1159	1274	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1160	1275	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1161	1277	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1162	1279	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1163	1282	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1164	1283	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1165	1286	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1166	1287	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1167	1290	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1168	1291	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1169	1292	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1170	1293	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1171	1295	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1172	1298	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1173	1302	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1174	1303	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1175	1306	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1176	1307	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1177	1310	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1178	1312	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1179	1313	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1180	1319	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1181	1320	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1182	1321	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1183	1322	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1184	1325	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1185	1326	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1186	1327	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1187	1328	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1188	1335	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1189	1337	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1190	1339	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1191	1340	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1192	1342	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1193	1343	71	2026-07-16	\N	ABSENT	74	2026-07-16 10:53:59.735151+05:30
1194	1346	71	2026-07-16	\N	PRESENT	74	2026-07-16 10:53:59.735151+05:30
1195	1357	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1196	1358	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1197	1359	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1198	1360	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1199	1361	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1200	1362	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1201	1363	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1202	1364	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1203	1365	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1204	1366	18	2026-07-17	\N	ABSENT	62	2026-07-16 13:45:29.167129+05:30
1205	1265	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1206	1267	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1207	1269	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1208	1270	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1209	1271	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1210	1272	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1211	1274	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1212	1275	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1213	1277	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1214	1279	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1215	1282	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1216	1283	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1217	1286	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1218	1287	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1219	1290	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1220	1291	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1221	1292	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1222	1293	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1223	1295	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1224	1298	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1225	1302	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1226	1303	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1227	1306	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1228	1307	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1229	1310	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1230	1312	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1231	1313	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1232	1319	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1233	1320	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1234	1321	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1235	1322	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1236	1325	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1237	1326	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1238	1327	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1239	1328	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1240	1335	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1241	1337	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1242	1339	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1243	1340	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1244	1342	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1245	1343	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1246	1346	71	2026-07-18	\N	PRESENT	74	2026-07-18 16:42:46.30464+05:30
1247	1357	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1248	1358	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1249	1359	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1250	1360	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1251	1361	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1252	1362	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1254	1364	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1255	1365	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1253	1363	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1256	1366	18	2026-07-21	\N	PRESENT	69	2026-07-22 13:24:00.652694+05:30
1257	1265	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1258	1267	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1259	1269	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1260	1270	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1261	1271	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1262	1272	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1263	1274	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1264	1275	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1265	1277	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1266	1279	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1267	1282	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1268	1283	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1269	1286	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1270	1287	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1271	1290	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1272	1291	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1273	1292	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1274	1293	71	2026-07-22	\N	ABSENT	74	2026-07-22 10:30:44.614094+05:30
1275	1295	71	2026-07-22	\N	ABSENT	74	2026-07-22 10:30:44.614094+05:30
1276	1298	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1277	1302	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1278	1303	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1279	1306	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1280	1307	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1281	1310	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1282	1312	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1283	1313	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1284	1319	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1285	1320	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1286	1321	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1287	1322	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1288	1325	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1289	1326	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1290	1327	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1291	1328	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1292	1335	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1293	1337	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1294	1339	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1295	1340	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1296	1342	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1297	1343	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1298	1346	71	2026-07-22	\N	PRESENT	74	2026-07-22 10:30:44.614094+05:30
1323	1432	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1324	1433	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1325	1434	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1326	1436	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1327	1437	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1328	1439	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1329	1440	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1330	1441	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1331	1443	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1332	1447	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1333	1449	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1334	1450	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1335	1453	51	2026-07-23	\N	ABSENT	73	2026-07-23 10:30:25.128934+05:30
1336	1454	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1337	1457	51	2026-07-23	\N	ABSENT	73	2026-07-23 10:30:25.128934+05:30
1338	1460	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1339	1461	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1340	1463	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1341	1464	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1342	1468	51	2026-07-23	\N	ABSENT	73	2026-07-23 10:30:25.128934+05:30
1343	1470	51	2026-07-23	\N	ABSENT	73	2026-07-23 10:30:25.128934+05:30
1344	1471	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1345	1472	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1346	1473	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1347	1475	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1348	1476	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1349	1480	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1350	1486	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1351	1487	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1352	1488	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1353	1490	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1354	1491	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1355	1493	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1356	1497	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1357	1499	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1358	1502	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1359	1504	51	2026-07-23	\N	ABSENT	73	2026-07-23 10:30:25.128934+05:30
1360	1505	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1361	1507	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1362	1509	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1363	1510	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1364	1512	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1365	1515	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1366	1516	51	2026-07-23	\N	ABSENT	73	2026-07-23 10:30:25.128934+05:30
1367	1517	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1368	1520	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1369	1521	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1370	1524	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1371	1526	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1372	1530	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1373	1531	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1374	1533	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1375	1537	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1376	1541	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1377	1543	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1378	1546	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1379	1547	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1380	1548	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1381	1549	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1382	1550	51	2026-07-23	\N	PRESENT	73	2026-07-23 10:30:25.128934+05:30
1383	1263	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1384	1264	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1385	1266	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1386	1268	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1387	1273	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1388	1276	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1389	1278	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1390	1280	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1391	1281	69	2026-07-23	\N	ABSENT	82	2026-07-23 10:39:04.924979+05:30
1392	1284	69	2026-07-23	\N	ABSENT	82	2026-07-23 10:39:04.924979+05:30
1393	1285	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1394	1288	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1395	1289	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1396	1294	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1397	1296	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1398	1297	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1399	1299	69	2026-07-23	\N	ABSENT	82	2026-07-23 10:39:04.924979+05:30
1400	1301	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1401	1305	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1402	1308	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1403	1309	69	2026-07-23	\N	ABSENT	82	2026-07-23 10:39:04.924979+05:30
1404	1311	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1405	1314	69	2026-07-23	\N	ABSENT	82	2026-07-23 10:39:04.924979+05:30
1406	1315	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1407	1316	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1408	1317	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1409	1318	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1410	1323	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1411	1324	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1412	1329	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1413	1330	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1414	1331	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1415	1332	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1416	1333	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1417	1334	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1418	1336	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1419	1338	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1420	1341	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1421	1344	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1422	1345	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1423	1304	69	2026-07-23	\N	PRESENT	82	2026-07-23 10:39:04.924979+05:30
1424	1265	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1425	1267	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1426	1269	71	2026-07-23	\N	ABSENT	74	2026-07-23 10:39:14.160748+05:30
1427	1270	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1428	1271	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1429	1272	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1430	1274	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1431	1275	71	2026-07-23	\N	ABSENT	74	2026-07-23 10:39:14.160748+05:30
1432	1277	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1433	1279	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1434	1282	71	2026-07-23	\N	ABSENT	74	2026-07-23 10:39:14.160748+05:30
1435	1283	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1436	1286	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1437	1287	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1438	1290	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1439	1291	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1440	1292	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1441	1293	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1442	1295	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1443	1298	71	2026-07-23	\N	ABSENT	74	2026-07-23 10:39:14.160748+05:30
1444	1302	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1445	1303	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1446	1306	71	2026-07-23	\N	ABSENT	74	2026-07-23 10:39:14.160748+05:30
1447	1307	71	2026-07-23	\N	ABSENT	74	2026-07-23 10:39:14.160748+05:30
1448	1310	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1449	1312	71	2026-07-23	\N	ABSENT	74	2026-07-23 10:39:14.160748+05:30
1450	1313	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1451	1319	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1452	1320	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1453	1321	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1454	1322	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1455	1325	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1456	1326	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1457	1327	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1458	1328	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1459	1335	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1460	1337	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1461	1339	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1462	1340	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1463	1342	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1464	1343	71	2026-07-23	\N	ABSENT	74	2026-07-23 10:39:14.160748+05:30
1465	1346	71	2026-07-23	\N	PRESENT	74	2026-07-23 10:39:14.160748+05:30
1466	1552	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1467	1556	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1468	1558	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1469	1560	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1470	1562	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1471	1563	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1472	1564	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1473	1565	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1474	1570	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1475	1571	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1476	1572	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1477	1573	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1478	1574	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1479	1578	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1480	1580	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1481	1583	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1482	1584	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1483	1586	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1484	1587	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1485	1588	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1486	1589	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1487	1594	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1488	1597	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1489	1600	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1490	1603	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1491	1606	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1492	1608	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1493	1613	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1494	1614	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1495	1615	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1496	1617	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1497	1618	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1498	1620	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1499	1621	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1500	1623	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1501	1626	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1502	1628	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1503	1629	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1504	1631	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1505	1634	33	2026-07-23	\N	ABSENT	79	2026-07-23 10:46:45.031011+05:30
1506	1635	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1507	1636	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1508	1638	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1509	1639	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1510	1641	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1511	1643	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1512	1644	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1513	1647	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1514	1649	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1515	1650	33	2026-07-23	\N	PRESENT	79	2026-07-23 10:46:45.031011+05:30
1516	1553	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1517	1554	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1518	1555	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1519	1557	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1520	1559	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1521	1561	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1522	1566	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1523	1567	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1524	1568	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1525	1569	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1526	1575	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1527	1576	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1528	1577	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1529	1579	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1530	1581	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1531	1582	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1532	1585	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1533	1590	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1534	1591	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1535	1592	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1536	1593	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1537	1595	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1538	1596	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1539	1598	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1540	1599	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1541	1601	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1542	1602	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1543	1604	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1544	1605	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1545	1607	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1546	1609	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1547	1610	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1548	1611	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1549	1612	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1550	1616	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1551	1619	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1552	1622	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1553	1624	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1554	1625	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1555	1627	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1556	1630	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1557	1632	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1558	1633	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1559	1637	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1560	1640	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1561	1642	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1562	1645	33	2026-07-23	\N	ABSENT	77	2026-07-23 10:47:14.481339+05:30
1563	1646	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1564	1648	33	2026-07-23	\N	PRESENT	77	2026-07-23 10:47:14.481339+05:30
1565	1435	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1566	1438	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1567	1442	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1568	1444	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1569	1445	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1570	1446	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1571	1448	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1572	1451	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1573	1452	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1574	1455	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1575	1456	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1576	1458	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1577	1459	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1578	1462	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1579	1465	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1580	1466	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1581	1467	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1582	1469	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1583	1474	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1584	1477	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1585	1478	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1586	1479	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1587	1481	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1588	1482	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1589	1483	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1590	1484	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1591	1485	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1592	1489	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1593	1492	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1594	1494	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1595	1495	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1596	1496	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1597	1498	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1598	1500	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1599	1501	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1600	1503	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1601	1506	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1602	1508	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1603	1511	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1604	1513	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1605	1514	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1606	1518	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1607	1519	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1608	1522	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1609	1523	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1610	1525	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1611	1527	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1612	1528	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1613	1529	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1614	1532	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1615	1534	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1616	1535	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1617	1536	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1618	1538	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1619	1539	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1620	1540	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1621	1542	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1622	1544	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1623	1545	51	2026-07-23	\N	PRESENT	76	2026-07-23 10:48:29.865235+05:30
1624	1551	51	2026-07-23	\N	ABSENT	76	2026-07-23 10:48:29.865235+05:30
1625	1553	33	2026-07-24	\N	ABSENT	77	2026-07-24 09:18:27.393463+05:30
1626	1554	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1627	1555	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1628	1557	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1629	1559	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1630	1561	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1631	1566	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1632	1567	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1633	1568	33	2026-07-24	\N	ABSENT	77	2026-07-24 09:18:27.393463+05:30
1634	1569	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1635	1575	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1636	1576	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1637	1577	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1638	1579	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1639	1581	33	2026-07-24	\N	ABSENT	77	2026-07-24 09:18:27.393463+05:30
1640	1582	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1641	1585	33	2026-07-24	\N	ABSENT	77	2026-07-24 09:18:27.393463+05:30
1642	1590	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1643	1591	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1644	1592	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1645	1593	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1646	1595	33	2026-07-24	\N	ABSENT	77	2026-07-24 09:18:27.393463+05:30
1647	1596	33	2026-07-24	\N	ABSENT	77	2026-07-24 09:18:27.393463+05:30
1648	1598	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1649	1599	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1650	1601	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1651	1602	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1652	1604	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1653	1605	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1654	1607	33	2026-07-24	\N	ABSENT	77	2026-07-24 09:18:27.393463+05:30
1655	1609	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1656	1610	33	2026-07-24	\N	ABSENT	77	2026-07-24 09:18:27.393463+05:30
1657	1611	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1658	1612	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1659	1616	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1660	1619	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1661	1622	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1662	1624	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1663	1625	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1664	1627	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1665	1630	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1666	1632	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1667	1633	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1668	1637	33	2026-07-24	\N	ABSENT	77	2026-07-24 09:18:27.393463+05:30
1669	1640	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1670	1642	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1671	1645	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1672	1646	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1673	1648	33	2026-07-24	\N	PRESENT	77	2026-07-24 09:18:27.393463+05:30
1674	1552	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1675	1556	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1676	1558	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1677	1560	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1678	1562	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1679	1563	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1680	1564	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1681	1565	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1682	1570	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1683	1571	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1684	1572	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1685	1573	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1686	1574	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1687	1578	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1688	1580	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1689	1583	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1690	1584	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1691	1586	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1692	1587	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1693	1588	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1694	1589	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1695	1594	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1696	1597	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1697	1600	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1698	1603	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1699	1606	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1700	1608	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1701	1613	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1702	1614	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1703	1615	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1704	1617	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1705	1618	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1706	1620	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1707	1621	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1708	1623	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1709	1626	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1710	1628	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1711	1629	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1712	1631	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1713	1634	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1714	1635	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1715	1636	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1716	1638	33	2026-07-24	\N	ABSENT	79	2026-07-24 09:22:37.961875+05:30
1717	1639	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1718	1641	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1719	1643	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1720	1644	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1721	1647	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1722	1649	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1723	1650	33	2026-07-24	\N	PRESENT	79	2026-07-24 09:22:37.961875+05:30
1724	1263	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1725	1264	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1726	1266	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1727	1268	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1728	1273	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1729	1276	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1730	1278	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1731	1280	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1732	1281	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1733	1284	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1734	1285	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1735	1288	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1736	1289	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1737	1294	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1738	1296	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1739	1297	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1740	1299	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1741	1301	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1742	1305	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1743	1308	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1744	1309	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1745	1311	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1746	1314	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1747	1315	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1748	1316	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1749	1317	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1750	1318	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1751	1323	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1752	1324	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1753	1329	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1754	1330	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1755	1331	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1756	1332	69	2026-07-24	\N	ABSENT	82	2026-07-24 09:24:22.055099+05:30
1757	1333	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1758	1334	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1759	1336	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1761	1341	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1762	1344	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1763	1345	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1764	1304	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1760	1338	69	2026-07-24	\N	PRESENT	82	2026-07-24 09:24:22.055099+05:30
1765	1432	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1766	1433	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1767	1434	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1768	1436	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1769	1437	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1770	1439	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1771	1440	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1772	1441	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1773	1443	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1774	1447	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1775	1449	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1776	1450	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1777	1453	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1778	1454	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1779	1457	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1780	1460	51	2026-07-24	\N	ABSENT	73	2026-07-24 09:36:11.122891+05:30
1781	1461	51	2026-07-24	\N	ABSENT	73	2026-07-24 09:36:11.122891+05:30
1782	1463	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1783	1464	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1784	1468	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1785	1470	51	2026-07-24	\N	ABSENT	73	2026-07-24 09:36:11.122891+05:30
1786	1471	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1787	1472	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1788	1473	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1789	1475	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1790	1476	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1791	1480	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1792	1486	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1793	1487	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1794	1488	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1795	1490	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1796	1491	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1797	1493	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1798	1497	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1799	1499	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1800	1502	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1801	1504	51	2026-07-24	\N	ABSENT	73	2026-07-24 09:36:11.122891+05:30
1802	1505	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1803	1507	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1804	1509	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1805	1510	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1806	1512	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1807	1515	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1808	1516	51	2026-07-24	\N	ABSENT	73	2026-07-24 09:36:11.122891+05:30
1809	1517	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1810	1520	51	2026-07-24	\N	ABSENT	73	2026-07-24 09:36:11.122891+05:30
1811	1521	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1812	1524	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1813	1526	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1814	1530	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1815	1531	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1816	1533	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1817	1537	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1818	1541	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1819	1543	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1820	1546	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1821	1547	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1822	1548	51	2026-07-24	\N	ABSENT	73	2026-07-24 09:36:11.122891+05:30
1823	1549	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1824	1550	51	2026-07-24	\N	PRESENT	73	2026-07-24 09:36:11.122891+05:30
1825	1265	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1826	1267	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1827	1269	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1828	1270	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1829	1271	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1830	1272	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1831	1274	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1832	1275	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1833	1277	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1834	1279	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1835	1282	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1836	1283	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1837	1286	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1838	1287	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1839	1290	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1840	1291	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1841	1292	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1842	1293	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1843	1295	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1844	1298	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1845	1302	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1846	1303	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1847	1306	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1848	1307	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1849	1310	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1851	1313	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1852	1319	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1853	1320	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1854	1321	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1855	1322	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1856	1325	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1857	1326	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1858	1327	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1859	1328	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1860	1335	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1861	1337	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1862	1339	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1863	1340	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1864	1342	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1865	1343	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1866	1346	71	2026-07-24	\N	ABSENT	74	2026-07-24 09:40:49.649339+05:30
1850	1312	71	2026-07-24	\N	PRESENT	74	2026-07-24 09:40:49.649339+05:30
1867	1435	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1868	1438	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1869	1442	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1870	1444	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1871	1445	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1872	1446	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1873	1448	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1874	1451	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1875	1452	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1876	1455	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1877	1456	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1878	1458	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1879	1459	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1880	1462	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1881	1465	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1882	1466	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1883	1467	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1884	1469	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1885	1474	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1886	1477	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1887	1478	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1888	1479	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1889	1481	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1890	1482	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1891	1483	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1892	1484	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1893	1485	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1894	1489	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1895	1492	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1896	1494	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1897	1495	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1898	1496	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1899	1498	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1900	1500	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1901	1501	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1902	1503	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1903	1506	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1904	1508	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1905	1511	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1906	1513	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1907	1514	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1908	1518	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1909	1519	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1910	1522	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1911	1523	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1912	1525	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1913	1527	51	2026-07-24	\N	ABSENT	76	2026-07-24 10:16:01.971768+05:30
1914	1528	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1915	1529	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1916	1532	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1917	1534	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1918	1535	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1919	1536	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1920	1538	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1921	1539	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1922	1540	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1923	1542	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1924	1544	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1925	1545	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
1926	1551	51	2026-07-24	\N	PRESENT	76	2026-07-24 10:16:01.971768+05:30
\.


--
-- Data for Name: authorities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.authorities (id, user_id, first_name, last_name, title, email, phone, employee_id, is_active, created_at, updated_at) FROM stdin;
1	10	balaji	n	Dean	dean@svcet.ac.in	9344793685	emp123	t	2026-06-27 08:30:15.732067+05:30	\N
3	769	pradeep 	devaneyan	Principal	principal@svcet.ac.in	9632587412	123	t	2026-06-28 16:32:58.189521+05:30	\N
4	780	Office	Manager	Office Manager	om@gmail.com	7894561233	empo666	t	2026-07-01 12:09:46.444134+05:30	2026-07-02 09:41:13.043191+05:30
6	1307	Office	Manager	Office Manager	om@svcet.ac.in	1234567890	EMP_OFFICE_MANAGER	t	2026-07-08 09:52:22.956103+05:30	\N
7	1308	Vice	Principal	Vice Principal	viceprincipal@svcet.ac.in	1234567890	EMP_VICE_PRINCIPAL	t	2026-07-08 09:52:22.956103+05:30	\N
8	1327	HR	Authority	HR	hr@svcet.ac.in	000000000.	HRSVC001	t	2026-07-10 15:07:58.535836+05:30	\N
\.


--
-- Data for Name: compensation_registry_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.compensation_registry_requests (id, faculty_id, peer_faculty_id, date_worked, classes_substituted, status, is_used, created_at, updated_at) FROM stdin;
1	74	71	2026-07-17	Testing	approved	t	2026-07-17 09:36:32.518115+05:30	2026-07-17 10:10:36.215019+05:30
2	62	61	2026-07-12	t	approved	f	2026-07-17 10:30:24.353917+05:30	2026-07-17 10:31:03.691089+05:30
3	62	65	2026-07-12	t	approved	t	2026-07-17 11:03:04.781559+05:30	2026-07-17 11:05:18.750102+05:30
\.


--
-- Data for Name: course_assignment_units; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_assignment_units (id, course_assignment_id, unit_number, title, is_completed, updated_at) FROM stdin;
4	104	4	test4	f	2026-07-15 14:20:13.11719+05:30
5	104	5	test5	f	2026-07-15 14:20:13.11719+05:30
1	104	1	test1	t	2026-07-15 14:20:24.004929+05:30
2	104	2	test2	t	2026-07-15 14:20:24.004929+05:30
3	104	3	test3	t	2026-07-15 14:20:35.204649+05:30
6	108	1	\N	f	\N
7	108	2	\N	f	\N
8	108	3	\N	f	\N
9	108	4	\N	f	\N
10	108	5	\N	f	\N
11	97	1		t	2026-07-18 16:51:11.676911+05:30
12	97	2		f	2026-07-18 16:51:11.676911+05:30
13	97	3		f	2026-07-18 16:51:11.676911+05:30
14	97	4		f	2026-07-18 16:51:11.676911+05:30
15	97	5		f	2026-07-18 16:51:11.676911+05:30
16	96	1	\N	f	\N
17	96	2	\N	f	\N
18	96	3	\N	f	\N
19	96	4	\N	f	\N
20	96	5	\N	f	\N
21	142	1	\N	f	\N
22	142	2	\N	f	\N
23	142	3	\N	f	\N
24	142	4	\N	f	\N
25	142	5	\N	f	\N
\.


--
-- Data for Name: course_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_assignments (id, faculty_id, course_id, section_id, academic_year, semester, is_active, created_at) FROM stdin;
96	74	71	7	2026-2027	7	t	2026-07-14 12:26:11.631946+05:30
97	74	67	7	2026-2027	7	t	2026-07-14 12:26:24.088377+05:30
100	72	69	8	2026-2027	7	t	2026-07-14 12:28:51.544517+05:30
101	82	67	8	2026-2027	7	t	2026-07-14 12:29:08.721237+05:30
102	82	71	8	2026-2027	7	t	2026-07-14 12:29:16.725483+05:30
103	82	72	8	2026-2027	7	t	2026-07-14 12:29:32.480327+05:30
104	74	72	7	2026-2027	7	t	2026-07-14 12:29:46.833861+05:30
105	61	83	42	2026-2027	1	f	2026-07-14 12:32:38.781175+05:30
106	61	87	42	2026-2027	1	f	2026-07-14 12:32:52.204556+05:30
107	67	83	42	2026-2027	1	t	2026-07-14 12:35:24.54799+05:30
108	67	87	42	2026-2027	1	t	2026-07-14 12:35:32.809871+05:30
109	69	103	46	2026-2027	5	t	2026-07-14 14:25:50.935996+05:30
110	62	104	46	2026-2027	5	t	2026-07-14 14:26:01.716856+05:30
111	61	105	46	2026-2027	5	t	2026-07-14 14:26:12.224051+05:30
112	70	106	46	2026-2027	5	t	2026-07-14 14:26:25.48554+05:30
113	63	107	46	2026-2027	5	t	2026-07-14 14:26:37.409947+05:30
114	69	103	47	2026-2027	5	t	2026-07-14 14:26:57.96724+05:30
115	62	104	47	2026-2027	5	t	2026-07-14 14:27:05.459953+05:30
116	61	105	47	2026-2027	5	t	2026-07-14 14:27:14.431912+05:30
117	70	106	47	2026-2027	5	t	2026-07-14 14:27:24.8914+05:30
118	63	107	47	2026-2027	5	t	2026-07-14 14:27:40.078719+05:30
98	71	69	7	2026-2027	7	f	2026-07-14 12:26:37.537994+05:30
73	33	79	18	2026-2027	7	t	2026-07-07 10:58:33.982558+05:30
74	34	80	18	2026-2027	7	t	2026-07-07 10:58:42.092124+05:30
75	33	81	18	2026-2027	7	t	2026-07-07 10:58:49.529947+05:30
76	33	80	19	2026-2027	1	t	2026-07-07 12:36:14.651511+05:30
95	71	73	7	2026-2027	7	f	2026-07-14 12:25:51.321855+05:30
119	71	69	7	2026-2027	7	t	2026-07-15 09:51:26.636979+05:30
120	71	73	7	2026-2027	7	t	2026-07-15 09:51:35.289578+05:30
121	76	51	9	2026-2027	5	t	2026-07-15 09:52:42.488829+05:30
122	73	52	9	2026-2027	5	t	2026-07-15 09:52:53.714193+05:30
123	81	53	9	2026-2027	5	t	2026-07-15 09:53:02.609684+05:30
124	73	55	9	2026-2027	5	t	2026-07-15 09:53:22.243091+05:30
126	81	58	9	2026-2027	5	t	2026-07-15 09:53:49.228862+05:30
127	76	51	10	2026-2027	5	t	2026-07-15 09:54:32.017578+05:30
128	73	52	10	2026-2027	5	t	2026-07-15 09:54:43.304022+05:30
129	81	53	10	2026-2027	5	t	2026-07-15 09:54:47.854527+05:30
130	76	55	10	2026-2027	5	t	2026-07-15 09:54:55.175669+05:30
131	76	57	10	2026-2027	5	t	2026-07-15 09:55:14.294939+05:30
132	81	58	10	2026-2027	5	t	2026-07-15 09:55:19.686366+05:30
133	65	86	42	2026-2027	1	t	2026-07-15 15:34:26.677353+05:30
136	33	18	49	2026	1	t	2026-07-16 13:44:40.706059+05:30
137	66	121	48	2026-2027	7	t	2026-07-16 14:35:52.541319+05:30
138	33	84	43	2026-2027	1	f	2026-07-22 13:45:37.637024+05:30
139	65	84	43	2026-2027	1	t	2026-07-22 13:46:24.563452+05:30
140	63	85	43	2026-2027	1	t	2026-07-22 13:46:30.220007+05:30
141	69	86	43	2026-2027	1	t	2026-07-22 13:46:36.590251+05:30
142	67	87	43	2026-2027	1	t	2026-07-22 13:46:43.459937+05:30
143	65	83	43	2026-2027	1	t	2026-07-22 13:46:55.756285+05:30
99	71	73	8	2026-2027	7	f	2026-07-14 12:28:39.713637+05:30
144	72	73	8	2026-2027	7	t	2026-07-22 14:21:31.337027+05:30
145	80	50	9	2026-2027	5	t	2026-07-22 14:28:27.970606+05:30
146	82	54	9	2026-2027	5	t	2026-07-22 14:29:53.780625+05:30
147	80	56	9	2026-2027	5	t	2026-07-22 14:30:08.066969+05:30
148	80	56	10	2026-2027	5	t	2026-07-22 14:31:49.725251+05:30
149	33	50	10	2026-2027	5	f	2026-07-22 14:32:00.394332+05:30
150	74	50	10	2026-2027	5	t	2026-07-22 14:32:13.788418+05:30
151	79	54	10	2026-2027	5	t	2026-07-22 14:32:25.308814+05:30
152	79	33	11	2026-2027	3	t	2026-07-21 16:03:49.962103+05:30
153	79	38	11	2026-2027	3	t	2026-07-21 16:04:00.522062+05:30
154	33	33	50	2026-2027	3	f	2026-07-21 16:04:17.733603+05:30
155	77	33	50	2026-2027	3	t	2026-07-21 16:04:30.323759+05:30
156	77	38	50	2026-2027	3	t	2026-07-21 16:04:39.774832+05:30
157	67	125	42	2026-2027	1	t	2026-07-22 10:26:15.1456+05:30
158	67	126	42	2026-2027	1	t	2026-07-22 10:26:22.935419+05:30
125	76	57	9	2026-2027	5	f	2026-07-15 09:53:41.709344+05:30
185	73	57	9	2026-2027	5	t	2026-07-23 10:42:59.075812+05:30
\.


--
-- Data for Name: course_plan_topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_plan_topics (id, course_plan_id, sequence_no, proposed_date, hours, unit, topic, cognitive_level, mode_of_delivery, actual_date, reason_for_deviation, is_signed, signed_at, co, po, experiment_name, resources) FROM stdin;
211	5	1	2026-07-14	1	1	sdfgsdfgdfsg	K1	BB	2026-07-15	Topic covered during Daily Attendance session	t	2026-07-15 14:35:46.069831+05:30	CO1	PO1	\N	\N
215	6	1	2026-07-16	5	1		K1	BB	2026-07-15	Topic covered during Daily Attendance session	t	2026-07-15 14:36:06.41844+05:30	CO1	PO1	experiment name	resourse
216	7	1	2026-07-18	1	1	intro 	K1	BB	\N		f	\N	CO1	PO1	\N	\N
\.


--
-- Data for Name: course_plans; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.course_plans (id, course_assignment_id, created_at, updated_at) FROM stdin;
5	107	2026-07-14 14:36:29.173184+05:30	\N
6	108	2026-07-14 15:11:52.28561+05:30	\N
7	97	2026-07-18 16:49:51.261477+05:30	\N
\.


--
-- Data for Name: courses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.courses (id, department_id, code, name, credits, course_type, semester, is_active, created_at, short_name, syllabus, objectives, outcomes, textbooks, "references", prerequisites, co_po_mapping, co_k_levels, project_guidelines, project_teams_data, seminar_topics_data) FROM stdin;
18	1	CSBL101	Physics Lab	2	LAB	1	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
19	1	CSEL102	Basic Electronics Lab	2	LAB	1	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
20	1	CSEL103	Engineering Graphics & Design Lab	3	LAB	1	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
21	1	CSHL104	Design Thinking	1	LAB	1	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
22	1	CSAU105	IDEA Lab Workshop	0	LAB	1	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
23	1	CSHS201	English	3	THEORY	2	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
24	1	CSBS202	Mathematics-II	4	THEORY	2	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
25	1	CSBS203	Chemistry	3	THEORY	2	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
26	1	CSES204	Programming for Problem Solving	3	THEORY	2	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
27	1	CSHS205	Universal Human Values-II	3	THEORY	2	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
28	1	CSBL201	Chemistry Lab	2	LAB	2	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
29	1	CSEL202	Programming for Problem Solving Lab	2	LAB	2	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
30	1	CSEL203	Workshop/Manufacturing Lab	3	LAB	2	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
31	1	CSAU204	Sports and Yoga	0	LAB	2	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
32	1	CSES301	Microprocessor and Microcontroller	3	THEORY	3	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
33	1	CSPC302	Data Structures and Algorithms	3	THEORY	3	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
34	1	CSES303	Digital Electronics and Systems	3	THEORY	3	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
35	1	CSBS304	Mathematics-III	3	THEORY	3	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
36	1	CSHS305	Principles of Management	3	THEORY	3	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
37	1	CSEL301	Microprocessor and Microcontroller Lab	2	LAB	3	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
38	1	CSPL302	Data Structure and Algorithms Lab	2	LAB	3	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
39	1	CSEL303	Digital Electronics and System Lab	2	LAB	3	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
40	1	CSPL304	IT Workshop (SciLab/MATLAB)	3	LAB	3	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
41	1	CSPC401	Discrete Mathematics	4	THEORY	4	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
42	1	CSPC402	Computer Organization & Architecture	3	THEORY	4	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
43	1	CSPC403	Design & Analysis of Algorithms	3	THEORY	4	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
44	1	CSPC404	Advanced Programming in JAVA	3	THEORY	4	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
45	1	CSHS405	Organizational Behaviour	3	THEORY	4	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
46	1	CSMC406	Environmental Sciences	0	THEORY	4	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
47	1	CSPL401	Computer Organization & Architecture Lab	2	LAB	4	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
48	1	CSPL402	Design & Analysis of Algorithms Lab	2	LAB	4	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
49	1	CSPL403	JAVA Programming Lab	2	LAB	4	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
64	1	CSPL601	Web Technology Lab	2	LAB	6	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
65	1	CSPL602	Compiler Design Lab	2	LAB	6	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
66	1	CSPROJ603	Mini Project	3	PROJECT	6	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
70	1	CSOE704	Open Elective-I	3	ELECTIVE	7	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
74	1	CSPE801	Professional Elective-IV	3	ELECTIVE	8	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
75	1	CSOE802	Open Elective-II	3	ELECTIVE	8	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
78	1	CSPROJ802	Internship	1	PROJECT	8	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
59	1	CSPC601	Web Technology	3	THEORY	6	t	2026-06-28 08:42:33.2096+05:30	WT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
60	1	CSPC602	Compiler Design	3	THEORY	6	t	2026-06-28 08:42:33.2096+05:30	CD	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
61	1	CSPC603	Distributed Computing System	3	THEORY	6	t	2026-06-28 08:42:33.2096+05:30	DCS	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
62	1	CSPC604	Artificial Intelligence and Machine Learning	4	THEORY	6	t	2026-06-28 08:42:33.2096+05:30	AIML	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
63	1	CSPE605	User Interface and User Experience	3	ELECTIVE	6	t	2026-06-28 08:42:33.2096+05:30	UI UX	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
50	1	CSPC501	Computer Networks	3	THEORY	5	t	2026-06-28 08:42:33.2096+05:30	CN	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
79	6	csbl702	iOT	3	THEORY	7	t	2026-07-06 14:01:01.463965+05:30	IOT	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
80	6	cbse704	cyber	3	THEORY	7	t	2026-07-07 09:36:47.19746+05:30	CW	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
81	6	csbe705	network	3	THEORY	7	t	2026-07-07 09:37:49.741786+05:30	NW	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
69	1	CSPE402	Mobile Application Development	3	ELECTIVE	7	t	2026-06-28 08:42:33.2096+05:30	MAD							{}	\N	\N	\N	\N
58	1	CSPL503	Operating Systems Lab	2	LAB	5	t	2026-06-28 08:42:33.2096+05:30	OS LAB							{}	\N	\N	\N	\N
72	1	CSPROJ702	Seminar	1	PROJECT	7	t	2026-06-28 08:42:33.2096+05:30	SEM							{}	\N	\N	\N	\N
73	1	CSPROJ703	Capstone Project-I	6	PROJECT	7	t	2026-06-28 08:42:33.2096+05:30	CP-I							{}	\N	\N	\N	\N
15	1	CSBS101	Mathematics-I	4	THEORY	1	t	2026-06-28 08:42:33.2096+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
68	1	CSBS702	Biology	3	THEORY	7	t	2026-06-28 08:42:33.2096+05:30	BIO							{}	\N	\N	\N	\N
16	1	CSBS102	Physics	3	THEORY	1	t	2026-06-28 08:42:33.2096+05:30								{}	\N	\N	\N	\N
71	1	CSPL701	Cyber Security Lab	2	LAB	7	t	2026-06-28 08:42:33.2096+05:30	CS LAB							{}	\N	\N	\N	\N
17	1	CSES103	Basic Electronics Engineering	3	THEORY	1	t	2026-06-28 08:42:33.2096+05:30								{}	\N	\N	\N	\N
54	1	CSPE101	Software Engineering	3	ELECTIVE	5	t	2026-06-28 08:42:33.2096+05:30	SE							{}	\N	\N	\N	\N
51	1	CSPC502	Database Systems	3	THEORY	5	t	2026-06-28 08:42:33.2096+05:30	DBS							{}	\N	\N	\N	\N
52	1	CSPC503	Theory of Computation	4	THEORY	5	t	2026-06-28 08:42:33.2096+05:30	TOC							{}	\N	\N	\N	\N
53	1	CSPC504	Operating System	3	THEORY	5	t	2026-06-28 08:42:33.2096+05:30	OS							{}	\N	\N	\N	\N
55	1	CSMC505	Constitution of India	0	THEORY	5	t	2026-06-28 08:42:33.2096+05:30	COI							{}	\N	\N	\N	\N
56	1	CSPL501	Computer Networks Lab	2	LAB	5	t	2026-06-28 08:42:33.2096+05:30	CN LAB							{}	\N	\N	\N	\N
57	1	CSPL502	Database Systems Lab	2	LAB	5	t	2026-06-28 08:42:33.2096+05:30	DBS LAB							{}	\N	\N	\N	\N
67	1	CSPC701	Cyber Security	3	THEORY	7	t	2026-06-28 08:42:33.2096+05:30	CS	UNIT I (9 Hrs)\nINTRODUCTION TO CYBER SECURITY: Introduction and basic Terminology Cyber Security and CIA Triad,\nCyber Threats to CIA, Cyber-Attack surfaces, Recent Cyber- Security incidents and high-level analysis - Basic\nCryp- tography - Role of Cryptography in ensuring confidentiality for data at rest, data in motion, and data in\nprocess - Symmetric and Asymmetric Cryptography, Needs, Symmetric and Asymmetric algorithm outlines (RSA,\nDH, DES, AES) - Role of cryptography in Data Integrity, non-repudiation Hashing and Digital Signature - hash\nfunction (MD5, SHA-256), Understanding digital signature and its role, Digital Certificate and PKI - Importance of\nthe role of a proper Pseudo Random Number Generator.\nUNIT II (5 Hrs)\nAUTHENTICATION, AUTHORIZATION AND PRIVILEGE: Importance of strong Authentication –\ndistinction between authorization and authorization - importance of authorization-access control – Mandatory and\nDiscretionary Access control - role based authorization – privilege and privilege escalation.\nUNIT III (13 Hrs)\nAPPLICATION SECURITY: Application Security- Basic application vulnerabilities (Buffer overflow, Integer Overflow, format string vulnerability) – Basic mitigations of buffer overflow – platform bases – compiler based, secure\nprogramming practice - Web Client Security, Same Origin Principle – DOM, Java Script Vulnerability – Cookies\nand Cookie Attributes Secure, http only–Concept of session and session ID– Session hijacking vulnerability–http vs.\nhttps and SSL/TLS and version issue - Web Server Security – XSS, CSRF, SQL Injection, Command Injection\nconcepts.\nUNIT IV (9 Hrs)\nPERIMETER PROTECTION AND INTRUSION DETECTION: Vulnerabilities in DNS, Routing and IP protocols especially in IPv4 and suggested remedies with DNSSEC, S-BGP, and IPSec - Perimeter Protection And\nIntrusion Detection- Host Intrusion Detection techniques, To look for and how an SIEM tool can consolidate such\nindicators into a management console- Network Intrusion Detection – signature based vs. behavior based, Snort,\nIntrusion Detection System.\n85\nUNIT V (9 Hrs)\nBASIC MALWARE ANALYSIS: Firewall vs. Intrusion detection tool – Firewall rules and customization\ntechniques. Basic Malware Analysis- Various malware classes and their characteristics - Difference between static\nanalysis and dynamic analysis - Signature vs. behavioral detection techniques.						\N	\N	\N	\N	\N
76	1	CSPE601	INFORMATION SECURITY	3	ELECTIVE	8	t	2026-06-28 08:42:33.2096+05:30	IS	UNIT I (9 Hrs)\nFUNDAMENTALS: Introduction to Information Security - Critical Characteristics of Information, NSTISSC Security Model, Components of an Information System, Securing the Components , Balancing Security and Access,\nSDLC, Security SDLC\nUNIT II (9 Hrs)\nSECURITY INVESTIGATION: Need for Security - Business Needs, Threats, Attacks, Legal, Ethical and Professional Issues.\nUNIT III (9 Hrs)\nSECURITY ANALYSIS: Risk Management- Identifying and Assessing Risk, Assessing and Controlling Risk,\nTrends in Information Risk Management, Managing Risk in an Intranet Environment.\nUNIT IV (9 Hrs)\nLOGICAL DESIGN: Blueprint for Security - Information Security Policy, Standards and Practices, ISO 17799/BS\n7799, NIST Models, VISA International Security Model, Design of Security Architecture, Planning for Continuity.\nUNIT V (9 Hrs)\nPHYSICAL DESIGN: Security Technology - IDS, Scanning and Analysis Tools, Cryptography - Access Control\nDevices, Physical Security, Security and Personnel issues.	To learn principle concepts of Information security, investigation techniques, security analysis and design\nwith applications.\n	• To master information security governance, and related legal and regulatory issues.\n• To be familiar with how threats to an organization are discovered, analyzed.\n• To be familiar with network security threats and counter measures.\n• To be familiar with network security designs using available secure solutions (such as PGP, SSL, IPSec, etc).\n• To be familiar with advanced security issues and technologies (such as DDoS attack detection and\ncontainment, and anonymous communications)	1. Michael E Whitman and Herbert J Mattord, “Principles of Information Security”, Vikas Publishing House, 2022.\n	1. Matt Bishop, Elisabeth Sullivan, Michelle Ruppel, “Computer Security Art and Science”, Addison-Wesley/Pearson\nEducation, 2019.\n2. Stuart Collier, Mark;Endler, David, “Hacking Exposed”, Open University publications, 2\nnd Edition, 2013.\n3. Micki Krause, Harold F. Tipton, “Handbook of Information Security Management”, Vol 1-3 CRC Press LLC,\n2004		{"CO-1":{"PO-1":"N","PO-2":"N","PO-3":"N","PO-4":"M"}}	{"Unit-1":"K1","Unit-2":"K2","Unit-3":"K3","Unit-4":"K4","Unit-5":"K5"}	\N	\N	\N
84	9	t2	1test2	3	THEORY	1	t	2026-07-14 10:55:15.364168+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
85	9	t3	1test3	3	THEORY	1	t	2026-07-14 10:55:29.885764+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
86	9	t4	1test4	3	THEORY	1	t	2026-07-14 10:55:49.135833+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
88	9	t6	2test1	3	THEORY	2	t	2026-07-14 10:57:45.208421+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
89	9	t7	2test2	3	THEORY	2	t	2026-07-14 10:57:56.669173+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
90	9	t8	2test3	3	THEORY	2	t	2026-07-14 10:58:05.833579+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
91	9	t9	2test4	3	THEORY	2	t	2026-07-14 10:58:16.657486+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
93	9	t11	3test1	3	THEORY	3	t	2026-07-14 10:59:09.067227+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
94	9	t12	3test3	3	THEORY	3	t	2026-07-14 10:59:16.918107+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
96	9	t14	3test4	3	THEORY	3	t	2026-07-14 10:59:38.334796+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
97	9	t15	3test L5	3	LAB	3	t	2026-07-14 11:00:05.77652+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
87	9	t5	1test L5	3	LAB	1	t	2026-07-14 10:56:36.786283+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
92	9	t10	2test L5	3	LAB	2	t	2026-07-14 10:58:37.025375+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
95	9	t13	3test2	3	THEORY	3	t	2026-07-14 10:59:26.021756+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
98	9	t16	4test1	3	THEORY	4	t	2026-07-14 11:03:45.418642+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
99	9	t17	4test2	3	THEORY	4	t	2026-07-14 11:03:53.711911+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
100	9	t18	4test3	3	THEORY	4	t	2026-07-14 11:04:03.959074+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
101	9	t19	4test4	3	THEORY	4	t	2026-07-14 11:04:14.82316+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
102	9	t20	4test L5	3	LAB	4	t	2026-07-14 11:04:28.250869+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
103	9	t21	5test1	3	THEORY	5	t	2026-07-14 11:05:09.101094+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
104	9	t22	5test2	3	THEORY	5	t	2026-07-14 11:05:20.938399+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
105	9	t23	5test3	3	THEORY	5	t	2026-07-14 11:05:36.848029+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
106	9	t24	5test4	3	THEORY	5	t	2026-07-14 11:06:14.298554+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
108	9	t26	6test1	3	THEORY	6	t	2026-07-14 11:06:57.959001+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
109	9	t27	6test2	3	THEORY	6	t	2026-07-14 11:07:11.478692+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
110	9	t28	6tesr3	3	THEORY	6	t	2026-07-14 11:07:21.740286+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
111	9	t29	6test4	3	THEORY	6	t	2026-07-14 11:07:42.565609+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
112	9	t30	6test L5	3	LAB	6	t	2026-07-14 11:08:00.875932+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
107	9	t25	5test L5	3	LAB	5	t	2026-07-14 11:06:40.398213+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
113	9	t31	7test1	3	THEORY	7	t	2026-07-14 11:08:28.275282+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
114	9	t32	7test2	3	THEORY	7	t	2026-07-14 11:08:44.329863+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
116	9	t34	7test4	3	THEORY	7	t	2026-07-14 11:09:13.559372+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
117	9	test36	8test1	3	THEORY	8	t	2026-07-14 11:42:14.275319+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
118	9	t2=34	7test4	3	THEORY	7	t	2026-07-14 11:42:54.556355+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
119	9	t35	7test L5	3	THEORY	7	t	2026-07-14 11:43:19.737735+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
120	9	t36	8test1	3	THEORY	8	t	2026-07-14 11:45:06.750476+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
115	9	t33	7test3	3	LAB	7	t	2026-07-14 11:08:56.719066+05:30		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
83	9	t1	1test1	3	THEORY	1	t	2026-07-14 10:54:52.560592+05:30		UNIT I (9 Hrs)\nINTRODUCTION: History - Features - Working with Python - Installing Python - basic syntax - Data types -\nvariables - Manipulating Numbers - Text Manipulations - Python Build in Functions.\n\nUNIT II (9 Hrs)\nCOMPONENTS OF PYTHON PROGRAMMING: Python objects and other languages - operator Basics - Numbers - String - List - Tuples - Dictionaries - Files - Object Storage - Type Conversion - Type Comparison -Statements- Assignments - Control Statements.\n\nUNIT III (9 Hrs)\nFUNCTIONS AND MODULES: Functions Definition and Execution - Arguments - Return Values - Advanced\nFunction Calling - Modules - Importing modules - Packages - Creating a module.\n\nUNIT IV (9 Hrs)\nOBJECT ORIENTED AND EXCEPTION HANDLING: Classes and Objects - creating a class - class methods -\nclass inheritance. Exceptions Handling-Build in Exceptions- Files, File operations, reading a file content, writing a\nfile, change position, controlling file I/O, Manipulating file paths.\n\nUNIT V (9 Hrs)\nAPPLICATIONS: Working with PDF and Word Documents - Working with CSV Files and JSON Data - Sending\nEmail and Text Messages - Manipulating Images - Using Python for Multimedia.	• To acquire the knowledge of programming in Python. To learn the concepts, principles, functions and\ndevelop an application.\n 	• To understand the basic concepts and working principles of Python Programming.\n• To develop algorithmic solutions to simple computational problems.\n• To understand the structure of solving problems using programming.\n• To explore the concepts of compound data using Python lists, tuples, dictionaries.\n• To explore the various multimedia features using python.	1. Allen B.Downey, “Think Python: How to Think Like a Computer Scientist”, Shroff O Reilly Publishers, 2\nnd\nEdition, 2016.\n2. Guido Van Rossum and Fred L. Drake Jr, “An Introduction to Python”, Network Theory Ltd., 2011.\n3. Martin C.Brown, “The Complete reference - Python”, Tata McGraw Hill Indian Edition, 2010.	1. Eric Matthes, “A Hands-On, Project-Based Introduction To Programming”, 2\nnd Edition, 2019.\n2. Budd T A, “Exploring Python”, Tata McGraw Hill Education, 2011.\n3. Robert Sedgewick, Kevin Wayne, Robert Dondero, “Introduction to Programming in Python: An Inter-disciplinary\nApproach”, Pearson India Education Services Pvt. Ltd., 2016.\n		{"CO-4":{"PO-4":"M","PO-2":"M"},"CO-2":{"PO-1":"M"},"CO-1":{"PO-2":"M"},"CO-7":{"PO-2":"M"},"CO-3":{"PO-3":"M"},"CO-6":{"PO-3":"M"},"CO-5":{"PO-2":"M"}}	{"Unit-1":["K1","K2"],"Unit-2":["K3","K4","K6"],"Unit-3":["K2","K3"],"Unit-4":["K2","K3"],"Unit-5":["K3"]}	\N	\N	\N
121	9	OL123	open elective 	3	OPEN_ELECTIVE	7	t	2026-07-16 13:59:23.339864+05:30	OL	hdthdth	dhdth	hdthtdhhdth	hdthdth	hdhdthdthdth		{}	\N	\N	\N	\N
126	9	CSPROJ801	CAPSTONE Project II	3	PROJECT	1	t	2026-07-22 10:14:41.022908+05:30	PROJECT 		• To gain domain knowledge, technical skills to solve potential business/research problems.To publish work in\nindexed journal/patent and prepare reports and presentation.	• To gain domain knowledge and technical skill set required for solving industry / research problems.\n• To provide solution architecture, module level designs, algorithms.\n• To implement, test and deploy the solution for the target platform.\n• To prepare detailed technical report, demonstrate and present the work.\n• To publish work in reputed indexing journal or patent			• Mini project\n• CapStone Project I	{}	\N	The students shall individually / or as group work( 3 to 4 members) on business/research domains and related\nproblems approved by the Department / organization that offered the project.\nThe student can select any topic which is relevant to his/her specialization of the programme. The student should\ncontinue the work on the selected topic as per the formulated methodology.\nAt the end of the semester, after completing the work to the satisfaction of the supervisor and review committee,\na detailed report which contains clear definition of the identified problem, detailed literature review related to the\narea of work and methodology for carrying out the work, results and discussion, conclusion and references should be\nprepared as per the format prescribed by the University and submitted to the Head of the department. The students\nwill be evaluated based on the report and viva-voce examination by a panel of examiners as per the Regulations.	[{"id":"team_1784787683305_vo06","type":"team","register_no":"23tdo234\\n23td0676\\n23td0888\\n23td0782","members":"asif\\naaqil\\nmohammed\\ndeepak","project_name":"ML in farming ","members_list":[{"register_no":"23tdo234","name":"asif"},{"register_no":"23td0676","name":"aaqil"},{"register_no":"23td0888","name":"mohammed"},{"register_no":"23td0782","name":"deepak"}]},{"id":"team_1784789790491_3mjj","type":"team","members_list":[{"register_no":"asdfasdf","name":"asdfasdf"},{"register_no":"asdfasdf","name":"asdfasdf"}],"register_no":"asdfasdf\\nasdfasdf","members":"asdfasdf\\nasdfasdf","project_name":"adfasdfasdf"}]	\N
125	9	asdfasdfsdf	SEMINAR	3	SEMINAR	1	t	2026-07-22 10:08:50.393304+05:30	SEMINAR							{}	\N		\N	[{"id":"topic_1784788539873_tkm7","type":"topic","register_no":"23td0685","student_names":"Vijay Antony","seminar_topic":"Cloud Computing in Music"}]
\.


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (id, name, code, hod_id, vision, mission, is_active, created_at, updated_at, current_sem_start_date, attendance_closed, peos, psos, is_common_first_year) FROM stdin;
9	test	TEST	61	To achieve academic excellence in the field of computer science and engineering \nby imparting meticulous knowledge to the students, facilitating research and \nentrepreneurship, to the ever-changing industrial demands and social needs \nthrough skill enhancement.	M1: To Enhance analytical knowledge by fostering innovation and problem\nsolving skills. \nM2:  To Promote interdisciplinary research and entrepreneurship for solving Real\nworld problems. \nM3:  To Impart students with the ability to tackle evolving industrial challenges. \nM4: To Inculcate moral and ethical values to serve society.	t	2026-07-14 10:14:47.03725+05:30	2026-07-15 13:38:15.257596+05:30	\N	f	PEO1: Appropriate employment in related industries and services, showcasing \nprofessional competence and expertise in modern tools. \n \nPEO2: The ability to pursue advanced studies and research in engineering and \nmanagement fields. \n \nPEO3: Prosperous career, meeting the rising demands of the Computer Science \nand Engineering profession, and empowering them for entrepreneurial ventures. \n \nPEO4: Our graduates nurture professional ethics, effective communication, \nteamwork, and a multidisciplinary approach to tackle engineering challenges. 	PSO1 Capability to utilize fundamental mathematical principles in computer science and engineering to deliver\noptimal solutions.\n\nPSO2 Designing, testing, and evaluating software to meet end users' requirements and offering innovative\ntechnologies for creating cost-effective solutions.	f
3	Mechanical Engineering	MECH	\N	\N	\N	t	2026-06-27 07:56:10.278526+05:30	2026-07-03 13:59:04.333485+05:30	\N	f	\N	\N	f
4	Biomedical Engineering	BME	\N		\N	t	2026-06-28 08:05:31.543616+05:30	2026-07-03 13:59:06.390267+05:30	\N	f	\N	\N	f
5	Electrical and Electronics Engineering	EEE	35		\N	t	2026-06-28 08:05:49.400562+05:30	2026-07-08 10:21:20.600723+05:30	\N	f	\N	\N	f
6	IOT CYBER SECURITY AND BLOCKCHAIN TECHNOLOGY	IOT-CSBT	\N		\N	t	2026-06-30 10:59:18.490151+05:30	2026-07-08 10:21:54.20234+05:30	\N	t	\N	\N	f
7	ARTIFICIAL INTELLIGENCE AND DATA SCIENCE	AI&DS	40		\N	t	2026-06-30 11:01:01.578924+05:30	2026-07-08 10:56:04.942835+05:30	\N	f	\N	\N	f
2	Electronics and Communication Engineering	ECE	41		\N	t	2026-06-27 07:53:47.316533+05:30	2026-07-08 11:02:58.879396+05:30	\N	f	\N	\N	f
10	Science and Humanities	S&H	\N			t	2026-07-17 11:08:39.809875+05:30	\N	\N	f			t
1	Computer Science and Engineering	CSE	71	To achieve academic excellence in the field of computer science and engineering \nby imparting meticulous knowledge to the students, facilitating research and \nentrepreneurship, to the ever-changing industrial demands and social needs \nthrough skill enhancement.	M1: To Enhance analytical knowledge by fostering innovation and problem\nsolving skills. \nM2:  To Promote interdisciplinary research and entrepreneurship for solving Real\nworld problems. \nM3:  To Impart students with the ability to tackle evolving industrial challenges. \nM4: To Inculcate moral and ethical values to serve society.	t	2026-06-27 07:49:51.945224+05:30	2026-07-18 15:38:54.27376+05:30	2026-07-02 05:30:00+05:30	f	PEO1: Appropriate employment in related industries and services, showcasing \nprofessional competence and expertise in modern tools. \n \nPEO2: The ability to pursue advanced studies and research in engineering and \nmanagement fields. \n \nPEO3: Prosperous career, meeting the rising demands of the Computer Science \nand Engineering profession, and empowering them for entrepreneurial ventures. \n \nPEO4: Our graduates nurture professional ethics, effective communication, \nteamwork, and a multidisciplinary approach to tackle engineering challenges. 	PEO1: Appropriate employment in related industries and services, showcasing \nprofessional competence and expertise in modern tools. \n \nPEO2: The ability to pursue advanced studies and research in engineering and \nmanagement fields. \n \nPEO3: Prosperous career, meeting the rising demands of the Computer Science \nand Engineering profession, and empowering them for entrepreneurial ventures. \n \nPEO4: Our graduates nurture professional ethics, effective communication, \nteamwork, and a multidisciplinary approach to tackle engineering challenges. 	f
\.


--
-- Data for Name: discipline_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.discipline_records (id, student_id, reported_by_id, incident_type, incident_date, remarks, action_status, action_taken, is_locked, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: enrollments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.enrollments (id, student_id, course_id, academic_year, semester, enrolled_at, section_id) FROM stdin;
1	1277	121	2023-2024	7	2026-07-16 15:11:18.510511+05:30	48
2	1294	121	2023-2024	7	2026-07-16 15:11:22.744346+05:30	48
3	1276	121	2023-2024	7	2026-07-16 16:29:57.349842+05:30	48
4	1342	121	2023-2024	7	2026-07-18 16:04:32.635115+05:30	48
5	1347	121	2023-2024	7	2026-07-18 16:05:09.586488+05:30	48
6	1354	121	2023-2024	7	2026-07-18 16:05:12.464976+05:30	48
7	1298	121	2023-2024	7	2026-07-18 16:05:17.441138+05:30	48
8	1311	121	2023-2024	7	2026-07-18 16:05:19.257643+05:30	48
9	1360	121	2023-2024	7	2026-07-18 16:05:31.609512+05:30	48
10	1349	121	2023-2024	7	2026-07-18 16:05:32.712922+05:30	48
11	1356	121	2023-2024	7	2026-07-18 16:05:33.816979+05:30	48
12	1358	121	2023-2024	7	2026-07-18 16:05:35.063723+05:30	48
\.


--
-- Data for Name: faculty; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty (id, user_id, department_id, first_name, last_name, gender, date_of_birth, blood_group, nationality, community, photo_url, college_email, personal_email, phone, alternate_phone, address_line1, address_line2, city, state, pincode, employee_id, designation, qualification, specialization, experience_years, date_of_joining, is_active, created_at, updated_at, religion, aadhar_number, pan_card, accommodation, transportation, father_name, mother_name, family_persons, bus_number, emergency_contacts, academic_history, employment_type, past_experience) FROM stdin;
33	1216	6	aswin	T	\N	\N	\N	Indian	\N	\N	aswin@gmail.com	\N	6374102586	\N	\N	\N	\N	\N	\N	254130	Assistant Professor	\N	cyber security, Network	\N	\N	t	2026-07-07 09:24:14.367145+05:30	2026-07-07 09:38:22.569438+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
34	1217	6	hemachandran	G	\N	\N	\N	Indian	\N	\N	hema@gmail.com	\N	142369745	\N	\N	\N	\N	\N	\N	4125306	Assistant Professor	\N	networking design, network	\N	\N	t	2026-07-07 09:25:30.108804+05:30	2026-07-07 09:38:44.449518+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
35	1309	5	Dr.Venkedesh	Ramalingam	\N	\N	\N	Indian	\N	\N	hod.eee@svcet.ac.in	\N	9443797768	\N	\N	\N	\N	\N	\N	5147035	HOD	\N	Power Electronics & Drivers	\N	\N	t	2026-07-08 10:21:20.600723+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
36	1310	5	Mr.Sandou Louis Kishor	Sandou Chirstino Marie Alphonse Ganana	\N	\N	\N	Indian	\N	\N	sandoulouiskishor@svcet.ac.in	\N	9952417992	\N	\N	\N	\N	\N	\N	5147036	Assistant Professor	\N	Electrical Drivers & Control	\N	\N	t	2026-07-08 10:28:09.414641+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
37	1311	5	Mr. Murali	Murugan	\N	\N	\N	Indian	\N	\N	murali.eee@svcet.ac.in	\N	8015526869	\N	\N	\N	\N	\N	\N	5147037	Assistant Professor	\N	Electrical Drivers & Control	\N	\N	t	2026-07-08 10:30:45.726466+05:30	2026-07-08 10:32:02.390813+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
38	1312	5	Mr.Selvakumar	Lakshmanan	\N	\N	\N	Indian	\N	\N	seelva.ar@svcet.ac.in	\N	9944610013	\N	\N	\N	\N	\N	\N	5147038	Assistant Professor	\N	Electrical Drivers & Control	\N	\N	t	2026-07-08 10:35:40.890376+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
39	1313	5	Mrs.Punitha	Sekar	\N	\N	\N	Indian	\N	\N	punitha@svcet.ac.in	\N	9943818011	\N	\N	\N	\N	\N	\N	5147039	Assistant Professor	\N	Electrical Drivers & Control	\N	\N	t	2026-07-08 10:37:20.302448+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
42	1316	2	Dr.Amudhavalli	G	\N	\N	\N	Indian	\N	\N	amudhavalli@svcet.ac.in	\N	9843222603	\N	\N	\N	\N	\N	\N	5147027	Professor	\N	ECE: Low Power VLSI	\N	\N	t	2026-07-08 10:44:31.369362+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
43	1317	2	Mrs. Sujatha	Kaliyan	\N	\N	\N	Indian	\N	\N	sujathaupt@svcet.ac.in	\N	7826031308	\N	\N	\N	\N	\N	\N	5147028	Assistant Professor	\N	ECE	\N	\N	t	2026-07-08 10:45:29.942778+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
44	1318	2	Mr.Devanathan	Devaraj	\N	\N	\N	Indian	\N	\N	devanathanece@svcet.ac.in	\N	9786310137	\N	\N	\N	\N	\N	\N	5147030	Assistant Professor	\N	ECE: Embedded System	\N	\N	t	2026-07-08 10:46:23.539091+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
45	1319	2	Mrs. Mayavady	Krishnaraj	\N	\N	\N	Indian	\N	\N	mayavadyece@svcet.ac.in	\N	9597480282	\N	\N	\N	\N	\N	\N	5147029	Assistant Professor	\N	ECE	\N	\N	t	2026-07-08 10:47:11.677914+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
47	1321	2	Mr. Rajasekar	Ramasamy	\N	\N	\N	Indian	\N	\N	sekarrajan@svcet.ac.in	\N	7092660305	\N	\N	\N	\N	\N	\N	5147032	Assistant Professor	\N	ECE	\N	\N	t	2026-07-08 10:48:38.643538+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
48	1322	2	Mrs. Neeraja	Thasarathan	\N	\N	\N	Indian	\N	\N	neeraja@svcet.ac.in	\N	9976147420	\N	\N	\N	\N	\N	\N	5147033	Assistant Professor	\N	ECE: Applied Electronics	\N	\N	t	2026-07-08 10:51:47.055905+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
49	1323	2	Mrs. Deepa	Veerappan	\N	\N	\N	Indian	\N	\N	deepaece@svcet.ac.in	\N	7448448835	\N	\N	\N	\N	\N	\N	5147034	Assistant Professor	\N	ECE	\N	\N	t	2026-07-08 10:52:33.759063+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
50	1324	2	Mrs. Dhanalakshmi	Durai	\N	\N	\N	Indian	\N	\N	dhanalakshmi@svcet.ac.in	\N	9677774254	\N	\N	\N	\N	\N	\N	5147010	Assistant Professor	\N	ECE:Communication System	\N	\N	t	2026-07-08 10:53:38.629935+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
40	1314	5	Mr.Bharathan	Radhamanavalan	\N	\N	\N	Indian	\N	\N	r.bharathan@svcet.ac.in	\N	9629947325	\N	\N	\N	\N	\N	\N	5147040	Assistant Professor	\N	Power Electronics & Drivers	\N	\N	t	2026-07-08 10:38:30.669+05:30	2026-07-08 11:01:14.891845+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
41	1315	2	Dr.Nagaraj	Vaithilingam	\N	\N	\N	Indian	\N	\N	hod.ece@svcet.ac.in	\N	9894188982	\N	\N	\N	\N	\N	\N	5147026	HOD	\N	ECE: Wireless Communication	\N	\N	t	2026-07-08 10:43:34.691849+05:30	2026-07-08 11:02:58.879396+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
46	1320	2	Mr. Kishor	Krishnamoorthy	Male	1985-01-01	\N	Indian	General	\N	kishor25@svcet.ac.in	\N	8903862357	\N	\N	\N	\N	\N	\N	5147031	Assistant Professor	\N	ECE:VLSI and Embedded system	\N	\N	t	2026-07-08 10:47:50.46653+05:30	2026-07-10 14:21:40.613628+05:30	Hindu	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
69	1346	9	Test	Faculty9	\N	\N	\N	Indian	\N	\N	testfaculty9@college.edu	\N	9876500009	\N	\N	\N	\N	\N	\N	EMP1009	Assistant Professor	\N		\N	\N	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:47.479823+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
61	1338	9	Test	Faculty1	\N	\N	\N	Indian	\N	\N	hod.test@college.edu	\N	9876500001	\N	\N	\N	\N	\N	\N	EMP1001	HOD	\N		\N	\N	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:35.368513+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
70	1347	9	Test	Faculty10	\N	\N	\N	Indian	\N	\N	testfaculty10@college.edu	\N	9876500010	\N	\N	\N	\N	\N	\N	EMP1010	Assistant Professor	\N		\N	\N	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:42.705528+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
68	1345	9	Test	Faculty8	\N	\N	\N	Indian	\N	\N	testfaculty8@college.edu	\N	9876500008	\N	\N	\N	\N	\N	\N	EMP1008	Assistant Professor	\N		\N	\N	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:49.145512+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
66	1343	9	Test	Faculty6	\N	\N	\N	Indian	\N	\N	testfaculty6@college.edu	\N	9876500006	\N	\N	\N	\N	\N	\N	EMP1006	Assistant Professor	\N		\N	\N	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:52.453449+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
65	1342	9	Test	Faculty5	\N	\N	\N	Indian	\N	\N	testfaculty5@college.edu	\N	9876500005	\N	\N	\N	\N	\N	\N	EMP1005	Assistant Professor	\N		\N	\N	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:54.833863+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
64	1341	9	Test	Faculty4	\N	\N	\N	Indian	\N	\N	testfaculty4@college.edu	\N	9876500004	\N	\N	\N	\N	\N	\N	EMP1004	Assistant Professor	\N		\N	\N	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:57.453639+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
63	1340	9	Test	Faculty3	\N	\N	\N	Indian	\N	\N	testfaculty3@college.edu	\N	9876500003	\N	\N	\N	\N	\N	\N	EMP1003	Assistant Professor	\N		\N	\N	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:59.241923+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
78	1439	7	Ms. Pavithra	Selvacoumare	\N	\N	\N	Indian	\N	\N	pavithraapcse@svcet.ac.in	\N	8838353686	\N	\N	\N	\N	\N	\N	5147016	Assistant Professor	\N	Data Science	\N	\N	t	2026-07-14 11:48:02.645612+05:30	2026-07-22 14:03:48.324097+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
72	1433	1	Dr. Andal	Kanniapan	\N	\N	\N	Indian	\N	\N	andalcse@svcet.ac.in	\N	8220777991	\N	\N	\N	\N	\N	\N	5147014	Assistant Professor	\N	Deep Learning	\N	\N	t	2026-07-14 11:48:02.645612+05:30	2026-07-14 11:53:11.142672+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
74	1435	1	Mr. Loganathan	Ramanujam	\N	\N	\N	Indian	\N	\N	cseloganathan@svcet.ac.in	\N	9677354846	\N	\N	\N	\N	\N	\N	5147020	Assistant Professor	\N	Distributed Computing System	\N	\N	t	2026-07-14 11:48:02.645612+05:30	2026-07-14 11:58:52.937507+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
76	1437	1	Ms. Sivasankari	Venkatachalam	\N	\N	\N	Indian	\N	\N	sivasankari@svcet.ac.in	\N	9791985350	\N	\N	\N	\N	\N	\N	5147019	Assistant Professor	\N	Networking	\N	\N	t	2026-07-14 11:48:02.645612+05:30	2026-07-14 11:59:12.329472+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
75	1436	1	Mr. Danasegaran	Ramalingam	\N	\N	\N	Indian	\N	\N	dhanasegaran21td0605@svcet.ac.in	\N	9715963522	\N	\N	\N	\N	\N	\N	5147015	Assistant Professor	\N	CSE	\N	\N	t	2026-07-14 11:48:02.645612+05:30	2026-07-14 12:01:19.55288+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
77	1438	1	Mrs. Anbu	Mounissamy	\N	\N	\N	Indian	\N	\N	cseanbus@svcet.ac.in	\N	8248421355	\N	\N	\N	\N	\N	\N	5147021	Assistant Professor	\N	CSE	\N	\N	t	2026-07-14 11:48:02.645612+05:30	2026-07-14 12:01:34.592595+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
79	1440	1	Mrs. Saranya	Vadivelu	\N	\N	\N	Indian	\N	\N	saranya28@svcet.ac.in	\N	6374600665	\N	\N	\N	\N	\N	\N	5147018	Assistant Professor	\N	CSE	\N	\N	t	2026-07-14 11:48:02.645612+05:30	2026-07-14 12:01:48.651943+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
67	1344	9	Test	Faculty7	Male	1996-12-03	A-	Indian	OBC	\N	testfaculty7@college.edu	\N	9876500007	\N	No.12,Ponniamman Kovil Street ,	Staff Quaters	Puducherry	Puducherry	605008	EMP1007	Assistant Professor	D.C.T., B.Tech., M.E., Ph.D	Distributed Computing System	3	2025-12-25	t	2026-07-14 10:48:57.430295+05:30	2026-07-22 14:07:19.508771+05:30	Hindu	711752629672	BEZPB9720E	Hostel	OWN	Rajan.T	Balathanga Valli	\N	\N	[{"name": "VISHWA BR", "relation": "brother", "number": "9344793687"}]	{"tenth": {"school": "hdgcdhkgsc", "board": "cbse", "percentage": "75"}, "twelfth": {"school": "kasjgvdjk", "board": "cbse", "percentage": "55"}, "ug": {"degree": "B.tech", "university": "jgvduhbwd", "percentage": "4.5"}, "pg": [{"degree": "fDFDSFSDF", "university": "SDFdfsdf", "percentage": "5.5"}, {"degree": "dsafsdf", "university": "fsdfsdaf", "percentage": "6.5"}], "phd": {"university": "", "specialization": "", "year": ""}}	\N	[{"institution": "aditya", "from_date": "2022-12-22", "to_date": "2024-12-03"}]
62	1339	9	Test	Faculty2	Other	1987-06-07	B+	pakistan 	mbc	\N	testfaculty2@college.edu	\N	9876500002	\N	Jeiram Chettiyar Thottam Second Cross	Puducherry	Puducherry	Puducherry	605001	EMP1002	Assistant Professor	m.tech 	CSE: Distributed Computing System.	24	2025-05-07	t	2026-07-14 10:48:57.430295+05:30	2026-07-15 13:39:04.702974+05:30	hindu 	784514291393	hhppr4029k	Hostel	OWN	EG4G	ewgQ3HG	\N	\N	[{"name": "Ragul A", "relation": "thambii", "number": "1234567890"}]	{"tenth": {"school": "amalian ", "board": "state ", "percentage": "100"}, "twelfth": {"school": "amalian ", "board": "state ", "percentage": "100"}, "ug": {"degree": "b.tech ", "university": "goindhama engineering kaleej ", "percentage": "10"}, "pg": {"degree": "m.tech ", "university": "irulandi institue of technology ", "percentage": "10"}, "phd": {"university": "", "specialization": "", "year": ""}}	\N	[{"institution": "goindhama eng kaleej ", "from_year": "2000", "to_year": "2024"}]
90	1860	3	Dr. Magimairaj	Balasundram	\N	\N	\N	Indian	\N	\N	magimairaj@svcet.ac.in	\N	9677835595	\N	\N	\N	\N	\N	\N	5147041		\N	\N	\N	\N	t	2026-07-22 13:48:43.079821+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
91	1861	3	Dr.Ravindran	Sekar	\N	\N	\N	Indian	\N	\N	ravi.indranmech@svcet.ac.in	\N	9790672303	\N	\N	\N	\N	\N	\N	5147042		\N	\N	\N	\N	t	2026-07-22 13:48:43.079821+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
92	1862	3	Mr.Karthikeyan	Vedhagiri	\N	\N	\N	Indian	\N	\N	karthikeyan.v@svcet.ac.in	\N	9790578103	\N	\N	\N	\N	\N	\N	5147044		\N	\N	\N	\N	t	2026-07-22 13:48:43.079821+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
93	1863	3	Mr.Kamalanathan	Ranganathan	\N	\N	\N	Indian	\N	\N	r.kamal.nathan@svcet.ac.in	\N	9500614186	\N	\N	\N	\N	\N	\N	5147045		\N	\N	\N	\N	t	2026-07-22 13:48:43.079821+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
94	1864	3	Mr.Palanivel	Ganesan	\N	\N	\N	Indian	\N	\N	palanivel.g14@svcet.ac.in	\N	9698803994	\N	\N	\N	\N	\N	\N	5147046		\N	\N	\N	\N	t	2026-07-22 13:48:43.079821+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
95	1865	3	Ms. Manikandan	Chellan	\N	\N	\N	Indian	\N	\N	manikandan.ap@svcet.ac.in	\N	9499058690	\N	\N	\N	\N	\N	\N	5147047		\N	\N	\N	\N	t	2026-07-22 13:48:43.079821+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
71	1432	1	Dr. Balaji	Natarajan	Male	1983-01-14	AB+	Indian	MBC	\N	hod.cse@svcet.ac.in	\N	9944199803	\N	No.3	Staff Quarters	Puducherry	Puducherry	605102	5147013	HOD	Ph.D	CSE	18	2016-07-08	t	2026-07-14 11:48:02.645612+05:30	2026-07-22 13:50:06.084435+05:30	Hindu	265661123704	BEZPB9720E	Day Scholar	OWN	T.NATARAJAN	N.DEVAKI	\N	\N	[{"name": "G.REVATHY", "relation": "Wife", "number": "9789442902"}, {"name": "N.Kalaiselvi", "relation": "Sister", "number": "8870261524"}]	{"tenth": {"school": "Govt. Hr. Sec. School, Naickenpettai, Kanchipuram", "board": "State Board", "percentage": "53"}, "twelfth": {"school": "Govt. Hr. Sec. School, Naickenpettai, Kanchipuram", "board": "State Board", "percentage": "62"}, "ug": {"degree": "B.Tech - I.T", "university": "Thiruvalluvar College of Engineering and Technology, Vandavsi. (Anna University)", "percentage": "71"}, "pg": [{"degree": "M.Tech - CSE", "university": "Thiruvalluvar College of Engineering and Technology, Vandavsi. (Anna University)", "percentage": "75"}], "phd": {"university": "Pondicherry Unviersity (Central University)", "specialization": "CSE", "year": "2017"}}	\N	[{"institution": "Audco India Ltd, Enathur, Kanchipuram", "from_date": "2003-06-03", "to_date": "2004-05-31"}, {"institution": "Thiruvalluvar College of Engineering and Technology, Vandavsi. (Anna University) - Assistant Professor / I.T", "from_date": "2009-07-15", "to_date": "2011-10-31"}, {"institution": "Pondicherry University - Research Experience as Fulltime Research Scholar,", "from_date": "2011-11-01", "to_date": "2014-08-14"}, {"institution": "Jai Krishna Polytechnic College - Teaching and Admin Experience as Vice - Principal", "from_date": "2014-08-18", "to_date": "2016-06-30"}]
96	1866	4	Mr. BALAJI	Subramanian	\N	\N	\N	Indian	\N	\N	hod.bme@svcet.ac.in	\N	9791632819	\N	\N	\N	\N	\N	\N	5147004		\N	\N	\N	\N	t	2026-07-22 13:54:30.658745+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
97	1867	4	Dr.  VENGADEASN	Alagapuri	\N	\N	\N	Indian	\N	\N	venkedesh@svcet.ac.in	\N	9865649482	\N	\N	\N	\N	\N	\N	5147007		\N	\N	\N	\N	t	2026-07-22 13:54:30.658745+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
98	1868	4	Mrs. RAJALAKSHMI,	Arumugam	\N	\N	\N	Indian	\N	\N	rajaianushbme@svcet.ac.in	\N	8525880219	\N	\N	\N	\N	\N	\N	5147003		\N	\N	\N	\N	t	2026-07-22 13:54:30.658745+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
99	1869	4	Mrs. SOWMIYA,	Muthukrishnan	\N	\N	\N	Indian	\N	\N	sowmiya@svcet.ac.in	\N	7550360985	\N	\N	\N	\N	\N	\N	5147005		\N	\N	\N	\N	t	2026-07-22 13:54:30.658745+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
100	1870	4	Mrs. KAVINILAVU	Athigaman	\N	\N	\N	Indian	\N	\N	kavinilavu06@svcet.ac.in	\N	7402290008	\N	\N	\N	\N	\N	\N	5147006		\N	\N	\N	\N	t	2026-07-22 13:54:30.658745+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
101	1871	4	Ms. KAVIYA	Kandhasamy	\N	\N	\N	Indian	\N	\N	kaviya01@svcet.ac.in	\N	6381438880	\N	\N	\N	\N	\N	\N	5147009		\N	\N	\N	\N	t	2026-07-22 13:54:30.658745+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
102	1872	4	Mr.KIRUBANANTHARAJ	SANTHARAMAN	\N	\N	\N	Indian	\N	\N	kirubabme@svcet.ac.in	\N	8667300493	\N	\N	\N	\N	\N	\N	5147011		\N	\N	\N	\N	t	2026-07-22 13:54:30.658745+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
103	1873	10	Mr. Ganesan	Varadhan	\N	\N	\N	Indian	\N	\N	ganesan@svcet.ac.in	\N	9994502202	\N	\N	\N	\N	\N	\N	5147058		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
104	1874	10	Mrs. Sathiya	Vengadesan	\N	\N	\N	Indian	\N	\N	sathyavenkatesan@svcet.ac.in	\N	7904239415	\N	\N	\N	\N	\N	\N	5147062		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
105	1875	10	Mrs. Kavitha	Annamalai	\N	\N	\N	Indian	\N	\N	kavitha@svcet.ac.in	\N	8778638072	\N	\N	\N	\N	\N	\N	5147060		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
106	1876	10	Dr. John sundar	Chinnappan	\N	\N	\N	Indian	\N	\N	jsundarc@svcet.ac.in	\N	9488369578	\N	\N	\N	\N	\N	\N	5147059		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
107	1877	10	Dr. Arulmozhi	Narayanasamy	\N	\N	\N	Indian	\N	\N	arulmozhisathya@gmail.com	\N	6385911182	\N	\N	\N	\N	\N	\N	5147061		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
108	1878	10	Dr. Thirumarran	Meganathan	\N	\N	\N	Indian	\N	\N	thirumarran2022@svcet.ac.in	\N	9345776321	\N	\N	\N	\N	\N	\N	5147067		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
109	1879	10	Dr. Mythili	Narayanan	\N	\N	\N	Indian	\N	\N	mythuwinmile@svcet.ac.in	\N	9791706831	\N	\N	\N	\N	\N	\N	5147068		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
110	1880	10	Dr. Shiamala	Logalatchagan	\N	\N	\N	Indian	\N	\N	shiamalaphysics@svcet.ac.in	\N	9488927813	\N	\N	\N	\N	\N	\N	5147069		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
111	1881	10	Mrs. Gandhimathi	Perumal	\N	\N	\N	Indian	\N	\N	gandhivikash@svcet.ac.in	\N	9787981900	\N	\N	\N	\N	\N	\N	5147065		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
112	1882	10	Mrs. Ilamathi . M	Murugaiyan	\N	\N	\N	Indian	\N	\N	ilamathi@svcet.ac.in	\N	9585976522	\N	\N	\N	\N	\N	\N	5147066		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
113	1883	10	Dr. Lakshmipriya	Kannabiran	\N	\N	\N	Indian	\N	\N	lakshmipriya@svcet.ac.in	\N	9940423289	\N	\N	\N	\N	\N	\N	5147063		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
114	1884	10	Dr.Neeladevi	Kuppuswamy	\N	\N	\N	Indian	\N	\N	neeladevi@svcet.ac.in	\N	9790773383	\N	\N	\N	\N	\N	\N	5147064		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
115	1885	10	Mrs. Anbukarasi	Vasudevan	\N	\N	\N	Indian	\N	\N	gugansharika@svcet.ac.in	\N	9786457277	\N	\N	\N	\N	\N	\N	5147012		\N	\N	\N	\N	t	2026-07-22 14:14:01.926516+05:30	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
73	1434	1	Mr. Duraimurugan	Jayabalan	Male	1987-09-27	A-	Indian	MBC	\N	dmurugan27@svcet.ac.in	\N	9843192002	\N	233 A North Street 	Kuyilappalayam 	Auroville 	Tamilnadu 	605101	5147023	Senior Assistant Professor	M.E,(Ph.D)	CSE	15	2026-01-02	t	2026-07-14 11:48:02.645612+05:30	2026-07-23 10:57:14.644714+05:30	Indian 	669126855121	AZJPJ0906A	Day Scholar	OWN	JAYABALAN 	MANGAVARAM 	\N	\N	[{"name": "Banumathy ", "relation": "Wife ", "number": "8056655702"}]	{"tenth": {"school": "KHSS", "board": "State Board ", "percentage": "94"}, "twelfth": {"school": "KHSS", "board": "State Board ", "percentage": "91"}, "ug": {"degree": "B.E", "university": "Anna University ", "percentage": "77"}, "pg": [{"degree": "M.E", "university": "Anna University ", "percentage": "8.01"}], "phd": {"university": "Anna University ", "specialization": "CSE", "year": ""}}	\N	[{"institution": "Christ Institute of Technology ", "from_date": "2011-06-13", "to_date": "2020-03-10"}, {"institution": "Anna University,CEG CAMPUS ", "from_date": "2020-03-13", "to_date": "2024-08-29"}, {"institution": "University College of engineering,Tindivanam", "from_date": "2024-08-30", "to_date": "2025-12-31"}]
80	1441	1	Mrs. Sathiya	Lakshmanan	Female	1988-12-22	B+	Indian	OBC	\N	sathiya@svcet.ac.in	\N	8870365261	\N	175/2,Mariyamman koil street, Arasur	Eswaran koil street, Navalmalkapeer	Puducherry	Tamilnadu	607107	5147017	Assistant Professor	M.E	Computer and Communication	5	2023-09-13	t	2026-07-14 11:48:02.645612+05:30	2026-07-23 11:01:14.233782+05:30	HINDU	756854823334	FNCPS4519G	Day Scholar	OWN	Lakshmanan	Malar	\N	\N	[{"name": "Iyyappan", "relation": "Husband", "number": "9578127339"}]	{"tenth": {"school": "Johndewey Metric Higher Secondary School", "board": "State Board", "percentage": "75"}, "twelfth": {"school": "Johndewey Metric Higher Secondary School", "board": "State Board", "percentage": "73"}, "ug": {"degree": "B.Tech(Informatinon Technology )", "university": "Annai Teresa College of Engineering and Technology", "percentage": "75"}, "pg": [{"degree": "M.E(Computer and Communication)", "university": "Dr.Paul's Engineering College ", "percentage": "75"}], "phd": {"university": "", "specialization": "", "year": ""}}	\N	[{"institution": "Annai Teresa College of Engineering and Technology", "from_date": "2012-06-12", "to_date": "2014-11-27"}]
81	1442	1	Ms. Priyanga	Hiranian	Female	1991-09-19	B+	Indian	INDIAN	\N	csepriya19@svcet.ac.in	\N	8870914163	\N	NO 21,Veterinary Hospital street,	karuvadikuppam	Pondicherry	Pondicherry	605008	5147022	Assistant Professor	M.Tech(CS)	CSE	5	2026-01-02	t	2026-07-14 11:48:02.645612+05:30	2026-07-23 11:04:27.512826+05:30	HINDU	782677149258	FHWPP1684K	Day Scholar	BUS	Hiranian.M	Umayial.H	\N	8	[{"name": "Lakshmi", "relation": "cousin", "number": "9940710267"}]	{"tenth": {"school": "Immaculate Heart of Mary Girls Hr,Sec,School", "board": "State Board", "percentage": "56"}, "twelfth": {"school": "Vallalar Govt,Girls,Hr,Sec,School", "board": "State Board", "percentage": "50"}, "ug": {"degree": "B.SC(CS)", "university": "Achariya Arts and Science College", "percentage": "72"}, "pg": [{"degree": "M.SC(CS)", "university": "Pondicherry University", "percentage": "7.5"}, {"degree": "M.Tech(CS)", "university": "Pondicherry University", "percentage": "7.5"}, {"degree": "B.ED(CS)", "university": "Nehru College Of Education", "percentage": "83"}], "phd": {"university": "", "specialization": "", "year": ""}}	\N	[{"institution": "HDF Life Insurance Pvt,Ltd", "from_date": "2020-05-24", "to_date": "2021-02-24"}, {"institution": "Sbi Life Insurance Pvt,Ltd", "from_date": "2021-06-01", "to_date": "2022-12-13"}, {"institution": "Aditya Birla Capital Limited", "from_date": "2023-03-08", "to_date": "2024-10-11"}, {"institution": "Kotak Mahindra Pvt,Ltd", "from_date": "2025-01-13", "to_date": "2025-10-15"}]
82	1443	1	Mr. Vinayagamoorthi	Eganathan	Male	2001-09-21	B+	Indian	HINDU	\N	vinayagam@svcet.ac.in	vinaysiva18@gmail.com	8754859065	\N	NO50A, MARIAMMAN KOIL STREET	AMBETHKAR NAGAR PS PALAYAM	PONDICHERRY	PONDICHERRY	605107	5147024	Assistant Professor	M.TECH	Information Security	1	2026-01-02	t	2026-07-14 11:48:02.645612+05:30	2026-07-23 11:33:35.961511+05:30	SC	600532769155	BZYPV9012K	Day Scholar	OWN	EGANATHAN S	SIVAGAMI E	\N	\N	[{"name": "SIVAGAMI E", "relation": "MOTHER", "number": "9943499936"}]	{"tenth": {"school": "PB GOVT HR SEC SCHOOL PS PALAYAM", "board": "STATE BOARD", "percentage": "75"}, "twelfth": {"school": "PB GOVT HR SEC SCHOOL PS PALAYAM", "board": "STATE BOARD", "percentage": "47"}, "ug": {"degree": "B.TECH", "university": "PONDICHERRY UNIVERSITY", "percentage": "7.8"}, "pg": [{"degree": "M.ECH", "university": "PUDUCHERRY TECHNOLOGICAL UNIVERSITY", "percentage": "6.4"}], "phd": {"university": "", "specialization": "", "year": ""}}	\N	[]
\.


--
-- Data for Name: faculty_attendance; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty_attendance (id, faculty_id, date, status, leave_request_id, created_at, updated_at) FROM stdin;
1	46	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
421	33	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
422	34	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
423	35	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
424	36	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
425	37	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
426	38	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
427	39	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
428	42	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
429	43	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
430	44	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
431	45	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
432	47	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
14	33	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
15	34	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
16	35	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
17	36	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
18	37	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
19	38	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
20	39	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
21	42	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
22	43	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
23	44	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
24	45	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
25	47	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
26	48	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
27	49	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
28	50	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
29	40	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
30	41	2026-07-10	present	\N	2026-07-10 12:47:15.133807+05:30	\N
433	48	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
434	49	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
435	50	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
436	40	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
437	41	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
438	46	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
439	69	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
440	62	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
441	61	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
442	70	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
41	33	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
42	34	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
43	35	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
44	36	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
45	37	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
46	38	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
47	39	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
48	42	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
49	43	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
50	44	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
51	45	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
52	47	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
53	48	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
54	49	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
55	50	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
56	40	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
57	41	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
58	46	2026-07-01	present	\N	2026-07-14 09:48:05.548662+05:30	\N
443	68	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
444	67	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
445	66	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
446	65	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
447	64	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
448	63	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
449	80	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
450	71	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
451	72	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
452	74	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
453	76	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
454	78	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
71	33	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
72	34	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
73	35	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
74	36	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
75	37	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
76	38	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
77	39	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
78	42	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
79	43	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
80	44	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
81	45	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
82	47	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
83	48	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
84	49	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
85	50	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
86	40	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
87	41	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
88	46	2026-07-02	present	\N	2026-07-14 09:48:05.567206+05:30	\N
455	82	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
456	73	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
457	75	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
458	77	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
459	79	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
460	81	2026-07-16	present	\N	2026-07-14 16:15:22.152739+05:30	\N
523	33	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
524	34	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
525	35	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
526	36	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
527	37	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
528	38	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
101	33	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
102	34	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
103	35	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
104	36	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
105	37	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
106	38	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
107	39	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
108	42	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
109	43	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
110	44	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
111	45	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
112	47	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
113	48	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
114	49	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
115	50	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
116	40	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
117	41	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
118	46	2026-07-03	present	\N	2026-07-14 09:48:05.578379+05:30	\N
529	39	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
530	42	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
531	43	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
532	44	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
533	45	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
534	47	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
535	48	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
536	49	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
537	50	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
538	40	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
539	41	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
540	46	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
131	33	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
132	34	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
133	35	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
134	36	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
135	37	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
136	38	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
137	39	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
138	42	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
139	43	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
140	44	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
141	45	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
142	47	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
143	48	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
144	49	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
145	50	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
146	40	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
147	41	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
148	46	2026-07-04	present	\N	2026-07-14 09:48:05.58925+05:30	\N
541	69	2026-07-17	on_leave	53	2026-07-17 09:00:12.707575+05:30	\N
542	61	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
543	70	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
544	68	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
545	67	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
546	66	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
547	65	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
548	64	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
461	33	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
462	34	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
463	35	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
161	33	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
162	34	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
163	35	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
164	36	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
165	37	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
166	38	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
167	39	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
168	42	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
169	43	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
170	44	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
171	45	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
172	47	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
173	48	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
174	49	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
175	50	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
176	40	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
177	41	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
178	46	2026-07-05	present	\N	2026-07-14 09:48:05.600826+05:30	\N
464	36	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
465	37	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
466	38	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
467	39	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
468	42	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
469	43	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
470	44	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
471	45	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
472	47	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
473	48	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
474	49	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
475	50	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
191	33	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
192	34	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
193	35	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
194	36	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
195	37	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
196	38	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
197	39	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
198	42	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
199	43	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
200	44	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
201	45	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
202	47	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
203	48	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
204	49	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
205	50	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
206	40	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
207	41	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
208	46	2026-07-06	present	\N	2026-07-14 09:48:05.612832+05:30	\N
476	40	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
477	41	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
478	46	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
479	69	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
480	62	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
481	61	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
482	70	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
483	68	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
484	67	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
485	66	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
486	65	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
487	64	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
221	33	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
222	34	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
223	35	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
224	36	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
225	37	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
226	38	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
227	39	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
228	42	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
229	43	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
230	44	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
231	45	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
232	47	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
233	48	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
234	49	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
235	50	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
236	40	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
237	41	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
238	46	2026-07-07	present	\N	2026-07-14 09:48:05.625259+05:30	\N
488	63	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
489	80	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
490	71	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
491	72	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
492	74	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
493	76	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
494	78	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
495	82	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
496	73	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
497	75	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
498	77	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
499	79	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
251	33	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
252	34	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
253	35	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
254	36	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
255	37	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
256	38	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
257	39	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
258	42	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
259	43	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
260	44	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
261	45	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
262	47	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
263	48	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
264	49	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
265	50	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
266	40	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
267	41	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
268	46	2026-07-08	present	\N	2026-07-14 09:48:05.639207+05:30	\N
500	81	2026-07-15	present	\N	2026-07-15 09:00:53.985204+05:30	\N
549	63	2026-07-17	on_leave	54	2026-07-17 09:00:12.707575+05:30	\N
550	80	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
551	71	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
552	72	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
553	74	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
554	76	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
555	78	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
556	82	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
557	73	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
558	75	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
559	77	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
281	33	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
282	34	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
283	35	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
284	36	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
285	37	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
286	38	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
287	39	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
288	42	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
289	43	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
290	44	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
291	45	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
292	47	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
293	48	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
294	49	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
295	50	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
296	40	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
297	41	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
298	46	2026-07-09	present	\N	2026-07-14 09:48:05.650891+05:30	\N
560	79	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
561	81	2026-07-17	present	\N	2026-07-17 09:00:12.707575+05:30	\N
562	62	2026-07-17	on_leave	55	2026-07-17 09:00:12.707575+05:30	\N
311	33	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
312	34	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
313	35	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
314	36	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
315	37	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
316	38	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
317	39	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
318	42	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
319	43	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
320	44	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
321	45	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
322	47	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
323	48	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
324	49	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
325	50	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
326	40	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
327	41	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
328	46	2026-07-11	present	\N	2026-07-14 09:48:05.671719+05:30	\N
501	69	2026-07-14	on_leave	64	2026-07-15 16:01:02.073475+05:30	\N
502	61	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
503	70	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
504	68	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
505	67	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
506	66	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
507	65	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
508	64	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
509	63	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
510	80	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
511	71	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
512	72	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
341	33	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
342	34	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
343	35	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
344	36	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
345	37	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
346	38	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
347	39	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
348	42	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
349	43	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
350	44	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
351	45	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
352	47	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
353	48	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
354	49	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
355	50	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
356	40	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
357	41	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
358	46	2026-07-12	present	\N	2026-07-14 09:48:05.683191+05:30	\N
513	74	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
514	76	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
515	78	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
516	82	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
517	73	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
518	75	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
519	77	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
520	79	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
521	81	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
522	62	2026-07-14	present	\N	2026-07-15 16:01:02.073475+05:30	\N
563	33	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
564	34	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
371	33	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
372	34	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
373	35	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
374	36	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
375	37	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
376	38	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
377	39	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
378	42	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
379	43	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
380	44	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
381	45	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
382	47	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
383	48	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
384	49	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
385	50	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
386	40	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
387	41	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
388	46	2026-07-13	present	\N	2026-07-14 09:48:05.694495+05:30	\N
565	35	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
566	36	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
567	37	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
568	38	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
569	39	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
570	42	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
571	43	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
572	44	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
573	45	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
574	47	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
575	48	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
576	49	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
401	33	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
402	34	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
403	35	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
404	36	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
405	37	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
406	38	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
407	39	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
408	42	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
409	43	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
410	44	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
411	45	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
412	47	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
413	48	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
414	49	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
415	50	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
416	40	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
417	41	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
418	46	2026-07-14	present	\N	2026-07-14 09:48:05.706392+05:30	\N
577	50	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
578	40	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
579	41	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
580	46	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
581	69	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
582	61	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
583	70	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
584	68	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
585	67	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
586	66	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
587	65	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
588	64	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
589	63	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
590	80	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
591	71	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
592	72	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
593	74	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
594	76	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
595	78	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
596	82	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
597	73	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
598	75	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
599	77	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
600	79	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
601	81	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
602	62	2026-07-18	present	\N	2026-07-17 09:00:25.982143+05:30	\N
763	33	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
764	34	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
765	35	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
766	36	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
767	37	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
768	38	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
769	39	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
770	42	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
771	43	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
772	44	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
773	45	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
774	47	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
775	48	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
776	49	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
777	50	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
778	40	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
779	41	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
780	46	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
781	69	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
782	61	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
783	70	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
784	68	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
785	66	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
786	65	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
787	64	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
788	63	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
789	80	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
790	71	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
791	72	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
792	74	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
793	76	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
794	78	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
795	82	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
796	73	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
797	75	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
798	77	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
799	79	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
800	81	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
801	67	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
802	62	2026-07-19	present	\N	2026-07-21 15:13:36.950526+05:30	\N
803	33	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
804	34	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
805	35	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
806	36	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
807	37	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
808	38	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
809	39	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
810	42	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
811	43	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
812	44	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
813	45	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
814	47	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
815	48	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
816	49	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
817	50	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
818	40	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
819	41	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
820	46	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
821	69	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
822	61	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
823	70	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
824	68	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
825	66	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
826	65	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
827	64	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
828	63	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
829	80	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
830	71	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
831	72	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
832	74	2026-07-20	on_leave	78	2026-07-21 15:13:36.96914+05:30	\N
833	76	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
834	78	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
835	82	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
836	73	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
837	75	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
838	77	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
839	79	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
840	81	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
841	67	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
842	62	2026-07-20	present	\N	2026-07-21 15:13:36.96914+05:30	\N
843	33	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
844	34	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
845	35	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
846	36	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
847	37	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
848	38	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
849	39	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
850	42	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
851	43	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
852	44	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
853	45	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
854	47	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
855	48	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
856	49	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
857	50	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
858	40	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
859	41	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
860	46	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
861	69	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
862	61	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
863	70	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
864	68	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
865	66	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
866	65	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
867	64	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
868	63	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
869	80	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
870	71	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
871	72	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
872	74	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
873	76	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
874	78	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
875	82	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
876	73	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
877	75	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
878	77	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
879	79	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
880	81	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
881	67	2026-07-21	present	\N	2026-07-21 15:13:36.974018+05:30	\N
882	62	2026-07-21	on_leave	82	2026-07-21 15:13:36.974018+05:30	\N
883	33	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
884	34	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
885	35	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
886	36	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
887	37	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
888	38	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
889	39	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
890	42	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
891	43	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
892	44	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
893	45	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
894	47	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
895	48	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
896	49	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
897	50	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
898	40	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
899	41	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
900	46	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
901	69	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
902	61	2026-07-22	on_leave	80	2026-07-22 09:13:02.452237+05:30	\N
903	70	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
904	68	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
905	66	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
906	65	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
907	64	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
908	63	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
909	80	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
910	72	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
911	74	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
912	76	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
913	78	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
914	82	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
915	73	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
916	75	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
917	77	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
918	79	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
919	81	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
920	67	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
921	62	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
922	71	2026-07-22	present	\N	2026-07-22 09:13:02.452237+05:30	\N
940	33	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
941	34	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
942	35	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
943	36	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
944	37	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
945	38	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
946	39	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
947	42	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
948	43	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
949	44	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
950	45	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
951	47	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
952	48	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
953	49	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
954	50	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
955	40	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
956	41	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
957	46	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
958	69	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
959	61	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
960	70	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
961	68	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
962	66	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
963	65	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
964	64	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
965	63	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
966	80	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
967	72	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
968	74	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
969	76	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
970	78	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
971	82	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
972	73	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
973	75	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
974	77	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
975	79	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
976	81	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
977	67	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
978	62	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
979	71	2026-07-23	present	\N	2026-07-22 12:47:18.359128+05:30	\N
980	90	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
981	91	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
982	92	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
983	93	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
984	94	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
985	95	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
986	96	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
987	97	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
988	98	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
989	99	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
990	100	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
991	101	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
992	102	2026-07-15	present	\N	2026-07-22 14:06:51.730823+05:30	\N
993	90	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
994	91	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
995	92	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
996	93	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
997	94	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
998	95	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
999	96	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
1000	97	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
1001	98	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
1002	99	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
1003	100	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
1004	101	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
1005	102	2026-07-16	present	\N	2026-07-22 14:06:51.740421+05:30	\N
1006	90	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1007	91	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1008	92	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1009	93	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1010	94	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1011	95	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1012	96	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1013	97	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1014	98	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1015	99	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1016	100	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1017	101	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1018	102	2026-07-17	present	\N	2026-07-22 14:06:51.744656+05:30	\N
1019	90	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1020	91	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1021	92	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1022	93	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1023	94	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1024	95	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1025	96	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1026	97	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1027	98	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1028	99	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1029	100	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1030	101	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1031	102	2026-07-18	present	\N	2026-07-22 14:06:51.748573+05:30	\N
1032	90	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1033	91	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1034	92	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1035	93	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1036	94	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1037	95	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1038	96	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1039	97	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1040	98	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1041	99	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1042	100	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1043	101	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1044	102	2026-07-19	present	\N	2026-07-22 14:06:51.752943+05:30	\N
1045	90	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1046	91	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1047	92	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1048	93	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1049	94	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1050	95	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1051	96	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1052	97	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1053	98	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1054	99	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1055	100	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1056	101	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1057	102	2026-07-20	present	\N	2026-07-22 14:06:51.756861+05:30	\N
1058	90	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1059	91	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1060	92	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1061	93	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1062	94	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1063	95	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1064	96	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1065	97	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1066	98	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1067	99	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1068	100	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1069	101	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1070	102	2026-07-21	present	\N	2026-07-22 14:06:51.760874+05:30	\N
1071	90	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1072	91	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1073	92	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1074	93	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1075	94	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1076	95	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1077	96	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1078	97	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1079	98	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1080	99	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1081	100	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1082	101	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1083	102	2026-07-22	present	\N	2026-07-22 14:06:51.765127+05:30	\N
1084	103	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1085	104	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1086	105	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1087	106	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1088	107	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1089	108	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1090	109	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1091	110	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1092	111	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1093	112	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1094	113	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1095	114	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1096	115	2026-07-15	present	\N	2026-07-22 14:30:36.178708+05:30	\N
1097	103	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1098	104	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1099	105	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1100	106	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1101	107	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1102	108	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1103	109	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1104	110	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1105	111	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1106	112	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1107	113	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1108	114	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1109	115	2026-07-16	present	\N	2026-07-22 14:30:36.189797+05:30	\N
1110	103	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1111	104	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1112	105	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1113	106	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1114	107	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1115	108	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1116	109	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1117	110	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1118	111	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1119	112	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1120	113	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1121	114	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1122	115	2026-07-17	present	\N	2026-07-22 14:30:36.194341+05:30	\N
1123	103	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1124	104	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1125	105	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1126	106	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1127	107	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1128	108	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1129	109	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1130	110	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1131	111	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1132	112	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1133	113	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1134	114	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1135	115	2026-07-18	present	\N	2026-07-22 14:30:36.198672+05:30	\N
1136	103	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1137	104	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1138	105	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1139	106	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1140	107	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1141	108	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1142	109	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1143	110	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1144	111	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1145	112	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1146	113	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1147	114	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1148	115	2026-07-19	present	\N	2026-07-22 14:30:36.202542+05:30	\N
1149	103	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1150	104	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1151	105	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1152	106	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1153	107	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1154	108	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1155	109	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1156	110	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1157	111	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1158	112	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1159	113	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1160	114	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1161	115	2026-07-20	present	\N	2026-07-22 14:30:36.206755+05:30	\N
1162	103	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1163	104	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1164	105	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1165	106	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1166	107	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1167	108	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1168	109	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1169	110	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1170	111	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1171	112	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1172	113	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1173	114	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1174	115	2026-07-21	present	\N	2026-07-22 14:30:36.210625+05:30	\N
1175	103	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1176	104	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1177	105	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1178	106	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1179	107	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1180	108	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1181	109	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1182	110	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1183	111	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1184	112	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1185	113	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1186	114	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1187	115	2026-07-22	present	\N	2026-07-22 14:30:36.214577+05:30	\N
1188	90	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1189	91	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1190	92	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1191	93	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1192	94	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1193	95	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1194	96	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1195	97	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1196	98	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1197	99	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1198	100	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1199	101	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1200	102	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1201	103	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1202	104	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1203	105	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1204	106	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1205	107	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1206	108	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1207	109	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1208	110	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1209	111	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1210	112	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1211	113	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1212	114	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1213	115	2026-07-23	present	\N	2026-07-23 09:13:11.803139+05:30	\N
1214	33	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1215	34	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1216	35	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1217	36	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1218	37	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1219	38	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1220	39	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1221	42	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1222	43	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1223	44	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1224	45	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1225	47	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1226	48	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1227	49	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1228	50	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1229	40	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1230	41	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1231	46	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1232	69	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1233	61	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1234	70	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1235	68	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1236	80	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1237	66	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1238	65	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1239	64	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1240	63	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1241	78	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1242	72	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1243	74	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1244	76	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1245	82	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1246	73	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1247	75	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1248	77	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1249	79	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1250	81	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1251	67	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1252	62	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1253	90	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1254	91	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1255	92	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1256	93	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1257	94	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1258	95	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1259	71	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1260	96	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1261	97	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1262	98	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1263	99	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1264	100	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1265	101	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1266	102	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1267	103	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1268	104	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1269	105	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1270	106	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1271	107	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1272	108	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1273	109	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1274	110	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1275	111	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1276	112	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1277	113	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1278	114	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1279	115	2026-07-24	present	\N	2026-07-23 09:27:26.793742+05:30	\N
1280	33	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1281	34	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1282	35	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1283	36	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1284	37	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1285	38	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1286	39	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1287	42	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1288	43	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1289	44	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1290	45	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1291	47	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1292	48	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1293	49	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1294	50	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1295	40	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1296	41	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1297	46	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1298	69	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1299	61	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1300	70	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1301	68	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1302	66	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1303	65	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1304	64	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1305	63	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1306	78	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1307	72	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1308	74	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1309	76	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1310	75	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1311	77	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1312	79	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1313	67	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1314	62	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1315	90	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1316	91	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1317	92	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1318	93	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1319	94	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1320	95	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1321	71	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1322	96	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1323	97	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1324	98	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1325	99	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1326	100	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1327	101	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1328	102	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1329	103	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1330	104	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1331	105	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1332	106	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1333	107	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1334	108	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1335	109	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1336	110	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1337	111	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1338	112	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1339	113	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1340	114	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1341	115	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1342	73	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1343	80	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1344	81	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
1345	82	2026-07-25	present	\N	2026-07-24 09:38:05.593393+05:30	\N
\.


--
-- Data for Name: faculty_duty_arrangements; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty_duty_arrangements (id, leave_request_id, substitute_faculty_id, subject, class_section, period, status, created_at, updated_at, day, compensation_date, compensation_period, section_id) FROM stdin;
66	53	62	t22	TEST Year-3 A	13:50 - 14:40	ACCEPTED	2026-07-14 16:11:35.515084+05:30	2026-07-14 16:11:56.152869+05:30	fri	2026-07-20	09:30 AM - 10:20 AM	\N
67	53	63	t25	TEST Year-3 A	14:50 - 15:40	ACCEPTED	2026-07-14 16:11:35.515084+05:30	2026-07-14 16:12:17.659868+05:30	fri	2026-07-20	10:35 AM - 11:25 AM	\N
68	54	69	t21	TEST Year-3 A	10:35 - 11:25	ACCEPTED	2026-07-15 09:11:56.340858+05:30	2026-07-15 09:12:07.444089+05:30	fri	2026-07-20	08:45 AM - 09:30 AM	\N
69	54	69	t21	TEST Year-3 A	13:00 - 13:50	ACCEPTED	2026-07-15 09:11:56.340858+05:30	2026-07-15 09:12:09.275919+05:30	fri	2026-07-20	01:00 PM - 01:50 PM	\N
70	54	69	Class Advisor	TEST Year-1 B	All Periods	ACCEPTED	2026-07-15 09:11:56.340858+05:30	2026-07-15 09:12:11.163555+05:30	All Days	\N	\N	\N
71	55	67	t1	a	a	ACCEPTED	2026-07-15 09:19:32.590801+05:30	2026-07-15 09:19:52.814131+05:30		2026-07-20	08:45 AM - 09:30 AM	\N
75	59	62	t22	TEST Year-3 A	13:50 - 14:40	ACCEPTED	2026-07-15 14:17:43.812805+05:30	2026-07-15 14:22:19.745605+05:30	fri	2026-07-20	09:30 AM - 10:20 AM	\N
76	59	62	t22	TEST Year-3 A	14:50 - 15:40	ACCEPTED	2026-07-15 14:17:43.812805+05:30	2026-07-15 14:22:21.834103+05:30	fri	2026-07-20	02:50 PM - 03:40 PM	\N
77	59	62	Class Advisor	TEST Year-4 B	All Periods	ACCEPTED	2026-07-15 14:17:43.812805+05:30	2026-07-15 14:22:23.635058+05:30	All Days	\N	\N	\N
78	60	62	t22	TEST Year-3 A	13:50 - 14:40	ACCEPTED	2026-07-15 14:28:45.589916+05:30	2026-07-15 14:46:59.126661+05:30	fri	2026-07-20	09:30 AM - 10:20 AM	\N
79	60	62	t22	TEST Year-3 A	14:50 - 15:40	ACCEPTED	2026-07-15 14:28:45.589916+05:30	2026-07-15 14:47:01.517468+05:30	fri	2026-07-20	02:50 PM - 03:40 PM	\N
80	60	62	Class Advisor	TEST Year-4 B	All Periods	ACCEPTED	2026-07-15 14:28:45.589916+05:30	2026-07-15 14:47:03.550463+05:30	All Days	\N	\N	\N
103	74	62	Department Works	Department Works	17-Jul-2026	ACCEPTED	2026-07-16 13:36:13.943596+05:30	2026-07-16 13:36:59.559722+05:30	fri	\N	\N	\N
85	64	62	t22	TEST Year-3 A	09:30 - 10:20	ACCEPTED	2026-07-15 15:57:26.414021+05:30	2026-07-15 15:58:02.406734+05:30	tue	2026-07-15	08:45 AM - 09:30 AM	\N
86	64	62	t22	TEST Year-3 A	11:25 - 12:15	ACCEPTED	2026-07-15 15:57:26.414021+05:30	2026-07-15 15:58:04.742094+05:30	tue	2026-07-15	09:30 AM - 10:20 AM	\N
87	64	62	Class Advisor	TEST Year-4 B	All Periods	ACCEPTED	2026-07-15 15:57:26.414021+05:30	2026-07-15 15:58:06.551327+05:30	All Days	\N	\N	\N
90	66	65	t4	TEST Year-1 A	08:45 - 09:30	ACCEPTED	2026-07-15 16:03:52.010092+05:30	2026-07-15 16:04:38.882184+05:30	thu	2026-07-17	09:30 AM - 10:20 AM	\N
91	66	70	Class Advisor	TEST Year-3 B	All Periods	ACCEPTED	2026-07-15 16:03:52.010092+05:30	2026-07-15 16:04:56.316776+05:30	All Days	\N	\N	\N
104	74	62	Class Advisor	TEST Year-4 B	All Periods	ACCEPTED	2026-07-16 13:36:13.943596+05:30	2026-07-16 13:37:03.38361+05:30	All Days	\N	\N	49
97	70	62	Department Works	Department Works	16:00 - 16:30	ACCEPTED	2026-07-16 12:45:20.765885+05:30	2026-07-16 12:45:40.463694+05:30	Fri	\N	\N	\N
98	71	62	Class Advisor	TEST Year-4 B	All Periods	REJECTED	2026-07-16 13:00:03.144088+05:30	2026-07-16 13:36:52.436484+05:30	\N	\N	\N	\N
101	74	62	t22	TEST Year-3 A	13:50 - 14:40	ACCEPTED	2026-07-16 13:36:13.943596+05:30	2026-07-16 13:36:55.431636+05:30	fri	2026-07-20	09:30 AM - 10:20 AM	46
102	74	62	t22	TEST Year-3 A	14:50 - 15:40	ACCEPTED	2026-07-16 13:36:13.943596+05:30	2026-07-16 13:36:57.343766+05:30	fri	2026-07-20	02:50 PM - 03:40 PM	46
108	77	67	t1	TEST Year-1 A	09:30 - 10:20	ACCEPTED	2026-07-17 08:56:05.341142+05:30	2026-07-17 08:58:18.353223+05:30	fri	2026-07-13	09:30 AM - 10:20 AM	42
109	77	67	Department Works	Department Works	10-Jul-2026	ACCEPTED	2026-07-17 08:56:05.341142+05:30	2026-07-17 08:58:21.127716+05:30	fri	\N	\N	\N
110	77	67	Class Advisor	TEST Year-2 B	All Periods	ACCEPTED	2026-07-17 08:56:05.341142+05:30	2026-07-17 08:58:23.663535+05:30	All Days	\N	\N	45
112	78	72	Class Advisor	CSE Year-4 A	All Periods	ACCEPTED	2026-07-17 10:10:36.215019+05:30	2026-07-17 10:11:35.341441+05:30	All Days	\N	\N	7
111	78	72	Department Works	Department Works	20-Jul-2026	ACCEPTED	2026-07-17 10:10:36.215019+05:30	2026-07-17 10:11:38.561046+05:30	mon	\N	\N	\N
113	79	67	HOD Duties	test — HOD Duties	20-Jul-2026	ACCEPTED	2026-07-17 10:15:22.254806+05:30	2026-07-17 10:15:39.582771+05:30	\N	\N	\N	\N
114	80	65	HOD Duties	test — HOD Duties	22-Jul-2026	ACCEPTED	2026-07-17 10:22:04.973149+05:30	2026-07-17 10:22:18.703904+05:30	\N	\N	\N	\N
115	81	67	HOD Duties	test — HOD Duties	17-Jul-2026	ACCEPTED	2026-07-17 10:33:55.622057+05:30	2026-07-17 10:34:12.549494+05:30	\N	\N	\N	\N
116	82	69	t21	TEST Year-3 A	10:35 - 11:25	ACCEPTED	2026-07-17 11:05:18.750102+05:30	2026-07-17 11:05:55.434216+05:30	tue	2026-07-22	10:35 AM - 11:25 AM	46
117	82	69	t21	TEST Year-3 A	13:00 - 13:50	ACCEPTED	2026-07-17 11:05:18.750102+05:30	2026-07-17 11:05:58.94571+05:30	tue	2026-07-22	01:00 PM - 01:50 PM	46
118	82	69	t21	TEST Year-3 A	13:50 - 14:40	ACCEPTED	2026-07-17 11:05:18.750102+05:30	2026-07-17 11:06:00.777815+05:30	tue	2026-07-23	11:25 AM - 12:15 PM	46
119	82	69	Department Works	Department Works	21-Jul-2026	ACCEPTED	2026-07-17 11:05:18.750102+05:30	2026-07-17 11:06:02.721561+05:30	tue	\N	\N	\N
120	82	69	Class Advisor	TEST Year-1 A	All Periods	ACCEPTED	2026-07-17 11:05:18.750102+05:30	2026-07-17 11:06:04.721488+05:30	All Days	\N	\N	42
121	83	64	Department Works	Department Works	25-Jul-2026	ACCEPTED	2026-07-23 14:48:02.452079+05:30	2026-07-23 14:49:02.301176+05:30	sat	\N	\N	\N
122	83	64	Class Advisor	TEST Year-3 A	All Periods	ACCEPTED	2026-07-23 14:48:02.452079+05:30	2026-07-23 14:49:04.467925+05:30	All Days	\N	\N	46
123	84	67	HOD Duties	test — HOD Duties	26-Jul-2026	PENDING	2026-07-24 11:45:33.958944+05:30	\N	\N	\N	\N	\N
124	84	67	t23	TEST Year-3 A	All Periods	PENDING	2026-07-24 11:45:33.958944+05:30	\N	All Days	\N	\N	46
125	84	67	t23	TEST Year-3 B	All Periods	PENDING	2026-07-24 11:45:33.958944+05:30	\N	All Days	\N	\N	47
\.


--
-- Data for Name: faculty_gate_passes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty_gate_passes (id, faculty_id, reason, out_time, expected_in_time, actual_in_time, status, viewed_by_hod, viewed_by_dean, viewed_by_om, hod_id, hod_approved_at, dean_id, dean_approved_at, om_id, om_approved_at, rejection_reason, is_deleted_by_faculty, created_at, updated_at) FROM stdin;
8	62	urgent ah ponu 	2026-07-15 02:19:00+05:30	2026-07-15 04:20:00+05:30	\N	REJECTED	t	f	f	61	2026-07-16 14:32:18.639699+05:30	\N	\N	\N	\N	fjjrfh	t	2026-07-15 13:40:13.601106+05:30	2026-07-16 14:32:18.635736+05:30
9	62	urgent ah ponnuuuuuu\n	2026-07-15 13:50:00+05:30	2026-07-15 16:00:00+05:30	\N	REJECTED	t	f	f	61	2026-07-16 14:32:21.780472+05:30	\N	\N	\N	\N	fdhjfj	t	2026-07-15 13:41:05.426226+05:30	2026-07-16 14:32:21.773727+05:30
7	62	tea	2026-07-14 16:00:00+05:30	2026-07-14 16:20:00+05:30	\N	APPROVED	t	t	t	61	2026-07-14 15:45:08.364973+05:30	1	2026-07-15 14:55:30.814106+05:30	4	2026-07-17 13:04:53.251227+05:30	\N	t	2026-07-14 15:42:33.819894+05:30	2026-07-18 13:04:37.524949+05:30
\.


--
-- Data for Name: faculty_leave_balances; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty_leave_balances (id, faculty_id, academic_year, casual_leaves_total, casual_leaves_used, sick_leaves_total, sick_leaves_used, earned_leaves_total, earned_leaves_used, created_at, updated_at, restricted_leaves_total, restricted_leaves_used, vacation_leaves_total, vacation_leaves_used, compensation_leaves_total, compensation_leaves_used, academic_leaves_total, academic_leaves_used) FROM stdin;
23	39	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
24	42	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
25	43	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
26	44	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
27	45	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
28	47	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
29	48	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
7	62	2023-2024	5	1	10	0	5	0	2026-07-14 15:42:51.289482+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	2	1	5	0
8	67	2023-2024	5	1	10	0	5	0	2026-07-14 15:58:50.471725+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
9	72	2023-2024	5	0	10	0	5	0	2026-07-14 16:01:30.465713+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
10	69	2023-2024	5	0	10	0	5	0	2026-07-14 16:07:31.502159+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	1	0	3	5	1
11	63	2023-2024	5	0	10	0	5	0	2026-07-15 09:11:15.261194+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	1	5	0
12	74	2023-2024	5	0	10	0	5	0	2026-07-15 11:58:40.706652+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	1	1	5	0
13	65	2023-2024	5	0	10	0	5	0	2026-07-15 16:16:12.286747+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	1
14	79	2023-2024	5	0	10	0	5	0	2026-07-16 09:58:32.147328+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
30	49	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
31	50	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
32	40	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
15	66	2023-2024	5	0	10	0	5	0	2026-07-16 10:38:55.757621+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
16	64	2023-2024	5	0	10	0	5	0	2026-07-16 10:56:34.54151+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
17	33	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
18	34	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
19	35	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
20	36	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
21	37	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
22	38	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
33	41	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
34	46	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
35	61	2023-2024	5	2	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
36	70	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
37	68	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
38	80	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
39	71	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
40	76	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
41	78	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
42	82	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
43	73	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
44	75	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
45	77	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
46	81	2023-2024	5	0	10	0	5	0	2026-07-16 12:33:41.982681+05:30	2026-07-23 14:18:11.642121+05:30	5	0	5	0	0	0	5	0
47	90	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
48	91	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
49	92	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
50	93	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
51	94	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
52	95	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
53	96	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
54	97	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
55	98	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
56	99	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
57	100	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
58	101	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
59	102	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
60	103	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
61	104	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
62	105	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
63	106	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
64	107	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
65	108	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
66	109	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
67	110	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
68	111	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
69	112	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
70	113	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
71	114	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
72	115	2023-2024	5	0	10	0	5	0	2026-07-23 14:18:11.642121+05:30	\N	5	0	5	0	5	0	5	0
\.


--
-- Data for Name: faculty_leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.faculty_leave_requests (id, faculty_id, leave_type, from_date, to_date, duration_days, reason, attachment_url, status, hod_approved_by, dean_approved_by, om_approved_by, rejection_reason, created_at, updated_at, viewed_by_hod, viewed_by_dean, compensation_verifier_id, compensation_date, compensation_purpose, hour_permission_session, hour_permission_period, proof_link, principal_approved_by, compensation_registry_id, alternate_hod_faculty_id) FROM stdin;
77	65	Academic Leave	2026-07-10	2026-07-10	1	t	\N	approved	61	1	4	\N	2026-07-17 08:56:05.341142+05:30	2026-07-17 09:19:48.650724+05:30	f	f	\N	\N	\N	\N	\N		3	\N	\N
59	69	Compensation Leave	2026-07-17	2026-07-17	1	w	\N	approved	61	1	3	\N	2026-07-15 14:17:43.812805+05:30	2026-07-15 14:27:03.688691+05:30	f	f	1339	2026-07-11	special class	\N	\N	\N	\N	\N	\N
60	69	Compensation Leave	2026-07-17	2026-07-17	1	a	\N	approved	61	1	3	\N	2026-07-15 14:28:45.589916+05:30	2026-07-15 14:48:19.629683+05:30	f	f	769	2026-07-09	special class	\N	\N	\N	\N	\N	\N
78	74	Compensation Leave	2026-07-20	2026-07-20	1	Outing	\N	approved	71	1	4	\N	2026-07-17 10:10:36.215019+05:30	2026-07-17 10:13:46.508692+05:30	f	f	\N	\N	\N	\N	\N		3	1	\N
79	61	Casual Leave	2026-07-20	2026-07-20	1	t	\N	pending_alternate_hod	\N	\N	\N	\N	2026-07-17 10:15:22.254806+05:30	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	67
64	69	Vacation Leave	2026-07-14	2026-07-14	1	t	\N	approved	61	1	3	\N	2026-07-15 15:57:26.414021+05:30	2026-07-15 15:59:01.10628+05:30	f	f	\N	\N		\N	\N	\N	\N	\N	\N
80	61	Casual Leave	2026-07-22	2026-07-22	1	t	\N	approved	\N	1	4	\N	2026-07-17 10:22:04.973149+05:30	2026-07-17 10:23:23.698573+05:30	f	f	\N	\N	\N	\N	\N	\N	3	\N	65
66	67	Casual Leave	2026-07-16	2026-07-16	1	Health issue	\N	approved	61	1	3	\N	2026-07-15 16:03:52.010092+05:30	2026-07-15 16:05:39.712669+05:30	f	f	\N	\N		\N	\N	\N	\N	\N	\N
81	61	Casual Leave	2026-07-17	2026-07-17	1	t	\N	approved	\N	1	4	\N	2026-07-17 10:33:55.622057+05:30	2026-07-17 10:35:07.832014+05:30	f	f	\N	\N	\N	\N	\N	\N	3	\N	67
70	69	Hour Permission	2026-07-17	2026-07-17	1	t	\N	approved	61	1	4	\N	2026-07-16 12:45:20.765885+05:30	2026-07-16 12:46:22.300288+05:30	f	f	\N	\N		16:00	16:30		3	\N	\N
71	33	On Duty	2026-07-30	2026-07-30	1	Test	\N	rejected	\N	\N	\N	One or more substitute faculty rejected the duty arrangement.	2026-07-16 13:00:03.144088+05:30	2026-07-16 13:36:52.445529+05:30	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
82	62	Compensation Leave	2026-07-21	2026-07-21	1	t	\N	approved	67	1	4	\N	2026-07-17 11:05:18.750102+05:30	2026-07-17 11:07:23.343006+05:30	f	f	\N	\N	\N	\N	\N		3	3	\N
83	66	Vacation Leave	2026-07-25	2026-07-25	1	sad	\N	pending_hod	\N	\N	\N	\N	2026-07-23 14:48:02.452079+05:30	2026-07-23 14:49:04.481436+05:30	f	f	\N	\N	\N	\N	\N		\N	\N	\N
74	69	On Duty	2026-07-17	2026-07-17	1	t	\N	approved	61	1	4	\N	2026-07-16 13:36:13.943596+05:30	2026-07-16 13:37:48.314362+05:30	f	f	\N	\N		\N	\N		3	\N	\N
53	69	Compensation Leave	2026-07-17	2026-07-17	1	e	\N	approved	61	1	1	\N	2026-07-14 16:11:35.515084+05:30	2026-07-14 16:13:41.235864+05:30	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
84	61	Casual Leave	2026-07-26	2026-07-26	1	Summa 	\N	pending_alternate_hod	\N	\N	\N	\N	2026-07-24 11:45:33.958944+05:30	\N	f	f	\N	\N	\N	\N	\N	\N	\N	\N	67
54	63	Compensation Leave	2026-07-17	2026-07-17	1	w	\N	approved	61	1	3	\N	2026-07-15 09:11:56.340858+05:30	2026-07-15 09:12:57.010189+05:30	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
55	62	Casual Leave	2026-07-17	2026-07-17	1	a	\N	approved	61	1	3	\N	2026-07-15 09:19:32.590801+05:30	2026-07-15 09:20:31.526111+05:30	f	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: fee_structures; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fee_structures (id, department_id, semester, amount, academic_year, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: gate_passes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gate_passes (id, student_id, reason, out_time, expected_in_time, actual_in_time, status, mentor_id, mentor_approved_at, hod_id, hod_approved_at, om_id, om_approved_at, rejection_reason, created_at, updated_at, is_deleted_by_student, viewed_by_mentor, viewed_by_hod, viewed_by_om) FROM stdin;
37	1407	t	2026-07-17 12:00:00+05:30	2026-07-17 12:30:00+05:30	\N	APPROVED	65	2026-07-17 05:08:28.427199+05:30	67	2026-07-17 05:28:30.84034+05:30	4	2026-07-17 05:29:05.347242+05:30	\N	2026-07-17 10:38:06.791583+05:30	2026-07-17 10:59:05.421758+05:30	f	f	f	f
38	1386	you\n	2026-07-17 15:50:00+05:30	2026-07-17 04:20:00+05:30	\N	PENDING_MENTOR	\N	\N	\N	\N	\N	\N	\N	2026-07-18 15:42:20.898613+05:30	2026-07-18 15:42:37.462705+05:30	t	f	f	f
39	1386	you \n	2026-07-17 16:00:00+05:30	2026-07-17 16:24:00+05:30	\N	PENDING_MENTOR	\N	\N	\N	\N	\N	\N	\N	2026-07-18 15:43:07.051299+05:30	\N	f	f	f	f
29	1347	hospital	2026-07-14 14:15:00+05:30	2026-07-14 15:30:00+05:30	\N	PENDING_MENTOR	\N	\N	\N	\N	\N	\N	\N	2026-07-14 14:10:13.05343+05:30	\N	f	f	f	f
33	1386	home\n	2026-07-14 15:30:00+05:30	2026-07-14 16:30:00+05:30	\N	PENDING_OM	62	2026-07-14 09:54:18.517257+05:30	61	2026-07-14 10:00:14.471976+05:30	\N	\N	\N	2026-07-14 15:08:13.518405+05:30	2026-07-14 15:30:14.814479+05:30	f	t	f	f
32	1376	home	2026-07-14 15:30:00+05:30	2026-07-14 16:30:00+05:30	\N	PENDING_OM	69	2026-07-14 09:39:48.529382+05:30	61	2026-07-14 10:00:16.449199+05:30	\N	\N	\N	2026-07-14 15:04:24.501044+05:30	2026-07-14 15:30:16.793937+05:30	f	t	f	f
31	1375	h	2026-07-14 15:15:00+05:30	2026-07-14 16:15:00+05:30	\N	REJECTED	69	2026-07-14 09:39:49.820291+05:30	\N	\N	\N	\N	no	2026-07-14 15:02:20.704757+05:30	2026-07-14 15:30:24.479369+05:30	f	t	f	f
34	1375	late\n	2026-07-14 16:00:00+05:30	2026-07-14 16:15:00+05:30	\N	PENDING_HOD	69	2026-07-14 10:05:23.166171+05:30	\N	\N	\N	\N	\N	2026-07-14 15:34:14.582383+05:30	2026-07-14 15:35:23.516883+05:30	f	t	f	f
35	1375	FF	2026-07-18 15:00:00+05:30	2026-07-18 16:20:00+05:30	\N	REJECTED	69	2026-07-17 22:47:01.774656+05:30	61	2026-07-17 22:51:20.687361+05:30	\N	\N	Mudiyathu paa sorry	2026-07-15 11:28:51.354691+05:30	2026-07-15 14:26:04.820847+05:30	f	f	f	f
30	1385	lunch	2026-07-14 14:45:00+05:30	2026-07-14 15:30:00+05:30	\N	PENDING_HOD	62	2026-07-14 09:54:19.693097+05:30	\N	\N	\N	\N	\N	2026-07-14 14:33:36.348548+05:30	2026-07-15 15:11:47.939896+05:30	t	t	f	f
36	1385	DYJ	2026-07-15 15:15:00+05:30	2026-07-15 16:00:00+05:30	\N	PENDING_OM	62	2026-07-15 09:43:46.177465+05:30	61	2026-07-15 10:03:42.298468+05:30	\N	\N	\N	2026-07-15 15:12:20.700135+05:30	2026-07-15 15:33:42.293643+05:30	f	f	f	f
\.


--
-- Data for Name: grades; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.grades (id, student_id, course_id, grade_type, marks_obtained, max_marks, academic_year, semester, graded_by_id, remarks, created_at, is_published, is_absent, updated_at, test_date) FROM stdin;
\.


--
-- Data for Name: holidays; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.holidays (id, date, name, created_by_id, created_at) FROM stdin;
\.


--
-- Data for Name: lab_marks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lab_marks (id, course_assignment_id, student_id, record_marks, ia1_marks, ia2_marks, viva_marks, is_published, graded_by_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: late_entry_notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.late_entry_notifications (id, student_id, mentor_id, date, expected_arrival_time, reason, acknowledged_by_security, acknowledged_at, created_at, viewed_by_mentor, viewed_at, mentor_comment, mentor_comment_at, is_approved, approved_by_id, approved_at, class_advisor_id, approval_status) FROM stdin;
60	1347	\N	2026-07-15	11:00:00	hospital	f	\N	2026-07-14 14:09:32.243576+05:30	f	\N	\N	\N	f	\N	\N	\N	pending
63	1375	69	2026-07-15	10:00:00	late	f	\N	2026-07-14 15:02:46.445702+05:30	t	\N	\N	\N	f	\N	\N	\N	pending
64	1376	69	2026-07-16	09:30:00	late	f	\N	2026-07-14 15:04:43.183251+05:30	t	\N	\N	\N	f	\N	\N	\N	pending
61	1385	62	2026-07-18	11:00:00	hospital	f	\N	2026-07-14 14:31:59.285779+05:30	t	\N	\N	\N	f	\N	\N	\N	pending
62	1386	62	2026-07-15	09:00:00	traffic	f	\N	2026-07-14 14:40:10.956025+05:30	t	\N	\N	\N	f	\N	\N	\N	pending
65	1385	62	2026-07-16	10:00:00	late\n	f	\N	2026-07-14 15:06:16.980944+05:30	t	\N	\N	\N	f	\N	\N	\N	pending
66	1386	62	2026-07-16	10:00:00	home	f	\N	2026-07-14 15:08:47.206009+05:30	t	\N	\N	\N	f	\N	\N	\N	pending
67	1375	69	2026-07-17	10:00:00	late\n	f	\N	2026-07-14 15:34:30.781944+05:30	t	\N	\N	\N	f	\N	\N	\N	pending
68	1385	62	2026-07-21	09:00:00	SM	f	\N	2026-07-15 15:13:07.423882+05:30	f	\N	\N	\N	f	\N	\N	\N	pending
69	1385	62	2026-07-17	09:00:00	late uh 	f	\N	2026-07-16 14:39:13.128743+05:30	f	\N	\N	\N	f	\N	\N	\N	pending
70	1385	62	2026-07-22	09:00:00	gfkj	f	\N	2026-07-16 14:57:44.2967+05:30	f	\N	\N	\N	f	\N	\N	\N	pending
71	1386	62	2026-07-22	09:00:00	gShwsh	f	\N	2026-07-16 15:10:39.232866+05:30	f	\N	\N	\N	f	\N	\N	\N	pending
72	1386	62	2026-07-23	09:00:00	SFqf	f	\N	2026-07-16 15:25:47.614273+05:30	f	\N	\N	\N	f	\N	\N	\N	pending
73	1386	62	2026-07-31	09:00:00	jbvkj	f	\N	2026-07-16 15:46:30.332622+05:30	f	\N	\N	\N	f	\N	\N	\N	pending
\.


--
-- Data for Name: late_records; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.late_records (id, student_id, recorded_by_id, date, "time", reason, remarks, created_at, action_status) FROM stdin;
\.


--
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_requests (id, student_id, leave_type, from_date, to_date, reason, status, mentor_approved_by, mentor_approved_at, hod_approved_by, hod_approved_at, rejection_reason, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: lms_resources; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lms_resources (id, course_id, uploaded_by_id, title, description, resource_type, file_url, external_link, created_at) FROM stdin;
11	83	67	1st Assignment	[Due: 2026-07-15]\ntt	ASSIGNMENT	\N	http://localhost:5173/faculty/courses/107/lms/assignments	2026-07-14 15:11:16.835467+05:30
12	67	74	1st Assignment	[Due: 2026-07-22]\nintro 	ASSIGNMENT	\N	http://10.1.10.24:5173/faculty/courses/97/lms/assignments	2026-07-18 16:49:03.188612+05:30
\.


--
-- Data for Name: mentor_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentor_assignments (id, mentor_id, student_id, academic_year, assigned_at) FROM stdin;
145	69	1419	2026-2027	2026-07-17 10:36:18.562544+05:30
146	65	1407	2026-2027	2026-07-17 10:37:22.82853+05:30
147	62	1386	2026-2027	2026-07-18 15:47:36.055234+05:30
150	72	1276	2026-2027	2026-07-18 16:14:15.056632+05:30
151	74	1298	2026-2027	2026-07-18 16:14:16.297243+05:30
152	74	1328	2026-2027	2026-07-18 16:14:17.656159+05:30
153	72	1311	2026-2027	2026-07-18 16:14:19.009177+05:30
154	76	1280	2026-2027	2026-07-22 10:07:49.749751+05:30
155	76	1274	2026-2027	2026-07-22 10:07:51.430942+05:30
156	76	1272	2026-2027	2026-07-22 10:07:52.638885+05:30
187	75	1558	2026-2027	2026-07-24 10:30:50.043777+05:30
188	75	1264	2026-2027	2026-07-24 10:30:52.039439+05:30
189	74	1649	2026-2027	2026-07-24 10:31:11.511037+05:30
190	74	1635	2026-2027	2026-07-24 10:31:12.473256+05:30
191	74	1620	2026-2027	2026-07-24 10:31:13.553485+05:30
\.


--
-- Data for Name: mentoring_meetings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mentoring_meetings (id, mentor_id, student_id, topic, description, status, requested_by_student, scheduled_at, completed_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: msg_conversations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.msg_conversations (id, student_id, dean_id, department_id, last_message, last_message_time, dean_unread_count, student_unread_count, created_at, updated_at, is_pinned, pinned_at, is_marked_for_review, review_marked_at) FROM stdin;
12	1417	1	9	\N	\N	0	0	2026-07-15 09:36:01.666131+05:30	\N	f	\N	f	\N
11	1342	1	1	test	2026-07-15 14:54:15.59565+05:30	0	0	2026-07-15 09:05:27.210998+05:30	2026-07-15 14:54:41.297304+05:30	f	\N	f	\N
13	1274	1	1	\N	\N	0	0	2026-07-16 14:19:49.831649+05:30	\N	f	\N	f	\N
14	1320	1	1	ok paa naa pathukuren	2026-07-22 13:31:49.088705+05:30	0	1	2026-07-18 16:50:52.846465+05:30	2026-07-22 13:31:49.088705+05:30	f	\N	f	\N
15	1422	1	9	\N	\N	0	0	2026-07-22 13:32:04.15993+05:30	\N	f	\N	f	\N
16	1526	1	1	\N	\N	0	0	2026-07-23 11:19:14.695483+05:30	\N	f	\N	f	\N
17	1512	1	1	\N	\N	0	0	2026-07-23 11:19:34.600906+05:30	\N	f	\N	f	\N
18	1541	1	1	For past 2 weeks. Even though we had PT period we couldn't play because PT Sir was not there. 	2026-07-23 11:25:51.69983+05:30	0	0	2026-07-23 11:23:58.488215+05:30	2026-07-23 12:16:35.363037+05:30	f	\N	f	\N
19	1462	1	1	\N	\N	0	0	2026-07-23 14:49:45.150072+05:30	\N	f	\N	f	\N
20	1610	1	1	\N	\N	0	0	2026-07-23 15:25:55.036863+05:30	\N	f	\N	f	\N
21	1542	1	1	\N	\N	0	0	2026-07-23 15:52:58.406739+05:30	\N	f	\N	f	\N
\.


--
-- Data for Name: msg_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.msg_messages (id, conversation_id, sender_type, message_type, message_text, image_url, is_read, created_at) FROM stdin;
26	11	STUDENT	TEXT	test	\N	t	2026-07-15 14:54:15.59565+05:30
27	14	STUDENT	TEXT	hi 	\N	t	2026-07-18 16:50:56.678504+05:30
28	14	STUDENT	TEXT	faculty  didnt complete portion 	\N	t	2026-07-18 16:52:51.692243+05:30
29	14	DEAN	TEXT	ok paa naa pathukuren	\N	f	2026-07-22 13:31:49.088705+05:30
30	18	STUDENT	TEXT	For past 2 weeks. Even though we had PT period we couldn't play because PT Sir was not there. 	\N	t	2026-07-23 11:25:51.69983+05:30
\.


--
-- Data for Name: notification_views; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_views (id, user_id, sector, last_viewed_at) FROM stdin;
87	1435	faculty-leave	2026-07-24 04:57:55.143338+05:30
122	1405	faculty-gatepass	2026-07-18 11:38:02.246277+05:30
123	1405	faculty-gatepass-own	2026-07-18 11:38:21.63955+05:30
183	1578	student-leave	2026-07-22 09:20:21.139878+05:30
124	1405	late-entry	2026-07-18 11:39:30.834006+05:30
113	1432	hod-latetracker	2026-07-24 04:44:39.883211+05:30
100	1342	faculty-mentorship	2026-07-23 04:28:44.403546+05:30
101	1342	faculty-ca-leave	2026-07-17 07:09:40.647584+05:30
125	1405	faculty-announcements	2026-07-18 11:40:37.283125+05:30
73	1344	faculty-gatepass-own	2026-07-24 04:36:19.584624+05:30
67	1338	hod-announcements	2026-07-18 07:21:59.620681+05:30
86	1435	faculty-gatepass	2026-07-23 07:00:45.719784+05:30
104	1338	hod-discipline	2026-07-18 07:22:14.938572+05:30
95	1344	hod-gatepass	2026-07-17 05:28:25.871726+05:30
79	1432	hod-discipline	2026-07-24 04:44:40.626014+05:30
128	1405	student-leave	2026-07-18 11:45:05.170089+05:30
129	1405	student-gatepass	2026-07-18 11:45:15.941696+05:30
90	1504	student-gatepass	2026-07-17 05:29:12.820775+05:30
69	1338	hod-gatepass	2026-07-18 07:22:16.371353+05:30
106	1338	hod-faculty-gatepass	2026-07-18 07:22:17.511595+05:30
61	1483	student-late-entry	2026-07-17 15:41:56.746564+05:30
66	1483	student-gatepass	2026-07-17 15:42:07.632697+05:30
105	1338	hod-latetracker	2026-07-18 07:22:18.56841+05:30
65	1347	faculty-leave	2026-07-16 15:45:44.400335+05:30
63	1346	faculty-leave	2026-07-17 05:35:48.698208+05:30
127	1405	student-late-entry	2026-07-18 11:45:22.017793+05:30
126	1405	student-announcements	2026-07-18 11:45:39.050226+05:30
115	1432	hod-faculty-gatepass	2026-07-23 04:58:51.399816+05:30
96	1344	hod-leave	2026-07-17 05:36:16.967178+05:30
84	769	authority-leave	2026-07-17 07:33:46.799582+05:30
62	1346	late-entry	2026-07-17 10:27:06.22958+05:30
107	769	authority-announcements	2026-07-17 07:33:51.302118+05:30
57	1339	faculty-leave	2026-07-17 15:44:05.703612+05:30
74	1344	late-entry	2026-07-16 10:43:37.57362+05:30
60	1483	student-leave	2026-07-17 15:44:22.548352+05:30
75	1344	faculty-announcements	2026-07-16 10:45:08.756909+05:30
85	1435	faculty-announcements	2026-07-23 07:00:48.448306+05:30
76	1472	student-leave	2026-07-18 03:04:59.311908+05:30
88	1433	faculty-leave	2026-07-17 04:41:21.053244+05:30
82	780	authority-leave	2026-07-17 07:34:42.167067+05:30
56	1339	late-entry	2026-07-17 15:45:55.129528+05:30
89	780	authority-gatepass	2026-07-17 07:34:47.131197+05:30
77	1472	student-gatepass	2026-07-18 03:07:05.425475+05:30
108	780	authority-faculty-gatepass	2026-07-17 07:34:49.683498+05:30
109	780	authority-announcements	2026-07-17 07:34:58.092179+05:30
116	1435	faculty-ca-leave	2026-07-23 07:00:56.388031+05:30
54	1435	late-entry	2026-07-23 07:00:46.201644+05:30
118	1339	faculty-gatepass-own	2026-07-17 15:45:59.366088+05:30
110	10	authority-faculty-gatepass	2026-07-21 10:45:14.649895+05:30
185	1578	student-gatepass	2026-07-22 09:20:21.618585+05:30
111	10	authority-announcements	2026-07-23 06:48:08.514161+05:30
59	1339	leave-mentor	2026-07-17 15:48:17.920345+05:30
137	1340	late-entry	2026-07-21 08:06:07.340941+05:30
138	1340	faculty-gatepass-own	2026-07-21 08:06:08.268503+05:30
92	1338	faculty-leave	2026-07-22 04:51:33.644586+05:30
112	1432	hod-announcements	2026-07-24 04:53:51.329918+05:30
186	1578	student-late-entry	2026-07-22 09:20:25.29386+05:30
58	1339	faculty-mentorship	2026-07-17 15:48:24.466343+05:30
139	1340	faculty-gatepass	2026-07-21 08:06:09.823291+05:30
117	1339	faculty-gatepass	2026-07-17 15:49:21.792378+05:30
71	1344	faculty-ca-leave	2026-07-24 04:35:55.391932+05:30
97	1340	faculty-leave	2026-07-21 08:06:13.676523+05:30
83	1	admin-discipline	2026-07-24 04:45:10.921638+05:30
72	1344	faculty-gatepass	2026-07-24 04:36:07.615313+05:30
136	1516	student-leave	2026-07-24 06:12:58.506151+05:30
64	1346	faculty-mentorship	2026-07-21 08:06:50.355609+05:30
178	1619	student-gatepass	2026-07-22 09:08:46.375172+05:30
140	1346	leave-mentor	2026-07-21 08:06:51.504664+05:30
78	1432	hod-leave	2026-07-25 06:18:46.427693+05:30
179	1641	student-leave	2026-07-22 09:09:30.941885+05:30
98	1338	faculty-announcements	2026-07-22 04:51:37.299507+05:30
148	1338	late-entry	2026-07-22 04:51:37.908332+05:30
81	10	authority-leave	2026-07-25 06:17:51.558827+05:30
180	1641	student-gatepass	2026-07-22 09:09:37.775689+05:30
147	1432	admin-discipline	2026-07-22 04:41:41.600025+05:30
68	1338	hod-leave	2026-07-25 06:12:57.356516+05:30
144	1	faculty-leave	2026-07-22 04:03:56.642989+05:30
188	1578	student-announcements	2026-07-22 09:20:29.950801+05:30
131	1514	student-leave	2026-07-21 08:01:43.828797+05:30
130	1435	faculty-mentorship	2026-07-24 05:00:24.373593+05:30
142	1516	student-gatepass	2026-07-21 08:09:04.995132+05:30
93	1338	faculty-gatepass-own	2026-07-22 04:51:38.530173+05:30
132	1519	student-announcements	2026-07-21 08:02:23.883934+05:30
135	1519	student-leave	2026-07-21 08:02:26.639137+05:30
134	1519	student-gatepass	2026-07-21 08:02:27.002792+05:30
133	1519	student-late-entry	2026-07-21 08:02:27.358355+05:30
119	1405	faculty-leave	2026-07-18 11:33:56.037429+05:30
120	1405	faculty-mentorship	2026-07-18 11:37:16.361172+05:30
121	1405	leave-mentor	2026-07-18 11:37:58.255945+05:30
70	1344	faculty-leave	2026-07-25 06:16:18.377619+05:30
143	1516	student-late-entry	2026-07-21 08:09:09.509126+05:30
141	1340	faculty-ca-leave	2026-07-21 08:09:37.742098+05:30
94	1338	faculty-gatepass	2026-07-22 04:51:39.512112+05:30
181	1641	student-late-entry	2026-07-22 09:09:39.169562+05:30
182	1641	student-announcements	2026-07-22 09:09:45.764377+05:30
177	1325	faculty-leave	2026-07-23 07:34:25.4+05:30
145	1344	admin-discipline	2026-07-22 04:05:52.507963+05:30
114	1432	hod-gatepass	2026-07-25 04:34:31.448525+05:30
146	1344	admin-latetracker	2026-07-22 04:05:52.887043+05:30
102	1	admin-latetracker	2026-07-22 08:37:31.791644+05:30
55	1435	faculty-gatepass-own	2026-07-23 07:00:47.489949+05:30
189	1592	student-announcements	2026-07-22 09:21:38.816525+05:30
190	1592	student-late-entry	2026-07-22 09:21:43.434956+05:30
184	1592	student-gatepass	2026-07-22 09:22:05.547895+05:30
187	1592	student-leave	2026-07-22 09:22:06.799969+05:30
192	1566	student-gatepass	2026-07-22 09:23:13.690615+05:30
193	1566	student-late-entry	2026-07-22 09:23:15.628531+05:30
195	1566	student-announcements	2026-07-22 09:23:19.023454+05:30
196	1556	student-gatepass	2026-07-22 09:23:22.671508+05:30
197	1556	student-leave	2026-07-22 09:23:24.541401+05:30
198	1625	student-gatepass	2026-07-22 09:23:37.203168+05:30
199	1625	student-leave	2026-07-22 09:23:55.831123+05:30
200	1625	student-late-entry	2026-07-22 09:23:56.878804+05:30
201	1625	student-announcements	2026-07-22 09:23:57.376896+05:30
202	1556	student-announcements	2026-07-22 09:24:02.772782+05:30
191	1566	student-leave	2026-07-22 09:24:32.857335+05:30
99	1343	faculty-leave	2026-07-24 09:17:58.019966+05:30
91	1342	faculty-gatepass	2026-07-23 04:28:43.864604+05:30
80	1342	faculty-leave	2026-07-23 04:28:44.928497+05:30
194	1556	student-late-entry	2026-07-22 09:24:03.596188+05:30
203	1580	student-leave	2026-07-22 09:25:47.59833+05:30
204	1580	student-gatepass	2026-07-22 09:25:48.710322+05:30
205	1580	student-late-entry	2026-07-22 09:25:50.288184+05:30
206	1553	student-gatepass	2026-07-22 09:27:04.783805+05:30
208	1553	student-announcements	2026-07-22 09:27:16.735563+05:30
209	1553	student-late-entry	2026-07-22 09:27:17.851992+05:30
207	1553	student-leave	2026-07-22 09:27:31.782689+05:30
211	1574	student-late-entry	2026-07-22 09:30:03.488909+05:30
210	1574	student-leave	2026-07-22 09:30:30.498672+05:30
214	1582	student-leave	2026-07-22 09:33:35.544665+05:30
212	1582	student-gatepass	2026-07-22 09:33:37.590871+05:30
213	1582	student-late-entry	2026-07-22 09:34:04.83312+05:30
215	1582	student-announcements	2026-07-22 09:34:24.655201+05:30
216	1620	student-late-entry	2026-07-22 10:06:10.879159+05:30
217	1588	student-gatepass	2026-07-22 10:38:25.066125+05:30
218	1588	student-leave	2026-07-22 10:38:26.602395+05:30
219	1588	student-late-entry	2026-07-22 10:38:54.223955+05:30
220	1587	student-gatepass	2026-07-22 10:40:27.058679+05:30
221	1587	student-late-entry	2026-07-22 10:40:28.597729+05:30
224	1614	student-gatepass	2026-07-22 10:50:57.933666+05:30
225	1614	student-leave	2026-07-22 10:50:59.20225+05:30
223	1614	student-announcements	2026-07-22 10:51:26.980639+05:30
222	1614	student-late-entry	2026-07-22 10:51:29.043729+05:30
226	1342	faculty-gatepass-own	2026-07-23 04:23:11.704326+05:30
227	1342	faculty-announcements	2026-07-23 04:28:42.716566+05:30
228	1342	late-entry	2026-07-23 04:28:43.331709+05:30
103	1	admin-announcements	2026-07-23 04:38:00.406044+05:30
229	1434	faculty-ca-leave	2026-07-23 05:13:19.979632+05:30
231	1561	student-leave	2026-07-23 05:45:46.70299+05:30
232	1561	student-gatepass	2026-07-23 05:45:48.72471+05:30
233	1561	student-late-entry	2026-07-23 05:45:56.356317+05:30
238	1609	student-announcements	2026-07-23 05:49:38.567714+05:30
275	1633	student-late-entry	2026-07-23 07:32:44.128944+05:30
234	1623	student-leave	2026-07-23 05:50:05.341339+05:30
274	1633	student-gatepass	2026-07-23 07:32:54.248966+05:30
239	1609	student-gatepass	2026-07-23 05:50:12.208878+05:30
242	1638	student-gatepass	2026-07-23 05:50:13.591553+05:30
277	1740	student-gatepass	2026-07-23 08:32:31.186766+05:30
278	1740	student-late-entry	2026-07-23 08:32:31.972368+05:30
237	1623	student-announcements	2026-07-23 05:50:20.601434+05:30
236	1623	student-late-entry	2026-07-23 05:50:21.292953+05:30
235	1623	student-gatepass	2026-07-23 05:50:21.974891+05:30
245	1533	student-late-entry	2026-07-23 05:50:35.666536+05:30
230	1529	student-late-entry	2026-07-23 05:50:50.640786+05:30
246	1529	student-announcements	2026-07-23 05:51:03.322429+05:30
244	1529	student-gatepass	2026-07-23 05:51:04.216243+05:30
247	1529	student-leave	2026-07-23 05:51:08.244782+05:30
248	1537	student-leave	2026-07-23 05:54:04.644795+05:30
240	1609	student-late-entry	2026-07-23 05:55:33.169239+05:30
241	1609	student-leave	2026-07-23 05:55:35.619359+05:30
250	1537	student-late-entry	2026-07-23 05:55:49.888307+05:30
249	1537	student-gatepass	2026-07-23 05:55:56.163082+05:30
279	1740	student-announcements	2026-07-23 08:32:38.299234+05:30
276	1740	student-leave	2026-07-23 08:32:40.911537+05:30
253	1570	student-gatepass	2026-07-23 05:56:14.586377+05:30
252	1570	student-leave	2026-07-23 05:56:15.344295+05:30
254	1570	student-late-entry	2026-07-23 05:56:16.711236+05:30
251	1638	student-announcements	2026-07-23 05:56:24.655516+05:30
255	1638	student-late-entry	2026-07-23 05:56:27.943098+05:30
243	1638	student-leave	2026-07-23 05:56:31.855946+05:30
280	1738	student-leave	2026-07-23 08:32:43.467423+05:30
256	1644	student-announcements	2026-07-23 05:57:00.48836+05:30
257	1644	student-late-entry	2026-07-23 05:57:01.131934+05:30
258	1644	student-gatepass	2026-07-23 05:57:01.76187+05:30
259	1443	faculty-announcements	2026-07-23 06:05:16.973342+05:30
260	1443	faculty-announcements	2026-07-23 06:05:16.974513+05:30
261	1443	late-entry	2026-07-23 06:05:56.200754+05:30
262	1443	faculty-gatepass-own	2026-07-23 06:05:56.810171+05:30
263	1443	faculty-gatepass	2026-07-23 06:05:57.362701+05:30
266	1607	student-gatepass	2026-07-23 06:28:26.672636+05:30
264	1607	student-late-entry	2026-07-23 06:28:35.877822+05:30
269	1643	student-leave	2026-07-23 06:30:32.523041+05:30
268	1643	student-gatepass	2026-07-23 06:30:34.474437+05:30
281	1343	faculty-ca-leave	2026-07-24 08:32:46.132223+05:30
267	1643	student-announcements	2026-07-23 06:30:45.801431+05:30
282	1343	late-entry	2026-07-24 08:48:33.927635+05:30
283	1343	faculty-gatepass	2026-07-24 08:48:34.191275+05:30
284	1720	student-leave	2026-07-23 08:52:48.599189+05:30
285	1720	student-gatepass	2026-07-23 08:52:49.560245+05:30
286	1720	student-late-entry	2026-07-23 08:52:53.129248+05:30
287	1720	student-announcements	2026-07-23 08:52:59.746604+05:30
288	1356	student-leave	2026-07-23 09:06:22.469342+05:30
289	1356	student-late-entry	2026-07-23 09:06:30.988426+05:30
291	1343	faculty-announcements	2026-07-24 09:17:08.704422+05:30
265	1643	student-late-entry	2026-07-23 09:23:06.017089+05:30
271	1551	student-gatepass	2026-07-23 09:23:06.815103+05:30
290	1559	student-leave	2026-07-23 09:20:37.352332+05:30
293	1559	student-gatepass	2026-07-23 09:20:44.304276+05:30
294	1559	student-late-entry	2026-07-23 09:20:54.071554+05:30
295	1559	student-announcements	2026-07-23 09:20:56.869602+05:30
296	1721	student-late-entry	2026-07-23 09:20:57.431741+05:30
297	1721	student-gatepass	2026-07-23 09:21:14.111001+05:30
298	1721	student-leave	2026-07-23 09:21:18.012866+05:30
306	1666	student-gatepass	2026-07-23 09:35:42.999179+05:30
273	1551	student-announcements	2026-07-23 09:23:26.289935+05:30
272	1551	student-late-entry	2026-07-23 09:23:33.181574+05:30
270	1551	student-leave	2026-07-23 09:23:50.421928+05:30
299	1664	student-leave	2026-07-23 09:31:15.890816+05:30
300	1664	student-gatepass	2026-07-23 09:31:17.623433+05:30
301	1745	student-leave	2026-07-23 09:31:30.040465+05:30
302	1745	student-gatepass	2026-07-23 09:31:30.712925+05:30
303	1745	student-late-entry	2026-07-23 09:31:31.498107+05:30
304	1745	student-announcements	2026-07-23 09:31:36.541177+05:30
305	1608	student-late-entry	2026-07-23 09:36:17.226778+05:30
307	1618	student-leave	2026-07-23 09:51:24.335386+05:30
309	1618	student-late-entry	2026-07-23 09:51:45.659563+05:30
311	1707	student-leave	2026-07-23 09:55:31.860997+05:30
310	1618	student-announcements	2026-07-23 09:51:52.360328+05:30
308	1618	student-gatepass	2026-07-23 09:51:54.624499+05:30
312	1536	student-leave	2026-07-23 09:59:14.049678+05:30
313	1536	student-gatepass	2026-07-23 09:59:15.655087+05:30
314	1536	student-late-entry	2026-07-23 09:59:16.583795+05:30
315	1536	student-announcements	2026-07-23 09:59:21.038867+05:30
316	1695	student-late-entry	2026-07-23 10:00:50.018429+05:30
317	1695	student-gatepass	2026-07-23 10:00:54.996668+05:30
318	1557	student-leave	2026-07-23 10:06:45.200403+05:30
319	1557	student-gatepass	2026-07-23 10:06:50.189806+05:30
320	1557	student-late-entry	2026-07-23 10:06:59.378502+05:30
321	1557	student-announcements	2026-07-23 10:07:18.451307+05:30
322	1840	student-leave	2026-07-23 10:10:23.915345+05:30
324	1840	student-late-entry	2026-07-23 10:10:25.390662+05:30
323	1840	student-gatepass	2026-07-23 10:10:24.37287+05:30
330	1811	student-late-entry	2026-07-23 10:35:44.309044+05:30
325	1840	student-announcements	2026-07-23 10:09:50.083369+05:30
326	1843	student-gatepass	2026-07-23 10:11:07.995279+05:30
328	1811	student-leave	2026-07-23 10:35:41.28083+05:30
327	1843	student-leave	2026-07-23 10:12:03.230617+05:30
329	1811	student-gatepass	2026-07-23 10:35:42.87471+05:30
331	1827	student-leave	2026-07-23 10:48:07.315615+05:30
332	1827	student-gatepass	2026-07-23 10:48:20.736903+05:30
333	1597	student-gatepass	2026-07-24 04:55:55.197723+05:30
335	1435	leave-mentor	2026-07-24 05:00:27.030789+05:30
337	1589	student-gatepass	2026-07-24 05:08:45.514088+05:30
336	1589	student-leave	2026-07-24 05:09:34.115094+05:30
338	1589	student-late-entry	2026-07-24 05:09:40.085533+05:30
339	1589	student-announcements	2026-07-24 05:10:22.645496+05:30
334	1463	student-leave	2026-07-24 05:24:50.937903+05:30
347	1548	student-late-entry	2026-07-24 05:40:23.088521+05:30
346	1548	student-announcements	2026-07-24 05:40:52.185341+05:30
341	1563	student-leave	2026-07-24 05:41:41.896853+05:30
342	1563	student-gatepass	2026-07-24 05:41:42.435806+05:30
343	1563	student-announcements	2026-07-24 05:41:43.607551+05:30
340	1563	student-late-entry	2026-07-24 05:41:44.430704+05:30
344	1548	student-leave	2026-07-24 05:41:48.188086+05:30
345	1548	student-gatepass	2026-07-24 05:41:50.711242+05:30
292	1341	faculty-leave	2026-07-25 06:00:36.88235+05:30
348	1742	student-leave	2026-07-24 06:19:56.21808+05:30
\.


--
-- Data for Name: password_reset_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_requests (id, role, name, college_id, email, status, created_at, resolved_at, department) FROM stdin;
1	student	vishwa	23td0732	vishwa23td0732@svcet.ac.in	resolved	2026-07-18 13:23:37.919853+05:30	2026-07-18 13:47:23.888776+05:30	
3	student	Hemachandran G	23TD0680	hemachandran23td0680@svcet.ac.in	resolved	2026-07-18 13:53:37.154829+05:30	2026-07-18 13:54:53.550599+05:30	Computer Science and Engineering
2	student	Vishwa B.R	23TD0732	vishwa23td0732@svcet.ac.in	resolved	2026-07-18 13:47:11.821199+05:30	2026-07-18 13:54:56.364802+05:30	Computer Science and Engineering
4	student	Hemachandran G	23TD0680	hemachandran23td0680@svcet.ac.in	pending	2026-07-18 15:32:22.625707+05:30	\N	Computer Science and Engineering
5	student	Gowtham M	24TD0780	gowtham24td0780@svcet.ac.in	pending	2026-07-23 11:56:04.714223+05:30	\N	Computer Science and Engineering
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, student_id, amount, payment_date, mode, receipt_no, voucher_no, ledger_name_raw, source, uploaded_by, notes, created_at) FROM stdin;
55	1364	2500.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student18 (Cen - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:40.743116+05:30
56	1405	4000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student59 (Mng - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:40.743116+05:30
57	1371	2500.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student25 (Mng - TEST/2024-2028)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:40.743116+05:30
58	1349	1000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student3 (Cen - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:40.743116+05:30
59	1379	1000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student33 (Mng - TEST/2024-2028)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:40.743116+05:30
60	1392	3000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student46 (Mng - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:40.743116+05:30
61	1381	1000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student35 (Mng - TEST/2024-2028)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:40.743116+05:30
62	1392	1000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student46 (Mng - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:50.758872+05:30
63	1358	2000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student12 (Cen - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:50.758872+05:30
64	1357	2000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student11 (Cen - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:50.758872+05:30
65	1402	2500.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student56 (Mng - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:50.758872+05:30
66	1415	5000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student69 (Mng - TEST/2026-2030)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:50.758872+05:30
67	1395	3000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student49 (Cen - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:50.758872+05:30
68	1356	2000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student10 (Mng - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:50.758872+05:30
69	1416	2500.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student70 (Cen - TEST/2026-2030)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:50.758872+05:30
70	1398	2000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student52 (Mng - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:50.758872+05:30
71	1367	5000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student21 (Mng - TEST/2024-2028)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:55.999597+05:30
72	1400	4000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student54 (Cen - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:55.999597+05:30
73	1355	1000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student9 (Mng - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:55.999597+05:30
74	1365	5000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student19 (Mng - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:55.999597+05:30
75	1394	3000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student48 (Mng - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:55.999597+05:30
76	1377	2500.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student31 (Cen - TEST/2024-2028)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:55.999597+05:30
77	1357	3000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student11 (Cen - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:55.999597+05:30
78	1365	1000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student19 (Mng - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:59.812302+05:30
79	1384	4000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student38 (Mng - TEST/2024-2028)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:59.812302+05:30
80	1396	1500.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student50 (Cen - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:59.812302+05:30
81	1394	5000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student48 (Mng - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:59.812302+05:30
82	1363	3000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student17 (Cen - TEST/2023-2027)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:59.812302+05:30
83	1415	2500.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student69 (Mng - TEST/2026-2030)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:59.812302+05:30
84	1390	2500.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student44 (Mng - TEST/2025-2029)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:59.812302+05:30
85	1413	1000.00	2026-07-24	TALLY_SYNC	\N	\N	Test.Student67 (Mng - TEST/2026-2030)	TALLY_UPLOAD	1886	\N	2026-07-24 09:46:59.812302+05:30
\.


--
-- Data for Name: program_outcomes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.program_outcomes (id, outcomes, updated_by_id, updated_at) FROM stdin;
1	PO1-Engineering knowledge: Apply the knowledge of mathematics, science, engineering fundamentals, and an engineering specialization to the solution of complex engineering problems.\n\nPO2-Problem analysis: Identify, formulate, review research literature, and analyze complex engineering problems reaching substantiated conclusions using first principles of mathematics, natural sciences, and engineering sciences.\n\nPO3- Design/development of solutions: Design solutions for complex engineering problems and design system components or processes that meet the specified needs with appropriate consideration for the public health and safety, and the cultural, societal, and environmental considerations.\n\nPO4-Conduct investigations of complex problems: Use research-based knowledge and research methods including design of experiments, analysis and interpretation of data, and synthesis of the information to provide valid conclusions.\n\nPO5-Modern tool usage: Create, select, and apply appropriate techniques, resources, and modern engineering and IT tools including prediction and modeling to complex engineering activities with an understanding of the limitations.\n\nPO6-The engineer and society: Apply reasoning informed by the contextual knowledge to assess societal, health, safety, legal and cultural issues and the consequent responsibilities relevant to the professional engineering practice.\n\nPO7-Environment and sustainability: Understand the impact of the professional engineering solutions in societal and environmental contexts, and demonstrate the knowledge of, and need for sustainable development.\n\nPO8-Ethics: Apply ethical principles and commit to professional ethics and responsibilities and norms of the engineering practice.\n\nPO9-Individual and team work: Function effectively as an individual, and as a member or leader in diverse teams, and in multidisciplinary settings.\n\nPO10- Communication: Communicate effectively on complex engineering activities with the engineering community and with society at large, such as, being able to comprehend and write effective reports and design documentation, make effective presentations, and give and receive clear instructions\n\nPO11-Project management and finance: Demonstrate knowledge and understanding of the engineering and management principles and apply these to one's own work, as a member and leader in a team, to manage projects and in multidisciplinary environments.\n\nPO12-Life-long learning: Recognize the need for, and have the preparation and ability to engage in independent and life-long learning in the broadest context of technological change	1	2026-07-15 13:36:05.878892
\.


--
-- Data for Name: restricted_holidays; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.restricted_holidays (id, name, date, description, academic_year, created_by_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: retest_marks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.retest_marks (id, grade_id, student_id, course_id, marks_obtained, max_marks, entered_by_id, remarks, is_published, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sections (id, department_id, name, year, class_advisor_id, is_active, created_at) FROM stdin;
14	1	B	1	\N	t	2026-06-28 07:41:10.536652+05:30
13	1	A	1	\N	t	2026-06-28 07:41:10.534902+05:30
7	1	A	4	74	t	2026-06-28 07:41:10.522625+05:30
8	1	B	4	82	t	2026-06-28 07:41:10.525452+05:30
42	9	A	1	62	t	2026-07-14 12:27:15.459448+05:30
43	9	B	1	63	t	2026-07-14 12:28:05.62638+05:30
44	9	A	2	64	t	2026-07-14 12:29:12.846687+05:30
45	9	B	2	65	t	2026-07-14 12:30:00.634452+05:30
46	9	A	3	66	t	2026-07-14 12:30:33.235561+05:30
47	9	B	3	67	t	2026-07-14 12:31:14.434724+05:30
48	9	A	4	68	t	2026-07-14 14:55:18.978141+05:30
49	9	B	4	69	t	2026-07-14 14:58:14.141877+05:30
9	1	A	3	73	t	2026-06-28 07:41:10.52776+05:30
11	1	A	2	79	t	2026-06-28 07:41:10.531299+05:30
50	1	B	2	77	t	2026-07-22 14:32:41.364187+05:30
10	1	B	3	76	t	2026-06-28 07:41:10.529657+05:30
18	6	b	1	33	t	2026-07-07 10:48:55.351134+05:30
19	6	A	1	34	t	2026-07-07 11:24:45.62549+05:30
\.


--
-- Data for Name: seminars; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.seminars (id, course_assignment_id, student_id, seminar_date, seminar_topic, marks_obtained, max_marks, is_topic_published, is_marks_published, created_at, updated_at, rubric_content_relevance, rubric_presentation_skills, rubric_resources_used, rubric_time_management, rubric_question_handling, rubric_team_coordination) FROM stdin;
\.


--
-- Data for Name: student_fee_assignments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_fee_assignments (id, student_id, fee_structure_id, amount_due, semester, academic_year, created_at) FROM stdin;
238	1352	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
239	1353	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
241	1355	\N	18000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
243	1357	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
244	1358	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
245	1359	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
248	1362	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
250	1364	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
254	1368	\N	10000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
256	1370	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
257	1371	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
258	1372	\N	10000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
259	1373	\N	10000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
261	1375	\N	10000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
262	1376	\N	10000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
265	1379	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
266	1380	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
267	1381	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
271	1385	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
274	1388	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
275	1389	\N	10000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
279	1393	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
281	1395	\N	10000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
282	1396	\N	10000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
284	1398	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
285	1399	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
288	1402	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
289	1403	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
290	1404	\N	10000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
291	1405	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
294	1408	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
295	1409	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
297	1411	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
302	1416	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
304	1418	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
306	1420	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
307	1421	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
308	1422	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
309	1423	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
311	1425	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
235	1349	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
236	1350	\N	18000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
237	1351	\N	18000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
240	1354	\N	18000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
242	1356	\N	18000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
246	1360	\N	18000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
247	1361	\N	18000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
249	1363	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
251	1365	\N	19000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
252	1366	\N	10000.00	7	2026-2027	2026-07-24 09:33:39.67275+05:30
253	1367	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
255	1369	\N	10000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
260	1374	\N	10000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
263	1377	\N	10000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
264	1378	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
268	1382	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
269	1383	\N	10000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
270	1384	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
272	1386	\N	18000.00	5	2026-2027	2026-07-24 09:33:39.67275+05:30
273	1387	\N	10000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
276	1390	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
277	1391	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
278	1392	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
280	1394	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
283	1397	\N	10000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
286	1400	\N	10000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
287	1401	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
292	1406	\N	18000.00	3	2026-2027	2026-07-24 09:33:39.67275+05:30
293	1407	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
296	1410	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
298	1412	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
299	1413	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
300	1414	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
301	1415	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
303	1417	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
305	1419	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
310	1424	\N	18000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
312	1426	\N	10000.00	1	2026-2027	2026-07-24 09:33:39.67275+05:30
\.


--
-- Data for Name: student_leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_leave_requests (id, student_id, from_date, to_date, duration_days, reason, status, mentor_id, mentor_remarks, mentor_actioned_at, class_advisor_id, class_advisor_remarks, class_advisor_actioned_at, hod_id, hod_remarks, hod_actioned_at, rejection_reason, created_at, updated_at, viewed_by_mentor, viewed_by_ca, viewed_by_hod, leave_type) FROM stdin;
36	1385	2026-07-18	2026-07-24	7	MZDM	REJECTED	62		2026-07-15 09:43:42.840901+05:30	67		2026-07-15 10:26:50.504174+05:30	\N	\N	\N	Rejected by class advisor	2026-07-15 15:13:24.021202+05:30	2026-07-15 15:56:50.560413+05:30	f	f	f	Regular
37	1385	2026-07-25	2026-07-29	5	zfdjdj	APPROVED	62		2026-07-16 09:32:18.031471+05:30	67		2026-07-16 10:41:36.056697+05:30	61		2026-07-17 03:36:05.689945+05:30	\N	2026-07-16 14:58:49.91336+05:30	2026-07-17 09:06:06.308561+05:30	f	f	f	Regular
35	1385	2026-07-17	2026-07-18	2	SUMMA \n	APPROVED	62		2026-07-15 09:41:26.756719+05:30	67		2026-07-15 10:27:07.251663+05:30	61		2026-07-17 03:36:06.928636+05:30	\N	2026-07-15 15:11:11.364423+05:30	2026-07-17 09:06:07.546976+05:30	f	t	f	Regular
40	1386	2026-08-16	2026-08-16	1	7ud	APPROVED	62		2026-07-18 02:59:34.471179+05:30	67		2026-07-17 05:02:16.277248+05:30	61		2026-07-17 05:02:58.604333+05:30	\N	2026-07-16 15:46:51.759456+05:30	2026-07-17 10:32:58.71931+05:30	f	f	f	Regular
39	1386	2026-07-22	2026-07-23	2	aseh	APPROVED	62		2026-07-18 02:59:34.991645+05:30	67		2026-07-17 05:02:16.772852+05:30	61		2026-07-17 05:02:59.092363+05:30	\N	2026-07-16 15:10:22.817619+05:30	2026-07-17 10:32:59.205359+05:30	f	f	f	Regular
38	1385	2026-07-30	2026-07-31	2	zsfh	APPROVED	62		2026-07-18 02:59:35.361839+05:30	67		2026-07-17 05:02:17.224902+05:30	61		2026-07-17 05:02:59.477878+05:30	\N	2026-07-16 15:02:41.479519+05:30	2026-07-17 10:32:59.589392+05:30	f	f	f	Regular
41	1386	2026-08-04	2026-08-04	1	gou	REJECTED	62		2026-07-17 10:18:19.282413+05:30	67		2026-07-21 08:04:18.064604+05:30	\N	\N	\N	Rejected by class advisor	2026-07-18 15:41:35.425746+05:30	2026-07-22 13:34:04.389497+05:30	f	f	f	Regular
30	1386	2026-07-20	2026-07-21	2	home\n	APPROVED	62		2026-07-14 09:54:08.150668+05:30	67		2026-07-16 09:55:42.559018+05:30	61		2026-07-14 10:43:00.959426+05:30	\N	2026-07-14 15:07:45.960875+05:30	2026-07-14 16:13:01.327637+05:30	t	t	t	Regular
29	1385	2026-07-18	2026-07-20	3	trip	APPROVED	62		2026-07-14 09:54:08.89664+05:30	67		2026-07-16 09:55:44.269237+05:30	61		2026-07-14 10:43:02.101809+05:30	\N	2026-07-14 15:05:51.098968+05:30	2026-07-14 16:13:02.474668+05:30	t	t	t	Regular
26	1386	2026-07-16	2026-07-19	4	trip	APPROVED	62		2026-07-14 09:54:09.579094+05:30	67		2026-07-16 09:55:43.508814+05:30	61		2026-07-14 10:43:02.799992+05:30	\N	2026-07-14 14:40:49.943493+05:30	2026-07-14 16:13:03.173238+05:30	t	t	t	Regular
32	1417	2026-07-20	2026-07-20	1	SAD	PENDING_MENTOR	\N	\N	\N	63	\N	\N	\N	\N	\N	\N	2026-07-15 09:35:30.142938+05:30	\N	f	f	f	Regular
42	1419	2026-07-21	2026-07-21	1	test	APPROVED	69	Parents informed	2026-07-21 08:07:00.705928+05:30	63		2026-07-21 08:07:15.537782+05:30	61		2026-07-21 08:07:31.609883+05:30	\N	2026-07-22 13:35:00.867107+05:30	2026-07-22 13:37:17.926923+05:30	f	f	f	Regular
33	1375	2026-07-18	2026-07-18	1	1	APPROVED	69		2026-07-17 22:28:12.825369+05:30	66		2026-07-17 22:29:01.689129+05:30	61		2026-07-15 09:13:19.971483+05:30	\N	2026-07-15 11:13:06.039311+05:30	2026-07-15 14:43:19.981471+05:30	t	t	t	Regular
27	1375	2026-07-15	2026-07-16	2	leave	APPROVED	69		2026-07-14 09:39:40.864381+05:30	66		2026-07-17 22:29:03.016294+05:30	61		2026-07-15 09:13:21.729829+05:30	\N	2026-07-14 15:01:53.226129+05:30	2026-07-15 14:43:21.743374+05:30	t	t	t	Regular
31	1375	2026-07-17	2026-07-18	2	late	APPROVED	69		2026-07-14 10:05:20.435997+05:30	66		2026-07-17 22:29:02.165611+05:30	61		2026-07-15 09:13:23.021834+05:30	\N	2026-07-14 15:33:48.83935+05:30	2026-07-15 14:43:23.032081+05:30	t	t	t	Regular
28	1376	2026-07-16	2026-07-17	2	trip	APPROVED	69		2026-07-14 09:39:39.675598+05:30	66		2026-07-17 22:29:02.564899+05:30	61		2026-07-15 09:13:23.751563+05:30	\N	2026-07-14 15:03:48.66266+05:30	2026-07-15 14:43:23.76112+05:30	t	t	t	Regular
25	1385	2026-07-15	2026-07-17	3	trip	APPROVED	62		2026-07-14 09:07:40.190961+05:30	69		2026-07-14 09:11:45.976208+05:30	61		2026-07-14 09:26:05.448769+05:30	\N	2026-07-14 14:31:27.845019+05:30	2026-07-14 14:56:05.743766+05:30	t	t	t	Regular
34	1347	2026-07-16	2026-07-17	2	G	PENDING_MENTOR	\N	\N	\N	68	\N	\N	\N	\N	\N	\N	2026-07-15 15:09:48.39121+05:30	\N	f	f	f	Regular
\.


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.students (id, user_id, department_id, section_id, first_name, last_name, register_number, gender, date_of_birth, blood_group, nationality, community, photo_url, batch, current_year, current_semester, college_email, personal_email, phone, father_name, father_phone, father_occupation, mother_name, mother_phone, mother_occupation, annual_income, address_line1, address_line2, city, state, pincode, tenth_school, tenth_board, tenth_marks, tenth_percentage, twelfth_school, twelfth_board, twelfth_marks, twelfth_percentage, admission_date, admission_type, is_active, created_at, updated_at, religion, aadhar_number, accommodation, transportation, bus_number, is_alumni, intended_department_id, guardian_name, guardian_phone, guardian_occupation, primary_contact) FROM stdin;
1558	1655	1	11	ASHVIKA	U	25TD0607	Female	2007-09-01	B+	Indian	OBC	\N	2025-2029	2	3	ashvika25td0607@svcet.ac.in	\N	8754958718	T.Umanath	9841199636	QC manager (private ltd)	U.Rajika	8428339816	house wife	480000.00	no:109 Cuddalore road,thirubhuvanai palayam	thirubhuvanai	Puducherry	puducherry	605107	Faithful Seventh Day Adventist hr,Sec school	STATE BOARD	396.00	79.20	Faithful Seventh Day Adventist hr,Sec school	STATE BOARD	502.00	85.00	2026-09-09	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:14:40.764298+05:30	Hindu	453088772088	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1277	1362	1	7	Devasri	S	23TD0666	Female	2005-11-30	B+	Indian	MBC	\N	2023-2027	4	7	devasri23td0666@svcet.ac.in	\N	9360134845	R.Sekar	9843161257	Farmer	S.Jayabharathi	9360729671	Housewife	100000.00	No:151,theradi street,Periyababusamuthiram	\N	Villupuram	Tamilnadu	605102	Bharathi English High School	Stateboard	500.00	100.00	sri Navadurga English Higher Secondary School	Stateboard	454.00	75.00	2023-07-13	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:57:15.271898+05:30	Hindu	795123885784	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1294	1379	1	8	Jaya Srinivasan	A	23TD0683	Male	2000-01-01	A+	Indian	OBC	\N	2023-2027	4	7	jayasrinivasan23td0683@svcet.ac.in	\N	7094816496	Father	1234567890	Business	Mother	0987654321	Housewife	\N	123 Main St	\N	Pondicherry	Puducherry	605001	School A	State Board	\N	\N	School B	State Board	\N	\N	2020-01-01	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:46:24.914032+05:30	Hindu	123456789012	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1276	1361	1	8	Deepika	S	23TD0665	Female	2005-02-09	B+	Indian	OBC	\N	2023-2027	4	7	deepika23td0665@svcet.ac.in	\N	8072328087	Sachithanandam R	9443256520	Document writer	Praveena S	9786031666	Home maker	200000.00	No 37, Anna nagar	\N	Villupuram	Tamilnadu	605111	St.Patrick matric higher secondary school	State board	500.00	100.00	St.Patrick matric higher secondary school	State board	485.00	80.00	2023-09-11	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-15 12:25:38.437329+05:30	Hindu	393255369187	Day Scholar	BUS	22	f	\N	\N	\N	\N	\N
1280	1365	1	8	Dharshini	S	23TD0669	Female	2006-08-07	O+	Indian	OBC	\N	2023-2027	4	7	dharshini23td0669@svcet.ac.in	\N	8300395388	SURESH.R	9444909158	PWD(M.T.S)	POORANI.S	9786397802	HOME MAKER	200000.00	47,Brindhavanam nagar villanur	\N	villanur	puducherry	605502	JAWAHAR HIGHER SECONDARY SCHOOL KOODAPPAKKAM PUDUCHERRY	STATE BOARD	500.00	100.00	JAWAHAR HIGHER SECONDARY SCHOOL KOODAPPAKKAM PUDUCHERRY	STATE BOARD	451.00	75.00	2023-09-11	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-15 12:26:15.160646+05:30	HINDU	474006018304	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1298	1383	1	7	Kamaraj	M	23TD0687	Male	2005-11-19	AB+	Indian	OBC	\N	2023-2027	4	7	kamaraj23td0687@svcet.ac.in	Kamarajkalvi2005@gmail.com	8667087002	N.Mari muthu	8682958917	\N	s.Kalvi	9677383130	Business	96000.00	No.27, 5th Cross, kavi kuyil Nagar, Saram	\N	Puducherry	Pondicherry	605013	Alpha Matriculation Higher Secondary School	State Board	500.00	100.00	Alpha Matriculation Higher Secondary School	State Board	460.00	76.00	2023-08-18	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-15 12:29:03.222914+05:30	Hindu	985592640408	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1311	1396	1	8	Muckthar Ahamed	R	23TD0700	Male	2006-06-22	A1B +	Indian	OBC	\N	2023-2027	4	7	mucktharahamed23td0700@svcet.ac.in	\N	9150364212	Riyaz Ahamed A	9600970748	Driver	Shireen Banu	9629983052	House Wife	96000.00	No 5/a	Muslim Karumara Street, Nellikuppam	Cuddalore	Tamil Nadu	607105	Aristo Public School	CBSE	358.00	71.00	Aristo Public School	CBSE	321.00	64.00	2023-08-10	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-15 13:45:13.890814+05:30	Muslim	957824515310	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1274	1359	1	7	Danush Kumar	K	23TD0663	Male	2005-10-15	O+	Indian	obc	\N	2023-2027	4	7	danushkumar23td0663@svcet.ac.in	dkmrinfotobeyou@gmail.com	8072012095	krishnakumar S	9043004023	employee	meenakshi k	9043004024	-	200000.00	46, jayamnager	uruvaiyaru road	villianur	puducherry	605110	Jawahar Vidya Nikethan Hr Sec School	state bord	499.00	99.00	Achariya Siksha Mandir	state bord	299.00	50.00	2023-09-11	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:15:40.156286+05:30	hindu	531262965471	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1328	1413	1	7	Sathish	M	23TD0718	Male	2005-11-19	B+	Indian	OBC	\N	2023-2027	4	7	sathish23td0718@svcet.ac.in	\N	6384584029	MURUGAN	9894699816	\N	RAJAM	8940187206	nil	71999.00	6 Bajanai Koil Street 	Komakkam	Puducherry	Puducherry	605110	Theera Sathiya Moorthi Gov Higher Sce School	State Board	90.00	90.00	Jeevanandhan Govt Hrs Sec Schoole	statue board	435.00	72.00	2023-09-15	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:21:42.987601+05:30	Hindu	670431993091	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1264	1349	1	8	Abarna	S	23TD0652	Female	2006-02-06	A+	Indian	MBC	\N	2023-2027	4	7	abarna23td0652@svcet.ac.in	\N	8608418246	Subramanian.K	8608418246	-	Jagadeswari.S	9047772426	-	62000.00	no.17,kattabomman street,thirubuvanai,puducherry	no.17,kattabomman street,thirubuvanai,puducherry	Puducherry	puducherry	605107	Swami Vivekananda Higher secondary school	stateboard	500.00	100.00	Swami Vivekananda Higher secondary school	stateboard	407.00	67.00	2023-09-26	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:25:56.360845+05:30	HINDU	453961869083	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1272	1357	1	7	Atchaya	S	23TD0661	Female	2006-08-17	B+	Indian	OBC	\N	2023-2027	4	7	atchaya23td0661@svcet.ac.in	\N	9487881517	SENTHAMARAIKANNAN.A	7806826248	KOLLI	KAMALA.S	9791384568	HOUSEWIFE	75000.00	NO.50 V.S NAGAR,1ST MADUKARAI,PUDUCHERRY	\N	PUDUCHERRY	PUDUCHERRY	605105	V.S.R GOVT.GIRLS.HIGHER.SEC.SCHOOL	STATEBOARD	491.00	95.00	V.S.R GOVT.GIRLS.HIGHER.SEC.SCHOOL	STATEBOARD	365.00	67.00	2023-09-11	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:34:19.105875+05:30	HINDU	796983977830	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1419	1516	9	43	Test	Student73	45CD0173	Male	2006-06-01	B+	Indian	mbc 	\N	2026-2030	1	1	teststudent73@svcet.ac.in	\N	9294356066	Ragul 	9944750754	SDE 	Akshya	7090792063	house wife 	200000.00	zdmtrrrrrrrrmmmmm	arzjzdjh	puducherry 	puducherry 	605001	amalorapvam hr sec 	state	500.00	100.00	amalorpavam hr sec 	state 	545.00	85.00	2023-09-02	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:04:14.408877+05:30	Hindu 	123045678900	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1268	1353	1	8	Anisha	V	23TD0657	Female	2005-10-08	B+	Indian	MBC	\N	2023-2027	4	7	anisha23td0657@svcet.ac.in	\N	9944338783	Veliyappan.M	9944338783	\N	Muthalu.V	9751185942	\N	\N	3/114,Kalathumettu Street,Edayanchavadi, Auroville Post,605101	\N	Auroville 	Tamilnadu 	605101	Udavi Gentlilesse Matriculation HIgher Secondary School	State board	500.00	100.00	Kuyilappalayam 	State Board	521.00	87.00	2023-09-11	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 12:14:48.054799+05:30	Hindhu	593921076357	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1263	1348	1	8	Aarthi	A	23TD0651	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	aarthi23td0651@svcet.ac.in	\N	9843821523	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1273	1358	1	8	Bhuvaneshwaran	A	23TD0662	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	bhuvaneshwaran23td0662@svcet.ac.in	\N	8122831072	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1278	1363	1	8	Dhanush	V	23TD0667	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	dhanush23td0667@svcet.ac.in	\N	7449172464	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1281	1366	1	8	Dulasi Krishna	P	23TD0670	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	dulasikrishna23td0670@svcet.ac.in	\N	9566517608	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1284	1369	1	8	Ganesh	P	23TD0673	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	ganesh23td0673@svcet.ac.in	\N	7339682728	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1285	1370	1	8	Gokul	S	23TD0674	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	gokul23td0674@svcet.ac.in	\N	7010525792	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1289	1374	1	8	Harish Kumar	R	23TD0678	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	harishkumar23td0678@svcet.ac.in	\N	6369181504	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1301	1386	1	8	Kiruba Karan	V.	23TD0690	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	kirubakaran23td0690@svcet.ac.in	\N	9361104375	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1304	1389	1	8	Madhan	R	23TDL015	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	madhanarun12052004@gmail.com	\N	6379886946	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1308	1393	1	8	Mohamed Asif	M	23TD0696	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	mohamedasif23td0696@svcet.ac.in	\N	8610782815	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1292	1377	1	7	Janithaa	Kanagaraj	23TD0681	Female	2006-06-15	B+	Indian	MBC	\N	2023-2027	4	7	janithaa23td0681@svcet.ac.in	\N	9345847899	KANAGARAJ	8903050560	ACCOUNTANT	REVATHY	9360341036	HOUSE WIFE	75000.00	NO 4 SUBRAYAPILLAI STREET ARIYANKUPPAM PONDICHERRY	\N	PONDICHERRY	PONDICHERRY	605007	ADITYA VIDYASHRAMA	CBSE	341.00	69.00	AMRITA VIDYALAYAM	CBSE	345.00	69.00	2023-09-11	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:30:47.169819+05:30	Hindu	767200814285	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1288	1373	1	8	Harini	G	23TD0677	Female	2006-05-03	B+	Indian	MBC	\N	2023-2027	4	7	harini23td0677@svcet.ac.in	\N	7871177245	Gopu.k	9345411772	naturelandscope	Geetha.G	9344588711	housewife	150000.00	No 26 palla street chinna mudiliyaru chavady kottakuppam	No 26 palla street chinna mudiliyaru chavady kottakuppam	kottakuppam	Tamil nadu	605104	Alpha english higher secondary school	State board	390.00	78.00	Alpha english higher secondary school	State board	430.00	75.00	2023-06-08	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:34:33.114657+05:30	Hindu	569225182654	Day Scholar	BUS	6	f	\N	\N	\N	\N	\N
1334	1419	1	8	Sivasankar	A	23TD0724	Male	2006-08-22	B+	Indian	mbc	\N	2023-2027	4	7	sivasankar23td0724@svcet.ac.in	\N	7604858958	S adimoolam	9787709490	technician	sindhamani	8838928352	house wife	100000.00	no:9,smv puram,villianur,puducherry.	no:9,smv puram,villianur,puducherry.	villianur	puducherry	605110	ideal higher secondary school	state board	500.00	100.00	presidency higher secondary school	state board	433.00	73.00	2023-09-11	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:38:27.897481+05:30	hindu	429132633807	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1323	1408	1	8	Renuga	R	23TD0713	Female	2005-10-23	O+	Indian	Mbc	\N	2023-2027	4	7	renuga23td0713@svcet.ac.in	\N	9943787468	Ramamoorthy.J	6380926766	Driver	Latha.R	7598656521	HouseMaker	75000.00	No.24 , Subalakshmi nagar ,Pillaiyarkuppam,puducherry	No.221,Mariyamman kovil street,Koodapakkam post,Ammanankuppam.	Puducherry	puducherry	605502	Jawahar higher secondary school,Koodapakkam	Stateboard	500.00	100.00	Jawahar higher secondary school,Koodapakkam	Stateboard	383.00	65.00	2023-08-21	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:39:08.937085+05:30	Hindu	678454380279	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1266	1351	1	8	Anbarasi	M	23TD0655	Female	2005-12-15	O+	Indian	MBC	\N	2023-2027	4	7	anbarasi23td0655@svcet.ac.in	\N	9626580719	Manickam	9894617430	coolie	Valarmathi	0	employee	74999.00	3,Mahalakshmi Nagar ,Madagadipet palayam,puducherry	\N	Puducherry	India	605107	Government High School	State board	500.00	100.00	Kalaignar Karunanidhi Government Higher Secondary School	State board	533.00	90.00	2023-09-19	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:58:52.186544+05:30	HINDU	900598873917	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1316	1401	1	8	Partha Sarathi	S	23TD0705	Male	2005-07-16	B+	Indian	Bc	\N	2023-2027	4	7	parthasarathi23td0705@svcet.ac.in	imsarathi91@gmail.com	6385716831	Subramanian.R	6385716831	Farmer	Sumathi	9344393487	House wife	75000.00	1220,SAVADI STREET,VILANDAI,ANDIMADAM	\N	ARIYALUR	Tamil Nadu	621801	Government higher secondary school vilandai Andimadam Ariyalur Tamilnadu 	State Board 	100.00	100.00	Don Bosco higher secondary school Ariyalur Tamilnadu 	State Board	489.00	80.00	2023-05-09	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:57:42.202028+05:30	Hindu	289461795327	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1330	1415	1	8	Senthamizh	S	23TD0720	Female	2005-11-24	O+	Indian	MBC	\N	2023-2027	4	7	senthamizh23td0720@svcet.ac.in	\N	0	Selvakumar.L	9791465210	labour	Devi.S	9025027606	housewife	69999.00	48,Murugan kovil street,Madukarai	\N	puducherry	puducherry	605 105	venkata subba reddiar government girls higher secondary school	state board	500.00	100.00	venkata subba reddiar government girls higher secondary school	state board	600.00	68.00	2023-06-12	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 12:09:08.998107+05:30	Hindu	660486553909	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1347	1444	9	48	Test	Student1	45CD0101	Male	2006-06-04	AB-	Indian	mbc 	\N	2023-2027	4	7	teststudent1@svcet.ac.in	\N	9629618536	wg	21545313454	\N	GGwgwrgwg3w4g	1345434554345	\N	126541.00	HJ AG LQE HEQFI Hiop topJHW	\N	AWRHGW;KEHGL;	AWGLJW[OGH2J	605001	wgqahhhh	state 	500.00	75.00	akhwhbvlh	state 	500.00	311.00	2023-05-11	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:15:34.85866+05:30	hindu 	12456781234	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1618	1715	1	11	PRAVEEN	S	25TD0667	Male	2007-11-13	O+	Indian	MBC	\N	2025-2029	2	3	praveen25td0667@svcet.ac.in	\N	6385919427	saravanan	9789544484	Security 	thamizharasi	9789544484	House Wife 	75000.00	no.9,subramaniar koil st	kathirkamam	pondicherry	puducherry	605009	T.v.g.h.s.s	State 	392.00	78.40	j.g.hr.s.	cbse	398.00	66.30	2025-09-13	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:24:16.345097+05:30	Hindu 	499327678965	Day Scholar	OWN	\N	f	1	thirukumaran	9150559289	software engineer	guardian
1354	1451	9	48	Test	Student8	45CD0108	Male	2026-06-30	A+	Indian	bdasda	\N	2023-2027	4	7	teststudent8@svcet.ac.in	\N	6243243923	zsrt	1236457891	xdhseth	fgsrgsergeartg	37343	ASDFWE	25434534.00	zsrt	zsrt	zsrt	dsdasdas	556464	qedfQEF	WEFwef	500.00	22.00	WFWDFWDF	fwfwefwefqwef	500.00	22.00	2026-07-01	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:30:20.52617+05:30	wrgf	789654123	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1360	1457	9	49	Test	Student14	45CD0114	Female	2000-01-01	AB+	Indianasdf	asdf	\N	2023-2027	4	7	teststudent14@svcet.ac.in	\N	9679939857	asdfasdf	1236547890	\N	asdfasdf	1236547890	\N	\N	asdfasdf	\N	asdfasdf	asdfasdf	1023600	asdfasdfasd	asdfasdf	100.00	98.00	asdfasdf	asdfasdf	100.00	100.00	2000-02-05	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:28:43.443701+05:30	asdf	1236547890	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1315	1400	1	8	Padhrinath	G	23TD0704	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	padhrinath23td0704@svcet.ac.in	\N	8610964755	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1317	1402	1	8	Pavithra	K	23TD0706	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	pavithra23td0706@svcet.ac.in	\N	8838125042	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1318	1403	1	8	Prakashraj	S	23TD0707	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	prakashraj23td0707@svcet.ac.in	\N	9787927236	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1324	1409	1	8	Roshekaa	R	23TD0714	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	roshekaa23td0714@svcet.ac.in	\N	8754667262	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1329	1414	1	8	Sathya	J	23TD0719	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	sathya23td0719@svcet.ac.in	\N	9176278368	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1332	1417	1	8	Sharanshanth	R	23TD0722	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	sharanshanth23td0722@svcet.ac.in	\N	9751459967	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1333	1418	1	8	Sivaranjani	K	23TD0723	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	sivaranjani23td0723@svcet.ac.in	\N	9790511446	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1336	1421	1	8	Sriram	I	23TD0726	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	sriram23td0726@svcet.ac.in	\N	7358947720	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1338	1423	1	8	Swetha	R	23TD0728	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	swetha23td0728@svcet.ac.in	\N	8940138478	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1349	1446	9	48	Test	Student3	45CD0103	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	teststudent3@svcet.ac.in	\N	6570120319	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 14:55:49.467161+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1352	1449	9	48	Test	Student6	45CD0106	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	teststudent6@svcet.ac.in	\N	9226885878	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 14:55:49.467161+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1356	1453	9	48	Test	Student10	45CD0110	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	teststudent10@svcet.ac.in	\N	9013445517	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 14:55:49.467161+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1357	1454	9	49	Test	Student11	45CD0111	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	teststudent11@svcet.ac.in	\N	7053899257	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 14:58:36.252719+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1358	1455	9	49	Test	Student12	45CD0112	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	teststudent12@svcet.ac.in	\N	6474026167	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 14:58:36.252719+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1784	1908	4	\N	VISHAL	K	25TJ0072	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	vishal25tj0072@svcet.ac.in	\N	7010172991	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1319	1404	1	7	Pushparaj	E	23TD0708	Male	2006-01-30	B-	Indian	BC	\N	2023-2027	4	7	pushparaj23td0708@svcet.ac.in	pushparajsound123@gmail.com	9566953541	M.Ezhumalai	6369758118	Heavy driver 	E.Santhi	8807205291	Home Maker	80000.00	No:170,West street,T.Gopurapuram, Virudhachalam ,Cuddalore,Tamil Nadu-606003	No:35, MGR street, jeevanandapuram, lawspet, Puducherry 	Puducherry 	Puducherry 	605008	Fatima Higher Secondary School 	State Board 	500.00	100.00	Fatima Higher Secondary School 	State Board 	410.00	69.00	2023-09-11	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:32:39.983384+05:30	Hindu 	904709195852	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1297	1382	1	8	Kalaivanan	L	23TD0686	Male	2000-01-01	A+	Indian	OBC	\N	2023-2027	4	7	kalaivanan23td0686@svcet.ac.in	\N	0	Father	1234567890	Business	Mother	0987654321	Housewife	100000.00	123 Main St	\N	Pondicherry	Puducherry	605001	School A	State Board	400.00	80.00	School B	State Board	1000.00	85.00	2020-01-01	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:44:45.662248+05:30	Hindu	123456789012	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1417	1514	9	43	Test	Student71	45CD0171	Male	2026-06-29	A-	Indian	OBC	\N	2026-2030	1	1	teststudent71@svcet.ac.in	\N	6025447030	Rajan.T	9787679136	Busisnness	Balathanga Valli	6383262279	Business	1500000.00	No.12,Ponniamman Kovil Street ,	\N	Puducherry	Puducherry	605008	Aditya Vidyashram residential school	CBSE	500.00	100.00	Aditya Vidyashram residential school	CBSE	500.00	100.00	2026-07-08	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 11:46:46.305084+05:30	Hindu	711752629672	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1378	1475	9	47	Test	Student32	45CD0132	Male	2006-07-16	B+	Indian	OBC	\N	2024-2028	3	5	teststudent32@svcet.ac.in	\N	7011235385	MURUGAN	9894699816	textstyle shop	RAJAM	8940187206	house wife	100000.00	6 Bajanai Koil Street 	\N	Puducherry	Puducherry	605 107	Theera Sathiya Moorthi Gov Higher Sce School	State Board	500.00	100.00	Jeevanandhan Govt Hrs Sec Schoole	statue board	484.00	80.00	2023-10-16	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:31:21.928811+05:30	Hindu	670431993091	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1430	1527	9	\N	dfsadfs	fsdafsadf	23td0732	\N	\N	\N	Indian	\N	\N	2026-2030	2	3	ashwinoff2@gmail.com	\N	123456789	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-18 12:20:18.516713+05:30	2026-07-18 12:31:20.157518+05:30	\N	\N	\N	\N	\N	f	9	\N	\N	\N	\N
1418	1515	9	43	Test	Student72	45CD0172	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent72@svcet.ac.in	\N	9323202010	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:28:16.915277+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1387	1484	9	44	Test	Student41	45CD0141	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent41@svcet.ac.in	\N	8170372545	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1388	1485	9	44	Test	Student42	45CD0142	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent42@svcet.ac.in	\N	7464771663	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1389	1486	9	44	Test	Student43	45CD0143	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent43@svcet.ac.in	\N	7911721384	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1390	1487	9	44	Test	Student44	45CD0144	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent44@svcet.ac.in	\N	9420543122	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1391	1488	9	44	Test	Student45	45CD0145	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent45@svcet.ac.in	\N	9707406734	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1392	1489	9	44	Test	Student46	45CD0146	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent46@svcet.ac.in	\N	9453767910	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1393	1490	9	44	Test	Student47	45CD0147	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent47@svcet.ac.in	\N	8197766249	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1397	1494	9	45	Test	Student51	45CD0151	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent51@svcet.ac.in	\N	6374027930	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1398	1495	9	45	Test	Student52	45CD0152	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent52@svcet.ac.in	\N	6971662176	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1399	1496	9	45	Test	Student53	45CD0153	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent53@svcet.ac.in	\N	9735973695	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1400	1497	9	45	Test	Student54	45CD0154	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent54@svcet.ac.in	\N	6544508939	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1401	1498	9	45	Test	Student55	45CD0155	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent55@svcet.ac.in	\N	8934097707	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1402	1499	9	45	Test	Student56	45CD0156	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent56@svcet.ac.in	\N	8441754863	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1403	1500	9	45	Test	Student57	45CD0157	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent57@svcet.ac.in	\N	6195589842	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1404	1501	9	45	Test	Student58	45CD0158	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent58@svcet.ac.in	\N	8323425100	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1405	1502	9	45	Test	Student59	45CD0159	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent59@svcet.ac.in	\N	9431877000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1406	1503	9	45	Test	Student60	45CD0160	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent60@svcet.ac.in	\N	9107479202	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:14.956213+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1367	1464	9	46	Test	Student21	45CD0121	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent21@svcet.ac.in	\N	6443909195	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:59.185118+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1368	1465	9	46	Test	Student22	45CD0122	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent22@svcet.ac.in	\N	9478439065	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:59.185118+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1369	1466	9	46	Test	Student23	45CD0123	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent23@svcet.ac.in	\N	7530262356	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:59.185118+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1370	1467	9	46	Test	Student24	45CD0124	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent24@svcet.ac.in	\N	8264898460	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:59.185118+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1373	1470	9	46	Test	Student27	45CD0127	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent27@svcet.ac.in	\N	6487742613	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:59.185118+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1374	1471	9	46	Test	Student28	45CD0128	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent28@svcet.ac.in	\N	7214648512	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:59.185118+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1375	1472	9	46	Test	Student29	45CD0129	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent29@svcet.ac.in	\N	7396159295	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:59.185118+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1377	1474	9	47	Test	Student31	45CD0131	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent31@svcet.ac.in	\N	7237215641	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:31:33.331409+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1379	1476	9	47	Test	Student33	45CD0133	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent33@svcet.ac.in	\N	6960911798	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:31:33.331409+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1380	1477	9	47	Test	Student34	45CD0134	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent34@svcet.ac.in	\N	7033445664	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:31:33.331409+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1381	1478	9	47	Test	Student35	45CD0135	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent35@svcet.ac.in	\N	9941070948	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:31:33.331409+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1382	1479	9	47	Test	Student36	45CD0136	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent36@svcet.ac.in	\N	7865613948	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:31:33.331409+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1383	1480	9	47	Test	Student37	45CD0137	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent37@svcet.ac.in	\N	7055161136	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:31:33.331409+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1384	1481	9	47	Test	Student38	45CD0138	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent38@svcet.ac.in	\N	6270425802	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:31:33.331409+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1385	1482	9	47	Test	Student39	45CD0139	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent39@svcet.ac.in	\N	8996027928	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:31:33.331409+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1327	1412	1	7	Sathish	K	23TD0717	Male	2005-09-16	A+	Indian	OBC	\N	2023-2027	4	7	sathish23td0717@svcet.ac.in	\N	8300863595	KUMAR	9790787176	COOLI	LATHA	8300863595	COOLI	72000.00	69,3RD CROSS,ANBU NAGAR,OTHIYAMPET,VILLIANUR,PUDCHERRY	\N	VILLIANUR	PUDUCHERRY	605110	GALAXY ENGLISH HIGH SCHOOL	STATE BOARD	401.00	80.00	SRI SANKARS VIDHYALAYA HR SEC SCHOOL	STATE BOARD	456.00	76.00	2023-09-13	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-15 12:14:36.563453+05:30	HINDHU	443198500195	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1340	1425	1	7	Vigneshwaran	V	23TD0730	Male	2005-06-02	O+	Indian	OBC(General)	\N	2023-2027	4	7	vigneshwaran23td0730@svcet.ac.in	vignesh.tech.v@gmail.com	8754984330	M.Vengadesan	9751830665	Two Wheeler Consulting Works	V.Kumari	9751830665	Teacher	77000.00	No:48,2nd Cross,Ambedkar Nagar.Muthialpet	No:02,4th Cross,Ganesh Nagar,Muthialpet	Puducherry	Puducherry	605003	Fatime.Higher.Secondary.Schoool,Karuvadikuppum,Puducherry	State Board	100.00	100.00	Fatime.Higher.Secondary.Schoool,Karuvadikuppum,Puducherry	State Board	403.00	76.10	2023-09-11	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 15:46:51.338052+05:30	Hindu	845815946730	Day Schoolllllrrrr	BUS	20	f	\N	\N	\N	\N	\N
1310	1395	1	7	Mohammed Aaqil	M	23TD0699	Male	2006-06-12	O+	Indian	MBC	\N	2023-2027	4	7	mohammedaaqil23td0699@svcet.ac.in	\N	9384917277	Mohamad Anas R	9626197277	Business Man	Najira Kani M	8608581439	House Wife	74998.00	No:6 New Street Sulthanpet Villianur	\N	Puducherry	Puducherry	605110	Raak Internatioinal School	State Board	500.00	100.00	Raak International Higher Secondary School	State Board	289.00	48.00	2023-09-11	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-15 12:24:23.648719+05:30	Muslim	586974048551	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1649	1746	1	11	YAAGESH PRIYAN	M	25TD0698	Male	2006-11-22	O-	Indian	MBC	\N	2025-2029	2	3	yaageshpriyan25td0698@svcet.ac.in	\N	9360868917	S.MURUGAN	9865474748	FARMER	S.VASANTHI	9786666860	HOME MAKER	84000.00	1/157,KALIYAMMAN KOVIL SREET,Ariyalur(Villupuram),POST:KANDAMANADI,DIST:Villupuram,KANDAMANADI,VILLUPURAM,TAMIL NADU-605401.	\N	VILLUPURAM	TAMIL NADU	605401	Ramakrishna Mission Vidyalaya Matric scool	STATE BOARD	284.00	56.80	VRP HIHGER SEC SCHOOL	STATE BOARD 	555.00	92.50	2025-09-20	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:15:35.940879+05:30	HINDU	679798060862	Day Scholar	BUS	35	f	1	\N	\N	\N	mother
1293	1378	1	7	Jasra	Farveen	23TD0682	Female	2006-08-28	O+	Indian	BC	\N	2023-2027	4	7	jasrafarveen23td0682@svcet.ac.in	\N	7395934622	M.I.Jamal Mohamed	9790528461	Sales Executer	J.Nasrin Banu	8838422749	Housewife	240000.00	No 67,Big Street,Kottakuppam	No 67,Big Street,Kottakuppam	Kottakuppam	Tamil Nadu	605104	Amalorpavam Higher Secondary School	State Board	425.00	85.00	Amalorpavam Higher Secondary School	State Board	442.00	74.00	2023-07-13	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:33:51.614874+05:30	Muslim	330194821661	Day Scholar	BUS	20	f	\N	\N	\N	\N	\N
1337	1422	1	7	Srivardhini	D	23TD0727	Female	2005-12-07	O+	Indian	MBC	\N	2023-2027	4	7	srivardhini23td0727@svcet.ac.in	\N	8825786849	Devanathan.R	9788080944	Farmer	Jayanthi.D	8220075185	HouseWife	74998.00	No.63, Main Road,Thookkanampakkam,Cuddalore	\N	Cuddalore	Tamilnadu	607402	Krishnasamy Memorial Marticulation Higher Secondary School	State Board	500.00	100.00	Krishnasamy Memorial Marticulation Higher Secondary School	State Board	444.00	72.00	2023-09-15	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:34:30.963293+05:30	Hindhu	856271105714	Day Scholar	BUS	33	f	\N	\N	\N	\N	\N
1265	1350	1	7	Abinaya	V	23TD0654	Female	2006-07-20	A+	Indian	OBC	\N	2023-2027	4	7	abinaya23td0654@svcet.ac.in	\N	9751830030	M.Venu	7904371923	Business	V.Rathika	6380988011	House Maker	100000.00	No.54, Main Road, Ariyur, Puducherry	\N	Puducherry	Puducherry	605 102	St.Joseph of Cluny Girls Higher Secondary School	State Board	500.00	100.00	St.Joseph of Cluny Girls Higher Secondary School	State Board	465.00	78.00	2023-09-11	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 12:04:17.213911+05:30	Hindu	784503785503	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1785	1909	4	\N	VITHIYASRI	J	25TJ0073	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	vithiyasri25tj0073@svcet.ac.in	\N	8870599658	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1786	1910	4	\N	YOHESWARAN	S	25TJ0074	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	yoheswaran25tj0074@svcet.ac.in	\N	8825861761	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1269	1354	1	7	Arish Kumar	K	23TD0658	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	arishkumar23td0658@svcet.ac.in	\N	9655321915	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1270	1355	1	7	Ashwin	C	23TD0659	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	ashwin23td0659@svcet.ac.in	\N	9514269546	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1500	1597	1	10	Priyanka	S	24TD0820	Female	2007-05-26	A1+ve	Indian	OBC	\N	2024 -2028	3	5	priyanka24td0820@svcet.ac.in	\N	7094574553	Sithanandam.K	9944759889	retired officer	Latha.S	\N	\N	74999.00	no 22 balaji street jeevanandapuram lawspet puducherry	\N	Puducherry	Puducherry	605008	Don bosco matriculation higher secondary school	Stateboard	349.00	70.00	Immaculate Heart of Mary Girls Higher Secondary School	Sateboard	396.00	66.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:25:00.380791+05:30	Hindu	727022411372	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1275	1360	1	7	Deepalakshmi	G	23TD0664	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	deepalakshmi23td0664@svcet.ac.in	\N	8072671878	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1279	1364	1	7	Dharshani	S	23TD0668	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	dharshani23td0668@svcet.ac.in	\N	9500567340	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1282	1367	1	7	Faizal Mohamed	P	23TD0671	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	faizalmohamed23td0671@svcet.ac.in	\N	9043415980	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1286	1371	1	7	Hariharan	A	23TD0675	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	hariharan23td0675@svcet.ac.in	\N	7418118302	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1287	1372	1	7	Harikrishnan	S	23TD0676	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	harikrishnan23td0676@svcet.ac.in	\N	9994342911	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1290	1375	1	7	Harishraj	V	23TD0679	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	harishraj23td0679@svcet.ac.in	\N	8248003427	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1295	1380	1	7	Jeevaraajan	S	23TD0684	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	jeevaraajan23td0684@svcet.ac.in	\N	9042377061	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1302	1387	1	7	Krishna	S	23TD0691	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	krishna23td0691@svcet.ac.in	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1303	1388	1	7	Madhan	R	23TD0692	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	madhan23td0692@svcet.ac.in	\N	8838272726	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1306	1391	1	7	Mahesh	V	23TD0694	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	mahesh23td0694@svcet.ac.in	\N	9342416294	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1307	1392	1	7	Manoj	V	23TD0695	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	manoj23td0695@svcet.ac.in	\N	7092894113	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1313	1398	1	7	Nandhakumar	B	23TD0702	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	nandhakumar23td0702@svcet.ac.in	\N	7845250907	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1321	1406	1	7	Rama	S	23TD0710	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	rama23td0710@svcet.ac.in	\N	7010661639	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1322	1407	1	7	Ranjith	S	23TD0712	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	ranjith23td0712@svcet.ac.in	\N	9345663424	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1325	1410	1	7	Sabreen	S	23TD0715	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	sabreen23td0715@svcet.ac.in	\N	9514789578	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1339	1424	1	7	Thulasimani	V	23TD0729	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	thulasimani23td0729@svcet.ac.in	\N	9940950791	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1291	1376	1	7	Hemachandran	G	23TD0680	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	hemachandran23td0680@svcet.ac.in	\N	9443560381	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-18 13:54:48.835352+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1343	1428	1	7	Vithya Sakar	S	23TD0733	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	vithyasakar23td0733@svcet.ac.in	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1346	1431	1	7	Yuvasree	P	23TD0736	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	yuvasree23td0736@svcet.ac.in	\N	9345822450	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:11:22.298408+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1314	1399	1	8	Nikilesh Yogan	G	23TD0703	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	nikileshyogan23td0703@svcet.ac.in	\N	8610480592	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:41:58.371248+05:30	2026-07-14 12:12:20.478497+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1407	1504	9	42	Test	Student61	45CD0161	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent61@svcet.ac.in	\N	6651661289	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1408	1505	9	42	Test	Student62	45CD0162	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent62@svcet.ac.in	\N	9697434129	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1409	1506	9	42	Test	Student63	45CD0163	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent63@svcet.ac.in	\N	8473011611	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1410	1507	9	42	Test	Student64	45CD0164	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent64@svcet.ac.in	\N	6692789039	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1411	1508	9	42	Test	Student65	45CD0165	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent65@svcet.ac.in	\N	7286093864	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1412	1509	9	42	Test	Student66	45CD0166	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent66@svcet.ac.in	\N	9845122449	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1413	1510	9	42	Test	Student67	45CD0167	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent67@svcet.ac.in	\N	8241113889	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1414	1511	9	42	Test	Student68	45CD0168	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent68@svcet.ac.in	\N	8343210528	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1415	1512	9	42	Test	Student69	45CD0169	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent69@svcet.ac.in	\N	9472925904	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1416	1513	9	42	Test	Student70	45CD0170	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent70@svcet.ac.in	\N	8058174032	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:27:38.701025+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1795	1919	2	\N	DHARSHINI	S	24TC0559	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	dharshini24tc0559@svcet.ac.in	\N	9487366115	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1420	1517	9	43	Test	Student74	45CD0174	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent74@svcet.ac.in	\N	7941939540	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:28:16.915277+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1796	1920	2	\N	DHINESH BHARATHI	A	24TC0560	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	dhineshbharathi24tc0560@svcet.ac.in	\N	9080157691	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1422	1519	9	43	Test	Student76	45CD0176	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent76@svcet.ac.in	\N	9041555155	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:28:16.915277+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1423	1520	9	43	Test	Student77	45CD0177	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent77@svcet.ac.in	\N	9515722099	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:28:16.915277+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1424	1521	9	43	Test	Student78	45CD0178	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent78@svcet.ac.in	\N	6377925753	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:28:16.915277+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1425	1522	9	43	Test	Student79	45CD0179	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent79@svcet.ac.in	\N	7662127165	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:28:16.915277+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1426	1523	9	43	Test	Student80	45CD0180	\N	\N	\N	Indian	\N	\N	2026-2030	1	1	teststudent80@svcet.ac.in	\N	9038208133	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:28:16.915277+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1394	1491	9	44	Test	Student48	45CD0148	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent48@svcet.ac.in	\N	6727607172	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1395	1492	9	44	Test	Student49	45CD0149	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent49@svcet.ac.in	\N	6890248912	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1396	1493	9	44	Test	Student50	45CD0150	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	teststudent50@svcet.ac.in	\N	7174146308	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:29:28.748667+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1376	1473	9	46	Test	Student30	45CD0130	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	teststudent30@svcet.ac.in	\N	7064866752	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 12:30:59.185118+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1436	1533	1	9	Ajai	I	24TD0754	Male	2007-12-01	B+	Indian	obc	\N	2024 -2028	3	5	ajai24td0754@svcet.ac.in	\N	7804953781	iyannarappan V	7362135125	teacher	sumathi N	8124186113	teacher	300000.00	mariamman nagar	 karamanikuppam puducherry	pondicherry	pondicherry	605004	alpha matriculation hr sec school	state board	321.00	64.00	presidency hr sec school	state board	403.00	64.00	2024-12-09	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:03:16.027111+05:30	hindu	55386473890	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1362	1459	9	49	Test	Student16	45CD0116	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	teststudent16@svcet.ac.in	\N	9112253102	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 14:58:36.252719+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1363	1460	9	49	Test	Student17	45CD0117	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	teststudent17@svcet.ac.in	\N	7252294716	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 14:58:36.252719+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1364	1461	9	49	Test	Student18	45CD0118	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	teststudent18@svcet.ac.in	\N	6663503017	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 14:58:36.252719+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1365	1462	9	49	Test	Student19	45CD0119	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	teststudent19@svcet.ac.in	\N	7482775505	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-14 11:54:38.483082+05:30	2026-07-14 14:58:36.252719+05:30	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N
1344	1429	1	8	Yogesh	M	23TD0734	Male	2005-07-19	O-	Indian	OBC	\N	2023-2027	4	7	yogesh23td0734@svcet.ac.in	\N	6381616364	MUGUNTHAN K	9159382017	BUSINESS MAN	SUMATHI S	8778767719	TEACHER	74998.00	N0:14(3)K.K.NAGER, KURINJIPADI, CUDDALORE,607302	NO:14(3)K.K.Nager,Kurinjipadi,Cuddalore,607302	Cuddalore	Tamil nadu	607302	SILVER JUBILEE Matric.hr.sec.school (TARGET)	STATE BOARD	500.00	100.00	Raj Matric.hr.sec.school	STATE BOARD	369.00	66.00	2023-09-07	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-15 12:15:22.572686+05:30	Hindu	201941988857	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1299	1384	1	8	Karthikeyan	R	23TD0688	Male	2005-11-08	A+	Indian	MBC	\N	2023-2027	4	7	karthikeyan23td0688@svcet.ac.in	karthikeyanragupathi08@gmail.com	6374990548	Raghupati 	9042495161	Line Instructor Py EB	Kavimani.R	8098433285	House Wife	1200000.00	Old No.32,New No.4, Throwpathi amman koil thittu 	MURUNGAPAKKAM	PUDUCHERRY	Puducherry	605004	Amalorpavam High Secondary school 	Tamilnadu State Board 	100.00	100.00	Amalorpavam Higher Secondary school 	State Board 	404.00	67.00	2026-08-19	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:35:26.601578+05:30	Hindu	641896151317	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1341	1426	1	8	Vijay Vel	R.S	23TD0731	Male	2006-05-31	B+	Indian	BC	\N	2023-2027	4	7	vijayavel23td0731@svcet.ac.in	\N	9677425001	Saravanan 	8344237470	Weaver 	Revathi 	8344237470	House wife 	48000.00	1247,savadi street 	\N	Andimadam, Ariyalur [ DT]	Tamil Nadu 	621 801	Don Bosco Higher secondary school, V-pet 	State Board 	500.00	100.00	Don Bosco Higher secondary school, V-pet 	State Board 	453.00	75.50	2023-05-12	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:43:06.504077+05:30	Hindu 	625260554701	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1320	1405	1	7	Ragul	A	23TD0709	Male	2006-06-07	B+	Indian	MBC	\N	2023-2027	4	7	ragul23td0709@svcet.ac.in	\N	9952003765	Arumugasamy K	9025883755	Security 	Soumathi A 	9952003765	House Wife 	120000.00	Jeiram Chettiyar Thottam Second Cross	Puducherry	Puducherry	Puducherry	605001	Amalorpavam Hr. Sec. School 	State 	500.00	100.00	Amalorpavam Hr. Sec. School 	State 	430.00	72.00	2023-09-11	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:55:44.952989+05:30	Hindu 	784514291393	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1345	1430	1	8	Yuvasree	G	23TD0735	Female	2006-01-26	AB+	Indian	MBC	\N	2023-2027	4	7	yuvasree23td0735@svcet.ac.in	\N	9092672345	K.Gajendiran	9843672345	FPS Works	G.Rajalakshmi	9843122345	Home Maker	70.00	27,mariamman kovil street Manakuppam	\N	Puducherry	Puducherry	605106	Swami Vivekanandha Vidhyalaya higher Secondary School ,Manakuppam	State Board	500.00	100.00	Swami Vivekanandha Vidhyalaya higher Secondary School ,Manakuppam	State Board	600.00	64.00	2023-07-24	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:57:03.728641+05:30	Hindu	841115790227	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1267	1352	1	7	Angelin Jelis	S	23TD0656	Female	2005-10-31	O-	Indian	OBC	\N	2023-2027	4	7	angelinjelis23td0656@svcet.ac.in	\N	9514011417	Savarimuthu A	9585128422	Company Worker	Cecily Selva Priya S	9585308356	House Wife	200000.00	No:14,Thamarai Nagar,2nd Cross Street,Ariyur,Puducherry	No:14,Thamarai Nagar,2nd Cross Street,Ariyur,Puducherry	Puducherry	Puducherry	605102	Sri Ramachandra Vidhyalaya High School	State Board	500.00	100.00	Blue Stars Higher Secondary School	State Board	507.00	85.00	2023-09-11	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 12:04:12.879408+05:30	CHRISTIAN	578067920439	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1350	1447	9	48	Test	Student4	45CD0104	Male	2012-12-12	AB+	Indian	bc	\N	2023-2027	4	7	teststudent4@svcet.ac.in	\N	8266978842	zsrt	1236457891	xdhseth	fgsrgsergeartg	124567896	ASDFWE	100000.00	zsrt	zsrt	zsrt	zset	zset	qedfQEF	WEFwef	499.00	99.00	WFWDFWDF	fwfwefwefqwef	599.00	99.00	2024-01-01	MANAGEMENT	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:14:14.413014+05:30	wrgf	dtydrymestet	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1628	1725	1	11	SAKTHIVEL	M	25TD0677	Male	2008-02-06	O+	Indian	OBC	\N	2025-2029	2	3	sakthivel25td0677@svcet.ac.in	\N	7639883254	manikandan	7639883254	business	govindhamal	9047786231	Housewife	75000.00	no22,kattamanikuppam,muthialpet,puducherry	\N	puducherry	puducherry	605003	sri anivandhar higher secondary school	State Board	317.00	63.40	sri anivandhar higher secondary school	417	417.00	69.50	2025-07-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:16:03.752228+05:30	Hindu	855434274565	Day Scholar	BUS	20	f	1	\N	\N	\N	mother
1635	1732	1	11	SHYAM	S	25TD0684	Male	2007-12-18	B-	Indian	sc	\N	2025-2029	2	3	shyam25td0684@svcet.ac.in	\N	9159455321	subramani	8072410970	decoration	Elakkanni	9159455321	\N	75000.00	no.15 lazar kovil street, duparapet,puducherry	\N	puducherry	Puducherry	600501	sathyalayam higher secondary school	State Board	285.00	57.00	FATIMA HIGHER SECONDARY SCHOOL	State Board	346.00	58.00	2025-08-19	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:27:18.676689+05:30	Hindu	24368879611	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1631	1728	1	11	SEDHUMADHAVAN	P	25TD0680	Male	2008-04-06	B-	Indian	bc	\N	2025-2029	2	3	sedhumadhavan25td0680@svcet.ac.in	\N	7845380377	perumal.k	9047516040	farmer	vasantha.p	9360216040	homemaker	100000.00	1\\134,pillyar kovil street,	arpisamplayam	villupuram	tamilnadu	605108	Holy Flowers Hr Sec School	state board	306.00	60.00	Holy Flowers Hr Sec School	state board	408.00	65.00	2025-09-22	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:29:45.602844+05:30	hindu	247654297562	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1620	1717	1	11	PRIYAMATHI	V	25TD0669	Female	2007-05-26	B+	Indian	MBC	\N	2025-2029	2	3	priyamathi25td0669@svcet.ac.in	\N	9944644688	E.vengatesan	9944813899	Police of tamil nadu(cbcid)	V.sri devi	9944644688	House Wife 	100000.00	48,singaravel nagar 	vandipalayam	cuddalore	tamil nadu	607002	arlm school ,cuddalore	state board	389.00	62.00	Green tech	State 	402.00	67.00	2025-11-15	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:33:47.512649+05:30	Hindu 	588886945122	Day Scholar	BUS	30	f	1	\N	\N	\N	father
1271	1356	1	7	Aswin	T	23TD0660	Male	2005-07-30	A+	Indian	OBC	\N	2023-2027	4	7	aswin23td0660@svcet.ac.in	\N	8754681696	Thangamani T	7502970696	Business	Vetrivel 	6383016136	House Wife	99999.00	No 22 Bharathi Street Jeevanandhapuram Lawspet Puducherry	\N	Puducherry	Puducherry	605008	Amalorpavam Higher Secondary School	State Board	360.00	72.00	Amalorpavam Higher Secondary School	State Board	488.00	81.00	2023-09-01	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-23 14:34:20.767872+05:30	Hindu	249961472752	Day Scholar	BUS	8	f	\N	\N	\N	\N	father
1644	1741	1	11	VIJAYA	V	25TD0693	Female	2007-01-02	B+	Indian	obc	\N	2025-2029	2	3	vijaya25td0693@svcet.ac.in	\N	9344241078	vaithiyanathan	\N	\N	vanitha	8883707841	tailor	75000.00	thirukumarn street,radha krishnan nagar,meenachipet,puducherry605009	\N	puducherry	Puducherry	605009	girls govt higher secondary school	state board	336.00	66.00	girls govt higher secondary school	cbse	314.00	67.00	2025-08-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:34:28.134733+05:30	hindu	450986628878	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1597	1694	1	11	KRISHA	L	25TD0646	Female	2008-03-14	B+	Indian	mbc	\N	2025-2029	2	3	krisha25td0646@svcet.ac.in	\N	8220951650	j.logesh	9629528527	fisherman	l.selvi	9790566823	house wife	100000.00	no.5 marakanam anumandai ellaiamman kovil street	\N	villupuram	tamilnadu	605102	marakanam govt school	STATE BOARD	360.00	65.00	marakanam govt school	STATE BOARD	478.00	79.00	2025-07-09	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:35:46.281652+05:30	Hindu	0	Day Scholar	BUS	24	f	1	\N	\N	\N	father
1283	1368	1	7	Ganesan	K	23TD0672	Male	2006-05-16	AB+	Indian	BC	\N	2023-2027	4	7	ganesan23td0672@svcet.ac.in	\N	9787069411	Kumarakurubaran	9865433233	Weaver	Mangaiyarkarasi	8903646323	House wife	60000.00	3/132a,Gandhi nagar, sendhurai	\N	Ariyalur	Tamil Nadu	621714	Govt.Hr.Sec.School	state board	100.00	100.00	Govt.Hr.Sec.School	state board	464.00	77.00	2023-09-13	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-23 14:44:08.227609+05:30	Hind	893493018580	Hostel	OWN	\N	f	\N	\N	\N	\N	father
1627	1724	1	50	SAKTHI	M	25TD0676	Male	2008-02-16	O+	Indian	MBC	\N	2025-2029	2	3	sakthi25td0676@svcet.ac.in	alliuscaesar7@gmail.com	9363768084	MURUGAN S	9444877680	VIDEO GRAPHER	HEMALATHA Y	8300461422	EMPLOYEE	100000.00	NO-05,ANNA STREET,SHANMUGAPURAM	\N	PUDUCHERRY	PUDUCHERRY	605009	SEVENTH DAY ADVENTIST HIGHER SECONDARY SCHOOL	STATE BOARD	425.00	85.00	SEVENTH DAY ADVENTIST HIGHER SECONDARY SCHOOL	STATE BOARD	454.00	75.67	2025-09-19	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:57:48.664958+05:30	Hindu	741765879033	Day Scholar	BUS	37	f	1	\N	\N	\N	mother
1567	1664	1	50	DHIVYA DHARSHINI	S	25TD0616	Female	2008-02-27	B+	Indian	mbc	\N	2025-2029	2	3	dhivyadharshini25td0616@svcet.ac.in	dhivyadharshini1569@gmail.com	9150158927	Selvakumar	9943767304	driver	Dhanalakshmi	9489005266	house wife	70000.00	no.4 municipality street,pims road	kanapathichettikulam	Puducherry	puducherry	605014	MOH Farook Maricar Government Girls higher secondary school,kalapet	STATE BOARD	424.00	84.60	MOH Farook Maricar Government Girls higher secondary school,kalapet	CBSE	417.00	60.00	2025-09-19	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:00:20.655739+05:30	Hindu	906767516521	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1511	1608	1	10	Sanjay	S	24TD0831	Male	2006-09-03	O+	Indian	MBC	\N	2024 -2028	3	5	sanjay24td0831@svcet.ac.in	\N	8903740209	sakthivel	9092731819	labour	maheshwari	8940121080	home maker	72000.00	no.14, 3rd cross street ,thamarai nagar,ariyur, puducherry	no.14, 3rd cross street ,thamarai nagar,ariyur, puducherry	puducherry	puducherry	605 102	shri hindocha charitable trust higher secondary school ,ariyur, puducherry	stateboard	269.00	53.80	jeevanandham government higher secondary school,karamanikuppam,puducherry	stateboard	421.00	70.10	2024-09-06	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:00:21.887302+05:30	Hindu	500767080304	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1566	1663	1	50	DHIVIYA	I	25TD0615	Female	2007-10-23	O+	Indian	mbc	\N	2025-2029	2	3	dhiviya25td0615@svcet.ac.in	shridhiviya56@gmail.com	8925255039	Iyappan	9943872639	Rection works 	Sivashanthi 	8925255039	Housewife	100000.00	315,kombakkam,odhiampet,villianur main road 	\N	Puducherry	Tamilnadu	604303	government higher secondary school	state board 	438.00	87.60	government higher secondary school	state board	440.00	73.30	2026-09-17	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:04:24.663783+05:30	HINDU	212836398902	Day Scholar	BUS	25	f	1	\N	\N	\N	father
1743	1840	6	\N	JAIAKASH	D	25TK0053	Male	2007-10-19	B+	Indian	MBC	\N	2025-2029	2	3	jaiakash25tk0053@svcet.ac.in	jaiakash1910@gmail.com	9585349099	dhananjayan	9943539888	BUSSINESS	kaLAIVANY	9626806353	housewife	\N	34,mailam road 	silukkaripalayam	Pondicherry	Puducherry	605107	BRAINY BLOOMS 	CBSE	291.00	58.20	BRAINY BLOOMS 	CBSE	336.00	67.20	2025-08-18	CENTAC	t	2026-07-22 11:21:56.354334+05:30	2026-07-23 15:39:09.103921+05:30	hindu	811836427513	Day Scholar	OWN	\N	f	6	\N	\N	\N	father
1499	1596	1	9	Priyanka	S	24TD0819	Female	2006-09-22	A-	Indian	obc	\N	2024 -2028	3	5	priyanka24td0819@svcet.ac.in	priyankastalin22@gmail.com	7825095829	C.Stalin	9843167474	Tiles Worker	S.Jayalakshmi	7539920910	House wife	120000.00	No:8A 	Lawspet Main Road,Pudupet	Puducherry	Puducherry	605008	Don Bosco Matriculation Higher Secondary School	state board	421.00	84.00	Don Bosco Matriculation Higher Secondary Schoolcondary School	state board	496.00	84.00	2024-09-08	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:44:59.403837+05:30	Hindu	488969646247	Day Scholar	BUS	8	f	1	\N	\N	\N	father
1331	1416	1	8	Shalini	C	23TD0721	Female	2006-07-31	O+	Indian	MBC	\N	2023-2027	4	7	shalini23td0721@svcet.ac.in	\N	6381607515	Chandra Sekaran .G	8754912007	Farmer	Vijayalakshmi .C	9962464762	House wife	3.00	No.:43, Mariyamman Kovil Street	\N	Sompet	Puducherry	605 501	Goverment High School ,Thirukkanur	State Board	500.00	100.00	Bonne Nehru Higher Secondary School,Thirukkanur	State Board	466.00	78.00	2023-09-27	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 12:05:29.023565+05:30	Hindu	325799929983	Day Scholar	BUS	17	f	\N	\N	\N	\N	\N
1484	1581	1	10	Narkis banu	D	24TD0804	Female	2006-11-26	O+	Indian	MBC	\N	2024 -2028	3	5	narkisbanu24td0804@svcet.ac.in	\N	6384569276	Dasthageer	9952649774	Labour	Thilsath	8754768826	Housewife	74999.00	no.17 Akbar street purathopu kottakuppam	\N	villupuram	Tamilnadu	605104	St Joseph Govt Aided Higher Secondary School	state board	394.00	78.80	Thiruvalluvar Govt Girls Higher Secondary School	State board	375.00	62.50	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:51:41.818556+05:30	muslim	480940623328	Day Scholar	BUS	20	f	1	\N	\N	\N	father
1442	1539	1	10	CHANDHRU	M	24TD0761	\N	\N	\N	Indian	\N	\N	2024 -2028	3	5	chandhru24td0761@svcet.ac.in	\N	9487054925	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:27:48.778322+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1498	1595	1	10	Priyadharshini	S	24TD0818	Female	2006-12-13	B+	Indian	OBC	\N	2024 -2028	3	5	priyadharshini24td0818@svect.ac.in	dharshinisanthosh2006@gmail.com	9688861110	E. Santhoshkumar	9750655945	Technician	S.Amala	9688861110	House Wife	100000.00	No:33 maruthidhasan nagar ariyapalayam, villiyanur puducherry	\N	Puducherry	Puducherry	605110	Amalorpavam Higher Secondary School	State Board	500.00	76.00	Amalorpavam Higher Secondary School	State Board	600.00	67.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:37:52.558719+05:30	Hindu	0000000000	Day Scholar	OWN	\N	f	1	-	\N	\N	mother
1763	1887	4	\N	BAVANI	V	25TJ0051	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	bavani25tj0051@svcet.ac.in	\N	8940277565	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1448	1545	1	10	Dhinagar	S	24TD0767	\N	\N	\N	Indian	\N	\N	2024 -2028	3	5	dhinagar24td0767@svcet.ac.in	\N	9042397413	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:27:48.778322+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1764	1888	4	\N	EUNICE JEMIMA	B	25TJ0052	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	eunicejemima25tj0052@svcet.ac.in	\N	9445526644	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1765	1889	4	\N	JAYASHREE	S	25TJ0053	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	jayashree25tj0053@svcet.ac.in	\N	9080337069	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1501	1598	1	10	Priyavarsan	P	24TD0821	Male	2006-01-04	B+	Indian	sc	\N	2024 -2028	3	5	priyavarsan24td0821@svcet.ac.in	\N	9655122772	purushothaman	8098227878	farmer	dhivya	8110988590	hous wife	75000.00	no.4mariamman koil street suthukeny 	\N	pondicherry	pondicherry	605502	subramaniya bharathi higher secondary school 	state board	500.00	100.00	annai raani convent school 	state board 	346.00	57.00	2024-10-01	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:53:31.036304+05:30	hindu	787673680741	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1458	1555	1	10	Gokul	Krishnan	24TD0777	Male	2007-05-22	A+	Indian	OBC	\N	2024 -2028	3	5	gokulakrishnan24td0777@svcet.ac.in	\N	8608370199	ramachandran.s	8870826729	labour	renku.r	8608370199	house wife	75000.00	no.9 kuyavar street kottakuppam	\N	tamilnadu	villupuram	605104	fatima higher secondary school	state board	223.00	45.00	fatima higher secondary school	state board	318.00	53.00	2024-05-22	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:51:36.907885+05:30	hindu	917669122458	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1482	1579	1	10	Monish	K	24TD0802	Male	2006-07-28	A+	Indian	obc	\N	2024 -2028	3	5	monish24td0802@svcet.ac.in	monibhuvi006@gmail.com	7200598459	kanniappan .D	9944703125	auto driver	deepa.K	7418990514	house wife	3.00	no 11 annai indra ninaivu nagar vanarapet pondicherry	no 11 annai indra ninaivu nagar vanarapet pondicherry	pondicherry	pondicherry	605001	Petit seminaire higher secondary school	state board	500.00	100.00	Petit seminaire higher secondary school	state board	439.00	73.00	2024-09-11	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:53:03.95279+05:30	hindu	873713981291	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1485	1582	1	10	Naveen	C	24TD0805	Male	2006-08-31	A+	Indian	OBC	\N	2024 -2028	3	5	naveen24td0805@svcet.ac.in	\N	6369368626	CHANEMOUGAME.C	9092440211	DRIVER	PRIYA.C	9092440211	HOUSE WIFE	\N	No.63,Gangai Amman Koil St, Kathirkamam, Puducherry.	\N	Pondicherry	puducherry	605009	Thillaiyadi Valiammai Government High School	STATE BOARD	418.00	84.00	Presidency Higher Secondary School	STATE BOARD	389.00	64.00	2024-09-11	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:03:17.750003+05:30	Hindu	522742949102	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1478	1575	1	10	Mangalakshmy	M	24TD0798	Female	2006-07-29	B+	Indian	MBC	\N	2024 -2028	3	5	mangalakshmy24td0798@svcet.ac.in	\N	7092554797	Murthy M	9750537711	Carpenter	Radha M	\N	House Wife	\N	25D, Pillaiyar koil Street,Angalamman Nagar,Muthialpet,Pondicherry	\N	Puducherry	Puducherry	605003	Kuyilappalayam Higher Secondary School	State board	444.00	88.80	Kuyilappalayam Higher Secondary School	State board	479.00	79.80	2024-08-08	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:20:37.082291+05:30	Hindu	961545907967	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1489	1586	1	10	Nivedha	K	24TD0809	Female	2007-06-27	B+	Indian	OBC	\N	2024 -2028	3	5	nivedha24td0809@svcet.ac.in	\N	9080425539	R Karunanandam	9443603053	Stamp venter	Kalaiselvi K	9487765053	NIL	\N	NO:46,2nd cross, Sudhakar Nagar, Reddiyarpalayam, Puducherry	Nil	Puducherry	Pududcherry	605010	Amalorpavam Higher Secondary School	State	412.00	82.40	Amalorpavam Higher Secondary School	State	464.00	77.33	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:26:56.319068+05:30	HINDU	997695286629	Day Scholar	BUS	26	f	1	\N	\N	\N	father
1518	1615	1	10	Sharmy	B	24TD0838	Female	2007-01-11	O+	Indian	General	\N	2024 -2028	3	5	sharmy24td0838@svcet.ac.in	\N	7806827305	Balaji.K	8667558102	Milk Seller	Devi.B	9384408332	House wife	72000.00	No.108, Pondy-Villupuram Main Road, Ariyur, Puducherry .	\N	Ariyur	Puducherry	605102	Sri Ramachandra Vidhyalaya High School  	State Board	465.00	93.00	Achariya Siksha Mandir	State Board	495.00	82.50	2024-07-20	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:30:35.545379+05:30	Hindu	541787813854	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1494	1591	1	10	Prakashidha	S	24TD0814	Female	2007-06-22	B+	Indian	OBC	\N	2024 -2028	3	5	prakashidha24td0814@svcet.ac.in	\N	9677352206	saravanan	9362135125	mechanic	\N	\N	\N	\N	no.9, Bharathi street, Venkateshwara nagar, ariyur, puducherry, 605102	\N	puducherry	puduchery	605102	Sri Ramachandra vidhayalaya high school	state board	311.00	62.00	Presidency higher secondary school	state board	405.00	68.00	2024-08-20	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:45:18.565974+05:30	hindu	358545507217	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1452	1549	1	10	Diviya Dharshini	B	24TD0771	Female	2006-11-20	B+	Indian	MBC	\N	2024 -2028	3	5	divyadharshini24td0771@svcet.ac.in	\N	9342816899	Baskar	9940970935	collie	Chandra kala	9003738840	accountancy	\N	NO:27  Subramaniyar kovil street , pethuchettipet , Lawspet	\N	pudhucherry	pudhucherry	605008	immaculate heart of mary girls hr.sec.school	stateboard	260.00	52.00	immaculate heart of mary girls hr.sec.school	stateboard	383.00	64.00	2024-09-04	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:10:43.435226+05:30	hindu	623140046372	Day Scholar	BUS	8	f	1	\N	\N	\N	mother
1305	1390	1	8	Mahalakshmi	A	23TD0693	Female	2005-09-15	O+	Indian	MBC	\N	2023-2027	4	7	mahalakshmi23td0693@svcet.ac.in	\N	8610197256	Arumugam. D	9994480495	Barber shop	Chitra. A	8903499503	House Wife	75000.00	No 15, Last cross, JMJ Gardern, Kalitheerthal Kuppam,Puducherry	\N	Puducherry	Puducherrt	605 107	Kalainar Karunanithi Government Higher Secondary School in Madagadipet	state board	500.00	100.00	Kalainar Karunanithi Government Higher Secondary School in Madagadipet	state board	484.00	80.00	2023-10-30	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 12:06:47.915049+05:30	Hindu, Navidhar	714809929137	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1296	1381	1	8	Jeevitha	E	23TD0685	Female	2006-08-08	O+	Indian	MBC	\N	2023-2027	4	7	jeevitha23td0685@svcet.ac.in	\N	9585465906	Elumalai.M	9943465906	Carpenter	Thamilselvi.E	7540065906	\N	80000.00	5/51 pillaiyar kovil street kuyilappalayam,Auroville	\N	puducherry	tamilnadu	605101	kuyilappalayam higher secondary school,kuyilappalayam	state board	500.00	100.00	kuyilappalayam higher secondary school,kuyilappalayam	state board	484.00	80.66	2023-07-13	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 12:07:05.125107+05:30	hindu	887920952812	Day Scholar	BUS	06	f	\N	\N	\N	\N	\N
1326	1411	1	7	Saniyasri	J	23TD0716	Female	2006-03-02	A+	Indian	MBC	\N	2023-2027	4	7	saniyasri23td0716@svcet.ac.in	\N	7092173885	R.Jayamani	7540047891	Fisherman	J.Jaya	9944759925	Housewife	100000.00	No:08 ,  Maari  Amma Kovil  Street  ,  Chinna Muthaliyar  Chavadi	\N	Kottakuppam	TamilNadu	605104	Vivekanandha Higher Secondary School	StateBoard	500.00	100.00	Vivekanandha Higher Secondary School	StateBoard	489.00	82.00	2023-07-13	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 12:07:06.360016+05:30	Hindu	501565980160	Day Scholar	BUS	06	f	\N	\N	\N	\N	\N
1371	1468	9	46	Test	Student25	45CD0125	Female	2005-07-21	A+	Indian	OBC	\N	2024-2028	3	5	teststudent25@svcet.ac.in	\N	6972306465	Thangamani T	8754681696	Business	Vetrivel 	6383016136	House Wife	42.00	No 22 Bharathi Street Jeevanandhapuram Lawspet Puducherry	csdafef	Puducherry	Puducherry	26446	Amalorpavam Higher Secondary School	State Board	43.00	53.00	Amalorpavam Higher Secondary School	State Board	22.00	2.00	2026-07-01	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:17:21.053118+05:30	Hindu	249961472752	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1386	1483	9	47	Test	Student40	45CD0140	Male	2026-07-03	A-	Indian	OBC(General)	\N	2024-2028	3	5	teststudent40@svcet.ac.in	\N	9048296989	M.Vengadesan	09751830665	Two Wheeler Consulting Works	V.Kumari	09751830665	Teacher	\N	No:48,2nd Cross,Ambedkar Nagar.Muthialpet	No:02,4th Cross,Ganesh Nagar,Muthialpet	Puducherry	Puducherry	605003	Fatime.Higher.Secondary.Schoool,Karuvadikuppum,Puducherry	State Board	65.00	55.00	Fatime.Higher.Secondary.Schoool,Karuvadikuppum,Puducherry	State Board	546.00	65.00	2026-07-10	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:27:13.604574+05:30	Hindu	845815946730	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1353	1450	9	48	Test	Student7	45CD0107	Male	2006-06-07	AB-	Indian	ASN	\N	2023-2027	4	7	teststudent7@svcet.ac.in	\N	9163324813	SGHweh	09952003765	\N	GHwehgweahgahg	13454610241	\N	100000.00	Jeiram Chettiyar Thottam Second Cross	Puducherry	Puducherry	Puducherry	605001	Amalorpavam Hr. Sec. School 	State 	500.00	75.00	Amalorpavam Hr. Sec. School 	State 	561.00	87.00	2023-10-11	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:28:40.616157+05:30	Srhbabh	784514291393	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1351	1448	9	48	Test	Student5	45CD0105	Female	2005-02-05	B+	Indian	mbc 	\N	2023-2027	4	7	teststudent5@svcet.ac.in	\N	7396453952	asfasdfasd	25416539870	\N	asdfasdfasfasdfasdf	7896541230	\N	102222.00	asdfsafasdf	\N	asdfasdf	asdsadfsadf	201500	asdfasdfasdf	dasfasdfasdf	100.00	65.00	asdfasdfasdf	asdfasdfasd	500.00	85.00	2000-02-05	MANAGEMENT	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:31:13.022136+05:30	fjasdf	123456781234	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1361	1458	9	49	Test	Student15	45CD0115	Male	2000-05-22	A-	Indianasdfasdf	asdfasdf	\N	2023-2027	4	7	teststudent15@svcet.ac.in	\N	9564756096	asdfasdf	1234567890	\N	asdasdf	1234567890	\N	\N	asdfasdf	\N	asdfasdf	asdfasdf	12354000	asdfasdf	asdasdf	100.00	100.00	asdfasdf	adfasdf	100.00	94.00	2024-01-01	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:28:47.376881+05:30	asdasdf	1234569870	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1355	1452	9	48	Test	Student9	45CD0109	Female	2000-02-25	B+	Indian	obc	\N	2023-2027	4	7	teststudent9@svcet.ac.in	\N	9907523298	asdfasdf	12345689770	\N	asdfasdf	1234567890	\N	\N	46, st 1 abcd 	\N	puducherry	asdfasdf	605110	asdfasdf	asdfasdf	100.00	100.00	asdfasdf	asdfasdf	100.00	100.00	2024-01-01	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:36:57.961973+05:30	hindu	12648931236	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1359	1456	9	49	Test	Student13	45CD0113	Female	2000-01-01	B+	Indian	adsfasdf	\N	2023-2027	4	7	teststudent13@svcet.ac.in	\N	8741932108	asdfasdf	1236547890	\N	asdfasdf	1236547890	\N	\N	asdfasdf	\N	asdfasdf	asdfasdf	1236500	asdfasdf	adfasdf	100.00	100.00	asdfasdf	asdfasdf	100.00	100.00	2024-01-01	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:28:41.626543+05:30	asdfasdf	1236547890	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1372	1469	9	46	Test	Student26	45CD0126	Male	2000-01-01	B+	Indian	asdfa	\N	2024-2028	3	5	teststudent26@svcet.ac.in	\N	6532483062	asdfadf	1236547890	\N	asdfasdf	1236547890	\N	\N	sdfgadf	\N	asdf	asdf	251033	asdfasdf	asdfasdf	100.00	100.00	asdfasdf	asdfasdf	100.00	100.00	2024-01-01	MANAGEMENT	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:33:58.865433+05:30	asdfasd	123654789	Hostel	OWN	\N	f	\N	\N	\N	\N	\N
1766	1890	4	\N	KAVYA	K	25TJ0054	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	kavya25tj0054@svcet.ac.in	\N	9943161943	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1522	1619	1	10	Sree krishnan	I	24TD0842	Male	2007-01-02	O+	Indian	obc	\N	2024 -2028	3	5	sreekrishnan24td0842@svcet.ac.in	\N	9092548748	iyyanar	8300097087	mation	\N	\N	\N	120000.00	No:15, 11th cross, kurunji nagar,	lawspet	puducherry	puducherry	605008	fatima higher secondary school	state	291.00	62.00	fatima higher secondary school	state	363.00	64.00	2024-08-14	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:50:44.955008+05:30	Hindu	944883066865	Day Scholar	BUS	08	f	1	\N	\N	\N	father
1528	1625	1	10	Susindran	R	24TD0848	Male	2006-06-20	A+	Indian	MBC	\N	2024 -2028	3	5	susindran24td0848@svcet.ac.in	\N	9894495316	R.ramu	9047014103	mechanic	R.sivagami	9894855464	home maker 	75000.00	no:21,3rd cross,vallalar nagar,boomianyet	\N	puducherry	puducherry	605005	The roy international school	state board	256.00	51.20	Pesidency higher secondary school (ELITE)	state board	356.00	59.60	2024-08-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:52:44.439607+05:30	HINDU	633905008572	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1435	1532	1	10	Afrine	S	24TD0753	Female	2006-12-29	B-	Indian	BCM	\N	2024 -2028	3	5	afrine24td0753@svcet.ac.in	\N	7358260713	M.Sathakathula	9443659482	Tailor	S.Julihabeevi	\N	-	80000.00	no.12A 8th cross,jamiyath nagar	-	puducherry	pudcherry	605104	Immaculate Heart of Mary Girls Higher Secondary School	State board	339.00	67.80	Immaculate Heart of Mary Girls Higher Secondary School	State board	369.00	61.50	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:26:48.219369+05:30	Muslim	897449268654	Day Scholar	BUS	20	f	1	-	\N	-	father
1519	1616	1	10	Somaya Ramya	M	24TD0839	Female	2006-10-22	O+	Indian	OBC	\N	2024 -2028	3	5	somayaramya24td0839@svcet.ac.in	\N	8778172778	Mohanraj Somaya.V	8489503602	Driver	Padma.M	\N	Home Maker	72000.00	No. 7, 3rd Cross Street, Bharathi Nagar, Ariyur, Puducherry	\N	Puducherry	Puducherry	605 102	Sri Ramachandra Vidhyalaya High School,Ariyur	State	347.00	69.00	Girls Government Higher Secondary School , Thiruvandar Koil	State	421.00	70.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:28:31.782048+05:30	Hindu	303514604344	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1527	1624	1	10	Susi	A	24TD0847	Female	2007-04-17	B+	Indian	general	\N	2024 -2028	3	5	susi24td0847@svcet.ac.in	\N	9384278524	Anandhababu	8807792602	collie	priya	8438447382	house wife	\N	NO:20 swaminatha pillai street Mudaliarpet	\N	pudhucherry	pudhuchery	605004	archana suburaya nayakar government high school	stateboard	344.00	69.00	Thiruvalluvar Govt. Girls Hr.Sec.School	stateboard	513.00	86.00	2024-09-03	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:30:51.925788+05:30	hindu	222663197157	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1767	1891	4	\N	KEERTHANA	G	25TJ0055	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	keerthana25tj0055@svcet.ac.in	\N	9363233890	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1348	1445	9	48	Test	Student2	45CD0102	Male	2000-02-25	B+	Indian	obc	\N	2023-2027	4	7	teststudent2@svcet.ac.in	\N	8109335439	adfasdfsadf	2025416310	\N	asdfasdf	231456987	\N	1000000.00	asdfasdfasdf	\N	asfasdfas	adfasdfsadf	2015566	adfasdfsda	asdfasdfsd	500.00	52.00	asdfasdf	500	200.00	25.00	2024-01-01	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:31:46.175631+05:30	hindu	123456781234	Hostel	BUS	15	f	\N	\N	\N	\N	\N
1366	1463	9	49	Test	Student20	45CD0120	Male	2000-01-01	B-	Indian	ASDFSADF	\N	2023-2027	4	7	teststudent20@svcet.ac.in	\N	6139100361	ASDFASDF	1236547889	\N	ASDFASDF	1236548990	\N	\N	ASDFADSF	ASDASASDF	ASDFADF	ASDFASDF	1254200	ASDFASDF	ASDFASDF	100.00	100.00	ASDFASDF	ASDFASDF	100.00	100.00	2024-01-01	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-16 12:30:04.813119+05:30	ADSFSDF	1236547890	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1495	1592	1	10	Prasanna	K	24TD0815	Male	2007-06-22	AB+	Indian	OBC	\N	2024 -2028	3	5	prasanna24td0815@svcet.ac.in	\N	8122273131	Kathiravan	8903413578	fisherman	Usha	7448806627	house wife	75000.00	no:p4/21,tsunami housing colony,periyakalpet,puducherry-14	\N	kalapet	puducherrry	605014	 Kolping Matriculation Higher Secondary School	state	374.00	74.00	 Kolping Matriculation Higher Secondary School	state	367.00	61.00	2024-09-02	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:48:36.058054+05:30	Hindu	977626674274	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1481	1578	1	10	Mohamed Ithris	A	24TD0801	Male	2005-08-06	O+	Indian	BCM	\N	2024 -2028	3	5	mohamedithris24td0801@svcet.ac.in	ithrisbgm@gmail.com	9488875205	K. Akbar Ali	8072400019	photographer	Rahamath Nisha	8124105058	House wife	4.00	No 3 manikka mudaliyar street muthialpet puducherry 	\N	puducherry	puducherry	605003	New modern vidhya mandir higher secondary school 	state board	338.00	67.60	New modern vidhya mandir higher secondary school 	state board	379.00	63.00	2024-09-11	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:49:34.620261+05:30	Muslim	324658442869	Day Scholar	BUS	20	f	1	-	\N	-	father
1465	1562	1	10	Harish	G	24TD0784	Male	2007-07-14	A+	Indian	MBC	\N	2024 -2028	3	5	harish24td0784@svcet.ac.in	gharishharishgopi@gmail.com	8056534595	Gothandapani D	8110037277	electrical technician	Hema G	9159215496	house wife	300000.00	no.10 ottaiyar st 	\N	thirubhuvanai	pondycherry	605107	sri navadurga eng	state board	366.00	72.00	acharya shiksha mandir	state board	329.00	54.00	2024-09-11	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:52:47.517831+05:30	Hindu	870720974609	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1483	1580	1	10	Nakkul	R	24TD0803	Male	2007-03-10	B+	Indian	SC	\N	2024 -2028	3	5	nakkul24td0803@svcet.ac.in	srinakkul@gmail.com	9566599618	Rajajayakumarran N	9677059618	LIC AGENT	Sarida R	7598859618	Home Maker	\N	28,3RD cross,Kamban street 	Thamizthai nagar,vanarapet	puducherry	puducherry	605001	Petit Semiare Higher Secondary School	STATE BOARD	387.00	75.20	Petit Semiare Higher Secondary School	STATE BOARD	432.00	70.10	2024-08-22	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:55:19.055067+05:30	HINDHU	587747791727	Day Scholar	BUS	27	f	1	\N	\N	\N	father
1508	1605	1	10	Sahanath Farveen	R	24TD0828	Female	2006-08-07	B+	Indian	BC	\N	2024 -2028	3	5	Sahanathfarveen24td0828@svcet.ac.in	\N	9080543282	Raja Mohammed.A	\N	Driver	Salihama.R	9944162541	House Wife	90000.00	113\\32,Sonagar street,cuddalore O.T	\N	cuddalore	Tamilnadu	607003	Lakshmi Matriculation School	state board	336.00	67.00	Krishnasamy Memorial Matriculation Higher Secondary School	state board	395.00	66.00	2024-07-16	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:30:16.245715+05:30	Muslim	327650074868	Day Scholar	BUS	28	f	1	\N	\N	\N	mother
1502	1599	1	9	Pugazhenthi	K	24TD0822	Male	2007-04-30	B+	Indian	MBC	\N	2024 -2028	3	5	pugazhenthi24td0822@svcet.ac.in	\N	9655934148	kanniappan A	8870009384	driver	Rajalakshimi K	7904713695	House Wife	100000.00	no:27,sri balaji street,muthupillaypalayam,pondicherry.	\N	Puducherry	Puducherry	605004	blue stars higher secondary school	Stateboard	312.00	62.40	blue stars higher secondary school	Sateboard	420.00	69.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:37:21.955461+05:30	Hindu	699957250002	Day Scholar	OWN	\N	f	1	-	\N	-	father
1433	1530	1	9	Abdul Hafil	A	24TD0751	Male	2007-01-06	A-	Indian	BCM	\N	2024 -2028	3	5	abdulhafil24td0751@svcet.ac.in	\N	9488920173	Ajeetoulla G	9894189914	Business	Jainul Arabia A	8098339406	House wife	\N	13,Vaikkal street sulthanpet,puducherry	\N	puducherry	puducherry	605110	Petit Seminaire Higher Secondary School	State Board	300.00	60.00	Petit Seminaire Higher Secondary School	State Board	391.00	66.00	2024-09-09	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:16:15.456107+05:30	MUSLIM	202374732650	Day Scholar	OWN	20	f	1	\N	\N	\N	father
1545	1642	1	10	Yogeshwari	S	24TD0866	Female	2007-04-09	O+	Indian	obc	\N	2024 -2028	3	5	yogeshwari24td0866@svcet.ac.in	\N	7604933209	Suresh R	7708414855	Ironing 	Devi S	9585816901	HOUSE WIFE	75000.00	No:1,Karapaga Vinayagar Koil St,backside Kurinji Nagar,Lwaspet,Puducherry	\N	PUDUCHERRY	PONDICHERRY	605008	Sekkizhar Govt High School ,Thattanchavady	STATE BOARD 	365.00	75.00	Thiruvalluvar Govt Higher Secondary School,Puducherry	STATE BOARD	427.00	71.60	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 13:08:47.149423+05:30	hindu	835506821761	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1474	1571	1	10	Kiruthika	S	24TD0794	Female	2006-11-14	O+	Indian	MBC	\N	2024 -2028	3	5	kiruthika24td0794@svcet.ac.in	\N	6385634203	Sivanathan M	8148092855	Driver	Selvarani S	\N	House Maid	72000.00	No:4/400, Thamarai street, Kalaivanar nagar, Pattanur village, Vanur taluk	\N	Villupuram	Tamilnadu	605111	Subramaniya Baharathiyar Government Girls Higher Secondary School	state board	334.00	66.80	Subramaniya Bharathiyar Government Girls Higher Secondary School	state board	386.00	61.30	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 13:09:37.836501+05:30	Hindu	314929651714	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1560	1657	1	11	BOOMIGANGA	U	25TD0609	Female	2008-02-04	O+	Indian	INDIAN	\N	2025-2029	2	3	boomiganga25td0609@svcet.ac.in	\N	8825472505	Udhayachandiran A	9843087688	ASI of Police	Nalini devi E 	7904121200	TEACHER	1199999.00	no:332 4th cross	street mangalapuri nagar	villianur	Pondicherry	605110	ACHARIYA SIKSHA MANDIR	CBSE	412.00	82.40	ACHARIYA BALA SIKSHA MANDIR 	CBSE	364.00	72.80	2025-09-13	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:03:27.072746+05:30	HINDU	451760026927	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1570	1667	1	11	GERSHON	M	25TD0619	Male	2008-03-29	AB+	Indian	BC	\N	2025-2029	2	3	gershon25td0619@svcet.ac.in	\N	7810061211	P.R.Melcki Zedeck	9894240901	Auditor	A.Magdalin	8526314593	Teacher	500000.00	no.8 bharathidasan nagar,mudilarpet.Puducherry	\N	Pondicherry	Puducherry	605004	Seventh Day Adventist Hr Sec School	Tamil Nadu State Board	370.00	74.00	Seventh Day Adventist Hr Sec  School	Tamil Nadu State Board	474.00	79.00	2025-07-17	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:03:38.303567+05:30	Christian	655973442925	Day Scholar	BUS	26	f	1	\N	\N	\N	father
1556	1653	1	11	ARISHRAJ	K	25TD0605	Male	2007-06-01	O+	Indian	obc	\N	2025-2029	2	3	arishraj25td0605@svcet.ac.in	\N	8778460695	Kandhasamy R	9442485840	kuli	Alamelu K	9629761334	house wife	200000.00	42,Rathinavel street	 Ariyankuppam 	puducherry	puducherry	605007	Immaculate heart of Mary Higher Secondary School	state board	416.00	83.20	Jeevanadham Boys Higher Secondary School Karamanikuppam puducherry 	cbse	354.00	70.20	2025-08-19	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:03:55.510959+05:30	Hindu	363051194107	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1588	1685	1	11	KAMALESH	S	25TD0637	Male	2008-03-06	A+	Indian	MBC	\N	2025-2029	2	3	kamalesh25td0637@svcet.ac.in	\N	7200279950	SIVAMURUGAN	9791229930	MASON	BAKKIYALAKSHMI	7708686137	HOUSE WIFE	75000.00	18, GANGAIAMMAN KOIL STREET	KARUVADIKUPPAM	Puducherry	Puducherry	605008	FATIMA HIGHER SECONDARY SCHOOL	STATE BOARD	380.00	75.00	FATIMA HIGHER SECONDARY SCHOOL	STATE BOARD	473.00	75.00	2008-08-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:05:20.815146+05:30	Hindu	545763120883	Day Scholar	BUS	08	f	1	\N	\N	\N	mother
1562	1659	1	11	DEEPIGA	L	25TD0611	Female	2008-08-09	B+	Indian	MBC	\N	2025-2029	2	3	deepiga25td0611@svcet.ac.in	\N	9361180167	lakshmipathy	9361180167	farmar	vengateshwari	8098909657	house wife	200000.00	390,railway street,thandavamoorthikuppam	\N	ariyur	Tamil Nadu	605102	vallalar govt higher secondary school , kandamangalam	state board	275.00	56.00	vallalar govt higher secondary school, kandamangalamkanda	state board	370.00	68.00	2025-07-23	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:09:04.119383+05:30	Hindu	295341375556	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1476	1573	1	9	Lavanya	A	24TD0796	Female	2006-07-10	O+	Indian	MBC	\N	2024 -2028	3	5	lavanya24td0796@svcet.ac.in	\N	6385643936	\N	\N	\N	Ezhilarasi	9786559850	Daily Wadge	60000.00	No,206	, Marriyamman koil street.	Kalithirampattu	Tamilnadu	605501	Government Higher Sec School.Sithalampattu	State Board	379.00	75.80	Government Higher Sec School.Sithalampattu	State Board	426.00	71.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:22:10.901211+05:30	Hindu	947942009125	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1440	1537	1	9	Buvanesh	M	24TD0759	Male	2006-06-06	A1+	Indian	OBC	\N	2024 -2028	3	5	buvanesh24td0759@svcet.ac.in	mbuvanesh662006@gmail.com	8838829654	M.Madivanan	9442085344	carpenter	M.Kalpana	9486026043	housewife	120000.00	no.65 thandukarai st. arumbathapuram v.manaveli puducherry	\N	puducherry	puducherry	605110	petit  seminaire higher secondary school	state board	500.00	100.00	petit  seminaire higher secondary school	state board	368.00	59.00	2024-09-23	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:22:23.968465+05:30	Hindu	765116034624	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1464	1561	1	9	Hari Prasath	S	24TD0783	Male	2006-09-05	O+	Indian	obc	\N	2024 -2028	3	5	hariprasath24td0783@svcet.ac.in	\N	9363987818	Sasikumar.K	9443987818	Mason	Deepa.S	9087987818	HOUSE WIFE	75000.00	no.20/A jeevanandam st,Nagammal nagar,nainarmandapam	\N	PUDUCHERRY	PONDYCHERRY	605004	Seventh day hr.sec.school	STATE BOARD 	270.00	54.00	Blessed mother tersa hr.sec.School	STATE BOARD	343.00	56.00	2024-09-22	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:18:44.364248+05:30	INDHU	868144627110	Day Scholar	BUS	25	f	1	\N	\N	\N	father
1443	1540	1	9	Charu	Arumugam	24TD0762	Female	2007-01-25	O+	Indian	OBC	\N	2024 -2028	3	5	charu24td0762@svcet.ac.in	charucharr18@gmail.com	8489315907	Arumugam	9994789264	Franchise in HAP	Saraladevi	8489315907	Housewife	120000.00	No:24, Bharathidasn street, Thamarai nagar,vanarapet,Puducherry.	\N	PONDICHERRY	PUDUCHERRY	605004	Amalorpavam Higher  Secondary School	State Board	408.00	81.00	Amalorpavam Higher  Secondary School	State Board	464.00	77.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:40:26.099161+05:30	Hindu	330749291180	Day Scholar	OWN	\N	f	1	NIL	\N	NIL	father
1768	1892	4	\N	MAHESWARI	S	25TJ0056	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	maheswari25tj0056@svcet.ac.in	\N	6384079423	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1769	1893	4	\N	MOHAMMED IMRAN	M	25TJ0057	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	mohammedimran25tj0057@svcet.ac.in	\N	6380681960	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1453	1550	1	9	Divyesh	M	24TD0772	\N	\N	\N	Indian	\N	\N	2024 -2028	3	5	divyesh24td0772@svcet.ac.in	\N	9025927681	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:26:34.202928+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1471	1568	1	9	Kabilan	S	24TD0791	Male	2006-10-24	O+	Indian	Mbc	\N	2024 -2028	3	5	kabilan24td0791@svcet.ac.in	\N	9840553715	sathiyamoorthy P	9626488892	company	tamilpriya S	9626444421	housewife	1200000.00	no.10,pudhu nagar	pangoor	pondicherry	pondicherry	605102	sri ramachandra vidhyalaya high school	state board	375.00	74.00	achariya siksha mandhir	state board	400.00	65.00	2024-09-19	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:13:50.897577+05:30	HINDU	301102447416	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1457	1554	1	9	Gopinath	R	24TD0776	\N	\N	\N	Indian	\N	\N	2024 -2028	3	5	gopinath24td0776@svcet.ac.in	\N	7904217542	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:26:34.202928+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1473	1570	1	9	Karthivasan	D	24TD0793	Male	2006-09-12	AB+	Indian	MBC	\N	2024 -2028	3	5	karthivasan24td0793@svcet.ac.in	\N	8838014446	Duraimurugan J	9344190071	private company	sevandhi	9751093899	\N	100000.00	no.4 indra nagar 	thirubuvanai	pondicherry	puducherry	605107	sri navadurga english higher secondary school	state board	410.00	82.00	sri navadurga english higher secondary school	state board	477.00	78.00	2024-12-09	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:24:13.210999+05:30	Hindu	320959762441	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1468	1565	1	9	Iniyan	S	24TD0787	\N	\N	\N	Indian	\N	\N	2024 -2028	3	5	iniyan24td0787@svcet.ac.in	\N	7418634863	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:26:34.202928+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1470	1567	1	9	Jhoncy	V R	24TD0790	\N	\N	\N	Indian	\N	\N	2024 -2028	3	5	jhoncy24td0790@svcet.ac.in	\N	9047066283	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:26:34.202928+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1469	1566	1	10	Jayanth Karpageswar	R	24TD0789	Male	2006-11-25	B+	Indian	General	\N	2024 -2028	3	5	jayanthkarpageswar24td0789@svcet.ac.in	jayanthkarpageswar@gmail.com	8946015265	Rangaraj. R	7358866953	Manager	\N	\N	\N	400000.00	No-7,4th Cross,Balaji Nagar,New Saram,Puducherry-605013.	\N	Puducherry	Puducherry	605013	Sri Sankara Vidhyalaya Higher Secondary School	State Board	296.00	49.60	Sri Sankara Vidhyalaya Higher Secondary School	State Board	423.00	70.50	2024-05-22	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:51:06.121281+05:30	Hindu	430402003257	Day Scholar	BUS	36	f	1	-	\N	-	father
1455	1552	1	10	Felcina	P	24TD0774	Female	2006-06-13	AB+	Indian	bc	\N	2024 -2028	3	5	felcina24td0774@svcet.ac.in	\N	6383605642	Paulraj	8903048718	Armed guard	\N	\N	\N	\N	No 14,4th street ,thamarai nagar ,Ariyur,Puducherry	\N	Puducherry	Puducherry	605007	sri ramachandra vidyalaya high school	state board	425.00	85.00	Presidency higher secondry school	state board	449.00	75.00	2024-09-14	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:35:04.789062+05:30	christian	726312908126	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1445	1542	1	10	Dhanasri	K	24TD0764	Female	2007-05-07	B+	Indian	Karuneegar	\N	2024 -2028	3	5	dhanasri24td0764@svcet.ac.in	\N	6380689155	Karthikeyan	8940454935	Driver	Chokkanayagi	9442672444	House wife	75000.00	NO.13,2nd cross,Pudhu nagar,Reddiarpalyam,Puducherry	\N	Pondicherry	Puducherry	605010	Presidency Higher Secondary School	State	500.00	73.00	Presidency Higer Secondary School	State	600.00	75.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:47:10.209453+05:30	Hindu	936921264619	Day Scholar	BUS	26	f	1	\N	\N	\N	father
1472	1569	1	9	Kamali	K	24TD0792	Female	2007-06-06	A+	Indian	OBC	\N	2024 -2028	3	5	kamali24td0792@svcet.ac.in	\N	6385101273	V KESAVARAMANUJAM	6385584897	BUSINESS MAN	K ANANTHI	8300299406	HOME MAKER	75000.00	No:16 PARASURAMAPURAM MAIN ROAD,VILLAINUR PONDICHERRY-605110	\N	PONDICHERRY	PONDICHERRY	605110	St joseph of cluny higher secondary girls school	STATE	381.00	76.20	Immaculate heart of mary girls higher secondary school	STATE	462.00	77.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:11:37.106367+05:30	HINDU	433646263073	Day Scholar	BUS	30	f	1	\N	\N	\N	father
1463	1560	1	9	Harini	P	24TD0782	Female	2007-03-27	O+	Indian	MBC	\N	2024 -2028	3	5	harini24td0782@svcet.ac.in	\N	7418987406	R.Prakash	9842561406	Car mechanic	P.Anandhi	8610994659	Home maker	75000.00	No:162 1st cross street annai theresa nagar murungapakkam puducherry	\N	PONDICHERRY	PONDICHERRY	605004	Immaculate heart of mary girls hr.sec school	STATE BOARD	282.00	56.00	Immaculate heart of mary girls hr.sec school	STATE BOARD	383.00	64.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:19:56.015631+05:30	Hindu	492493024813	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1441	1538	1	9	Catherine	J	24TD0760	Female	2007-03-28	O+	Indian	OBC	\N	2024 -2028	3	5	catherine24td0760@svcet.ac.in	\N	6381210072	JOSEPH . D	9443293044	CAR MECHANIC	ANITHA MAGADALENE MARY	6380194644	HOME MAKER	\N	NO : 135, ARUL PADAYATCHI STREET, NELLITHOPE, PONDICHERRY - 605005	\N	PUDUCHERRY	PUDUCHERRY	605005	ST JOSEPH OF CLUNY GIRLS HIGHER SECONDARY SCHOOL	STATE BOARD 	311.00	62.20	IMMACULATE HEART OD MARY GIRLS HIGHER SECONDARY SCHOOL	STATE BOARD	464.00	77.33	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:21:51.46111+05:30	CHRISTIAN	967322136847	Day Scholar	BUS	26	f	1	\N	\N	\N	father
1526	1623	1	9	Surendar	V	24TD0846	Male	2007-05-15	A+	Indian	General	\N	2024 -2028	3	5	surendar24td0846@svcet.ac.in	\N	9074238217	Veluswamy.T	9995621356	\N	Selvi.V	9074238217	\N	\N	No - 4 Vivekananda nagar, Ariyur, Puducherry	\N	Pondicherry	Puducherry	605102	Govt GHSS, Karamana, Thiruvananthapuram, Kerala	State	499.00	99.00	Govt GBHSS, Karamana, Thiruvananthapuram, Kerala	State	1074.00	87.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:16:18.681007+05:30	Hindu	575107538724	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1512	1609	1	9	Sathish Kumar	S	24TD0832	Male	2007-02-01	B+	Indian	OBC	\N	2024 -2028	3	5	sathishkumar24td0832@svcet.ac.in	\N	9087078974	Shunmugham.B	6380702080	Pharmacist	Uma parvathy.S	9345263580	House wife	150000.00	No:5,Vinayagar street, Thiriveni Nagar(East),V.Manaveli, Arumbarthapuram, Puducherry	\N	Puducherry	Puducherry	605110	Amalorpavam.Hr.Sec.School	State	398.00	80.00	Presidency.Hr.Sec.School	State	470.00	80.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:18:46.653009+05:30	Hindu	541465842940	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1770	1894	4	\N	NANDHINI	A	25TJ0058	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	nandhini25tj0058@svcet.ac.in	\N	8122727961	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1520	1617	1	9	Someshwar	M	24TD0840	Male	2006-09-11	O+	Indian	BC	\N	2024 -2028	3	5	someshwar24td0840@svcet.ac.in	\N	6381529272	Murugan T	9976154291	Co.operative society	Sivasankari M	9487071975	Housewife	300000.00	18/Gandhi Nagar 2nd Street nellikuppam	cuddalore 607102	Cuddalore	Tamil Nadu	607102	krishnaswamy matriculation hr sec school	State Board	353.00	70.00	krishnaswamy memorial hr sec school	State Board	403.00	67.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:29:05.146186+05:30	Hindu	826001720436	Day Scholar	BUS	33	f	1	\N	\N	\N	father
1504	1601	1	9	Rakesh	S	24TD0824	\N	\N	\N	Indian	\N	\N	2024 -2028	3	5	rakesh24td0824@svcet.ac.in	\N	8098555646	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:26:34.202928+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1507	1604	1	9	Sadhana	A	24TD0827	Female	2007-07-08	A1B+	Indian	MBC	\N	2024 -2028	3	5	sadhana24td0827@svcet.ac.in	\N	7010778238	Arumugam.G	9894938667	Private Employee 	kalaivani.A	8870809085	home maker	75000.00	NO,108	govindan kovil street	muthariyar palayam	puducherry	605009	mutharaiyar higher sec school	STATE BOARD	359.00	71.80	muthararaiyar higher sec school	STATE BOARD 	431.00	71.80	2024-09-17	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:16:53.147642+05:30	HINDU	628452328007	Day Scholar	BUS	37	f	1	-	\N	\N	father
1531	1628	1	9	Vaishali	I	24TD0852	Female	2006-08-13	O+	Indian	sc	\N	2024 -2028	3	5	vaishali24td0852@svcet.ac.in	ivaishali410@gmail.com	9600805734	Imanuvel.D	9600531493	works in agriculture department	Banumathy.D	9994666857	House Wife	300000.00	no.33	Dr MGR nagar	Puducherry	Puducherry	605010	Immaculate heart of mary girls hr.sec. school	State Board	418.00	81.00	Presidency.hr.sec school	State Board	404.00	67.00	2024-09-21	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:49:07.183131+05:30	Hindu	432588852041	Day Scholar	BUS	19	f	1	\N	\N	\N	father
1771	1895	4	\N	OVIYA	V	25TJ0059	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	oviya25tj0059@svcet.ac.in	\N	7418074177	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1772	1896	4	\N	PAVITHRA	V	25TJ0060	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	pavithra25tj0060@svcet.ac.in	\N	9943151831	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1524	1621	1	9	Stephen Antony	S	24TD0844	Male	2007-01-23	B+	Indian	OBC	\N	2024 -2028	3	5	stephenantony24td0844@svcet.ac.in	\N	7418689049	savarimuthu	9585128422	company	cecily selva priya	9585308356	House Wife	\N	No 14 second  cross street 	thamarai nagar , ariyur .	Puducherry	Puducherry	605102	sri ramachandra vidhyalaya high school 	Stateboard	359.00	74.00	blue stars higher secondary school	Sateboard	433.00	74.00	2024-09-19	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:10:33.84206+05:30	christian	729047889325	Day Scholar	OWN	\N	f	1	-	\N	\N	father
1516	1613	1	9	Shakshitha	M	24TD0836	\N	\N	\N	Indian	\N	\N	2024 -2028	3	5	shakshitha24td0836@svcet.ac.in	\N	7397029968	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:26:34.202928+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1773	1897	4	\N	PRIYADHARSHINI	V	25TJ0061	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	priyadharshini25tj0061@svcet.ac.in	\N	9655132345	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1459	1556	1	10	Gopinath	T	24TD0779	Male	2007-01-31	B+	Indian	OBC	\N	2024-2028	3	5	gopinath24td0779@svcet.ac.in	\N	6374757192	A.THIRUNAVUKARASU	9751108789	WORKING AT PRIVATE COMPANY	T.SANKARI	8668119823	HOME MAKER	75000.00	no,7 Pudhu Nagar, Madagadipet palayam 	\N	Puducherry	puducherrry	605107	SRI NAVADURGA ENGLISH HIGHER SECONDARY SCHOOL	STATE BOARD	402.00	80.20	SRI NAVADURGA ENGLISH HIGHER SECONDARY SCHOOL	STATE BOARD	455.00	79.00	2024-05-22	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:52:30.824396+05:30	Hindu	52518858598	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1523	1620	1	10	Srividhya	T	24TD0843	Female	2005-11-12	O+	Indian	vanniyar	\N	2024 -2028	3	5	srividhya24td0843@svcet.ac.in	\N	8300868736	Thirusangu	8098631984	\N	Usha Rani	9487177900	manager	264000.00	no.33,moogambigai nagar extension 2 ,v.manaveli	\N	villianur	puducherry	605110	AMRITA VIDYALAYAM 	CBSE	500.00	87.00	AMRITA VIDYALAYAM	CBSE	500.00	73.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:35:13.796234+05:30	hindu	623503969321	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1491	1588	1	9	Pooja	T	24TD0811	Female	2006-09-30	B+	Indian	MBC	\N	2024 -2028	3	5	pooja24td0811@svcet.ac.in	\N	6381450435	P.Thamizh Murugan	9047025992	Accountants	T.Sangeetha	9444725992	House Wife	-1.00	130/1,Pilliyar kovil street,kalinchikuppam , villupuram district tamil nadu	139,sri mangalapuri teachers colony extension 1,villianur taluk ,puducherry	puducherry	puducherry	605105	Aditya Vidyashram Residential school	cbse	350.00	62.00	Aditya Vidyashram Residential School	cbse	300.00	60.00	2024-04-08	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:08:03.310788+05:30	HINDU	91029689535	Day Scholar	BUS	19	f	1	nil	\N	nil	father
1493	1590	1	9	Pragathi	K	24TD0813	Female	2006-12-20	B+	Indian	OBC	\N	2024 -2028	3	5	pragathi24td0813@svcet.ac.in	\N	9360029835	Kanagavel	9677958251	Programmer	Sheela rani	9442002981	-	\N	No 15 second cross ponselvaraj nagar villianur	pondicherry 	Pondicherry	Pondicherry 	605110	Aditya vidhyashram residential school  	CBSE	422.00	84.40	Aditya vidhyashram residential school 	CBSE	404.00	80.80	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:09:11.776007+05:30	Hindu	961582735883	Day Scholar	BUS	19	f	1	\N	\N	\N	father
1537	1634	1	9	Vilasini	R	24TD0858	Female	2007-08-08	A+	Indian	MBC	\N	2024 -2028	3	5	vilasini24td0858@svcet.ac.in	\N	9600684772	Rajaram R	8248038076	\N	Saraswathy R	9600684772	\N	150000.00	No:40 Cuddalore Road Madagadipet Palayam 	\N	Puducherry	Puducherry	605107	Aditya Vidyashram  Poraiyur Villianur	CBSE	302.00	60.40	Aditya Vidyashram  Poraiyur Villianur	CBSE	340.00	69.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:10:23.062641+05:30	Hindu	583688339564	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1517	1614	1	9	Shanmuga Priya	S	24TD0837	Female	2007-02-06	B+	Indian	MBC	\N	2024 -2028	3	5	shanmugapriya24td0837@svcet.ac.in	\N	7418650300	Saravanan	9787470300	Mason	Priya	6374072703	-	\N	No 34 Velan nagar new vandipalayam	\N	cuddalore	TamilNadu	607004	St.Anne's girls HR secondary school	State board	350.00	70.00	St.Anne's girls HR secondary school	State board	419.00	69.80	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:18:19.62593+05:30	Hindu	312878987412	Day Scholar	BUS	30	f	1	\N	\N	\N	father
1497	1594	1	9	Priyadharshini	A	24TD0817	Female	2007-03-05	AB+	Indian	vaniyar	\N	2024 -2028	3	5	priyadharshini24td0817@svcet.ac.in	\N	8189987429	Anbazhagan N	9500682363	Security	Punitham A	8189987429	NIL	75000.00	No.148,bharathiyar nagar 2nd street,periyakapet,puducherry	\N	Pondicherry	Puducherry	605014	Mohammad farook maricar government girls higher secondary school,periyakalapet	State board	500.00	71.60	Mohammad farook maricar government girls higher secondary school,periyakalapet	State board	600.00	77.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:29:11.892286+05:30	Hindu	212950088744	Day Scholar	BUS	24	f	1	Anbazhagan N	9500682363	\N	father
1647	1744	1	11	VISHNUPRIYA	S	25TD0696	Female	2008-07-01	O+	Indian	mbc	\N	2025-2029	2	3	vishnupriya25td0696@svcet.ac.in	\N	8220618797	saravanan	9443468647	driver	suganya	8807409479	house wife	100000.00	6,sundaraj street,lakshmi nagar	\N	Pondicherry	Puducherry	605004	Aamalorpavam Higher Secondary School	stateboard	430.00	80.00	Aamalorpavam Higher Secondary School	stateboard	480.00	80.00	2025-08-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:34:24.188746+05:30	hindu	351259722793	Day Scholar	BUS	26	f	1	\N	\N	\N	father
1569	1666	1	50	GAYATHRI	S	25TD0618	Female	2005-12-15	B+	Indian	MBC	\N	2025-2029	2	3	gayathri25td0618@svcet.ac.in	\N	8754119241	Shanmugam	9442993217	farmer	kayalvizhi	8300976145	house wife	\N	17,sedar street ,madukarai	\N	Puducherry	Puducherry	605105	Balar vidhyalaya high school,madukarai	State Board	500.00	99.00	achariya siksha mandir hr sec school	state board	447.00	74.50	2025-09-14	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:04:34.877524+05:30	Hindu	921467054109	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1548	1645	1	9	Zainub	I	24TD0869	Female	2006-11-04	O+	Indian	BCM	\N	2024 -2028	3	5	zainub24td0869@svcet.ac.in	\N	6374625373	Iqbal Basha	\N	labour	Meharaj begam 	9629786384	Home maker	60000.00	no.20	akbar street	purathoppu ,kottakuppam	Tamil nadu	605104	Nirvana high school	state board	369.00	73.80	Sinnatha Government Girls Higher Secondary School	State board	431.00	71.80	2024-09-15	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:15:07.795541+05:30	muslim	787195642451	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1544	1641	1	10	Yogesh	C	24TD0865	Male	2006-12-19	O+	Indian	MBC	\N	2024 -2028	3	5	yogesh24td0865@svcet.ac.in	\N	7010245963	Camalanadan.R	9344689819	labour	Chitra.C	9245862354	homemaker	72000.00	No.D.palani nagar,kalitheerthalkuppam,puducherry	No.D.palani nagar,kalitheerthalkuppam,puducherry	puducherry	puducherry	605107	shri hindocha charitable trust hgher secondary school,ariyur	stateboard	368.00	72.30	shri hindocha charitable trust higher secondary school,ariyur,puducherry	stateboard	434.00	73.60	2024-09-05	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:50:40.154813+05:30	hindu	297414506457	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1547	1644	1	9	Yuvaprasad	S	24TD0868	Male	2006-09-28	B+	Indian	MBC	\N	2024 -2028	3	5	yuvaprasad24td0868@svcet.ac.in	\N	9840975781	Sivaprakasam M 	9840975781	supervisor	Rajalakshmi S	\N	\N	\N	1/83 Pudhu street,	Navamal Kapper	villupuram	Tamil Nadu	605102	Sri Ramachandra Vidhyalaya High School 	SSLC	428.00	85.60	Achariya Siksha Mandir	SSLC	479.00	79.80	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:26:15.541642+05:30	Hindu	435359937661	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1510	1607	1	9	Sakthivel	R	24TD0830	Male	2007-05-29	B+	Indian	OBC	\N	2024 -2028	3	5	sakthivel24td0830@svcet.ac.in	\N	7200907295	Raja E	9788898699	Driver	Sundari R	85083916898	House wife	70001.00	no,2 Om sakthi nagar, muthupillaipalayam	\N	puducherry	puducherry	605110	Blue Stars Higher Secondary School	state board	341.00	68.20	Blue Stars Higher Secondary School	state board	467.00	78.00	2024-09-19	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:57:39.296929+05:30	Hindu	926890887795	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1479	1576	1	10	Mathivanan	V	24TD0799	Male	2006-08-24	B+	Indian	MBC	\N	2024 -2028	3	5	mathivanan24td0799@svcet.ac.in	\N	7598122689	Venkatesan R	8940760262	Coolie	\N	\N	\N	\N	206 mariyamman kovil street kalithirampattu sellipet viluppuram tamil nadu 	\N	viluppuram	tamil nadu	605501	blue stars higher secondary school	Stateboard	280.00	56.00	blue stars higher secondary school	Sateboard	411.00	68.00	2024-09-02	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:09:23.43327+05:30	Hindu	516257111263	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1540	1637	1	10	Yamikha	S	24TD0861	Female	2006-11-22	O+	Indian	obc	\N	2024 -2028	3	5	yamikha24td0861@svcet.ac.in	\N	9080789192	R. Senthil kumar	9994392957	HVAC Mechanic	S. Kavitha	9791632326	Home maker	300002.00	plot no. 3/4 Raj tower, T3, Third floor, 6th cross, Kamban nagar, Reddiayarpalayam, Puducherry	plot no. 3/4 Raj tower, T3, Third floor, 6th cross, Kamban nagar, Reddiayarpalayam, Puducherry	puducherry	India	605010	Aditya vidhyashram resedential school poraiyur	CBSE	336.00	67.00	Aditya vidhyashram resedential school poraiyur	cbse	326.00	63.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:36:27.060245+05:30	hindu	902478661876	Day Scholar	BUS	26	f	1	\N	\N	\N	father
1576	1673	1	50	ILAKIAN	C	25TD0625	Male	2008-05-03	A+	Indian	MBC	\N	2025-2029	2	3	ilakian25td0625@svcet.ac.in	\N	8056916597	CHANDRAN	9952212051	LABOUR	SHANTHI	8098482051	HOUSE WIFE	99997.00	No. 122, second cross, verappan koil street	pudhu nagar, sanjeevi nagar	pondicherry 	puducherry	605111	GOVERNMENT HIGHER SECONDARY SCHOOL ALANKUPPAM	TN STATE BOARD	417.00	83.40	GOVERNMENT HIGHER SECONDARY SCHOOL ALANKUPPAM	CBSE	426.00	71.00	2025-09-01	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-24 11:41:35.464753+05:30	hindhu	694861758544	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1456	1553	1	10	Ganesh	C	24TD0775	Male	2006-08-27	O+	Indian	MBC	\N	2024 -2028	3	5	ganesh24td0775@svcet.ac.in	ganeshc1827@gmail.com	6380655122	Chandrasekar E	9360414529	mason	Kalaivani C	8940803851	house wife	75000.00	no;2/267 Bharathipuram Kottakarai, villupuram district,tamilnadu	\N	villupuram	Tamil Nadu	605111	kuyilapalayam Higher secondary school	state board	359.00	72.00	kuyilapalayam Higher secondary school	state board	456.00	76.00	2024-08-31	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:56:01.393263+05:30	Hindhu	922121607419	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1543	1640	1	9	Yogapriya	V	24TD0864	Female	2004-07-29	B+	Indian	MBC	\N	2024 -2028	3	5	yogapriya24td0864@svcet.ac.in	\N	7708009167	Vengadesan.B	9843899167	SVGI	Amsa.V	\N	House wife	71999.00	23	Purushothamman Reddiar Street 	Nettapakkam	Puducherry	605 106	Balaji Higher Secondary School Embalam	Statement	451.00	91.00	Swami Vivekhanandha Higher Secondary School Manakuppam	Stateboard	374.00	62.33	2024-10-03	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 16:07:03.795273+05:30	Hindu	985547804660	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1542	1639	1	10	Yogaprabu	V	24TD0863	Male	2004-07-29	B+	Indian	OBC	\N	2024 -2028	3	5	yogaprabu24td0863@svcet.ac.in	yogaprabuprabu4@gmail.com	6369307133	Vengatesan	9843899167	plumber 	Amsa	\N	house wife	3.00	No 23 purushothamman reddiyar  gardan,Nettapakkam  Puducherry	\N	Puducherry	Puducherry	605106	Balaji higher secondary school 	state board	455.00	91.00	swamy vivekanadha higher secondary school 	state board	330.00	55.00	2024-09-11	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:03:02.560649+05:30	Hindu	223109385128	Day Scholar	OWN	\N	f	1	-	\N	-	father
1446	1543	1	10	Dharani Priya	S	24TD0765	Female	2006-07-26	O-	Indian	Pattinavar	\N	2024 -2028	3	5	dharanipriya24td0765@svcet.ac.in	\N	8778925144	Saravanan	9791567725	Fisherman	Kavitha	6369284130	House wife	75000.00	No.7,Kamarajar street,Solai nagar,Muthiyalapet,Puducherry	\N	Pondicherry	Puducherry	605003	Immaculate heart of marry girls hr.sec.school	State	500.00	65.00	Immaculate heart of marry girls hr.sec.school	State	600.00	63.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:37:44.913184+05:30	Hindu	257850428006	Day Scholar	BUS	20	f	1	\N	\N	\N	father
1553	1650	1	50	ABISHEK	S	25TD0602	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	abishek25td0602@svcet.ac.in	\N	7358851217	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:20:31.255935+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1568	1665	1	50	DIVYESH	A	25TD0617	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	divyesh25td0617@svcet.ac.in	\N	6384559867	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:20:31.255935+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1585	1682	1	50	KABIL	K	25TD0634	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	kabil25td0634@svcet.ac.in	\N	8015525853	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:20:31.255935+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1503	1600	1	10	Rakesh	N	24TD0823	Male	2007-01-12	A+	Indian	MBC	\N	2024 -2028	3	5	rakesh24td0823@svcet.ac.in	\N	9345063332	NATARAJAN A	9965624557	DRIVER	DHANALAKSHIMI	8144424557	HOUSE MAKER	70000.00	13/244 MEENAVAR STREET NADUVEERAPATTU,CUDDALORE 607102	SATHIPATTU MAINROAD NADUVEERAPATTU NADUVEERAPATTU CUDDALORE 607102	CUDDALORE	TAMIL NADU	607102	GOVERMENT HIGHER SECONDARY SCHOOL NADUVEERAPATTU, CUDDALORE	STATE 	242.00	48.00	GOVERNMENT HIGHER SECONDARY SCHOOL NADUVEERAPATTU, CUDDALORE	STATE	368.00	61.00	2024-09-07	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:56:55.428078+05:30	hindhu	710790632053	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1513	1610	1	10	Shadhana Neerthika	K	24TD0833	Female	2007-07-12	B+	Indian	mbc	\N	2024 -2028	3	5	shadhananeerthika24td0833@svcet.ac.in	\N	7904577594	k.kumeravel	9843447201	carpenter	k.gayathri	7010139626	block mission manager	\N	no:46,narerikuppam,rettanai,villupuram,tindivanam,tamilnadu,604306	\N	villupuram	tamilnadu	604306	kennedy matric hr.sec. school	state board	356.00	71.00	kennedy matric hr.sec. school	state board	422.00	70.00	2024-08-09	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:37:39.593272+05:30	hindu	341326771164	Hostel	OWN	\N	f	1	\N	\N	\N	father
1432	1529	1	9	Mohamed Ibrahim	S	23TD0697	Male	2005-07-16	A-	Indian	BCM	\N	2024 -2028	3	5	mohamedibrahim23td0697@svcet.ac.in	\N	9843503076	Sathick Basha	8754818806	Labour	Zeenathul Munawara	8754818806	House wife	150000.00	No. 5/7, Nattanmai street, Kottakuppam	\N	Villupuram	Tamil Nadu	605104	Nirvana High School	State Board	499.00	99.00	Kuyilappalayam Higher Secondary School	State Board	475.00	79.00	2023-07-07	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:17:14.729028+05:30	Muslim	207339343537	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1342	1427	1	7	Vishwa	B.R	23TD0732	Male	2005-12-03	A1+	Indian	OBC	\N	2023-2027	4	7	vishwa23td0732@svcet.ac.in	vishwa.labs@gmail.com	9344793687	Rajan.T	9787679136	Busisnness	Balathanga Valli	6383262279	Business	100000.00	No.12,Ponniamman Kovil Street ,	Pethuchettypet,Lawspet	Puducherry	Puducherry	605008	Aditya Vidyashram residential school	CBSE	404.00	81.00	Aditya Vidyashram residential school	CBSE	362.00	73.00	2023-09-06	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-23 11:56:55.461155+05:30	Hindu	711752629672	Day Scholar	OWN	\N	f	\N	\N	\N	\N	\N
1546	1643	1	9	Yukessh	M	24TD0867	Male	2006-10-26	O+	Indian	OBC	\N	2024 -2028	3	5	yukessh24td0867@svcet.ac.in	\N	8807669326	G.MURUGAN	8300069376	Bussiness	M.Sousithra	7397587463	house wife	75000.00	no:7 salai mariaaman kovil street, muthailpet	\N	Puducherry	Pondycherry	605001	SRI SANKARA VIDYALAYA HIGHER SECONDARAY SCHOOL	STATE BOARD	312.00	62.40	SRI RAMAKRISHANA VIDYALAYA HIGHER SECONDARAY SCHOOL	STATE BOARD	401.00	66.83	2024-09-19	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:57:59.602972+05:30	Hindu	483150121922	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1461	1558	1	9	Gowtham	M	24TD0780	Male	2006-10-21	B+	Indian	obc	\N	2024 -2028	3	5	gowtham24td0780@svcet.ac.in	\N	7010445323	Murugan I	8754251447	Driver	Chitra I	9500598509	house wife	500000.00	No:16 pillaiyar kovil st	thiruvandar kovil	pondicherry	pondicherry	605102	sri Ramachandra vidhiyalaya high school 	state board	308.00	61.10	Blue star higher secondary school	state board	435.00	75.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:06:04.266216+05:30	hindu	604196346078	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1454	1551	1	9	Eniya Varshan	S	24TD0773	Male	2007-06-04	O+	Indian	OBC	\N	2024 -2028	3	5	eniyavarshan24td0773@svcet.ac.in	\N	6379031279	Selvakumar K	7449108202	Conductor	Thilagavathi S	7449108202	house wife	\N	19,Kamrajar street,Subash nagar,Periyakalapet	\N	Kalapet,Pondicherry	Puducherry	605014	Jothi Vallalar Higher Secondary School	state board	418.00	83.00	Chevalier Sellane Higher Secondary School 	state board	468.00	79.00	2024-09-19	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:06:49.458136+05:30	Hindu	791879983894	Day Scholar	BUS	06	f	1	\N	\N	\N	father
1622	1719	1	50	RAHIM MOUHAMAD	IMTHIAZ	25TD0671	Male	2007-02-15	AB+	Indian	OBC	\N	2025-2029	2	3	rahimmouhamadimthiaz25td0671@svcet.ac.in	\N	6379293189	Rahim Mouhamad Moushtack	9894924904	shop keeper	Zaibunnisa begum	8300661808	House wife	\N	no:26,Ram Raja Street,Puducherry	\N	puducherry	Puducherry	605001	Ar Rahmaan Higher Secondary School	State Board	414.00	82.20	Ar Rahmaan Higher Secondary School	State Board	505.00	84.00	2025-09-07	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:03:32.438378+05:30	muslim	784591307924	Day Scholar	BUS	27	f	1	Rahim Mouhamad Moushtack	9894924904	shop keeper	mother
1605	1702	1	50	MANISH	M	25TD0654	Male	2008-03-19	O+	Indian	MBC	\N	2025-2029	2	3	manish25td0654@svcet.ac.in	manish25td0654@svcet.ac.in	9043428005	mourougane	9944338005	Business	lakshmi	9087865591	Housewife	100000.00	no,14th cross extension,krishna nagar,lawspet,puducherry	\N	PUDUCHERRY	Puducherry	605008	vivekanandha higher secondary school	STATE BOARD	344.00	68.80	vivekanandha higher secondary school	425	425.00	71.00	2026-09-16	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:01:38.36987+05:30	Hindu	408645660549	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1630	1727	1	50	SARAN	P	25TD0679	Female	2006-08-14	B+	Indian	MBC	\N	2025-2029	2	3	saran25td0679@svcet.ac.in	\N	7550175406	Pannir selvam.N	9944717255	AC mechanic	Surya.P	9962618980	Home Maker	75000.00	No.1	Karunanithi street	Govindasalai	puducherry	605011	Thiruvaluvar Govt. Girls Higher Secondary School	STATE BOARD	280.00	56.00	Subramania Bharathiyar Govt. Girls Higher Secondary School	STATE BOARD	367.00	61.00	2025-09-06	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:28:11.094143+05:30	HINDHU	773009135481	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1611	1708	1	50	MUGESH	M	25TD0660	Male	2008-07-07	o+	Indian	obc	\N	2025-2029	2	3	mugesh25td0660@svcet.ac.in	mugesh07md@gmail.com	7010347265	Muthuvel	9940997303	Carpenter	Dhanalakshmi	8870114238	Home Maker	200000.00	no:57, Vasantharayan Palayam,Keppar Malai Road,Cuddalore  OT,Cuddalore	\N	cuddalore	Tamilnadu	607003	Lakshmi Matriculation School	state board	448.00	89.60	Krishnasamy Memorial Matriculation Higher Secondary School	state board	514.00	85.60	2025-03-24	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:27:10.658953+05:30	Hindu	489018208153	Day Scholar	BUS	8	f	1	\N	\N	\N	\N
1625	1722	1	50	RISHI	S	25TD0674	Male	2007-09-14	O+	Indian	sc	\N	2025-2029	2	3	rishi25td0674@svcet.ac.in	\N	8438967651	sivaperumal	6379243421	government staff	saritha	9787212616	House wife	\N	11,ramij nagar main road .maducarai .pondicherry .	\N	puducherry	Puducherry	605105	ramamorrthy higer secoundry school	State Board	366.00	73.00	maraimalai adigal higher secoundry school ,embalem	cbse	334.00	73.00	2025-07-10	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:25:48.712179+05:30	Hindu	642126899677	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1609	1706	1	50	MOHANDOSS	M	25TD0658	Male	2007-06-21	B+	Indian	MBC	\N	2025-2029	2	3	mohandoss25td0658@svcet.ac.in	mohandoss@2103gmail.com	7397302531	k.Murugan	989472531	coolie	M.Sudha	\N	House wife	149999.00	15,west street,Ariyur	\N	 Puducherry	Puducherry	605102	shri hindocha charitable Trust higher secondary school	state board	304.00	60.00	St joseph higher sscondary school	state board	479.00	82.00	2025-07-21	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:26:54.744914+05:30	Hindu	224332894394	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1774	1898	4	\N	RAGA SHRI	I	25TJ0062	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	ragashri25tj0062@svcet.ac.in	\N	9363955313	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1775	1899	4	\N	REEMA	M	25TJ0063	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	reema25tj0063@svcet.ac.in	\N	9043283147	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1776	1900	4	\N	RETHISHNATH	A	25TJ0064	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	rethishnath25tj0064@svcet.ac.in	\N	9487612788	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1595	1692	1	50	KISHORE	R	25TD0644	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	kishore25td0644@svcet.ac.in	\N	8825906576	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:20:31.255935+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1596	1693	1	50	KISHORE	V	25TD0645	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	kishore25td0645@svcet.ac.in	\N	9344960773	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:20:31.255935+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1477	1574	1	10	Malik Sha	S	24TD0797	Male	2007-02-20	B+	Indian	BCM	\N	2024 -2028	3	5	maliksha24td0797@svcet.ac.in	shamalik757@gmail.com	8124101808	SHOWKATH ALI.M	9566607136	DRIVER	AMUL.S	9566607136	HOUSE WIFE	\N	32/B R.S.PILLAI STREET	\N	TINDIVANAM	TAMILNADU	604001	ST.JOSEPH OF CLUNY MAT.HR.SEC.SCHOOL	STATE BOARD	270.00	58.00	ST.JOSEPH OF CLUNY MAT.HR.SEC.SCHOOL	STATE BOARD	470.00	78.00	2024-09-11	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 14:59:42.718592+05:30	MUSLIM	632896888354	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1711	1808	7	\N	Joe Benedict	J	25TP0417	Male	2008-05-28	O+	Indian	OBC	\N	2025-2029	2	3	joebenedict25tp0417@svcet.ac.in	\N	9363368245	A Jayaseelan	9787666236	lab technician	Sofiya Lawrence Mary	8072353933	teaching	200000.00	NO:34,third cross,manimegalai nagar,thandukarai street,v.manaveli	\N	pondicherry	puducherry	605110	ADITYA VIDYASHRAM RESIDENTIAL SCHOOL	CBSE	342.00	68.40	ADITYA VIDYASHRAM RSIDENTIAL SCHOOL	CBSE	354.00	70.80	2025-09-22	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:00:24.27742+05:30	christian	230473962600	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1701	1798	7	\N	Ashwini	R	25TP0406	Female	2008-06-05	B+	Indian	mbc	\N	2025-2029	2	3	ashwini25tp0406@svcet.ac.in	\N	8681899017	raja	\N	\N	p.kalaiselvi	8124438592	house wife	75000.00	no 461 cheran street thulukanaththamman nagar nainarmandapam 	\N	puducherry	puducherry	605004	annai sivagami girls government higher secondary school	state board	383.00	79.00	annai sivagami girls government highrer secondary school	cbse	397.00	75.00	2025-08-10	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:03:20.641151+05:30	Hindu	581553175158	Day Scholar	BUS	28	f	7	\N	\N	\N	mother
1651	1748	5	\N	JEEVEDHA K	K	24TE0151	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	jeevedha24te0151@svcet.ac.in	\N	6383545795	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:48:27.994959+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1652	1749	5	\N	KAUSTUBH	MISHRA	24TE0152	\N	\N	\N	Indian	\N	\N	2024-2029	3	5	kaustubhmishra24te0152@svcet.ac.in	\N	9360704903	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:48:27.994959+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1653	1750	5	\N	KIRANBHAVAN A	A	24TE0153	\N	\N	\N	Indian	\N	\N	2024-2030	3	5	kiranbhavan24te0153@svcet.ac.in	\N	9894592837	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:48:27.994959+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1654	1751	5	\N	RAKSHINI K	K	24TE0155	\N	\N	\N	Indian	\N	\N	2024-2031	3	5	rakshini24te0155@svcet.ac.in	\N	8072420046	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:48:27.994959+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1655	1752	5	\N	SANJAY S	S	24TE0156	\N	\N	\N	Indian	\N	\N	2024-2032	3	5	sanjay24te0156@svcet.ac.in	\N	6380766624	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:48:27.994959+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1656	1753	5	\N	SARATHI P	P	24TE0157	\N	\N	\N	Indian	\N	\N	2024-2033	3	5	sarathi24te0157@svcet.ac.in	\N	9344765902	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:48:27.994959+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1657	1754	5	\N	Abdhul alim	R	23TE0151	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	abdhulalim23te0151@svcet.ac.in	\N	9952033594	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1658	1755	5	\N	Bhuvanesh	P	23TE0152	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	bhuvanesh23te0152@svcet.ac.in	\N	9360449873	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1659	1756	5	\N	Dheepak dayal raj	A	23TE0153	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	dheepkdayalraj23te0153@svcet.ac.in	\N	9943343284	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1660	1757	5	\N	Gobinath	R	23TE0154	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	gobinath23te0154@svcet.ac.in	\N	8838594731	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1661	1758	5	\N	Pavishwaran	R	23TE0155	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	pavishwaran23te0156@svcet.ac.in	\N	9943301985	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1662	1759	5	\N	Praveen	M	23TE0156	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	praveen23te0156@svcet.ac.in	\N	6382896788	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1663	1760	5	\N	Sabitha	S	23TE0157	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	sabitha23te0157@Svcet.ac.in	\N	8807565052	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1664	1761	5	\N	Sanjai	V	23TE0158	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	sanjai23te0158@svcet.ac.in	\N	6380766624	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1665	1762	5	\N	Swetha	P	23TE0159	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	swetha23te0159@svcet.ac.in	\N	7449127663	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1666	1763	5	\N	Thamizhvanan	V	23TE0160	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	thamizhvanan23te0160@svcet.ac.in	\N	9042568827	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1667	1764	5	\N	Tharun	K	23TE0161	\N	\N	\N	Indian	\N	\N	2023-2027	4	7	tharun23te0161@svcet.ac.in	\N	8667676539	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:49:42.618891+05:30	\N	\N	\N	\N	\N	\N	f	5	\N	\N	\N	\N
1698	1795	7	\N	Akilesh	V	25TP0403	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	akilesh25tp0403@svcet.ac.in	\N	8838709805	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1702	1799	7	\N	Assmath Najiya	M.I.	25TP0407	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	assmadnajiya25tp0407@svcet.ac.in	\N	8778915294	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1705	1802	7	\N	Dhivya Bharathi	V	25TP0411	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	dhivyabarathi25tp0411@svcet.ac.in	\N	9962444130	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1707	1804	7	\N	Gokulnath	N	25TP0413	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	gokulnath25tp0413@svcet.ac.in	\N	9087099825	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1710	1807	7	\N	Jayaprakash	J	25TP0416	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	jayaprakash25tp0416@svcet.ac.in	\N	7538866015	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1712	1809	7	\N	Kirubha Mugilan	S	25TP0418	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	kirubhamugilan25tp0418@svcet.ac.in	\N	6374162826	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1718	1815	7	\N	Ooviya	G	25TP0425	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	ooviya25tp0425@svcet.ac.in	\N	9629863367	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1721	1818	7	\N	Praveen kumar	G	25TP0428	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	praveenkumar25tp0428@svcet.ac.in	\N	9791742406	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1696	1793	7	\N	Abishek	M	25TP0401	Male	2008-02-06	O+	Indian	SC	\N	2025-2029	2	3	abishek25tp0401@svcet.ac.in	\N	8925242887	Murugan N	8681003113	cooly	Sarala M	\N	Home Maker	80000.00	no12 4th street kariyamanickam	\N	puducherry	puducherry	605106	holy flowers higher secondary school 	STATE BOARD	331.00	66.00	holy flowers higher secondary school	STATE BOARD	419.00	71.00	2025-09-01	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:08:58.729057+05:30	HINDHU	204411402097	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1706	1803	7	\N	Dinesh karthik	N	25TP0412	Male	2008-01-31	O+	Indian	MBC	\N	2025-2029	2	3	dineshkarthik25tp0412@svcet.ac.in	natrajmuthulakshmi31@gmail.com	9514711348	NADARADJANE.D	6381663833	EMPLOYEE	MUTHULAKSHMI	\N	HOUSEWIFE	100000.00	NO.40 GANDHI STREET	SIVAGANAPTHY NAGAR VILLIANUR	VILLIANUR	PONDICHERRY	605110	AYA HIGHER SECONDARY SCHOOL	STATEBOARD	393.00	79.00	SRI SANKARS VIDYALAYA HIGHER SECONDARY SCHOOL	STATEBOARD	396.00	66.00	2025-09-12	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:06:24.461103+05:30	HINDU	833449570080	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1723	1820	7	\N	Punidha	J	25TP0430	Female	2007-10-11	O+	Indian	MBC	\N	2025-2029	2	3	punidha25tp0430@svcet.ac.in	\N	7339606674	Jayakumar S	9486522310	Farmer	Kamala J	9489325841	\N	72000.00	no.90,Periya street, Lingareddipalayam, Puducherry 605 502	\N	Puducherry	Puducherry	605 502	Sri Annai Raani Convent CBSE School Puducherry	CBSE	363.00	72.40	Sri Annai Raani Convent CBSE School Puducherry	CBSE	340.00	67.00	2025-09-09	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:16:37.663652+05:30	Hindu	358355408689	Day Scholar	BUS	34	f	7	\N	\N	\N	father
1720	1817	7	\N	Prathika	M	25TP0427	Female	2007-07-15	A+	Indian	MBC	\N	2025-2029	2	3	prathika25tp0427@svcet.ac.in	\N	8870771570	Mathivanan .N	9677685782	coolie	Mangavaram.M	9677685782	House Wife	7200.00	no:6 library street 	eripakkam	Puducherry	Puducherry	605106	holy flowers higher secondary school	Stateboard	399.00	79.80	holy flowers higher secondary school	Sateboard	459.00	76.50	2026-09-22	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:19:13.208885+05:30	Hindu	249076350105	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1724	1821	7	\N	Rajapriyan	N	25TP0431	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	rajapriyan25tp0431@svcet.ac.in	\N	8438271882	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1727	1824	7	\N	Sanjay	S	25TP0434	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	sanjay25tp0434@svcet.ac.in	\N	9884104363	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1728	1825	7	\N	Sarath raj	M	25TP0435	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	sarathraj25tp0435@svcet.ac.in	\N	9361669151	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:31.778737+05:30	\N	\N	\N	\N	\N	\N	f	7	\N	\N	\N	\N
1744	1841	6	\N	KAMELESH	R	25TK0054	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	kamelesh25tk0054@svcet.ac.in	\N	8438394378	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1745	1842	6	\N	KISHORE	B	25TK0055	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	kishore25tk0055@svcet.ac.in	\N	7397317946	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1747	1844	6	\N	LALITKISHORE	S	25TK0057	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	lalitkishore25tk0057@svcet.ac.in	\N	8838363923	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1748	1845	6	\N	MOHESH	P	25TK0058	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	mohesh25tk0058@svcet.ac.in	\N	7358224378	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1749	1846	6	\N	NAVINKUMAR	A	25TK0059	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	navinkumar25tk0059@svcet.ac.in	\N	9500573505	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1750	1847	6	\N	NETHRA	K	25TK0060	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	nethra25tk0060@svcet.ac.in	\N	8248043756	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1751	1848	6	\N	PAVITHRAN	K	25TK0061	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	pavithiran25tk0061@svcet.ac.in	\N	7904702658	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1752	1849	6	\N	POOJA	R	25TK0062	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	pooja25tk0062@svcet.ac.in	\N	7871275626	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1753	1850	6	\N	RAGHASREE	P	25TK0063	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	raghasree25tk0063@svcet.ac.in	\N	9150145351	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1756	1853	6	\N	SASIKUMAR	K	25TK0066	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	sasikumar25tk0066@svcet.ac.in	\N	6385764670	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1759	1856	6	\N	THENMOZHI	S	25TK0069	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	thenmozhi25tk0069@svcet.ac.in	\N	6385637193	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1761	1858	6	\N	VENKATESHWARAN	V	25TK0071	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	venkateshwaran25tk0071@svcet.ac.in	\N	9043004313	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1762	1859	6	\N	VIJAY	R	25TK0072	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	vijay25tk0072@svcet.ac.in	\N	7448326919	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 11:21:56.354334+05:30	\N	\N	\N	\N	\N	\N	f	6	\N	\N	\N	\N
1421	1518	9	43	Test	Student75	45CD0175	Male	2005-12-03	A+	Indian	OBC	\N	2026-2030	1	1	teststudent75@svcet.ac.in	\N	6003071365	Rajan.T	9787679136	Busisnness	Balathanga Valli	6383262279	Business	50000.00	No.12,Ponniamman Kovil Street ,	Pethuchettypet,Lawspet	Puducherry	Puducherry	605008	Aditya Vidyashram residential school	CBSE	500.00	72.00	Aditya Vidyashram residential school	CBSE	500.00	79.00	2023-12-03	CENTAC	t	2026-07-14 11:54:38.483082+05:30	2026-07-22 12:47:47.862849+05:30	Hindu	711752629672	Hostel	OWN	\N	f	\N	\N	\N	\N	father
1309	1394	1	8	Mohamed Thasleem	S	23TD0698	Male	2006-07-03	A+	Indian	OBC	\N	2023-2027	4	7	mohamedthasleem23td0698@svcet.ac.in	\N	7449258754	Saleem.A	7092591410	Labour	Reziya Begam	9369448971	House Wife	71998.00	No:1  Kamaraj Nagar,Main road	Nellikuppam	Cuddalore	Tamil Nadu	607105	Danish Mission Higher Secondary School	State Board	500.00	100.00	Danish Mission Higher Secondary School	State Board	393.00	63.00	2023-08-10	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-22 12:57:07.123109+05:30	Muslim	572650349680	Day Scholar	OWN	\N	f	\N	\N	\N	\N	father
1552	1649	1	11	ABISHEK	P	25TD0601	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	abishek25td0601@svcet.ac.in	\N	7448552294	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1758	1855	6	\N	SURESH	R	25TK0068	Male	2008-02-12	A+	Indian	obc	\N	2025-2029	2	3	suresh25tk0068@svcet.ac.in	\N	9363283202	R.ramesh	9629448399	daily wager	R.jaya	7538809375	house wife	8000.00	no.62, marriamman kovil street, moorthinagar, villianurr	\N	Villianur	puducherry	605110	Galaxy English High School	State board	334.00	67.00	Jawahar Higher Secondary School	State board	443.00	73.00	2025-09-01	CENTAC	t	2026-07-22 11:21:56.354334+05:30	2026-07-23 15:42:32.446796+05:30	Hindu	892556500970	Day Scholar	OWN	\N	f	6	\N	\N	\N	father
1757	1854	6	\N	SHEIK IMRAN	S	25TK0067	Male	2007-09-16	AB+	Indian	BC	\N	2025-2029	2	3	sheikimran25tk0067@svcet.ac.in	sheikimran127@gamil.com	8122747106	Sadhik basha .S	8940865498	Manager	Hasina	9786626945	House Wife	99999.00	No 287 darga street ecr main road koonimedu	\N	villupuram	Tamil Nadu	604303	St.ann's higher secondary school	State Board	354.00	75.00	St.ann's higher secondary school	State Board	431.00	71.00	2025-09-01	MANAGEMENT	t	2026-07-22 11:21:56.354334+05:30	2026-07-23 15:39:46.200232+05:30	Muslim	735416474642	Day Scholar	OWN	\N	f	6	\N	\N	\N	father
1741	1838	6	\N	ANBUSELVAN	A	25TK0051	Male	2008-08-02	A+	Indian	BC	\N	2025-2029	2	3	anbuselvan25tk0051@svcet.ac.in	\N	9994430074	Arulselvam.S	9500333945	Dhinakaran , Manager .	Nathiya.A	9677333735	house wife	\N	NO57.B Srinivasa garden , Kakayanthopu	 Ariyankupam 	pondicherry	pondicherry	605007	Amalorpavam Higher Secondary School	state bord	319.00	48.00	Amalorpavam higher secondry school	state bord	345.00	50.00	2025-08-24	CENTAC	t	2026-07-22 11:21:56.354334+05:30	2026-07-23 15:44:21.696249+05:30	Hindu	390057048059	Day Scholar	BUS	27	f	6	\N	\N	\N	father
1725	1822	7	\N	Rokesh	K	25TP0432	Male	2008-05-18	B+	Indian	BC	\N	2025-2029	2	3	rokesh25tp0432@svcet.ac.in	\N	9597782290	P. Kannan	9842480173	Gold Smith	K. Kavitha	7092653735	working in medical agency	100000.00	17/26 north iyyanar kulam 	\N	villupuram	villupuram	605602	sri kamakoti orential high school	STATE	267.00	53.30	governmemnt higher secondary school 	STATE	361.00	60.16	2025-09-17	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:00:51.51277+05:30	hindu	577054567817	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1564	1661	1	11	DHARSHINI	M	25TD0613	Female	2008-08-08	B-	Indian	MBC	\N	2025-2029	2	3	dharshini25td0613@svcet.ac.in	\N	9789387617	P.Manimaran	8220201675	Hotel Master	M.Selvi	9789387617	House Maid	80000.00	no:06,salai mari aaman kovil street muthialpet	\N	puducherry	puducherry	605003	Subramaniya Baharathiyar Government Girls Higher Secondary School	state board	326.00	65.50	Thiruvalluvar Goverment Girls Higher Secondart School	CBSE	302.00	60.40	2025-09-02	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:12:19.499224+05:30	Hindu	325223026056	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1732	1829	7	\N	Sibiraj	R	25TP0439	Male	2008-04-13	O+	Indian	SC	\N	2025-2029	2	3	sibiraj25tp0439@svcet.ac.in	\N	9025188174	renganathan D	9003571799	hotel labour	senbagam R	9342755636	Home maker	80000.00	No.20 velan nagar,inthirapriyadharshini street,saram	\N	puducherry	puducherry	605013	st.antony govt aided high school	STATE BOARD	295.00	59.00	presidency higher secondary school(elite)	STATE BOARD 	405.00	69.00	2025-09-01	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:08:53.762181+05:30	HINDU	378746562600	Day Scholar	OWN	\N	f	7	\N	\N	\N	mother
1730	1827	7	\N	Sarika	B	25TP0437	Female	2007-08-30	B+	Indian	MBC	\N	2025-2029	2	3	sarika25tp0437@svcet.ac.in	\N	9952880130	Balamurugan P	8438037437	Daily Wages	Saraswathy B	9443077116	House Wife	72000.00	No.2/245, Main Road, Mitta Mandagapattu	\N	Villupuram	Tamilnadu	605 106	S R Government Girls Higher Secondary School	State board	427.00	85.40	S R Government Girls Higher Secondary School	State board	536.00	89.30	2025-09-08	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:16:38.130289+05:30	Hindu	455351399036	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1726	1823	7	\N	Sadhana	M	25TP0433	Female	2007-03-08	A+	Indian	OBC	\N	2025-2029	2	3	sadhana25tp0433@svcet.ac.in	\N	9342665654	MADHAVAN S	\N	\N	LOGANAYAKI M	9787929266	DAILY WAGE	\N	NO.395,post office street,vazhudhavur, villupuram	\N	VILLUPURAM	TAMILNADU	605502	SRI ANNAI RANNI CONVENT CBSE 	CBSE	392.00	78.40	SRI ANNAI RANNI CONVENT	CBSE	375.00	75.00	2025-09-17	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:22:03.092632+05:30	HINDU	884127752549	Day Scholar	BUS	34	f	7	RAMALINGAM S	9840444214	DRIVER	guardian
1777	1901	4	\N	RITHICKVASAN	S	25TJ0065	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	rithickvasan25tj0065@svcet.ac.in	\N	9944776276	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1778	1902	4	\N	RUFENA	J	25TJ0066	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	rufena25tj0066@svcet.ac.in	\N	9629042006	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1626	1723	1	11	RUPESH	S	25TD0675	Male	2007-08-19	O+	Indian	MBC	\N	2025-2029	2	3	rupesh25td0675@svcet.ac.in	\N	8610059179	SELVAKOUMAR	9364134615	BUSINESS MAN	BHARATHI S	6384513379	Home Maker	84000.00	4TH NEHRU STREET KATHIRKAMAM	4TH NEHRU STREET KATHIRKAMAM	puducherry	puducherry	605009	NEW MODERN VIDHYA MANDIR HIGHER SECONDARY SCHOOL 	STATE BOARD	450.00	90.00	NEW MODERN VIDHYA MANDIR HIGHER SECONDARY HIGHER	STATE BOARD	478.00	79.00	2025-09-19	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:15:39.446934+05:30	HINDU	332481776196	Day Scholar	BUS	36	f	1	\N	\N	\N	mother
1623	1720	1	11	RATHEESH	R	25TD0672	Male	2007-07-01	O+	Indian	mbc	\N	2025-2029	2	3	ratheesh25td0672@svcet.ac.in	\N	9342041190	 Ramesh A	8220533169	government health center	Deepa R	8220533169	house wife	200000.00	04,majakupathar st	 bommaiyerpalayam,tamilnadu	bommaiyarpalayam	tamil nadu	605104	Fathima .Hr.Sec.school	state board	325.00	67.00	Fathima .Hr.Sec.school	state board	415.00	70.00	2025-08-19	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:18:23.744125+05:30	Hindu	617719559322	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1571	1668	1	11	GUGAN	K	25TD0620	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	gugan25td0620@svcet.ac.in	\N	9894765715	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1573	1670	1	11	HARINIVASS	K	25TD0622	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	harinivass25td0622@svcet.ac.in	\N	9443344232	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1574	1671	1	11	HEPHZIBBAH	D	25TD0623	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	hephzibbah25td0623@svcet.ac.in	\N	8870218297	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1578	1675	1	11	JAIKRISHNA	S	25TD0627	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	jaikrishna25td0627@svcet.ac.in	\N	8610533273	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1584	1681	1	11	JOYAL	B	25TD0633	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	joyal25td0633@svcet.ac.in	\N	7538870722	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1586	1683	1	11	KABILSHA	K	25TD0635	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	kabilsha25td0635@svcet.ac.in	\N	9360064135	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1629	1726	1	11	SANDOSH	K	25TD0678	Male	2008-03-05	B+	Indian	MBC	\N	2025-2029	2	3	sandosh25td0678@svcet.ac.in	\N	9443623140	kumaraguru.S	9486747621	farmer	k.saroja	9443623140	housewife	100000.00	29,mela street,chettipet,kodukkur post,pondicherry	\N	Pondicherry	Puducherry	605501	sandosh k	CBSE	347.00	69.00	AVRS	CBSE	361.00	72.00	2025-07-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:20:46.030255+05:30	hindu	984432971692	Day Scholar	BUS	17	f	1	\N	\N	\N	father
1603	1700	1	11	MAHABOOB KHAN	K	25TD0652	Male	2007-10-23	O+	Indian	BCM	\N	2025-2029	2	3	mahaboobkhan25td0652@svcet.ac.in	\N	8940442615	\N	\N	\N	Anar kali.k	8270985716	Home nurse	74000.00	no 89,chinnapallivasal st,	pakkiripalayam	panruti	Tamilnadu	607106	seventhday adventist matric hr sec school	state board 	316.00	63.20	Seventhday adventist matric hr sec school 	state board	488.00	81.30	2025-08-23	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:29:01.971548+05:30	Muslim	516422290341	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1608	1705	1	11	MOHAMED SAHIL	S	25TD0657	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	mohamedsahil25td0657@svcet.ac.in	\N	7548842436	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1613	1710	1	11	NISHANTH	M	25TD0662	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	nishanth25td0662@svcet.ac.in	\N	9444124784	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1615	1712	1	11	PRADEEP	G	25TD0664	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	pradeep25td0664@svcet.ac.in	\N	7358985178	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1621	1718	1	11	RAGHAVI	K	25TD0670	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	raghavi25td0670@svcet.ac.in	\N	7806998228	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1634	1731	1	11	SHARMA	S	25TD0683	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	sharma25td0683@svcet.ac.in	\N	9043829943	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:18:41.774427+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1580	1677	1	11	JANANI	S	25TD0629	Female	2007-12-11	O+	Indian	MBC	\N	2025-2029	2	3	janani25td0629@svcet.ac.in	\N	9150172704	Suresh .A 	9789763458	Tailor 	Revathi 	9655814062	House wife	75000.00	29 mayor narayanaswamy nagar karuvadikuppam 	lawspet 	puducherry 	Puducherry	605008	vallalar Girls Govt higher secondary school 	state board	367.00	73.40	vallalar Girls govt higher secondary school	cbse	365.00	73.00	2025-12-08	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:30:35.135814+05:30	Hindu	426563826006	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1637	1734	1	50	SUJITH	V	25TD0686	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	sujith25td0686@svcet.ac.in	\N	9344152255	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-22 10:45:13.145749+05:30	2026-07-22 14:20:31.255935+05:30	\N	\N	\N	\N	\N	f	1	\N	\N	\N	\N
1572	1669	1	11	HARINI	M	25TD0621	Female	2007-10-20	A-	Indian	mbc	\N	2025-2029	2	3	harini25td0621@svcet.ac.in	\N	9384458781	K. Manikandan	8754926516	Driver	M. Santhalakshmi	7373695405	Housewife	100000.00	10,kannagi street,indira gandhi nagar,orleanpet,puducherry.	\N	Puducherry	Tamilnadu	605102	St.Antony's govt.aided.high.school	state board 	366.00	69.00	manimegalai.higher.secondary.school	cbse	371.00	68.00	2025-05-20	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:10:17.454098+05:30	HINDU	919596694932	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1606	1703	1	11	MOHAMED FAHATH	N	25TD0655	Male	2007-12-05	O+	Indian	bc	\N	2025-2029	2	3	mohamedfahath25td0655@svcet.ac.in	\N	7868824785	NAZIROUDINE	9790606477	BUSNESS	FATHIMA THOULAT	9600652489	HOUSE WIFE	100000.00	no:4/a kuttavappu st	kottakuppam	villupuram	Tamil Nadu	605104	PETIT SEMINAIRE HIGHER SECONDARY SCHOOL	STATE BOARD	287.00	57.00	PETIT SEMINAIRE HIGHER SECONDARY SCHOOL	STATE BOARD	285.00	47.00	2026-09-22	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:34:16.471176+05:30	muslim	699015832008	Day Scholar	BUS	20	f	1	\N	\N	\N	father
1617	1714	1	11	PRATHIBHA	S	25TD0666	Female	2007-10-17	B+	Indian	OBC	\N	2025-2029	2	3	prathibha25td0666@svcet.ac.in	\N	7548882993	SAKTHIVEL	8124420095	DRIVER	PRIYA	7339360682	Home Maker	200000.00	KURUNJI STREET,JOTHI NAGAR,MUDALIARPET	KURUNJI STREET,JOTHI NAGAR,MUDALIARPET	puducherry	puducherry	605004	AMALORPAVAM HR SEC SCHOOL	STATE BOARD	312.00	68.00	AMALORPAVAM HR SEC SCHOOL	STATE BOARD	423.00	69.00	2025-09-14	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:35:09.789517+05:30	HINDU	682373666915	Day Scholar	BUS	26	f	1	\N	\N	\N	mother
1600	1697	1	11	LEVEESHNA	M	25TD0649	Female	2008-02-13	O+	Indian	EBC	\N	2025-2029	2	3	leveeshna25td0649@svcet.ac.in	\N	8438266576	malaiyalathan	9894353083	fishing	vijayalakshmi	\N	House Wife	80000.00	No.8 Kamarajar street,solai nagar,(near youth hostel),muthialpet	\N	Puducherry	Puducherry	605003	New Modern Vidhya Mandir hr.sec.school	Stateboard	330.00	66.00	New Modern Vidhya Mandir hr.sec.school	Sateboard	387.00	64.50	2025-09-10	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:40:09.134133+05:30	Hindu	947413689454	Day Scholar	BUS	20	f	1	\N	\N	\N	father
1614	1711	1	11	PAVITHRA	K	25TD0663	Female	2007-07-01	O+	Indian	mbc	\N	2025-2029	2	3	pavithra25td0663@svcet.ac.in	\N	8838558708	kannan R	8838558708	mason	Manjula K	8940307855	house wife	100000.00	05,thoppu street 	chinnakottakuppam 	villupuruam district	Tamil nadu	605104	sri Aravindar Higher Secondary School	state board	384.00	64.00	Sri Aravindar Higher secondary School	state board	364.00	60.00	2025-08-19	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:48:34.664954+05:30	Hindu	421347391737	Day Scholar	BUS	6	f	1	\N	\N	\N	father
1640	1737	1	50	UDHAYANIDHI	A	25TD0689	Male	2007-10-20	O+	Indian	MBC	\N	2025-2029	2	3	udhayanidhi25td0689@svcet.ac.in	\N	6383455304	Anbajagane	9843691200	Farmer	Rajalakshimi 	6369935381	House Wife	\N	No,105 MARIAMMAN KOIL ST, PILLAYARKUPPAM, PONDICHERRY 605 502.	\N	Puducherry	Puducherry	605502	SRI ANNAI RAANI CONVENT HR SEC SCHOOL PUDUCHERRY	CBSE	364.00	72.80	ADITYA VIDYASHRAM PORIYUR VILLIANUR PUDUCHERRY	CBSE	348.00	69.60	2025-09-25	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:38:17.307981+05:30	Hindu	464268704639	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1779	1903	4	\N	SHANGARI	T	25TJ0067	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	shangari25tj0067@svcet.ac.in	\N	9092135568	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1643	1740	1	11	VIJAY	S	25TD0692	Male	2008-07-03	A+	Indian	obc	\N	2025-2029	2	3	vijay25td0692@svcet.ac.in	vijaysuresh788@gmail.com	8680867530	SURESH	8124443865	MASON	MALA	9585881983	HOUSE WIFE	200000.00	PLOT NO 29 ,SRI BALAJI NAGAR	MANAVELI,VILLIANUR COMMUNE PANCHAYAT	PONDHICHERRY	PONDHICHERRY	605110	TVKGHSS ARUMPATHAPURAM	TN STATE BOARD	335.00	67.00	IAGHSS MUTHRAIYARPALAYAM	CBSE	286.00	59.00	2025-09-25	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:18:02.989642+05:30	HINDU	940726250789	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1583	1680	1	11	JOEL	J	25TD0632	Male	2008-03-09	O+	Indian	obc	\N	2025-2029	2	3	joel25td0632@svcet.ac.in	jjoeldavid2008@gmail.com	7810097014	David janakiraman 	8778125872	computer engineer	leediyal thamizwari	9894173932	housewife	70000.00	no s4 2nd floor annai lourd appartment 4th cross ragavendira nagar boomiyanpet pondicherry 605005 	\N	puducherry	puducherry	605005	PETIT SEMINAIRE HIGHER SECONDARY SCHOOL	stateboard	232.00	40.00	SRI SANKARA VIDYALAYA HIGGHER SECONDARY SCHOOL	stateboard	343.00	57.00	2025-08-19	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:31:03.218997+05:30	Christian	436841682483	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1650	1747	1	11	YUVABHARATHI	V	25TD0699	Female	2007-11-12	B+	Indian	OBC	\N	2025-2029	2	3	yuvabharathi25td0699@svcet.ac.in	\N	7395842872	Venkatesan	9443858451	Business	Boomathi	8428728901	Housewife	200000.00	No.8 south street korkadu	\N	PUDUCHERRY	Puducherry	605110	Achariya siksha mandir	CBSE	320.00	64.00	Balaji higher secondary school	STATE BOARD	475.00	79.00	2025-09-10	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:38:12.434095+05:30	Hindu	801685032903	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1636	1733	1	11	SRI PAVITHRA	N	25TD0685	Female	2007-01-17	O+	Indian	MBC	\N	2025-2029	2	3	sripavithra25td0685@svcet.ac.in	\N	8122784391	Narasimman.T	9159817995	coolie	Lakshmi.N	9159406205	housewife	72000.00	no.49 maraimalai nagar,velarmpet,mudaliarpet	no.49 maraimalai nagar,velarmpet,mudaliarpet	Pondicherry	Puducherry	605004	soucilababa government girls high secondary school	Tamil Nadu State Board	366.00	75.00	thrivalluvar government girls higher secondary school	CBSE	363.00	73.00	2025-05-12	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:44:57.363351+05:30	hindu	941866261756	Day Scholar	BUS	27	f	1	\N	\N	\N	father
1462	1559	1	10	Guhan	M	24TD0781	Male	2007-02-16	O+	Indian	MBC	\N	2024 -2028	3	5	guhan24td0781@svcet.ac.in	mguhan6383@gmail.com	6383236623	Murugaiyan B	9042870593	Carpenter	Shyamala M	6384947914	Home Maker	80000.00	No. : 29, Vinayagar kovil Street, Near State Bank of India,Auroville	\N	Villupuram	Tamilnadu	605101	Kuyilappalam Higher Secondary School	State Board	427.00	85.00	Kuyilappalam Higher Secondary School	State Board	553.00	92.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 14:54:06.331546+05:30	Hindhu	86435955110	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1648	1745	1	50	VISHNUPRIYAN	M	25TD0697	Male	2008-07-28	A+	Indian	MBC	\N	2025-2029	2	3	vishnupriyan25td0697@svcet.ac.in	mgvishnupriyan@gmail.com	9597756706	Mouttoucoumaran	9865693201	Enforcement Assistant 	Gunavathy	9487639605	Home Maker	100000.00	Plot No: 8 and 9, Kamarajar Street, Roja Nagar, Arumparthapuram, Puducherry - 605010 	\N	Puducherry	Puducherry	605010	Petit Seminaire Higher Secondary School	State Board	383.00	76.60	Petit Seminaire Higher Secondary School	State Board	472.00	78.60	2025-09-19	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:58:15.051878+05:30	Hindu 	476668440519	Day Scholar	BUS	19	f	1	\N	\N	\N	father
1490	1587	1	9	Nivetha	S	24TD0810	Female	2007-05-04	O+	Indian	MBC	\N	2024 -2028	3	5	nivetha24td0810@svcet.ac.in	\N	8610903577	Selvaganapathi.v	9786456820	Farmer	Sumathi.S	8220565384	Home maker	60000.00	Plot No:104 	Sri kumaran nagar bangala street	Uruvaiyaru	Puducherry	605110	John Dewey Matric Hr Sec School	state board	337.00	67.00	John Dewey Matric Hr Sec School	State board	397.00	64.00	2024-09-15	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 14:59:39.443445+05:30	hindu	735059520804	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1592	1689	1	50	KAYALVIZHI	U	25TD0641	Female	2007-09-10	O+	Indian	OBC	\N	2025-2029	2	3	kayalvizhi25td0641@svcet.ac.in	kayalpapu@2007@gmail.com	8610104810	Udhayakumar.R	9842329029	Lic agent	selvi.U	8678994911	House wife	100000.00	93,kanniya kovil street,bahour,puducherry	\N	puducherry	Puducherry	607402	professor annoussamy Hr.Sec school	state board	413.00	82.60	professor annoussamy Hr.Sec school	state board	528.00	88.00	2026-09-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:04:30.683121+05:30	Hindu	613867520108	Day Scholar	BUS	30	f	1	\N	\N	\N	father
1593	1690	1	50	KEERTHANA	P	25TD0642	Female	2008-05-27	O+	Indian	obc	\N	2025-2029	2	3	keerthana25td0642@svcet.ac.in	keerthi1212w@gmail.com	9629877595	Prabhakaran	9629877595	Cashier	Saridha	9629877595	nil	100000.00	No:114, Veermamunivar street sapthagiri diamond city,Iyyankuttipalayam	\N	pondicherry	pondicherry	605009	Immaculate heart of mary girls higher secondary school	State board	405.00	81.00	immaculate heart of mary girls hiher secondary school	State board	468.00	78.00	2026-09-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:05:35.59896+05:30	Hindhu	289973276221	Day Scholar	BUS	37	f	1	\N	\N	\N	\N
1599	1696	1	50	LEELA VINOTHINI	B	25TD0648	Female	2007-10-27	O+	Indian	obc	\N	2025-2029	2	3	leelavinothini25td0648@svcet.ac.in	leelavinothini84@gmail.com	9443393034	boopathi.S	7708466182	grocery shop	lalitha.B	9042629177	house wife	70000.00	no:27 ambedkar nagar,odiyampet road,villianur	no:27 ambedkar nagar,odiyampet road,villianur	puducherry	puducherry	605110	Immaculate heart of mary girls higher secondary school	state board	303.00	60.60	Immaculate heart of mary girls higher secondary school	state board	379.00	63.10	2025-09-27	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:07:33.292543+05:30	hindu	488546648839	Day Scholar	BUS	25	f	1	\N	\N	\N	father
1557	1654	1	50	ASHIFA BEGUM	A	25TD0606	Female	2008-05-20	B+	Indian	BCM	\N	2025-2029	2	3	ashifabegum25td0606@svcet.ac.in	ashifaajmeerali@gmail.com	8925071296	Ajmeer ali.M	8124297156	Tourist gaurd	Isa nachiya	7339693386	Home maker	180000.00	no.7,kulathumettu street	kombakkam	puducherry	puducherry	605 110	Newland english high school	State board	423.00	84.00	Alpha matriculation higher secondary school	State board	462.00	75.00	2025-09-18	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:10:23.384025+05:30	Muslim	397197554016	Day Scholar	BUS	25	f	1	\N	\N	\N	father
1438	1535	1	10	Athiseshan	V	24TD0757	Male	2006-10-16	O+	Indian	MBC	\N	2024 -2028	3	5	athiseshan24td0757@svcet.ac.in	athiseshan06@gmail.com	8870068952	Velu D	9597260871	plumber	Tamilselvi	9384967217	house-wife	\N	no.6,middle st,periyakalapet	\N	pondicherry	puducherry	605014	kolping matriculation higher secondary school	state board	240.00	48.00	kolping matriculation higher secondary school	state board	333.00	55.50	2024-09-19	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:10:47.705082+05:30	Hindu	589639696440	Day Scholar	BUS	24	f	1	\N	\N	\N	father
1581	1678	1	50	JAYAVASUDEVAN	P	25TD0630	Male	2008-06-10	AB-	Indian	bc	\N	2025-2029	2	3	jayavasudevan25td0630@svcet.ac.in	vasudevan200810@gmail.com	9345670320	prabu.k	9994773058	\N	manjula.p	9345670320	\N	\N	vallar kovil st,azhiyur,thiruvandarkovil	\N	puducherry	tamilnadu	620005	VRP higher sec school	state board	350.00	70.00	blue stars higher sec school	stateboard	395.00	64.00	2025-09-10	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:11:31.831588+05:30	hindu	829655848320	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1434	1531	1	9	Abinaya	G	24TD0752	Female	2007-08-25	O+	Indian	OBC	\N	2024 -2028	3	5	abinaya24td0752@svcet.ac.in	\N	7092425117	Ganesan	9626963665	Mechanical work	Tamilarasi	7010679895	Housewife	100000.00	NO.43,Main Road,vadamangalam,Puducherry.	\N	Puducherry	Pondicherry	605102	Baghavan Sri Ramakrishna English High school	STATE BOARD	500.00	80.00	Presidency Hr.Sec school	STATE BOARD	600.00	76.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:13:30.270075+05:30	Hindu	787904794590	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1509	1606	1	9	Sakkeena Begam	T	24TD0829	Female	2006-11-25	A+	Indian	obc	\N	2024 -2028	3	5	sakkeenabegam24td0829@svcet.ac.in	\N	8940453382	Thameen.S	9843829582	electrician	Kamrunnissa.T	9843708540	homemaker	75000.00	no 24	Kumaran nagar,ariyur	puducherry	puducherry	605102	sri ramachandra vidyalaya high school	state board	445.00	89.80	aditya's bharathidasan higher secondary school	state board	478.00	78.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:21:34.120923+05:30	muslim	974454249917	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1780	1904	4	\N	SORNA RAJESWARI	S	25TJ0068	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	sornarajeswari25tj0068@svcet.ac.in	\N	9486447497	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1535	1632	1	10	Vijayalakshmi	S	24TD0856	Female	2007-03-30	A-	Indian	OBC	\N	2024 -2028	3	5	vijayalakshmi24td0856@svcet.ac.in	\N	7395923968	sivanandham G	9500552699	Bussinesman	Jayasudha S	9500332590	Housewife	\N	no.27 old market street mudaliyarpet puducherry 605004	\N	puducherry	puducherry	605004	AMALORPAVAM HIGHER SECONDARY SCHOOL	State Board	386.00	77.80	AMALORPAVAM HIGHER SECONDARY SCHOOL	State Board	476.00	78.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:37:13.97085+05:30	Hindu	841060546461	Day Scholar	BUS	27	f	1	\N	\N	\N	mother
1536	1633	1	10	Vijayalakshmi	S	24TD0857	Female	2007-04-20	O+	Indian	MBC	\N	2024 -2028	3	5	vijayalakshmi24td0857@svcet.ac.in	\N	6379646702	Senthil.D	6369661128	driver	Santhi.S	9092785963	home maker	72000.00	No 601,vinayagr kovil street pannakuppam,villupuram,Tamilnadu	\N	villupuram	Tamilnadu	605102	Vallalar Government Higher Secondary School,Kandamangalam	state	295.00	59.00	 Vallalar Government Higher Secondary School,Kandamangalam	state	324.00	54.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:45:08.085363+05:30	hindu	877090253094	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1541	1638	1	9	Yeshua	R	24TD0862	Male	2007-03-28	O+	Indian	General	\N	2024 -2028	3	5	yeshua24td0862@svcet.ac.in	yeshuasamani@gmail.com	9043421431	Rajesh Kumar P	9043921431	Photographer	Gracy R	9940970419	House Wife	120000.00	No. 47, 1st Cross, Senthamarai Nagar, Thattanchavadi, Villianur, Puducherry-605110.	\N	Pondicherry	Puducherry	605110	Stansford International Hr.Sec.School	CBSE	342.00	66.00	Stansford International Hr.Sec.School	CBSE	346.00	69.00	2024-09-23	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:17:52.889469+05:30	Christian	231689783189	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1549	1646	1	9	Balamani	P	24TDL018	Male	2004-09-10	B+	Indian	obc	\N	2024 -2028	3	5	jb7524751@gmail.com	\N	7397734594	Pirabagaran	7397734594	Painter	Sundarambal	7397734594	HOUSE WIFE	50.00	no3rd cross street karunajothi nagar swamipilathotam	tamil oli main road 	PUDUCHERRY	PONDYCHERRY	605008	Fathima hr Secondary School	STATE BOARD 	250.00	50.00	Manakula vinayagar Polytechnic College	Pondicherry university	64.00	64.00	2025-07-06	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:04:21.285598+05:30	hindu	510437295765	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1488	1585	1	9	Nirmal	N	24TD0808	Male	2007-06-01	O+	Indian	obc	\N	2024 -2028	3	5	nirmal24td0808@svcet.ac.in	\N	9500880169	Nagarajan N	7598940499	driver	Jayanthi K	9597475799	Typist	300000.00	No,104,105 sri jayaram nagar,vaikkal mettu st.,	uruvaiyar	puducherry	puducherry	605110	Amalorpavam higher secondary school	state board	349.00	70.00	acharya shiksha mandir	state board	411.00	70.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:07:22.88764+05:30	Hindu	0000000000	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1475	1572	1	9	Kishore	C	24TD0795	Male	2007-07-12	AB+	Indian	MBC	\N	2024 -2028	3	5	kishore24td0795@svcet.ac.in	\N	7305170902	Caliyanassundharam.S	9500541902	Business	Thaiyalnayagi.C	9842399002	House wife	300000.00	16,bharathi street nainarmandabam,puducherry	\N	puducherry	puducherry	605004	Amalorpavam Higher Secondary school	state board	300.00	60.00	Amalorpavam Higher Secondary school	State board	401.00	66.00	2024-09-09	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:16:27.938583+05:30	HINDU	999102707935	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1565	1662	1	11	DHIVAGAR	G	25TD0614	Male	2008-07-22	O+	Indian	MBC	\N	2025-2029	2	3	dhivagar25td0614@svcet.ac.in	\N	9597102215	Govinda perumal J	9943538683	private company	Deepa G	9751533244	private company	75000.00	No.50 Thoppu street	Lingareddipalayam	pondicherry	puducherry	605502	Sri Annai Rani Convent CBSE school	CBSE	445.00	89.00	Sri Annai Rani Convent CBSE school	CBSE	405.00	81.00	2025-09-10	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:02:21.495243+05:30	Hindu	279039124629	Day Scholar	OWN	\N	f	1	-	\N	-	father
1563	1660	1	11	DHANYASHRI	B	25TD0612	Female	2006-10-23	O+	Indian	mbc	\N	2025-2029	2	3	dhanyashri25td0612@svcet.ac.in	\N	8940071295	Baskar  V	9363736560	worker	Chithira B	8940071295	housewife	70000.00	sri mahalakshmi nagar,pangur	\N	puducherry	puducherry	605102	sri ramachandra vidhyalaya high school,ariyur	stateboard	480.00	96.00	achariya siksha mandir,villianur	stateboard	548.00	91.20	2025-08-23	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:03:12.46628+05:30	hindu	918401319003	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1781	1905	4	\N	SRIDHAR	D	25TJ0069	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	sridhar25tj0069@svcet.ac.in	\N	8778821398	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1534	1631	1	10	Vaishnavi	R	24TD0855	Female	2007-02-08	O+	Indian	MBC	\N	2024 -2028	3	5	vaishnavi24td0855@svcet.ac.in	\N	7708382307	K.ravi	9486173981	councillor	R.seetha	9597356680	House wife	90000.00	Kuber nagar,1st left street,tamilnadu	\N	Thiruvannamalai	tamilnadu	606	sishya matric.hr.sec.school	state board	376.00	70.00	sishya matric.hr.sec.school	state board	326.00	59.00	2024-08-08	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:18:54.563238+05:30	Hindu	897025609409	Hostel	OWN	\N	f	1	\N	\N	\N	mother
1539	1636	1	10	Yagajanani	P	24TD0860	Female	2007-07-26	B+	Indian	MBC	\N	2024 -2028	3	5	yagajanani24td0860@svcet.ac.in	\N	8838783145	Pargunan D	9787120805	Driver	Prabavathy P	8838783145	Homemaker	90000.00	727,Murugan Kovil street,Pannakuppam,tamilnadu	\N	kandamangalam	Tamilnadu	605102	Sri Navadurga English Higher Secondary school	State Board	401.00	80.20	Sri Navadurga English Higher Secondary school	State Board 	454.00	74.00	2024-07-17	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:19:11.068702+05:30	hindu	535665180337	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1538	1635	1	10	Vishalini	P	24TD0859	Female	2006-08-18	O+	Indian	OBC	\N	2024 -2028	3	5	vishalini24td0859@svcet.ac.in	\N	7358481018	Poongol	8870319710	Fiber work	Thirupurasundari	8870461513	\N	\N	NO.17,2nd cross thiruveni nagar extn,V.Manaveli Arumathapuram,Puducherry	\N	Puducherry	Puducherry	605110	Amalorpavam Higher Secondary School	State	389.00	77.80	Amalorpavam Higher Secondary School	State	420.00	70.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:26:01.365861+05:30	HINDU	599959423160	Day Scholar	BUS	19	f	1	\N	\N	\N	father
1496	1593	1	10	Prashanthi	S	24TD0816	Female	2007-09-20	O+	Indian	SC	\N	2024 -2028	3	5	prashanthi24td0816@svcet.ac.in	\N	8807157609	R. SATHISH KUMAR	9500143159	OPERATOR	S.JAYALAKSHMI	9600109314	HOUSE WIFE	300000.00	NO.7 POOGAVANAM CHETTIYAR ST, PERIYAKALAPET PUDUCHERRY	NO.7 POOGAVANAM CHETTIYAR ST, PERIYAKALAPET PUDUCHERRY	PUDUCHERRY	PONDYCHERRY	605014	AMALA HIGHER SECONDARY SCHOOL	STATE BOARD 	300.00	60.00	AMALA HIGHER SECONDARY SCHOOL	STATE BOARD	428.00	72.00	2024-07-24	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:26:21.590721+05:30	INDHU	548777327990	Day Scholar	BUS	6	f	1	\N	\N	\N	father
1529	1626	1	10	Tanzeela Sultana	A	24TD0849	Female	2007-04-20	B+	Indian	MBC	\N	2024 -2028	3	5	tanzeelasultana24td0849@svcet.ac.in	\N	8825807686	A M Abdullah	99056053	Pharmacist	A Jubairiya Begam	9894042971	Housewife	-1.00	No:15,Muslim Street, Melpattampakkam, Cuddalore	\N	Cuddalore	Tamil Nadu	607104	ARLM Vidyalayam	State Board	403.00	80.50	ARLM Vidyalayam	State Board	477.00	79.50	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:27:36.984338+05:30	Muslim	489789362996	Day Scholar	BUS	23	f	1	\N	\N	\N	father
1467	1564	1	10	Hemavathy	S	24TD0786	Female	2007-05-18	O+	Indian	mbc	\N	2024 -2028	3	5	hemavathy24td0786@svcet.ac.in	\N	9443817088	\N	\N	\N	Indira	9791294188	\N	\N	No 120,Sivagami nagar,Ariyankuppam,puducherry	\N	Puducherry	Puducherry	605007	Soucilabai higher secondary school	state board	357.00	71.00	Subramania bharathiyar higher secondary school	state board	431.00	71.00	2024-09-14	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:28:51.830365+05:30	Hindu	445783430819	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1532	1629	1	10	Vaishnavi	C	24TD0853	Female	2006-12-10	A+	Indian	sc	\N	2024 -2028	3	5	vaishnavi24td0853@svcet.ac.in	vaishnavicouabre@gamil.com	7845246973	S.Coubare	8300613703	Photograhper	C.vatchala	7448396579	Homemaker	75000.00	No 2A Mariyamman Kovil st,karayambuthur,puducherry	\N	puducherry	puducherry	605106	Krishnaswamy mem. metcri.higher. sec school	stateboard	356.00	71.00	Krishnaswamy mem. metcri.higher. sec school	stateboard	445.00	74.00	2024-08-20	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:33:10.784739+05:30	Hindhu	904219060799	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1587	1684	1	11	KAILASH	N	25TD0636	Male	2007-07-01	A+	Indian	MBC	\N	2025-2029	2	3	kailash25td0636@svcet.ac.in	\N	7418129608	Narayanasamy  A	8807293470	farmer	Kalaivani N	9629688710	housewife	75000.00	gangai amman street 	omanthur	thindivanam	tamil nadu	604001	VKM vidhyalaya higher secondary school	CBSE	239.00	47.80	Walter scudder higher secondary school	Sateboard	333.00	55.50	2025-06-09	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:11:14.046479+05:30	Hindu	371120828587	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1641	1738	1	11	UGAM	R	25TD0690	Male	2007-12-22	O+	Indian	obc	\N	2025-2029	2	3	ugam25td0690@svcet.ac.in	ugamgehlot@gmail.com	6381755769	Ramesh lal	8098849905	Business man	Ganga	8778642737	House wife	500000.00	15 , sivasakthi nagar , pathirikuppam	kumarapettai	cuddalore	TAMIL NADU	607401	seventh day advantist higher secondary school	TN state board	386.00	77.20	seventh day advantist higher secondary school	TN state board	503.00	83.83	2025-09-07	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:17:53.385474+05:30	HINDU	291465770317	Day Scholar	BUS	30	f	1	\N	\N	\N	father
1589	1686	1	11	KARTHIKRAJ	P	25TD0638	Male	2008-04-01	O+	Indian	MBC	\N	2025-2029	2	3	karthikraj25td0638@svcet.ac.in	rajkarthik7879@gmail.com	9344942377	\N	\N	\N	SUMATHI	9047144237	FARMER	75000.00	13,mammer street,katterikuppam	katterikuppam	PUDUCHERRY	Puducherry	605502	Santa clara convent girls higher secondary school	STATE BOARD	366.00	73.20	subaramani bharathi higher secondary school	STATE BOARD	458.00	76.30	2025-06-15	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:19:15.579221+05:30	Hindu	528391098382	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1594	1691	1	11	KIRTHIKA	A	25TD0643	Female	2007-08-26	O+	Indian	MBC	\N	2025-2029	2	3	kirthika25td0643@svcet.ac.in	\N	8778488905	Arumugam	9843989316	farmer	Vasanthi	8248872709	House wife	100000.00	Navamal maruthur road	\N	kandamangalam	Tamilnadu	605102	vallalar government higher secondary school kandamangalam	state board	375.00	75.00	vallalar government higher secondary school kandamangalam	state board	438.00	73.00	2025-07-10	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:33:04.499407+05:30	Hindu	424142056900	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1639	1736	1	11	SWEETHA	G	25TD0688	Female	2008-01-12	A2B+	Indian	MBC	\N	2025-2029	2	3	sweetha25td0688@svcet.ac.in	\N	7010556910	GNANASEKAR.A	9688274914	\N	DHANALAKSHMI.G	9344678728	WEDDING PLANNER	50000.00	no:11,2nd CROSS STREET RANGASAMY NAGAR MANAVELY PUDUCHERRY	no:11,2nd CROSS STREET RANGASAMY NAGAR MANAVELY PUDUCHERRY	puducherry	puducherry	605110	ACHARIYA SIKSHA MANDIR	CBSE	370.00	74.00	ACHARIYA SIKSHA MANDIR	CBSE	347.00	69.40	2025-05-12	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:39:40.197023+05:30	Hindu	997153697609	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1638	1735	1	11	SUWATHI	S	25TD0687	Female	2008-05-31	B+ve	Indian	OBC	\N	2025-2029	2	3	suwathi25td0687@svcet.ac.in	\N	9344627484	D Senthilkumar	9943226519	Video Grapher	S Thamaraiselvi	9786627484	Home maker	120000.00	No:61 salai street , muthialpet,puducherry	No:61 salai street , muthialpet,puducherry	Puducherry	Puducherry	605003	Immaculate heart of mary girls higher secondary school	State board	305.00	61.00	Immaculate heart of mary girls higher secondary school	State board	426.00	71.00	2025-09-07	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:45:51.602516+05:30	Hindhu	451059152999	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1624	1721	1	50	RAVINDHARAN	K	25TD0673	Male	2008-03-23	O+	Indian	bc	\N	2025-2029	2	3	ravindharan25td0673@svcet.ac.in	\N	7200823793	keerthi	9994067982	real estate business	kalavathi	9944453793	housewife	300000.00	no.117\\118 nsc bose nagar	\N	moolakulam	puducherry	605010	billabong high international school	cbse	312.00	62.42	billabong high international school	cbse	288.00	57.60	2025-09-10	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:49:37.241144+05:30	hindu	331128781694	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1554	1651	1	50	AJAIY	S	25TD0603	Male	2008-06-10	B+	Indian	OBC	\N	2025-2029	2	3	ajaiy25td0603@svcet.ac.in	\N	7448673745	Sivakumar	9994473745	driver	Poonguzhali	8608555476	quality lead	\N	No:5 Chinna Veerampattinam st	odaively	Puducherry	Pondycherry	605007	ST Patrick Senior Secondary School	STATE BOARD	446.00	89.80	ST Patrick Senior Secondary School	CBSE	349.00	69.00	2025-09-19	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:50:06.496016+05:30	Hindu	246287773267	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1575	1672	1	50	HITHESHWARA KRISHNAN	K	25TD0624	Male	2007-08-10	A+	Indian	BC	\N	2025-2029	2	3	hitheshwarakrishnan25td0624@svcet.ac.in	\N	6381074847	k.kotteswara krishnan	9360215670	solara company	k.mala	9042376587	HOME MAKER	400000.00	10Achinnappan street 	manjakuppam cuddalore1	cuddalore	TAMIL NADU	607001	arlm school	STATE BOARD	272.00	60.00	krishnasamy	STATE BOARD 	409.00	68.00	2025-09-16	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:51:03.432225+05:30	HINDU	852326657482	Day Scholar	BUS	28	f	1	\N	\N	\N	father
1607	1704	1	50	MOHAMED MUJAMMIL	M	25TD0656	Male	2007-10-26	O+	Indian	bc	\N	2025-2029	2	3	mohamedmujammil25td0656@svcet.ac.in	\N	9042519907	mohamed ansary	9894126532	shop keeper	samsath begum	9597865399	HOUSE WIFE	400000.00	no 5,ibrahim garden	kottakuppam	villupuram	Tamil Nadu	605104	PETIT SEMINAIRE HIGHER SECONDARY SCHOOL	State Board	385.00	77.00	PETIT SEMINAIRE HIGHER SECONDARY SCHOOL	statue board	453.00	72.00	2007-09-16	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:54:31.108352+05:30	muslim	460896822914	Day Scholar	BUS	20	f	1	none	\N	\N	mother
1616	1713	1	50	PRATHAP	M	25TD0665	Male	2008-01-07	O+	Indian	SC	\N	2025-2029	2	3	prathap25td0665@svcet.ac.in	\N	6379499184	MANIKANDAN.R	9943440191	BUSINESS MAN	SHEELA.V	6379499184	Home Maker	\N	PALLITHENNAL	MARIYAMMAN KOVIL STEET	TAMIL NADU	TAMIL NADU	605 102	BAGAVAN SRI RAMAKRISHNA HIG SCHOOL	STATE BOARD	355.00	71.00	JAWAHAR HIGHER SECONDERY SCHOOL	STATE BOARD	365.00	60.00	2025-09-10	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:57:36.862673+05:30	HINDU	981944312241	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1591	1688	1	50	KAVYA	S	25TD0640	Female	2007-10-02	A1+	Indian	MBC	\N	2025-2029	2	3	kavya25td0640@svcet.ac.in	\N	7845322910	Sivakumar	638311043	Busisnness	Meena	7845322910	House Wife	9999.00	22,school street,nonankuppam,puducherry	22,school street,nonankuppam,puducherry	Puducherry	Puducherry	605007	blessed mother tearesa model higher secondary school	State Board	329.00	66.00	blessed mother tearesa model higher secondary school	State Board	421.00	70.00	2025-09-16	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:03:36.920762+05:30	Hindu	396660638507	Day Scholar	BUS	27	f	1	no	\N	no	father
1533	1630	1	9	Vaishnavi	N	24TD0854	Female	2006-08-18	B+	Indian	Bc	\N	2024 -2028	3	5	vaishnavi24td0854@svcet.ac.in	\N	8754575042	Nagarajan	9941541330	\N	Murugaselvi	8754575042	\N	6.00	No:668	KAMARAJAR STREET	DHARMAPURI	PONDICHERRY	605009	Government Adi Dravid Welfare School	stateboard	381.00	76.20	Government Girls Higher Secondary School	stateboard	409.00	68.17	2024-09-15	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:03:55.183339+05:30	hindu	634205160984	Day Scholar	BUS	37	f	1	V.Murugan	8657995221	Senior Engineer	guardian
1550	1647	1	9	Rajasri	V	24TDL019	Female	2006-12-15	AB+	Indian	MBC	\N	2024 -2028	3	5	rajasri24tdl019@svcet.ac.in	\N	9361327342	vengadesan.v	9787965818	farmer	Rama.v	9363301813	housewife	75000.00	7/775,Mariaman kovil street,l.R.Palayam	\N	Pondicherry	Puducherry	605001	Bharatha Devi English High school	Tamil Nadu State Board	346.00	69.20	Sri Manakula vinayagar Polytechnic college	Anna university	100.00	89.00	2025-07-06	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:04:43.189364+05:30	hindu	379049739998	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1590	1687	1	50	KAVIYA	S	25TD0639	Female	2008-06-18	AB-	Indian	BC	\N	2025-2029	2	3	kaviya25td0639@svcet.ac.in	kaviyasakthi2006@gmail.com	8438214831	sakthivel.R	9092552312	Tailor	parameshwari	9092552312	Bakery worker	100000.00	No 19 , Thirukameshwarar nagar,west street,1st cross 	villianur	Puducherry	Puducherry	605110	Galaxy English High School	State Board	384.00	76.80	Vel Senthil Higher Secondary School 	State Board	470.00	78.30	2025-09-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:07:56.053602+05:30	Hindu	502512920325	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1782	1906	4	\N	SUBASREE	S	25TJ0070	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	subasree25tj0070@svcet.ac.in	\N	7667846658	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1783	1907	4	\N	UDHAYA	P	25TJ0071	\N	\N	\N	Indian	\N	\N	2025-2029	2	3	udhaya25tj0071@svcet.ac.in	\N	8056592146	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:23:51.570637+05:30	\N	\N	\N	\N	\N	\N	f	4	\N	\N	\N	\N
1612	1709	1	50	NAMBI RAJAN	N	25TD0661	Male	2004-11-10	A1+ve	Indian	mbc	\N	2025-2029	2	3	nambiajan25td0661@svcet.ac.in	nambinarasimman@gmail.com	8870586297	J.Narasimman	9865061577	daily wages	T.Sarala	6385331757	house wife	72000.00	119 vanchinathan street,jothi nagar,chavadi,cuddalore	119 vanchinathan street,jothi nagar,chavadi,cuddalore	cuddalore	tamil nadu	607001	ARLM Matric Hr Sec School	state board	280.00	56.00	ARLM Matric Hr Sec School	state board	434.00	72.00	2025-09-07	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:13:55.481814+05:30	hindu	892142839611	Day Scholar	BUS	30	f	1	N.Nambi Rajan	8870586297	\N	guardian
1559	1656	1	50	BHARATH RAJ	T	25TD0608	Male	2008-06-04	A-	Indian	OBC	\N	2025-2029	2	3	bharathraj25td0608@svcet.ac.in	bharathrajt7@gmail.com	8122452763	Thangavelu.T	9994763882	driver	samundeeswari.T	9952462271	House Wife	100000.00	No 15 A salaii street	oulgaret	Puducherry	Puducherry	605010	Seventh Day Adventist Hr Secondary  School	State Board	343.00	68.60	Seventh Day Adventist Hr Secondary  School	State Board	418.00	69.60	2025-08-19	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:23:10.187619+05:30	Hindu	283380572145	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1487	1584	1	9	Nethra	P	24TD0807	Female	2007-05-10	O+	Indian	MBC	\N	2024 -2028	3	5	nethra24td0807@svcet.ac.in	\N	9363918619	Pachaiappan.B	9791852424	WORKING IN PETROL BUNK	Rajeswary.P	8056507064	Housewife	80000.00	No.8, Iyyanar kovil street, veeman nagar	\N	Puducherry	Puducherry	605009	St.Patrick Matric Senior secondary school	state board	389.00	75.00	nil	state board	401.00	77.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:17:40.372758+05:30	Hindu	869335329519	Day Scholar	BUS	36	f	1	\N	\N	\N	mother
1521	1618	1	9	Sountharya	S R	24TD0841	Female	2006-04-28	O+	Indian	Bc	\N	2024 -2028	3	5	sountharya24td0841@svcet.ac.in	\N	9489405504	D. sivakumar	9442118593	daily wages	S.Rani	\N	house wife	60000.00	no 68	bangala st,nanamedu	poornakuppam post	Puducherry	605007	jawarhar novodaya vidyalaya	cbse	399.00	79.80	jawarhar novodaya vidyalaya	cbse	450.00	72.00	2024-09-06	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:20:28.270956+05:30	hindu	947690490679	Day Scholar	BUS	27	f	1	\N	\N	\N	father
1555	1652	1	50	ARIKARTHIK	J	25TD0604	Male	2008-05-06	A1+	Indian	OBC	\N	2025-2029	2	3	arikarthik25td0604@svcet.ac.in	arikarthik24@gmail.com	9092770901	Jawaharlal Nehru.C	9443499076	Government staff	Seathalakshmi.P	9791722719	House wife	\N	no 37,east sannathi street villianur,Puducherry 	\N	puducherry	Puducherry	605110	Petit Seminarie Higher secondary school	State Board	334.00	66.80	Petit Seminarie Higher secondary school	State Board	400.00	66.60	2025-06-14	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:17:53.251459+05:30	Hindu	563854878811	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1437	1534	1	9	Akshaya	C	24TD0755	Female	2007-02-15	B+	Indian	oc	\N	2024 -2028	3	5	akshaya24td0755@svcet.ac.in	\N	6379563205	Chandrasekaran R	9842691499	Marketing executive	Vidhya A	9894689107	advocate	500000.00	no 20 jayaram garden	karuvadikuppam	Puducherry	Puducherry	605008	Sri sankara vidhyalaya hr secondary school	state board	404.00	80.80	Sri sankara vidhyalaya hr secondary school	State board	459.00	77.00	2024-09-19	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:22:47.807117+05:30	Hindu	679644833495	Day Scholar	BUS	6	f	1	\N	\N	\N	father
1632	1729	1	50	SHAJMI	K	25TD0681	Female	2008-01-26	B+	Indian	OBC	\N	2025-2029	2	3	shajmi25td0681@svcet.ac.in	shajmishaj26@gmail.com	8754703446	Kalesha basheer Ahamed	7339103447	own business	Jamela Begum	7339103446	Home Maker	75000.00	2\\87 ecr Main road koonimedu marakkanam	\N	marakkanam	tamil nadu	604303	Ar-Rahmaan Higher secondary School	Stateboard	380.00	70.00	Ar-Rahmaan Higher Secondary school	stateboard	482.00	80.00	2025-09-17	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:22:30.893936+05:30	muslim	884997464391	Day Scholar	BUS	24	f	1	\N	\N	\N	mother
1610	1707	1	50	MOIZ MURTAZA	RANGOONWALA	25TD0659	Male	2006-04-04	A+	Indian	GENRAL	\N	2025-2029	2	3	moizmurtazarangoonwala25td0659@svcet.ac.in	moiz4rangoonwala@gmail.com	8838283409	Murtaza I Rangoonwala	9345428152	Business	Farida M Rangoonwala	7667228152	HomeMaker	500000.00	Plot no 8,3rd street,13th crossKrishna Nagar	\N	Pondicherry	Pondicherry	605008	Vaasavi International School	CBSE	375.00	75.00	Vaasavi International School	CBSE	415.00	83.00	2025-10-24	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:25:17.972175+05:30	MUSLIM	322579939472	Day Scholar	BUS	6	f	1	Huzefa I Rangoonwala	9442625521	Business	father
1633	1730	1	50	SHALINI	S	25TD0682	Female	2008-03-04	O+	Indian	MBC	\N	2025-2029	2	3	shalini25td0682@svcet.ac.in	shalini04032008@gmail.com	9677602456	sudhakar	9092498456	fisherman	dhanalakshmi	8608694379	Housewife	\N	47,vengattamman kovil street,pillaichavady	\N	pillaichavady	tamilnadu	605014	kuyilapalayam higher secondary school	STATE BOARD	391.00	75.00	kuyilapalayam higher secondary school	STATE BOARD	519.00	85.00	2025-09-17	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:25:22.852213+05:30	Hindu	683502680389	Day Scholar	BUS	06	f	1	\N	\N	\N	mother
1598	1695	1	50	KRISHNAAGANTH	S	25TD0647	Male	2008-05-27	O+	Indian	mbc	\N	2025-2029	2	3	krishnaaganth25td0647@svcet.ac.in	krishnaa2008s@gmail.com	9363993143	R.Saravanan	9994193143	mechanic	S.Sasikala	\N	Housewife	150000.00	32,sedar street,madukkarai	\N	Puducherry	Pudhucherry	605105	Evergreen English Higher Secondary School	state board 	397.00	78.80	Balaji Higher Secondary School	state board	434.00	72.30	2025-09-23	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:26:36.473758+05:30	HINDU	741772634821	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1602	1699	1	50	MADHUMALAR	V	25TD0651	Female	2007-11-26	B+	Indian	mbc	\N	2025-2029	2	3	madhumalar25td0651@svcet.ac.in	madhumalarvimalathithan@gmail.com	7845299611	K.R.Vimalathithan	9342515523	librarian	V.Punidavathy	7305324579	homemaker	100000.00	no.5 mahalakshmi nagar,murungappakkam,puducherry4.	\N	puducherry	puducherry	605004	Immaculate heart of mary girls higher secondary school	state board	372.00	74.40	Immaculate heart of mary girls higher secondary school	state board	448.00	74.60	2025-09-06	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:27:11.489913+05:30	hindu	803773576910	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1561	1658	1	50	DEEPAK	M	25TD0610	Male	2008-06-16	O+	Indian	MBC	\N	2025-2029	2	3	deepak25td0610@svcet.ac.in	deepak160608@gmail.com	9003806111	Manivannan	9994838003	govt.staff	Kalaivany	9003806111	house wife	\N	no.18,2nd cross mothilal nagar,moolakulam 	\N	pondicherry	pondicherry	605010	Vivekanandha school CBSE	CBSE	429.00	84.00	Stansford international hr sec school	CBSE	343.00	64.00	2025-08-03	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:27:45.001156+05:30	Hindu	966372472540	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1530	1627	1	9	Thilagavathi	I	24TD0850	Female	2007-06-08	B+	Indian	MBC	\N	2024 -2028	3	5	thilagavathi24td0850@svcet.ac.in	\N	9500207921	Ilangovan.R	9843567921	Groceries shop	Parvathi.I	9500207921	Housewife	74999.00	NO.2,PIMS road ,amman nagar	\N	GANAPATHI CHETTI KULAM	Puducherry	605014	Kolping Matriculation Higher Secondary School	state board	330.00	60.00	Kolping Matriculation Higher Secondary School	state board	361.00	68.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:28:16.105545+05:30	Hindu	760725126764	Day Scholar	BUS	24	f	1	\N	\N	\N	father
1646	1743	1	50	VISHALI	P	25TD0695	Female	2008-01-18	A1+	Indian	mbc	\N	2025-2029	2	3	vishali25td0695@svcet.ac.in	pvishali887@gmail.com	9345831604	A.Prakash	9976991166	Labour at naresh electronics	P.Sangeetha	8056917716	Housewife	75000.00	no:36,Bharathipuram,Govinda salai[main road],puducherry	\N	Puducherry	Pondicherry	605011	Immaculate heart of mary girls higher secondary school	STATE BOARD	464.00	92.80	Thiruvalluvar government girls higher scondary school	CBSE	371.00	75.00	2025-09-26	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:29:20.170835+05:30	Hindu	852287741211	Day Scholar	BUS	21	f	1	\N	\N	\N	father
1619	1716	1	50	PRIYADHARSHINI	K	25TD0668	Female	2007-08-23	O+	Indian	MBC	\N	2025-2029	2	3	priyadharshini25td0668@svcet.ac.in	p35684469@gmail.com	7339356857	karthiban	9488556857	plumber	selvi	9600360087	HOUSE WIFE	100000.00	no:19 marriaman koil street ,manjini nagar ,muthialpet,puducherry	\N	Puducherry	Puducherry	605003	new modern vidhya mandir hr.sec.school	State Board	432.00	86.40	new modern vidhya mandir hr.sec.school	state board	439.00	73.17	2025-08-02	MANAGEMENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:30:02.248756+05:30	Hindu	374332003419	Day Scholar	BUS	20	f	1	\N	\N	\N	mother
1460	1557	1	9	Gopika	C	24TD0778	Female	2006-08-30	B+	Indian	MBC	\N	2024 -2028	3	5	gopika24td0778@svcet.ac.in	\N	6369442315	Coulandjiappane R	9944741140	HVAC Technologist	Manimegalai C	7449048932	Home Maker	75000.00	5,North Street,Kuruvinatham,Bahour commune puducherry.	\N	Bahour	puducherry	607402	Krishnasamy memorial matric higher secondary school	State Board	384.00	76.80	Aditya's bharathidasan Higher Secondary School	State Board	449.00	74.80	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:34:06.632455+05:30	Hindu	213089042624	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1760	1857	6	\N	THRISHA	S	25TK0070	Female	2007-11-03	A+	Indian	obc	\N	2025-2029	2	3	thrisha25tk0070@svcet.ac.in	\N	9487818688	subramani	8056670272	driver	nirmala	8248460108	homemaker	75000.00	no 242 ok ok palayam	mudaliarpet	puducherry	puducherry	605006	amalorpavam higher secondary school	state board	434.00	89.80	thiruvalluvar government girls higher secondary school	state board	384.00	78.00	2025-09-25	CENTAC	t	2026-07-22 11:21:56.354334+05:30	2026-07-23 15:34:27.985504+05:30	Hindu	267085201444	Day Scholar	BUS	26	f	6	\N	\N	\N	father
1439	1536	1	9	Bhava Dharshni	S	24TD0758	Female	2007-04-26	O+	Indian	hindu	\N	2024 -2028	3	5	bhavadharshni24td0758@svcet.ac.in	\N	9962844795	sankar p	9042950328	cooli	Rama Devi	8682040793	home maker	71998.00	no :14 p/t 1 st cross	srinivasa nagar	thirubuvanai	puducherry	605107	sri hindocha charitable trust higher secondary school	TN Board	411.00	81.00	government girls higher secondary school	TN Board	464.00	77.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:34:35.052614+05:30	yadhav	234074095617	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1755	1852	6	\N	SANJAY	S	25TK0065	Male	2008-03-07	O+	Indian	OBC	\N	2025-2029	2	3	sanjay25tk0065@svcet.ac.in	sanjayc4u77@gmail.com	9944472258	SATHIYARAJ K	7092222258	BUSSINESS	AMUTHAVALLI S	8778198341	HOUSEWIFE	0.00	NO 12	RED ROCK STREET, NEHRU AVENUE, NAVARKULAM MAIN ROAD,LAWSPET	PONDICHERRY	PONDICHERRY	605008	VHSS, SELLAPERUMALPET,PONDY	STATE BOARD	387.00	77.00	VHSS, SELLAPERUMALPET,PONDY	STATE BOARD	471.00	77.00	2025-08-18	CENTAC	t	2026-07-22 11:21:56.354334+05:30	2026-07-23 15:37:10.089888+05:30	HINDU	950999466489	Day Scholar	OWN	\N	f	6	\N	\N	\N	mother
1601	1698	1	50	LOKESH	K	25TD0650	Male	2007-12-20	A+	Indian	obc	\N	2025-2029	2	3	lokesh25td0650@svcet.ac.in	\N	9629106554	kumar N	9384458324	coolie	Kalaiselvi K	\N	\N	\N	No,1 senthamizh Street vadamangalam, puducherry	\N	puducherry	pondicherry	605 102	Govt high school mangalam, puducherry	state board	300.00	60.00	Jeevanadham govt higher sec boys school karamanikuppam , puducherry	CBSE	345.00	69.00	2025-09-23	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:38:19.058081+05:30	Hindu	657737872236	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1506	1603	1	10	Rithika	K	24TD0826	Female	2006-04-04	B+	Indian	obc	\N	2024 -2028	3	5	rithika24td0826@svcet.ac.in	\N	9080111753	kathikeyan	9080111753	vegetables  shop	ambika	8608200579	house wife	99998.00	no.5,php apartment,villianur road,murugapakkam,puducherry	no.5,php apartment,villianur road,murugapakkam,puducherry	Pondicherry	Puducherry	605110	theerar sathyamoorthy government higher secondary 	stateboard	26.00	52.00	annai siva gami  government higher secondary school	stateboard	371.00	62.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:39:06.801204+05:30	hindu	850151200688	Day Scholar	BUS	25	f	1	\N	\N	\N	father
1754	1851	6	\N	RAVICHANDIRAN	A	25TK0064	Male	2007-12-05	B+	Indian	OBC	\N	2025-2029	2	3	ravichandiran25tk0064@svcet.ac.in	\N	9092518077	Arivazhigan.s	9488513534	x ray technication	Nandhini.A	9345648443	Home maker	55000.00	226,cudulore road mudaliarpet 	\N	Puducherry	Puducherry	605004	Amalorpavam higher sec school	State board	287.00	57.00	amalorpavam higher sec school	State board	398.00	68.00	2025-12-08	CENTAC	t	2026-07-22 11:21:56.354334+05:30	2026-07-23 15:43:22.109762+05:30	Hindu	639301113998	Day Scholar	BUS	27	f	6	\N	\N	\N	father
1582	1679	1	50	JEEVANANTHAM	S	25TD0631	Male	2008-05-24	A+	Indian	mbc	\N	2025-2029	2	3	jeevanantham25td0631@svcet.ac.in	\N	7845039897	Sundaravelu	9443495274	worker	Amirthavalli	9787326035	housewife	75000.00	7 Shanmugapuram street sellipatu 	\N	pondicherry	puducherry	605501	IMMCULATE HEART OF MARRY GOVERMENT AIDED HIGH SCHOOL  Reddiarpalayam puducherry- 605110	state board	363.00	72.60	ILANGO ADIGAL GHSS MUTHARPALAYAM PUDUCHERRY	central board	335.00	67.00	2025-08-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:39:57.775781+05:30	hindu	705467176816	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1708	1805	7	\N	Haarish Jayakumar	J	25TP0414	Male	2007-08-11	B+	Indian	OBC	\N	2025-2029	2	3	haarishjayakumar25tp0414@svcet.ac.in	\N	6385635515	Jerome Leo	9994056671	Driver	Johnsi	8189866100	House wife	120000.00	No.13 Kumaran Nagar (Extn) 2nd Main Road Lawspet	\N	Puducherry	Puducherry	605008	Don Bosco Matriculation Higher Secondary School	Tamil Nadu State Board	332.00	66.40	Don Bosco Matriculation Higher Secondary School	Tamil Nadu State Board	435.00	72.50	2025-09-18	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 15:52:56.532059+05:30	Christian	504324861448	Day Scholar	BUS	08	f	7	\N	\N	\N	father
1700	1797	7	\N	Antony Sanjay	V	25TP0405	Male	2007-11-03	A+	Indian	obc	\N	2025-2029	2	3	antonysanjay25tp0405@svcet.ac.in	\N	9677556989	Vendar Bernarex Saroon	9994073505	Govt employee(MTS)	Jacquelin Mary	9894822346	housewife	420000.00	No: 27D, Ramanar street, SMS nagar, Marie Oulgaret, Puducherry - 605010.	No: 27D, Ramanar street, SMS nagar, Marie Oulgaret, Puducherry - 605010.	puducherry	puducherry	605010	PETIT SEMINAIRE HIGHER SECONDARY SCHOOL	state board	407.00	81.40	PETIT SEMINAIRE HIGHER SECONDARY SCHOOL	stateboard	405.00	67.50	2025-09-11	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 15:58:29.529538+05:30	Christian	519695670831	Day Scholar	BUS	19	f	7	\N	\N	\N	father
1729	1826	7	\N	Sarathi	K	25TP0436	Male	2007-10-28	O+	Indian	sc	\N	2025-2029	2	3	sarathi25tp0436@svcet.ac.in	\N	9003402810	kumaraguru v	8056475309	MTS	mohana k	9789128569	Home maker	100000.00	no.6 mariyamman kovil street	pandiyadikuppam	Puducherry	Puducherry	605106	holy flower higher secondary school	State board	367.00	73.40	holy flower higher secondary school	State board	385.00	64.10	2025-09-28	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 15:59:52.280737+05:30	Hindu	744295794793	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1505	1602	1	9	Rakshana	R	24TD0825	Female	2007-03-07	B+	Indian	MBC	\N	2024 -2028	3	5	rakshana24td0825@svcet.ac.in	rrakshana818@gmail.com	7305170317	Ramachandiran A	9965190419	Panchayat secretary	Uma R	8122990419	Home maker	300000.00	No, 1\\74	Main road,Veerasozhapuram	Villlupuram	TAMIL NADU	605755	Sri vidhya mandir senior secondary school	CBSE	342.00	68.40	Sri vidhya mandir senior secondary school	CBSE	308.00	61.10	2024-09-08	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:40:28.050207+05:30	HINDU	563067179294	Hostel	OWN	\N	f	1	\N	\N	\N	father
1486	1583	1	9	Nesika	P	24TD0806	Female	2007-05-26	B+	Indian	MBC	\N	2024 -2028	3	5	nesika24td0806@svcet.ac.in	nesika2605@gmail.com	9345307681	Pandiyan . A	9787515114	cooperative Milk Society Manager	Tamilarasi . p	6380383652	Civil Engineer	150000.00	NO:21,2nd Floor Srinivasa Tower	vazhudhavur Road,kathirkamam	puducherry	Puducherry	605009	Andavar English High School,Thirunallar	State Board	348.00	69.00	SRVS National Higher Secondary School,karaikal	state board	388.00	64.00	2024-09-05	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:49:05.771976+05:30	Hindu	283842049688	Day Scholar	BUS	37	f	1	\N	\N	\N	father
1736	1833	7	\N	Sudharshan	K	25TP0443	Male	2007-11-22	B+	Indian	MBC	\N	2025-2029	2	3	sudharshan25tp0443@svcet.ac.in	\N	7418964528	Krishnaraj k	6379697353	bussiness	Bhuvaneswari k	9626941628	house maker	100000.00	flat no:2,	sri ram nagar, rottu kudumiyan kuppam	valavanur	Tamilnadu	605108	ramakrishna mission vidhayala martic hr sec school.	State board	377.00	75.40	govt boys hr sec school,valavanur	State board	497.00	80.00	2025-09-09	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 15:58:40.190487+05:30	Hindu	889835163653	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1697	1794	7	\N	Ajai	A	25TP0402	Male	2007-09-21	O-	Indian	sc	\N	2025-2029	2	3	ajai25tp0402@svcet.ac.in	ajai25tp0402@svcet.ac.in	7010863488	M.Arasakumar	9047459979	painter	A.Arulmozhi	9087552716	House wife	85000.00	34,Iyyanarkovil street, Periyamudhaliyarchavady	\N	villupuram	Tamil Nadu	605104	kuyilapalayam Higher secondary school	state board	436.00	87.20	kuyilapalayam Higher secondary school	state board	513.00	85.50	2025-08-16	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 15:59:29.220362+05:30	Hindu	909839381759	Day Scholar	BUS	6	f	7	\N	\N	\N	father
1715	1812	7	\N	Logeshwaran	R	25TP0421	Male	2007-07-28	B+	Indian	MBC	\N	2025-2029	2	3	logeshwaran25tp0421@svcet.ac.in	LLogeshwaran704@gmail.com	9345617576	T.RAJA	6383406294	driver	\N	\N	\N	\N	38,MGR NAGAR,	THIRUVATHIGAI,PANRUTI.	CUDDALORE	tamilnadu	607106	TNPP MUNICIPAL HIGH SCHOO THIRUVATHIGAI	STATE BOARD	243.00	48.60	GOVERNMENT BOYD HIGH SECONDARY SCHOOL PUTHUPETTAI	STATE BOARD	374.00	62.00	2025-09-07	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:07:10.977734+05:30	Hindu	569770769642	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1746	1843	6	\N	KOUSHIK	V	25TK0056	Male	2007-07-03	A+	Indian	General	\N	2025-2029	2	3	koushik25tk0056@svcet.ac.in	\N	9488576439	Venkataraman.n	9047691496	accoutant	Sunitha.K	9994007127	House wife	140000.00	no54, 4th cross kamban nagar	reddiyarpalayam	puducherry	Puducherry	605010	Sri Sankara vidiyalaya hr sec school  ecr puducherry 	State Board	317.00	63.50	Sri Sankara vidiyalaya hr sec school  ecr puducherry 	State Board	399.00	69.00	2026-07-24	CENTAC	t	2026-07-22 11:21:56.354334+05:30	2026-07-23 15:40:38.246091+05:30	Hindu	787399195563	Day Scholar	BUS	26	f	6	\N	\N	\N	mother
1742	1839	6	\N	DEEPIKA	R	25TK0052	Female	2007-08-20	B+	Indian	OBC	\N	2025-2029	2	3	deepika25tk0052@svcet.ac.in	deepikrish20@gmail.com	8681906119	RAMESH.K	9943876119	FARMER	PRABAVATHY.R	9786714189	HOUSE WIFE	90000.00	PILLAYAR KOVIL STREET,EMBLEM NATHAMEDU,	CHELLANCHERRY POST,PUDUCHERRY-605106	pondicherry	pondicherry	605106	ACHARIYA SIKSHA MANDIR	CBSE	368.00	73.60	ADITYA VIDYASHRAM	CBSE	364.00	72.80	2025-08-03	CENTAC	t	2026-07-22 11:21:56.354334+05:30	2026-07-23 15:44:21.193238+05:30	Hindu	720857510715	Day Scholar	OWN	\N	f	6	\N	\N	\N	\N
1444	1541	1	10	Deepika	I	24TD0763	Female	2007-03-17	O+	Indian	mbc	\N	2024 -2028	3	5	deepika24td0763@svcet.ac.in	\N	9159413688	Iyyanar	9843777026	Driver	Thamizhselvi	9159413688	Housewife	150000.00	No:19,Murugan kovil street,Bharathi nagar,Ariyur.	\N	Pondicherry	Pondicherry	605102	Sri ramachandra vidhyalaya high school	stateboard	418.00	83.00	Blue Stars higher secondary school	stateboard	500.00	84.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:53:16.793472+05:30	hindu	352072921083	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1739	1836	7	\N	Vishalini	D	25TP0446	Female	2007-11-25	A+	Indian	OBC	\N	2025-2029	2	3	vishalini25tp0446@svcet.ac.in	\N	9790173952	durairaj	9894642970	auto driver	kanagavalli	8056925352	HOUSE WIFE	75000.00	142,senthamizh street, shanmuga nagar,	KARUVADIKUPPAM	Puducherry	Puducherry	605008	vallalar government girls higher secondary school	State Board	345.00	69.00	vallalar government girls higher secondary school	CBSE	393.00	79.00	2025-08-10	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:06:03.918954+05:30	Hindu	664317383595	Day Scholar	OWN	\N	f	7	\N	\N	\N	mother
1735	1832	7	\N	Subiksha	S	25TP0442	Female	2008-01-20	B+	Indian	MBC	\N	2025-2029	2	3	subiksha25tp0442@svcet.ac.in	\N	7418149113	\N	\N	\N	S.USHA	6369348138	HOUSE WIFE	75000.00	NO:1\\138 GANGAIYAMMAN KOVIL STREET	KENDIYANKUPPAM	Pondicherry	TAMIL NADU	605102	SRI RAMACHANDRA VIDHYALAYA HIGH SCHOOL	STATE BOARD	449.00	89.80	BRAINY BLOOMS OF LE'COLE INTERNATIONAL	CBSE	392.00	78.40	2025-09-16	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:11:35.096739+05:30	HINDU	523101657239	Day Scholar	OWN	\N	f	7	\N	\N	\N	mother
1703	1800	7	\N	Aswathi	E	25TP0408	Female	2008-05-01	B+	Indian	bc	\N	2025-2029	2	3	aswathi25tp0408@svcet.ac.in	\N	8668133537	Elumalai.S	9786461497	carpenter	Karpagam.E	8220873586	housewife	200000.00	No:133,Bharathi nagar ,Periyamudhaliyarchavady	-	Villupuram	tamilnadu	605104	Kuyilappalayam Higher Secondary School	state board	447.00	89.40	kuyilappalayam Higher Secondary  School	stateboard	557.00	92.80	2025-09-17	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:17:36.494282+05:30	hindu	722569770920	Day Scholar	BUS	6	f	7	-	\N	-	father
1716	1813	7	\N	Madhumitha	S	25TP0422	Female	2008-05-13	A+	Indian	OBC	\N	2025-2029	2	3	madhumitha25tp0422@svcet.ac.in	\N	9360684041	SRINIVASAN.A	9360684041	TINKER	KALPANA.S	9487843041	HOUSE WIFE	80000.00	NO:8,KATTABOMMAN STREET , KAMARAJ NAGAR ,GORIMEDU.	\N	PUDUCHERRY	PUDUCHERRY	605006	AMALORPAVAM HIGHER SECONDARY SCHOOL	STATE BOARD	374.00	75.00	AMALORPAVAM HIGHER SECONDARY SCHOOL	STATE BOARD	435.00	75.00	2025-09-17	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:20:57.866143+05:30	HINDU	881292813178	Day Scholar	BUS	36	f	7	\N	\N	\N	father
1734	1831	7	\N	Subalakshmi	R	25TP0441	Female	2007-05-20	O+	Indian	MBC	\N	2025-2029	2	3	subalakshmi25tp0441@svcet.ac.in	\N	7539993863	K.Ramachandran	9345760054	MASON	R.Devi	8940550132	HOUSEMAKER	72000.00	NO,B5,MARIAMMAN KOVIL STREET CHINNAMUDHADLIYAR CHAVADY	NO,B5,MARIAMMAN KOVIL STREET CHINNAMUDHADLIYAR CHAVADY	VILLUPURAM	TAMIL NADU	605104	KUYILAPPALAYAN\\M HIGHER SECONDARY SCHOOL 	STATE BOARD	454.00	90.80	KUYILAPPALYAM HIGHER SECONDARY SCHOOL	STATE BOARD 	551.00	92.00	2025-09-17	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:22:02.605872+05:30	HINDU	230577524639	Day Scholar	BUS	6	f	7	\N	\N	\N	father
1335	1420	1	7	Sowkanthini	Y	23TD0725	Female	2005-07-28	B+	Indian	MBC	\N	2023-2027	4	7	sowkanthini23td0725@svcet.ac.in	\N	7806934442	N.YUVARAJ	9095234920	BUSINESS(BAKERY)	S.LOGANAYAKI	9361046667	TAILOR	120000.00	NO:125,OM SAKTHI STREET,ASHOK NAGAR,GUDIYATTAM,VELLORE DISTRICT	\N	VELLORE	TAMIL NADU	641111	SEVENTH DAY ADVENTIST MATRIC HIGH SCHOOL	STATE BOARD	500.00	100.00	THIRUVALLUVAR HIGH SCHOOL	STATE BOARD	451.00	75.00	2023-08-09	MANAGEMENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-23 15:53:29.914697+05:30	HINDU	341884906396	Hostel	OWN	\N	f	1	\N	\N	\N	\N
1733	1830	7	\N	Sowmiya	B	25TP0440	Female	2008-01-12	B+	Indian	MBC	\N	2025-2029	2	3	sowmiya25tp0440@svcet.ac.in	\N	7639799354	Balachandran.I	8124713231	Assistant supervisior	ramani.B	\N	\N	60001.00	no. 26 new street sanarapet mutharaiyarpalyan puduherry 605009	\N	puducherry	Puducherry	605009	Muthariyar higher secondary school	state board	358.00	70.00	Muthariyar higher sevcondary school	state board	383.00	63.00	2025-09-27	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:18:48.396826+05:30	Hindu	355742249178	Day Scholar	BUS	37	f	7	\N	\N	\N	father
1717	1814	7	\N	Mahdiyah Tahseen	T	25TP0423	Female	2007-09-29	O+	Indian	BCM	\N	2025-2029	2	3	mahdiyahtahseen25tp0423@svcet.ac.in	zainults1@gmail.com	8870539108	Tajudeen	9566980358	Operation Co-ordinator	Zaithun Biby	9791549462	Homemaker	1000000.00	No.140, Ambour Salai	Pondicherry	Pondicherry	Puducherry	605001	Seventh-Day Adventist Higher Secondary School	State Board	460.00	92.00	St. Patrick Higher Secondary School	CBSE	383.00	76.60	2025-09-17	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:19:16.850689+05:30	Muslim	692387542164	Day Scholar	BUS	27	f	7	-	\N	\N	mother
1722	1819	7	\N	Pravin kumar	S	25TP0429	Male	2008-01-27	O+	Indian	MBC	\N	2025-2029	2	3	pravinkumar25tp0429@svcet.ac.in	\N	9342179545	M.Saravanan	9894040318	Business	S.Vijayalakshmi	8124400011	House Wife	200000.00	No:383,vazhudavour main road,shanmugapuram,Puducherry	No:383,vazhudavour main road,shanmugapuram,Puducherry	Puducherry	Puducherry	605009	Aditya vidyashram	CBSE	369.00	74.00	Shree Bharath Vidyashram	CBSE	384.00	77.00	2025-09-17	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 15:55:38.276162+05:30	Hindu	596231158719	Day Scholar	BUS	37	f	7	\N	\N	\N	father
1714	1811	7	\N	Krishnakumar	B	25TP0420	Male	2008-02-07	A+	Indian	MBC	\N	2025-2029	2	3	krishnakumar25tp0420@svcet.ac.in	bkrishnakumar037@gmail.com	9150902008	BALAKRISHNAN	9789750361	Farmer	CHITRA	7094618386	House wife	500000.00	No 6, Ellai amman kovil Street	K.R.Palayam 	Thirukkanur	Puducherry	605501	Brainy Blooms l'ecole internationale	CBSE	317.00	63.40	Brainy Blooms l'ecole internationale	CBSE	336.00	67.20	2025-09-07	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:03:20.550702+05:30	Hindu	433038368067	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1709	1806	7	\N	Hemachandhiran	S	25TP0415	Male	2007-11-29	A1+	Indian	OBC	\N	2025-2029	2	3	hemachandhiran25tp0415@svcet.ac.in	hemachandhiran.2007@gmail.com	7708348119	selvaradjou	7358865666	company	sudha 	9994216314	house wife	75000.00	No, 08, first cross	Samipillai thottam	karvadikuppum	puducherry	605008	Perinthalavir kamarajar higher secondary school.	state board of tamil nadu	392.00	79.00	V.O.C government boys higher secondray school	CBSE	391.00	65.00	2025-09-17	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:05:40.069499+05:30	Hindu	4060440102	Day Scholar	BUS	08	f	7	\N	\N	\N	father
1740	1837	7	\N	Yuvashree	D	25TP0447	Female	2008-01-06	AB+	Indian	mbc	\N	2025-2029	2	3	yuvasri25tp0447@svcet.ac.in	\N	8838163252	Devanathan.K	9843372908	teacher	Nagavalli.D	7639780889	teacher	75000.00	FRATERNITY COMMUNITY	AUROVILLE	Puducherry	Tamilnadu	605101	The Study l'ecole internationale	CBSE	410.00	82.00	The Study l'ecole internationale	CBSE	380.00	76.00	2025-09-26	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:11:56.246254+05:30	HINDU	911754843521	Day Scholar	BUS	6	f	7	\N	\N	\N	father
1713	1810	7	\N	Koodalarasi	S	25TP0419	Female	2007-12-15	O+	Indian	obc	\N	2025-2029	2	3	koodalarasi25tp0419@svcet.ac.in	koodalarasi.ds@gamil.com	7010863739	Sankar	9092033937	Engineer	Selvi	8608831313	house wife	70000.00	17, magizha street , solainagar,muthialpet,pondicherry	\N	Pondicherry	Puducherry	605003	Alpha english higher secondary school	stateboard	445.00	89.00	Thiruvalluvar gov girls higher sec school	cbse	447.00	74.50	2025-09-17	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:11:57.275717+05:30	hindu	847416512949	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1704	1801	7	\N	Barkath	S	25TP0409	Female	2007-08-02	A+	Indian	BCM	\N	2025-2029	2	3	barkath25tp0409@svcet.ac.in	\N	8807523045	Sathiq basha .N	9600474270	-	Alima bi .S	9894757138	company employee	3.00	2/648 vaikal mettu street	kandamangalam	villupuram	Tamil nadu 	605102	Thiruvalluvar government girls higher secondary school	state board	305.00	61.40	Thiruvalluvar government girls higher secondary school	CBSE	310.00	62.00	2026-09-17	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:16:51.695548+05:30	Muslim	818098085112	Day Scholar	OWN	\N	f	7	-	\N	-	mother
1731	1828	7	\N	Shameema	I	25TP0438	Female	2007-09-01	B+	Indian	BCM	\N	2025-2029	2	3	shameema25tp0438@svcet.ac.in	\N	7904573550	Ismael.V	6379755953	own business	Fathima.I	9500463171	Home Maker	280000.00	no.18 Mariamman kovil street,	St.Paulpet, Lawspet	Puducherry	Puducherry	605008	Crescent Hr. Sec. school	Stateboard	442.00	88.40	Alpha Mat. Hr. Sec School	Sateboard	519.00	87.00	2025-09-17	MANAGEMENT	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:05:33.05517+05:30	muslim	791209758164	Day Scholar	BUS	8	f	7	\N	\N	\N	father
1738	1835	7	\N	Tarshini	G.S	25TP0445	Female	2007-02-05	B+	Indian	OBC	\N	2025-2029	2	3	tarshini25tp0445@svcet.ac.in	tarshiniroshika0709@gmail.com	9342042430	Sudhakar G	7904612898	Civil engineer	Rekha S	6383823182	Home maker	75000.00	no 51, 4th cross,nethaji nagar	karaikal	karaikal	Puducherry	609602	Cauvery public school	cbse	370.00	74.00	Cauvery public school	cbse	320.00	64.00	2025-08-17	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:13:17.536709+05:30	Hindu	980293893042	Hostel	OWN	\N	f	7	Shivani umamaheshwari	7904088204	Software engineer	father
1699	1796	7	\N	Akshaya	R	25TP0404	Female	2008-03-17	AB+	Indian	MBC	\N	2025-2029	2	3	akshaya25tp0404@svcet.ac.in	akshayaakshay465@gmail.com	9489217061	Ravi	\N	\N	Mangaiyarkarasi	8680949576	Salesperson	75000.00	no:21,gandhi street,indira nagar,mudhaliyarpet	\N	puducherry	puducherry	605004	Immaculate heart of mary girls hr.sec school	state board	352.00	70.40	Immaculate heart of mary girls hr.sec school	State board	388.00	65.00	2025-09-03	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:07:00.959725+05:30	hindu	780590793347	Day Scholar	BUS	26	f	7	\N	\N	\N	mother
1719	1816	7	\N	Oviya	J	25TP0426	Female	2008-03-13	A+	Indian	OBC	\N	2025-2029	2	3	oviya25tp0426@svcet.ac.in	\N	8825901914	Jayakumar	9486534504	Business	Suguniya	9080602869	House Wife	74999.00	No:8a 2nd cross thirukameshwar nagar villianur  puducherry 	villianur	Puducherry	Puducherry	605110	Amalorpavam lords academy 	CBSE	426.00	81.00	Amalorpavam lords academy 	CBSE	346.00	69.00	2025-08-16	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:14:35.965632+05:30	Hindu	566038947419	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1737	1834	7	\N	Swathy	S	25TP0444	Female	2008-06-26	A+	Indian	BC	\N	2025-2029	2	3	swathy25tp0444@svcet.ac.in	\N	8438321499	Siva.R	9092993499	travels	Jayalakshmi.S	9092663499	hostel wadern	\N	No.22,Abdul Kalam Street,Dhanakodi Nagar EXTN,Dharmapuri,Puducherry	\N	Dharmapuri	puducherry	605009	Mutharaiyar Higher Secondary School	State board	426.00	85.00	Mutharaiyar Higher Secondary School	State board	467.00	77.00	2025-08-16	CENTAC	t	2026-07-22 11:21:31.778737+05:30	2026-07-23 16:18:19.375536+05:30	Hindu	283985660404	Day Scholar	OWN	\N	f	7	\N	\N	\N	father
1447	1544	1	9	Dharshini	M	24TD0766	Female	2007-08-20	B+	Indian	BC	\N	2024 -2028	3	5	dharshini24td0766@svcet.ac.in	dharshu200793@gmail.com	9791263376	S.Monaguru	9791982926	Sales Rep	M.Vijayashanthi	9944629365	Accountant	80000.00	No.11,Andianthope,Mudhaliarpet	Near Madha Agencies	Puducherry	Puducherry	605004	Amalorpavam Higher Secondary School	State Board	380.00	75.00	Amalorpavam Higher Secondary School	State board	470.00	82.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:25:24.462048+05:30	Hindu	664397462495	Day Scholar	BUS	27	f	1	NIL	\N	NIL	mother
1515	1612	1	9	Shahara Banu	S	24TD0835	Female	2007-02-23	O+	Indian	general	\N	2024 -2028	3	5	shaharabanu24td0835@svcet.ac.in	shaharabanu2325@gmail.com	9790646365	Sabir Mohammed.M	9566996365	Mechanic	Fathima Beevi.S	9790646365	House Wife	75000.00	no:34,pallivasal street,1st plot,pudhu nagar	\N	villianur	pondicherry	605110	Immaculate heart of mary's govt.aided girls high,villianur	state board	290.00	58.00	Blue stars higher secondary school,arumbarthapurama	state board	479.00	79.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:27:59.480521+05:30	muslim	718905468135	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1480	1577	1	9	Meena	S	24TD0800	Female	2007-01-09	B+	Indian	obc	\N	2024 -2028	3	5	meena24td0800@svcet.ac.in	meenasundarajan09012007@gmail.com	9345511697	Sundarrajan	9345511697	nil	Sathiya	9345511697	house wife	75000.00	No.83,Venkateshwara Nagar	\N	Ariyur	Puducherry	605102	Sri Ramanchandra Vidhalaya High School	state board	376.00	75.00	Blue Stars Higher Secondary School	state board	491.00	82.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:28:39.702959+05:30	Hindu	647876984964	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1449	1546	1	9	Dhivyadharshini	R	24TD0768	Female	2007-05-02	O+	Indian	MBC	\N	2024 -2028	3	5	dhivyadharshini24td0768@svcet.ac.in	radhivya2.0@gmail.com	7695801655	Ramesh R	8608764536	software	kavitha R	9092227339	Houe wife 	75000.00	no:5 sri balaji nagar sankaran pettai puducherry 	no:5 sri balaji nagar sankaran pettai puducherry 	puducherry	puducherry	605106	Balaji high secondary school embalam	STATE BOARD	291.00	59.00	Balaji high secondary school embalam	STATE BOARD	475.00	89.00	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:29:07.432752+05:30	hindu	904992522504	Day Scholar	OWN	\N	f	1	NIL	\N	\N	father
1525	1622	1	10	Sunil Kumar	A	24TD0845	Male	2007-02-22	O+	Indian	MBC	\N	2024 -2028	3	5	sunilkumar24td0845@svcet.ac.in	sunilkumaryogitha@gmail.com	9092643787	E.Arpudhaveel	9047989824	driver	A.Sarala	9087377947	house wife	75000.00	No:81 manguppam street ,Andiyarpalayam	\N	Mathagadipet	pondicherry	605108	sri hindocha higher secondary school	state board	290.00	55.00	nil	state board	350.00	56.00	2024-09-15	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:35:22.199172+05:30	hindu	990755563144	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1492	1589	1	10	pradhoshwaran	V.K	24TD0812	Male	2007-05-17	O+	Indian	obc	\N	2024 -2028	3	5	pradhoshwaran24td0812@svcet.ac.in	\N	9626382339	I.Velukumar	9790585811	bussiness	M.Kavitha	9597511174	hostel wadern	500000.00	no 6,10th cross tagore nagar lawspet puducherry 605008	\N	lawspet	puducherry	605008	Don bosco	State board	353.00	70.60	Don bosco	State board	339.00	56.00	2024-09-17	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:36:30.443468+05:30	Hindu	818131442830	Day Scholar	BUS	8	f	1	\N	\N	\N	mother
1450	1547	1	9	Dhivyadharshini	S	24TD0769	Female	2006-11-02	A+	Indian	mbc	\N	2024 -2028	3	5	dhivyadharshini24td0769@svcet.ac.in	dhivyadharshini155211@gmail.com	8056262181	Sivakumar K	8870833181	Agriculture	Nithiya S	9524227263	housewife	72000.00	No.277,Ghandhi Nagar, Eraiyur	\N	Villupuram	tamilnadu	6043304	Santa Clara convent girls higher secondary school, k manaveli	state board	387.00	78.00	Santa Clara convent girls higher secondary school, k manaveli	stateboard	444.00	75.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:39:01.556083+05:30	hindu	957320973735	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1551	1648	1	10	Siranjeevi	M	24TDL020	Male	2004-01-26	B+	Indian	sc	\N	2024 -2028	3	5	siranjeevi24tdl020@svcet.ac.in	siranjeeviabi357@gmail.com	9789222749	mukilan	9092739159	hostel warden	\N	\N	\N	300000.00	18,muthumariamman koil street, karuvadikuppam,pondicherry	\N	pondicherry	pondicherry	605008	fatima higher secondary school puducherry	state board	228.00	41.00	motilal nehru government polytechnic college	diploma	75.00	73.00	2025-08-08	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:40:32.902454+05:30	hindu	605269443866	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1787	1911	2	\N	AJAI	G	24TC0551	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	ajai24tc0551@svcet.ac.in	\N	9342799061	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1788	1912	2	\N	AJAY	M	24TC0552	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	ajay24tc0552@svcet.ac.in	\N	9150619248	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1789	1913	2	\N	ALEX	R	24TC0553	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	alex24tc0553@svcet.ac.in	\N	8072734688	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1790	1914	2	\N	ARAVIND	A	24TC0554	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	aravind24tc0554@svcet.ac.in	\N	9360490242	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1791	1915	2	\N	ARAVINDH	V	24TC0555	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	aravindh24tc0555@svcet.ac.in	\N	9080205056	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1792	1916	2	\N	BALAMURUGAN	R	24TC0556	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	balamurugan24tc0556@svcet.ac.in	\N	8438837649	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1793	1917	2	\N	DAYALAN	K	24TC0557	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	dayalan24tc0557@svcet.ac.in	\N	7639339310	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1794	1918	2	\N	DEEPAK	M	24TC0558	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	deepak24tc0558@svcet.ac.in	\N	6381529685	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1514	1611	1	10	Shafana	S	24TD0834	Female	2006-10-25	O+	Indian	Lubbai	\N	2024 -2028	3	5	shafana24td0834@svcet.ac.in	shafanasayed06@gmail.com	7397311425	Sayed Hussain B	9597959369	Watch Technician	Rahamathunisa S	9363381038	House maid	-2.00	Plot no:15, 1st cross Vaahidh Nagar, Sulthanpet, Villianur	\N	puducherry	puducherry	605110	Immaculate Heart of Mary's Government Aided Girls High School	Tamil Nadu	385.00	77.00	Maninimegalai Government Girls Higher Secondary School	Tamil Nadu	456.00	76.00	2024-09-24	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 10:43:20.152304+05:30	Muslim	859194530015	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1312	1397	1	7	Namachivayam	S	23TD0701	Male	2006-07-23	B+	Indian	-	\N	2023-2027	4	7	namachivayam23td0701@svcet.ac.in	namachivayamofficial@gmail.com	9894868421	Sengeni.R	9789182854	CO-Operative puducherry	Kavitha.M	9500715168	-	100000.00	No:16	Nehru Street	Kathirkamam	Pudhucherry	605009	Stansford International Higher Secondary School	CBSE	354.00	75.00	Stansford International Higher Secondary School	CBSE	312.00	63.00	2023-10-19	CENTAC	t	2026-07-14 11:41:58.371248+05:30	2026-07-24 10:48:10.184448+05:30	HINDU	292623845133	Day Scholar	OWN	\N	f	\N	-	\N	-	mother
1797	1921	2	\N	DHIVYA	D	24TC0561	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	dhivya24tc0561@svcet.ac.in	\N	6379604842	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1798	1922	2	\N	GANESHKUMAR	M	24TC0562	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	ganeshkumar24tc0562@svcet.ac.in	\N	9487204736	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1799	1923	2	\N	GIRI	M	24TC0563	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	giri24tc0563@svcet.ac.in	\N	9498850065	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1800	1924	2	\N	GOWRI	G	24TC0564	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	gowri24tc0564@svcet.ac.in	\N	8015434442	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1801	1925	2	\N	HARISH	A	24TC0565	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	harish24tc0565@svcet.ac.in	\N	9361637373	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1802	1926	2	\N	HARISHRAJ	K	24TC0566	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	harishraj24tc0566@svcet.ac.in	\N	7448689959	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1803	1927	2	\N	JAYASUNDARAPANDIAN	J	24TC0567	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	jayasundarapandian24tc0567@svcet.ac.in	\N	8925027597	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1804	1928	2	\N	JOHNSON	S	24TC0568	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	Johnson24tc0568@svcet.ac.in	\N	8838758909	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1805	1929	2	\N	KADHIR	S	24TC0569	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	kadhir24tc0569@svcet.ac.in	\N	9791229474	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1806	1930	2	\N	KALAIVANA	D	24TC0570	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	kalaivanan24tc0570@svcet.ac.in	\N	9677435797	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1807	1931	2	\N	KAVIYA	K	24TC0572	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	kaviya24tc0572@svcet.ac.in	\N	9500712507	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1808	1932	2	\N	KISHORE	S	24TC0573	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	kishore24tc0573@svcet.ac.in	\N	9500808499	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1809	1933	2	\N	LAKSITHA	A	24TC0574	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	laksitha24tc0574@svcet.ac.in	\N	9025085815	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1810	1934	2	\N	LOKESH	M.S	24TC0575	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	lokesh24tc0575@svcet.ac.in	\N	9363483793	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1811	1935	2	\N	LOKESH	M	24TC0576	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	lokesh24tc0576@svcet.ac.in	\N	8098506240	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1812	1936	2	\N	MANIKANDAN	A	24TC0577	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	manikandan24tc0577@svcet.ac.in	\N	8122660655	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1813	1937	2	\N	MOSHIKA	U	24TC0579	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	moshika24tc0579@svcet.ac.in	\N	9123522601	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1814	1938	2	\N	MOHAMED MOOSA	M	24TC0580	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	mouhamedmoosa24tc0580@svcet.ac.in	\N	9585099296	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1815	1939	2	\N	NIVEDHA	R	24TC0581	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	nivedha24tc0581@svcet.ac.in	\N	9360779500	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1816	1940	2	\N	PAVITHRAN	R	24TC0582	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	pavithran24tc0582@svcet.ac.in	\N	8925669951	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1817	1941	2	\N	PRABHA	S	24TC0583	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	prabha24tc0583@svcet.ac.in	\N	8300947453	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1818	1942	2	\N	PRATHAPAN	G	24TC0584	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	prathapan24tc0584@svcet.ac.in	\N	7867099094	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1819	1943	2	\N	PUGAZHENDHI	B	24TC0585	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	pugazhendhi24tc0585@svcet.ac.in	\N	9344027971	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1820	1944	2	\N	RAGAVARSHINI	P	24TC0586	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	ragavarshini24tc0586@svcet.ac.in	\N	8754380869	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1821	1945	2	\N	RAGHULGANESH	S	24TC0587	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	raghulganesh24tc0587@svcet.ac.in	\N	9943645349	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1822	1946	2	\N	RAJALATCHOUMY	R	24TC0588	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	rajalatchoumy24tc0588@svcet.ac.in	\N	7904897780	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1823	1947	2	\N	RAMKUMAR	K	24TC0589	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	ramkumar24tc0589@svcet.ac.in	\N	9790328037	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1824	1948	2	\N	RATHIMEENA	V	24TC0590	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	rathimeena24tc0590@svcet.ac.in	\N	9597257146	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1825	1949	2	\N	SAKTHIRAMAN	V	24TC0591	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	sakthiraman24tc0591@svcet.ac.in	\N	8248348102	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1826	1950	2	\N	SANJEEV PRASATH	T	24TC0592	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	sanjeevprasath24tc0592@svcet.ac.in	\N	8754015728	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1827	1951	2	\N	SARAN PRIYA	M	24TC0593	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	saranpriya24tc0593@svcet.ac.in	\N	6383906423	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1828	1952	2	\N	SARANRAJ	M	24TC0594	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	saranraj24tc0594@svcet.ac.in	\N	8667274101	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1829	1953	2	\N	SATHISHKUMAR	S	24TC0595	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	sathishkumar24tc0595@svcet.ac.in	\N	7448562694	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1830	1954	2	\N	SHANMUGANATHAN	A	24TC0596	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	shanmuganathan24tc0596@svcet.ac.in	\N	9360600361	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1831	1955	2	\N	SHARMILA	P	24TC0597	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	sharmila24tc0597@svcet.ac.in	\N	9025633983	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1832	1956	2	\N	SHINAK BAGAM	E	24TC0598	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	shinakbagam24tc0598@svcet.ac.in	\N	8438748856	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1833	1957	2	\N	SIDHARTH	J	24TC0599	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	siddharth24tc0599@svcet.ac.in	\N	7010093009	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1834	1958	2	\N	SIVARAJ	B	24TC0600	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	sivaraj24tc0600@svcet.ac.in	\N	9042058753	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1835	1959	2	\N	SUBIKSHA	T	24TC0601	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	subiksha24tc0601@svcet.ac.in	\N	8056357159	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1836	1960	2	\N	SURESH	S	24TC0602	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	suresh24tc0602@svcet.ac.in	\N	8438499255	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1837	1961	2	\N	SUSHMITHA	A	24TC0603	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	sushmitha24tc0603@svcet.ac.in	\N	9715483284	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1838	1962	2	\N	VIGNESH	B	24TC0604	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	vignesh24tc0604@svcet.ac.in	\N	9345531211	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1839	1963	2	\N	YASAR ARAFATH	G	24TC0605	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	yasararafath24tc0605@svcet.ac.in	\N	8015740626	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1840	1964	2	\N	YOGA PRIYA	P	24TC0606	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	yogapriya24tc0606@svcet.ac.in	\N	6380792918	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1841	1965	2	\N	YUVASRI	S	24TC0607	\N	\N	\N	Indian	\N	\N	2024-2028	3	5	yuvasri24tc0607@svcet.ac.in	\N	8098970934	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	t	2026-07-24 10:53:40.338865+05:30	\N	\N	\N	\N	\N	\N	f	2	\N	\N	\N	\N
1466	1563	1	10	Harishkumar	K	24TD0785	Male	2006-11-11	O+	Indian	OBC	\N	2024 -2028	3	5	harishkumar24td0785@svcet.ac.in	harishkumar11112006@gmail.com	9363502167	K.KATHIRESIN	9751112119	WELDER	K.JEYALAKSHMI	9566332184	HOUSE WIFE 	200000.00	NO,14 KALLARAI ST DAVIDPET PONDICHERRY	\N	PONDICHERRY	PONDICHERRY	605001	PETIT SEMINAIRE 	STATE BOARD	380.00	60.00	PETIT SEMINAIRE 	STATE BOARD	380.00	63.00	2024-09-12	MANAGEMENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 11:01:25.942221+05:30	MUSLIM	497841184469	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1451	1548	1	10	Dinesh kumar	S	24TD0770	Male	2007-02-10	O+	Indian	OBC	\N	2024 -2028	3	5	dineshkumar24td0770@svcet.ac.in	dinesxeeee12@gmail.com	9345918525	Sasi kumar .S	9486489596	Lining work 	Mahalakshmi.S	9444614596	Hotel	100000.00	No2 Indhira nagar , third cross thirunallar, karaikal 	\N	puducherry	puducherry	609602	Karaikal Ammayar government higher secondary school 	state board	398.00	79.00	Karaikal Ammayar government higher secondary school 	State board	437.00	72.30	2024-09-12	CENTAC	t	2026-07-21 16:25:56.664347+05:30	2026-07-24 11:08:00.009842+05:30	HINDU	316943744017	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1604	1701	1	50	MAHALAKSHMI	S	25TD0653	Female	2008-02-24	O+	Indian	MBC	\N	2025-2029	2	3	mahalakshmi25td0653@svcet.ac.in	mahamaha4377@gmail.com	7708692497	senthilmurugan.s	9994811353	barbar	\N	\N	\N	80000.00	no 12  	2nd street ganapathy nagar	thanthai periyar nagar	puducherry	605010	seventh day adventist hr.sec school	state board	383.00	76.00	presidency hr.sec school	State Board	444.00	74.00	2025-07-13	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-24 11:44:53.452121+05:30	Hindu 	683532880052	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1642	1739	1	50	VAIRA KIRUTHIKA	M	25TD0691	Female	2007-11-25	A+	Indian	MBC	\N	2025-2029	2	3	vairakiruthika25td0691@svcet.ac.in	diamond30969@gmail.com	9003584995	murugan.g	9524886232	agriculture	\N	\N	\N	70000.00	 no.05	west street	ariyur puducherry	puducherry	605102	sri ramachandra vidhyalaya high school ariyur puducherry	state board	467.00	93.00	alpha matriculation higher secondary school puducherry	state board	440.00	73.00	2025-09-15	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-24 11:45:20.983388+05:30	Hindu	210051433699	Day Scholar	OWN	\N	f	1	\N	\N	\N	father
1579	1676	1	50	JAMES	J	25TD0628	Male	2008-06-13	O+	Indian	obc	\N	2025-2029	2	3	james25td0628@svcet.ac.in	jamesbond8807172@gmail.com	8807172563	jesudass.j	8807172563	car mechanic	Benita.J	9790328782	House Wife	120000.00	no:103 venkateshwara nagar  ariyur	\N	pondicherry	pondicherry	605102	sri Ramachandra vidhiyalaya high school 	state board	403.00	80.00	presidency hr.sec school	state board	445.00	74.00	2025-08-12	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-24 11:49:22.014906+05:30	christian	730691509354	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1577	1674	1	50	IRFAN MOHAMMED	K	25TD0626	Male	2008-07-08	A+	Indian	BCM	\N	2025-2029	2	3	irfanmohammed25td0626@svcet.ac.in	irfanmuhamwd@gmail.com	6385599041	nil	\N	\N	fathima beevi	6385599041	medical representative	150000.00	NO.48, mohamadiya nagar,sulthanpet	\N	pondicherry	puducherry	605 110	fatima higher secondary school	STATE BOARD	375.00	75.00	Alpha english higher secondary school	STATE BOARD	407.00	67.83	2025-08-02	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-24 11:47:45.377314+05:30	muslim	969951734208	Day Scholar	OWN	\N	f	1	\N	\N	\N	mother
1645	1742	1	50	VIMALATHITHAN	N	25TD0694	Male	2007-10-29	O+	Indian	obc	\N	2025-2029	2	3	vimalathithan25td0694@svcet.ac.in	vimalathithan29n@gmail.com	6381430117	Nandakumar P	9894719199	\N	Usha N	\N	Govt employee (DEO)	120000.00	152 lawspet main road	pakkamudaianpet 	puducherry	puducherry	605008	Maharishi International Residential School	CBSE	283.00	57.00	New Modern Vidhya Mandir Hr.Sec.School	stateboard	419.00	69.80	2025-07-17	CENTAC	t	2026-07-22 10:45:13.145749+05:30	2026-07-24 11:50:45.375972+05:30	hindu	826133299951	Day Scholar	BUS	08	f	1	\N	\N	\N	father
\.


--
-- Data for Name: tally_ledger_mappings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tally_ledger_mappings (id, ledger_name_raw, student_id, confirmed_by, confirmed_at) FROM stdin;
260	Test.Student3 (Mng - TEST/2023-2027)	1349	\N	2026-07-24 09:33:39.67275+05:30
261	Test.Student4 (Cen - TEST/2023-2027)	1350	\N	2026-07-24 09:33:39.67275+05:30
262	Test.Student5 (Cen - TEST/2023-2027)	1351	\N	2026-07-24 09:33:39.67275+05:30
263	Test.Student6 (Cen - TEST/2023-2027)	1352	\N	2026-07-24 09:33:39.67275+05:30
264	Test.Student7 (Cen - TEST/2023-2027)	1353	\N	2026-07-24 09:33:39.67275+05:30
265	Test.Student8 (Cen - TEST/2023-2027)	1354	\N	2026-07-24 09:33:39.67275+05:30
266	Test.Student9 (Mng - TEST/2023-2027)	1355	\N	2026-07-24 09:33:39.67275+05:30
267	Test.Student10 (Cen - TEST/2023-2027)	1356	\N	2026-07-24 09:33:39.67275+05:30
268	Test.Student11 (Cen - TEST/2023-2027)	1357	\N	2026-07-24 09:33:39.67275+05:30
269	Test.Student12 (Cen - TEST/2023-2027)	1358	\N	2026-07-24 09:33:39.67275+05:30
270	Test.Student13 (Cen - TEST/2023-2027)	1359	\N	2026-07-24 09:33:39.67275+05:30
271	Test.Student14 (Cen - TEST/2023-2027)	1360	\N	2026-07-24 09:33:39.67275+05:30
272	Test.Student15 (Cen - TEST/2023-2027)	1361	\N	2026-07-24 09:33:39.67275+05:30
273	Test.Student16 (Cen - TEST/2023-2027)	1362	\N	2026-07-24 09:33:39.67275+05:30
274	Test.Student17 (Mng - TEST/2023-2027)	1363	\N	2026-07-24 09:33:39.67275+05:30
275	Test.Student18 (Cen - TEST/2023-2027)	1364	\N	2026-07-24 09:33:39.67275+05:30
276	Test.Student19 (Mng - TEST/2023-2027)	1365	\N	2026-07-24 09:33:39.67275+05:30
277	Test.Student20 (Mng - TEST/2023-2027)	1366	\N	2026-07-24 09:33:39.67275+05:30
278	Test.Student21 (Cen - TEST/2024-2028)	1367	\N	2026-07-24 09:33:39.67275+05:30
279	Test.Student22 (Cen - TEST/2024-2028)	1368	\N	2026-07-24 09:33:39.67275+05:30
280	Test.Student23 (Mng - TEST/2024-2028)	1369	\N	2026-07-24 09:33:39.67275+05:30
281	Test.Student24 (Mng - TEST/2024-2028)	1370	\N	2026-07-24 09:33:39.67275+05:30
282	Test.Student25 (Mng - TEST/2024-2028)	1371	\N	2026-07-24 09:33:39.67275+05:30
283	Test.Student26 (Cen - TEST/2024-2028)	1372	\N	2026-07-24 09:33:39.67275+05:30
284	Test.Student27 (Cen - TEST/2024-2028)	1373	\N	2026-07-24 09:33:39.67275+05:30
285	Test.Student28 (Mng - TEST/2024-2028)	1374	\N	2026-07-24 09:33:39.67275+05:30
286	Test.Student29 (Cen - TEST/2024-2028)	1375	\N	2026-07-24 09:33:39.67275+05:30
287	Test.Student30 (Cen - TEST/2024-2028)	1376	\N	2026-07-24 09:33:39.67275+05:30
288	Test.Student31 (Mng - TEST/2024-2028)	1377	\N	2026-07-24 09:33:39.67275+05:30
289	Test.Student32 (Cen - TEST/2024-2028)	1378	\N	2026-07-24 09:33:39.67275+05:30
290	Test.Student33 (Mng - TEST/2024-2028)	1379	\N	2026-07-24 09:33:39.67275+05:30
291	Test.Student34 (Mng - TEST/2024-2028)	1380	\N	2026-07-24 09:33:39.67275+05:30
292	Test.Student35 (Mng - TEST/2024-2028)	1381	\N	2026-07-24 09:33:39.67275+05:30
293	Test.Student36 (Cen - TEST/2024-2028)	1382	\N	2026-07-24 09:33:39.67275+05:30
294	Test.Student37 (Mng - TEST/2024-2028)	1383	\N	2026-07-24 09:33:39.67275+05:30
295	Test.Student38 (Cen - TEST/2024-2028)	1384	\N	2026-07-24 09:33:39.67275+05:30
296	Test.Student39 (Mng - TEST/2024-2028)	1385	\N	2026-07-24 09:33:39.67275+05:30
297	Test.Student40 (Cen - TEST/2024-2028)	1386	\N	2026-07-24 09:33:39.67275+05:30
298	Test.Student41 (Mng - TEST/2025-2029)	1387	\N	2026-07-24 09:33:39.67275+05:30
299	Test.Student42 (Mng - TEST/2025-2029)	1388	\N	2026-07-24 09:33:39.67275+05:30
300	Test.Student43 (Cen - TEST/2025-2029)	1389	\N	2026-07-24 09:33:39.67275+05:30
301	Test.Student44 (Cen - TEST/2025-2029)	1390	\N	2026-07-24 09:33:39.67275+05:30
302	Test.Student45 (Cen - TEST/2025-2029)	1391	\N	2026-07-24 09:33:39.67275+05:30
303	Test.Student46 (Cen - TEST/2025-2029)	1392	\N	2026-07-24 09:33:39.67275+05:30
304	Test.Student47 (Mng - TEST/2025-2029)	1393	\N	2026-07-24 09:33:39.67275+05:30
305	Test.Student48 (Cen - TEST/2025-2029)	1394	\N	2026-07-24 09:33:39.67275+05:30
306	Test.Student49 (Cen - TEST/2025-2029)	1395	\N	2026-07-24 09:33:39.67275+05:30
307	Test.Student50 (Cen - TEST/2025-2029)	1396	\N	2026-07-24 09:33:39.67275+05:30
308	Test.Student51 (Mng - TEST/2025-2029)	1397	\N	2026-07-24 09:33:39.67275+05:30
309	Test.Student52 (Mng - TEST/2025-2029)	1398	\N	2026-07-24 09:33:39.67275+05:30
310	Test.Student53 (Mng - TEST/2025-2029)	1399	\N	2026-07-24 09:33:39.67275+05:30
311	Test.Student54 (Mng - TEST/2025-2029)	1400	\N	2026-07-24 09:33:39.67275+05:30
312	Test.Student55 (Cen - TEST/2025-2029)	1401	\N	2026-07-24 09:33:39.67275+05:30
313	Test.Student56 (Mng - TEST/2025-2029)	1402	\N	2026-07-24 09:33:39.67275+05:30
314	Test.Student57 (Mng - TEST/2025-2029)	1403	\N	2026-07-24 09:33:39.67275+05:30
315	Test.Student58 (Cen - TEST/2025-2029)	1404	\N	2026-07-24 09:33:39.67275+05:30
316	Test.Student59 (Mng - TEST/2025-2029)	1405	\N	2026-07-24 09:33:39.67275+05:30
317	Test.Student60 (Cen - TEST/2025-2029)	1406	\N	2026-07-24 09:33:39.67275+05:30
318	Test.Student61 (Cen - TEST/2026-2030)	1407	\N	2026-07-24 09:33:39.67275+05:30
319	Test.Student62 (Cen - TEST/2026-2030)	1408	\N	2026-07-24 09:33:39.67275+05:30
320	Test.Student63 (Cen - TEST/2026-2030)	1409	\N	2026-07-24 09:33:39.67275+05:30
321	Test.Student64 (Mng - TEST/2026-2030)	1410	\N	2026-07-24 09:33:39.67275+05:30
322	Test.Student65 (Mng - TEST/2026-2030)	1411	\N	2026-07-24 09:33:39.67275+05:30
323	Test.Student66 (Mng - TEST/2026-2030)	1412	\N	2026-07-24 09:33:39.67275+05:30
324	Test.Student67 (Cen - TEST/2026-2030)	1413	\N	2026-07-24 09:33:39.67275+05:30
325	Test.Student68 (Mng - TEST/2026-2030)	1414	\N	2026-07-24 09:33:39.67275+05:30
326	Test.Student69 (Cen - TEST/2026-2030)	1415	\N	2026-07-24 09:33:39.67275+05:30
327	Test.Student70 (Cen - TEST/2026-2030)	1416	\N	2026-07-24 09:33:39.67275+05:30
328	Test.Student71 (Cen - TEST/2026-2030)	1417	\N	2026-07-24 09:33:39.67275+05:30
329	Test.Student72 (Mng - TEST/2026-2030)	1418	\N	2026-07-24 09:33:39.67275+05:30
330	Test.Student73 (Mng - TEST/2026-2030)	1419	\N	2026-07-24 09:33:39.67275+05:30
331	Test.Student74 (Mng - TEST/2026-2030)	1420	\N	2026-07-24 09:33:39.67275+05:30
332	Test.Student75 (Cen - TEST/2026-2030)	1421	\N	2026-07-24 09:33:39.67275+05:30
333	Test.Student76 (Cen - TEST/2026-2030)	1422	\N	2026-07-24 09:33:39.67275+05:30
334	Test.Student77 (Mng - TEST/2026-2030)	1423	\N	2026-07-24 09:33:39.67275+05:30
335	Test.Student78 (Cen - TEST/2026-2030)	1424	\N	2026-07-24 09:33:39.67275+05:30
336	Test.Student79 (Mng - TEST/2026-2030)	1425	\N	2026-07-24 09:33:39.67275+05:30
337	Test.Student80 (Mng - TEST/2026-2030)	1426	\N	2026-07-24 09:33:39.67275+05:30
338	Test.Student3 (Cen - TEST/2023-2027)	1349	\N	2026-07-24 09:46:40.743116+05:30
339	Test.Student46 (Mng - TEST/2025-2029)	1392	\N	2026-07-24 09:46:40.743116+05:30
340	Test.Student69 (Mng - TEST/2026-2030)	1415	\N	2026-07-24 09:46:50.758872+05:30
341	Test.Student10 (Mng - TEST/2023-2027)	1356	\N	2026-07-24 09:46:50.758872+05:30
342	Test.Student21 (Mng - TEST/2024-2028)	1367	\N	2026-07-24 09:46:55.999597+05:30
343	Test.Student54 (Cen - TEST/2025-2029)	1400	\N	2026-07-24 09:46:55.999597+05:30
344	Test.Student48 (Mng - TEST/2025-2029)	1394	\N	2026-07-24 09:46:55.999597+05:30
345	Test.Student31 (Cen - TEST/2024-2028)	1377	\N	2026-07-24 09:46:55.999597+05:30
346	Test.Student38 (Mng - TEST/2024-2028)	1384	\N	2026-07-24 09:46:59.812302+05:30
347	Test.Student17 (Cen - TEST/2023-2027)	1363	\N	2026-07-24 09:46:59.812302+05:30
348	Test.Student44 (Mng - TEST/2025-2029)	1390	\N	2026-07-24 09:46:59.812302+05:30
349	Test.Student67 (Mng - TEST/2026-2030)	1413	\N	2026-07-24 09:46:59.812302+05:30
\.


--
-- Data for Name: timetable_slots; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.timetable_slots (id, course_assignment_id, day, start_time, end_time, room, created_at) FROM stdin;
602	109	MON	08:45:00	09:30:00		2026-07-14 16:06:53.98696+05:30
603	110	MON	09:30:00	10:20:00		2026-07-14 16:06:53.98696+05:30
604	113	MON	10:35:00	11:25:00		2026-07-14 16:06:53.98696+05:30
605	113	MON	11:25:00	12:15:00		2026-07-14 16:06:53.98696+05:30
606	109	MON	13:00:00	13:50:00		2026-07-14 16:06:53.98696+05:30
607	109	MON	13:50:00	14:40:00		2026-07-14 16:06:53.98696+05:30
608	110	MON	14:50:00	15:40:00		2026-07-14 16:06:53.98696+05:30
609	110	MON	15:40:00	16:30:00		2026-07-14 16:06:53.98696+05:30
610	111	TUE	08:45:00	09:30:00		2026-07-14 16:06:53.98696+05:30
611	109	TUE	09:30:00	10:20:00		2026-07-14 16:06:53.98696+05:30
612	110	TUE	10:35:00	11:25:00		2026-07-14 16:06:53.98696+05:30
613	109	TUE	11:25:00	12:15:00		2026-07-14 16:06:53.98696+05:30
614	110	TUE	13:00:00	13:50:00		2026-07-14 16:06:53.98696+05:30
615	110	TUE	13:50:00	14:40:00		2026-07-14 16:06:53.98696+05:30
616	111	TUE	14:50:00	15:40:00		2026-07-14 16:06:53.98696+05:30
617	111	TUE	15:40:00	16:30:00		2026-07-14 16:06:53.98696+05:30
618	110	WED	08:45:00	09:30:00		2026-07-14 16:06:53.98696+05:30
619	110	WED	09:30:00	10:20:00		2026-07-14 16:06:53.98696+05:30
620	109	WED	10:35:00	11:25:00		2026-07-14 16:06:53.98696+05:30
621	110	WED	11:25:00	12:15:00		2026-07-14 16:06:53.98696+05:30
622	109	WED	13:00:00	13:50:00		2026-07-14 16:06:53.98696+05:30
623	111	WED	13:50:00	14:40:00		2026-07-14 16:06:53.98696+05:30
624	111	WED	14:50:00	15:40:00		2026-07-14 16:06:53.98696+05:30
625	112	WED	15:40:00	16:30:00		2026-07-14 16:06:53.98696+05:30
626	112	THU	08:45:00	09:30:00		2026-07-14 16:06:53.98696+05:30
627	111	THU	09:30:00	10:20:00		2026-07-14 16:06:53.98696+05:30
628	112	THU	10:35:00	11:25:00		2026-07-14 16:06:53.98696+05:30
629	109	THU	11:25:00	12:15:00		2026-07-14 16:06:53.98696+05:30
630	111	THU	13:00:00	13:50:00		2026-07-14 16:06:53.98696+05:30
631	112	THU	13:50:00	14:40:00		2026-07-14 16:06:53.98696+05:30
632	111	THU	14:50:00	15:40:00		2026-07-14 16:06:53.98696+05:30
633	111	THU	15:40:00	16:30:00		2026-07-14 16:06:53.98696+05:30
634	112	FRI	08:45:00	09:30:00		2026-07-14 16:06:53.98696+05:30
635	111	FRI	09:30:00	10:20:00		2026-07-14 16:06:53.98696+05:30
636	113	FRI	10:35:00	11:25:00		2026-07-14 16:06:53.98696+05:30
96	74	TUE	11:25:00	12:15:00		2026-07-07 11:14:54.311741+05:30
97	76	TUE	09:30:00	10:20:00		2026-07-07 12:40:09.343685+05:30
637	111	FRI	11:25:00	12:15:00		2026-07-14 16:06:53.98696+05:30
638	113	FRI	13:00:00	13:50:00		2026-07-14 16:06:53.98696+05:30
639	109	FRI	13:50:00	14:40:00		2026-07-14 16:06:53.98696+05:30
640	109	FRI	14:50:00	15:40:00		2026-07-14 16:06:53.98696+05:30
641	111	FRI	15:40:00	16:30:00		2026-07-14 16:06:53.98696+05:30
684	133	MON	08:45:00	09:30:00		2026-07-17 08:43:46.533558+05:30
685	108	MON	09:30:00	10:20:00		2026-07-17 08:43:46.533558+05:30
686	108	MON	10:35:00	11:25:00		2026-07-17 08:43:46.533558+05:30
687	107	MON	11:25:00	12:15:00		2026-07-17 08:43:46.533558+05:30
688	133	TUE	08:45:00	09:30:00		2026-07-17 08:43:46.533558+05:30
689	133	TUE	09:30:00	10:20:00		2026-07-17 08:43:46.533558+05:30
690	108	TUE	10:35:00	11:25:00		2026-07-17 08:43:46.533558+05:30
691	107	TUE	11:25:00	12:15:00		2026-07-17 08:43:46.533558+05:30
692	133	WED	08:45:00	09:30:00		2026-07-17 08:43:46.533558+05:30
693	108	WED	09:30:00	10:20:00		2026-07-17 08:43:46.533558+05:30
694	108	WED	10:35:00	11:25:00		2026-07-17 08:43:46.533558+05:30
695	133	WED	11:25:00	12:15:00		2026-07-17 08:43:46.533558+05:30
696	108	WED	13:00:00	13:50:00		2026-07-17 08:43:46.533558+05:30
697	108	THU	08:45:00	09:30:00		2026-07-17 08:43:46.533558+05:30
698	108	THU	09:30:00	10:20:00		2026-07-17 08:43:46.533558+05:30
699	108	THU	10:35:00	11:25:00		2026-07-17 08:43:46.533558+05:30
700	107	THU	11:25:00	12:15:00		2026-07-17 08:43:46.533558+05:30
701	108	THU	13:00:00	13:50:00		2026-07-17 08:43:46.533558+05:30
702	108	FRI	08:45:00	09:30:00		2026-07-17 08:43:46.533558+05:30
703	133	FRI	09:30:00	10:20:00		2026-07-17 08:43:46.533558+05:30
704	107	FRI	10:35:00	11:25:00		2026-07-17 08:43:46.533558+05:30
705	107	FRI	11:25:00	12:15:00		2026-07-17 08:43:46.533558+05:30
706	108	FRI	13:00:00	13:50:00		2026-07-17 08:43:46.533558+05:30
707	107	FRI	13:50:00	14:40:00		2026-07-17 08:43:46.533558+05:30
713	139	MON	08:45:00	09:30:00		2026-07-22 13:47:25.821442+05:30
714	140	MON	09:30:00	10:20:00		2026-07-22 13:47:25.821442+05:30
715	141	MON	10:35:00	11:25:00		2026-07-22 13:47:25.821442+05:30
716	142	MON	11:25:00	12:15:00		2026-07-22 13:47:25.821442+05:30
717	143	MON	13:00:00	13:50:00		2026-07-22 13:47:25.821442+05:30
718	142	MON	13:50:00	14:40:00		2026-07-22 13:47:25.821442+05:30
719	141	MON	14:50:00	15:40:00		2026-07-22 13:47:25.821442+05:30
\.


--
-- Data for Name: unmapped_ledger_entries; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.unmapped_ledger_entries (id, ledger_name_raw, amount, payment_date, voucher_no, status, suggested_student_id, upload_batch, created_at, entry_type) FROM stdin;
331	Test.Student1 (Cen - TEST/2023-2027)	10000.00	\N	\N	PENDING	\N	2026-07-24T04:03:39.673932	2026-07-24 09:33:39.67275+05:30	opening_balance
332	Test.Student2 (Cen - TEST/2023-2027)	10000.00	\N	\N	PENDING	\N	2026-07-24T04:03:39.673932	2026-07-24 09:33:39.67275+05:30	opening_balance
333	Test.Student2 (Mng - TEST/2023-2027)	1000.00	2026-07-24	\N	PENDING	\N	2026-07-24T04:16:50.760065	2026-07-24 09:46:50.758872+05:30	payment
334	Test.Student1 (Cen - TEST/2023-2027)	10000.00	\N	\N	PENDING	\N	2026-07-24T04:19:31.225974	2026-07-24 09:49:31.224809+05:30	opening_balance
335	Test.Student2 (Cen - TEST/2023-2027)	17000.00	\N	\N	PENDING	\N	2026-07-24T04:19:31.225974	2026-07-24 09:49:31.224809+05:30	opening_balance
\.


--
-- Data for Name: upload_batches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.upload_batches (id, upload_batch, filename, upload_type, rows_processed, auto_matched, newly_auto_matched_count, unmapped_count, skipped_duplicate, uploaded_by, created_at) FROM stdin;
\.


--
-- Data for Name: user_page_views; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_page_views (id, user_id, page_path, last_viewed_at, created_at) FROM stdin;
1	1444	/student/late-entry	2026-07-14 14:11:02.04466+05:30	2026-07-14 14:09:14.561809+05:30
2	1345	/faculty/leave	2026-07-14 14:20:01.994234+05:30	2026-07-14 14:20:01.994234+05:30
3	1345	/faculty/gatepass	2026-07-14 14:20:09.709497+05:30	2026-07-14 14:20:09.709497+05:30
5	1482	/student/marks	2026-07-14 14:33:06.879767+05:30	2026-07-14 14:32:11.401276+05:30
9	1346	/faculty/leave	2026-07-14 14:34:54.239494+05:30	2026-07-14 14:34:54.239494+05:30
17	1483	/student/marks	2026-07-14 14:40:13.670455+05:30	2026-07-14 14:40:13.670455+05:30
10	1346	/faculty/class-advisor/leave	2026-07-14 14:41:37.809145+05:30	2026-07-14 14:35:05.516636+05:30
19	1473	/student/late-entry	2026-07-14 15:04:26.43993+05:30	2026-07-14 15:04:26.43993+05:30
4	1482	/student/late-entry	2026-07-14 15:06:04.031948+05:30	2026-07-14 14:31:32.600099+05:30
16	1483	/student/late-entry	2026-07-14 15:08:16.205221+05:30	2026-07-14 14:39:53.091683+05:30
24	1338	/hod/faculty-gatepass	2026-07-14 16:12:49.088112+05:30	2026-07-14 15:45:03.227107+05:30
12	1338	/hod/leave	2026-07-14 16:12:56.345864+05:30	2026-07-14 14:38:19.612067+05:30
11	1339	/faculty/mentorship	2026-07-14 15:24:05.068462+05:30	2026-07-14 14:37:25.331366+05:30
13	1338	/hod/discipline	2026-07-14 15:30:10.203906+05:30	2026-07-14 14:38:25.400018+05:30
14	1338	/hod/latetracker	2026-07-14 15:30:11.52865+05:30	2026-07-14 14:38:26.43123+05:30
15	1338	/hod/gatepass	2026-07-14 15:30:12.906207+05:30	2026-07-14 14:38:27.530809+05:30
22	1472	/student/announcements	2026-07-14 15:31:50.459096+05:30	2026-07-14 15:31:50.459096+05:30
18	1472	/student/late-entry	2026-07-14 15:34:17.844749+05:30	2026-07-14 15:02:28.772901+05:30
8	1346	/faculty/mentorship	2026-07-14 15:35:17.668288+05:30	2026-07-14 14:34:45.156545+05:30
7	1346	/faculty/gatepass	2026-07-14 15:35:21.570058+05:30	2026-07-14 14:34:41.935559+05:30
6	1346	/faculty/late-entry	2026-07-14 15:35:24.53062+05:30	2026-07-14 14:34:35.221559+05:30
23	1339	/faculty/leave	2026-07-14 15:42:48.595376+05:30	2026-07-14 15:42:48.595376+05:30
20	1339	/faculty/gatepass	2026-07-14 15:44:00.386043+05:30	2026-07-14 15:24:11.757784+05:30
21	1339	/faculty/late-entry	2026-07-14 15:44:03.029606+05:30	2026-07-14 15:24:13.066575+05:30
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, hashed_password, role, is_active, created_at, updated_at) FROM stdin;
1348	aarthi23td0651@svcet.ac.in	$2b$12$QETmNxggseN2jTR0QKlUaOg1JgY0PQHTzuocUQlgpyum2wUVVy8dC	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
3	faculty@svcet.edu	$2b$12$qeYBYZiI3mBvT3zvgivJDOCSb0wukPilspARuFuc.AXGPTHR2BeIK	FACULTY	t	2026-06-26 18:18:23.030257+05:30	\N
1349	abarna23td0652@svcet.ac.in	$2b$12$DDlQQ96f6g3shNMdSdsat.K0Z9wblQggrD2VjmAtO3Sp6KsaxNTBG	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
5	authority@svcet.edu	$2b$12$4HBGVrlSe5reDhvUzgt78.dDkfTNOkKUjV2pYTpzeKqQ4aG.UKeW6	AUTHORITY	t	2026-06-26 18:18:23.030257+05:30	\N
1350	abinaya23td0654@svcet.ac.in	$2b$12$hfXNCyfjg4yeczhzj9i2Lu/EnqDaKMouFiW4NvCHYjvLWekM1aJXS	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1351	anbarasi23td0655@svcet.ac.in	$2b$12$GzohdEJF/6ulbdBHp2CMoekisNDCoIisxTQ3vuTPB9Qb.3m1qWqO2	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1352	angelinjelis23td0656@svcet.ac.in	$2b$12$I.Wl2hFMMGiIHzKDGNAOAeLStA.ujbs/mjKImj.EoHqq6k20a7DVi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1353	anisha23td0657@svcet.ac.in	$2b$12$.Cbe3CfFD519sn2dWCKZ5u9qzwweoBcQQ0eaK7TwBEN3BujM6xwH2	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1354	arishkumar23td0658@svcet.ac.in	$2b$12$jCkev1wzM0twc4An2xY6jOO50r/I9TIrZqxycfkYnthItotnZpb3O	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1355	ashwin23td0659@svcet.ac.in	$2b$12$aclF9e94pSVJPeNYTG0RU.u9PVkQSPiHg2Qhum6fFJasIXP3BJhCW	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1356	aswin23td0660@svcet.ac.in	$2b$12$edFa1IS57eBCeBuhF3EQ/.YXcyQEaBN9MStd/RwoDocFSFIddGVgO	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1357	atchaya23td0661@svcet.ac.in	$2b$12$reTl7XFKVG8Q1CM//Hu32OJVoH5qdn6R58nrkkSdmoBJShm0Jn72W	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1358	bhuvaneshwaran23td0662@svcet.ac.in	$2b$12$L68XvGn.rCoUCWbnsKOo4um4vrg9yLeMNbRvQV1k7PO6q8apQDxv.	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1359	danushkumar23td0663@svcet.ac.in	$2b$12$2SMTrvy39Aq4rUPDKXMdwO9wGMjajirwDHUlhk.YKBW6JPiWvG07e	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1360	deepalakshmi23td0664@svcet.ac.in	$2b$12$kJuLbXVELz0.DRV5Wih0.OpgPOQQd2GCEBoND1HnwuqcYfWs.APHG	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1361	deepika23td0665@svcet.ac.in	$2b$12$aqiZr6ItBxEwrP49n7CC4eclC8J4XZH54DHlZljTTffIUekFk4yXi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1362	devasri23td0666@svcet.ac.in	$2b$12$eIrCDKdfAnS/U4F5BtttZ.XGcqtzEyqckbq6BMHhK1oBCX5hXlLnO	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1363	dhanush23td0667@svcet.ac.in	$2b$12$U.sDdTxj6fooM7uplZRcCu8zBdsZdeI7tPHS8.BMHvl7LXPQ2naPq	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1364	dharshani23td0668@svcet.ac.in	$2b$12$hQhSp6SpzhM15sQ07CSF0uN/baii0uJ39M2f1v1y3kMXPeAar0Beu	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1365	dharshini23td0669@svcet.ac.in	$2b$12$bF/bRTojywhR04ZvriSiMupc5edsK2DT/5HTJmQ2caDbCNlRIKqvC	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1366	dulasikrishna23td0670@svcet.ac.in	$2b$12$7EDzLvdKXTsfJb52i1FoRO999hwyzURocms9ulHE6YNNRXhKLNQ5a	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1367	faizalmohamed23td0671@svcet.ac.in	$2b$12$CVhJXUlCqFx9dX9PHIbfne7D3Qhv/WsVoSj/mFBVGyTpU88VfLJ.O	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1368	ganesan23td0672@svcet.ac.in	$2b$12$SGauUF8xKtlJ8SOCXhSdZeK6adMVUaeut.Ft4BU5oqe5Rz0v/Hglu	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1369	ganesh23td0673@svcet.ac.in	$2b$12$bA7npW6uPEh0xGHkjz6g9OteIoYnEv3oi1PpVbLIPsPeZw8LBG0tG	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1370	gokul23td0674@svcet.ac.in	$2b$12$6krUEknqqNe2QwRBib/J2e3BZsaQNbMe/uMlkU0oyOWttl6iP9qLi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1371	hariharan23td0675@svcet.ac.in	$2b$12$skTeMFd4imhTosdjYoZ.9./QuY9hkPTghL7kQTVny6fa1iWXDIpcy	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1372	harikrishnan23td0676@svcet.ac.in	$2b$12$7IyIBt62ucfC5wAFifTWjeey5rQ9HRvvB0WVv36Yg1xngvRGupgtO	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1373	harini23td0677@svcet.ac.in	$2b$12$LwBt.wcyQULVfAWo2XcnDekVn27tD2Njr6oQd0jPIjxj1.lfotngy	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1374	harishkumar23td0678@svcet.ac.in	$2b$12$O1cMwFkOcI4gayHV6b1nNulQnrGsQ4MOla/6.9FomzrIbuPpnzVXS	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1375	harishraj23td0679@svcet.ac.in	$2b$12$8mROkIjrmR7vMUmqzSCSO.vviX8o1IJ/SGcL13KsiaKhuVBg79q7u	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1377	janithaa23td0681@svcet.ac.in	$2b$12$cRpWQEMJQ7vEekZPNvJ2YeAkKFIXEcuW8UoU96AxCXZ.CTdJg/FS.	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1378	jasrafarveen23td0682@svcet.ac.in	$2b$12$pVCk9G6XCrdU3VeBNPhobOryDlZn6AiziyWNTdFz56J3fV4.JNdFu	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1380	jeevaraajan23td0684@svcet.ac.in	$2b$12$c5t9uyFfeSl1pEKmXAU1S.YiGiGbIBQapD1SXTgma1QDNrMVy.msi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1381	jeevitha23td0685@svcet.ac.in	$2b$12$GGeLki8sOeje1R07tBl.c.m5Gg5dv6yupsV8UpXK5evMP6oDnEQTa	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1383	kamaraj23td0687@svcet.ac.in	$2b$12$ymEBWdhA9B8V/gC8golT..wvf51XkQPa58zcQ89vrOC0zP74dhoV2	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1384	karthikeyan23td0688@svcet.ac.in	$2b$12$MM05QC45/.vIGgkiyXG6b.rSAKxGvHWQy392cXZRBu0W4irc4R//S	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1386	kirubakaran23td0690@svcet.ac.in	$2b$12$Am4b/CvZgZ8laoR63e6gj.9W84h9lTs7Kd.izZMZeqAz.WappEkEi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1387	krishna23td0691@svcet.ac.in	$2b$12$JQA5zcooXie441TQL7vcS.5.pclT3vPs69ZsMxh7Dy4wj1uk4fSLG	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1388	madhan23td0692@svcet.ac.in	$2b$12$hVnPaKA0ChE6cykh21ots.PZXqrdZUHgVq5cbxgckV4.p0gLoIb7q	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1389	madhanarun12052004@gmail.com	$2b$12$Oo7KyMH6SbOKaL41PJfAEObZeSu9TfSrE3.7RL8Ue.Qtu0LqZQOcu	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1390	mahalakshmi23td0693@svcet.ac.in	$2b$12$NJLm3eDLCDm.5xk8Jg3z..yylYnrO5KB7tm9rSisLQI9e7ZQ9qj4S	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1391	mahesh23td0694@svcet.ac.in	$2b$12$Q57IkLJ/a41yuas943O7wuo/d.t4YjWgPgsQywZT9mDGsjseUUY/i	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1392	manoj23td0695@svcet.ac.in	$2b$12$0sckIqsk6sTnNLXTmRCCCOleBXaPP2eUExLeoJgrjOu40TG.Pqe1G	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1393	mohamedasif23td0696@svcet.ac.in	$2b$12$9fOX8kRZZdetZ2thogQie.f3bIwClU26E36UvjdAACVEdJBWL2Mzq	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1395	mohammedaaqil23td0699@svcet.ac.in	$2b$12$jhRuygfnCuYjQ4dAvFQ.H.fzjtXX30MpkCdS5a36EuBOOysjkYkR.	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1396	mucktharahamed23td0700@svcet.ac.in	$2b$12$Z7BBsCVhJG/ABpUBNdYFVugqrjz5QbUIoHLnGsnIo4yTjrqQOggYG	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1397	namachivayam23td0701@svcet.ac.in	$2b$12$OYF1Xy3Qs0jKtboUhASlF.XGgwGkanTumNWMETwi1.zqisFoVx.Fi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1398	nandhakumar23td0702@svcet.ac.in	$2b$12$uUF/bVJByGrorXUNLnF.8.q6.nY/RiUYGYKDEOGnGG6Q7ZIWVsJmu	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1399	nikileshyogan23td0703@svcet.ac.in	$2b$12$3k08B0zkNUAcFyy2a8Au6eTmZLN38HxRedrkCG2vXEZ3JTNHNgGxa	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1400	padhrinath23td0704@svcet.ac.in	$2b$12$34o2ENKS.LD83inznGjWiO.8RJcJBCdIYf8affjghun19us3TSJum	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1382	kalaivanan23td0686@svcet.ac.in	$2b$12$NsOSsDpqVQzUaPlP7/3JAu878pB5.Baq4zIODWyz4tx7p3uDHU0AK	STUDENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-15 13:20:07.423622+05:30
10	dean@svcet.ac.in	$2b$12$3LKECagVg3JnSv.Ji4Y1CufJAp6UH4R5LS5ZHgm9Om2XG3snb1LcO	AUTHORITY	t	2026-06-27 08:30:15.732067+05:30	2026-07-08 11:39:46.825754+05:30
1	admin@svcet.edu	$2b$12$wc4JxzG3CPd1Vl.Uzbz.YeIg9zvQjtEKGwRun2FXEQa3Q9pJaeLB.	ADMIN	t	2026-06-26 18:18:23.030257+05:30	2026-07-22 13:53:55.887936+05:30
1394	mohamedthasleem23td0698@svcet.ac.in	$2b$12$/V08aQJN42EypnsJy5AGeOtauUbI/7VclV21V7tl2UN9iIK/MuZ3u	STUDENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-22 12:58:01.20395+05:30
1401	parthasarathi23td0705@svcet.ac.in	$2b$12$R5NUqMXgTvpfMWn3CYP/he8/wsuleIUNAnO1yJofp7HdriT1dzdYG	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1402	pavithra23td0706@svcet.ac.in	$2b$12$E.4NsgZcgzuVFjJFdzuN.e2BYXleIAUU9APzLPo9P/8weZK/OxpyO	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1403	prakashraj23td0707@svcet.ac.in	$2b$12$9vlS4KDKr3bagDvuAxNu5eHOo.iyekZ44G.MoBAjW5G9P9KfBINnm	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1404	pushparaj23td0708@svcet.ac.in	$2b$12$RazW/8RIIoUXwts9QHYu..Q22.foZYuJciwlMcV3cipwdionD6Nzi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1405	ragul23td0709@svcet.ac.in	$2b$12$n/OwdHHpLj4JPFKnfcFWRu42MjBLSZ.k8TGiOogSnfTlVrlYQAHvW	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1406	rama23td0710@svcet.ac.in	$2b$12$En74Z9V7eKGvrnk1NchQYeixwepAEJ4rHwFZ5TycY4zokHYZVrO3O	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1407	ranjith23td0712@svcet.ac.in	$2b$12$WQPhM7pA6C2AghBRMGYCTu93xb1LvDUPTEeWtLITB6QtKDxnhKcY2	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1408	renuga23td0713@svcet.ac.in	$2b$12$jsf724y32TeEJGkS761YfOK0gDMIzsQzBkk7Z/Ve53dT5wJE.rA02	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1409	roshekaa23td0714@svcet.ac.in	$2b$12$hipBwlXfx7jDn2fJ1SbU7uz0EbAKIZ63btgia2eWbo.7YUzNZGsru	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1410	sabreen23td0715@svcet.ac.in	$2b$12$Kv.AO1KliQGLPXq2gwNKyeE.nwbwyNX2MIJrBvPm7O6LiEMpxf6e6	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1411	saniyasri23td0716@svcet.ac.in	$2b$12$yX/Le8yZaKSxynYiNgiq7eiSUxnSgFEmBNiST74.S1Fe4/WmbcGR.	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1412	sathish23td0717@svcet.ac.in	$2b$12$syK45vGv3QaiQzM4.GhhCuiwRuSvszoqBNcz9xj6YGfwLiZ/eBa3u	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1414	sathya23td0719@svcet.ac.in	$2b$12$36bgdpF7EaFAlwhsbPAjju6Sb44bqtH4MEGfIJ375EpjztgKPfClm	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1415	senthamizh23td0720@svcet.ac.in	$2b$12$yqoMWEhDrB0VORcCEZEGmu1oi.wSHobmC9AGg3qcRhjMiYoVMi2Gi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1416	shalini23td0721@svcet.ac.in	$2b$12$CTGQYSTvRSQ8dIuTSWZPiOWFXs6ZhlKk3wNyFMD5tWNBnFDbTeNfi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1417	sharanshanth23td0722@svcet.ac.in	$2b$12$VmlUUkjsX.Bco49XT6o4gOxf2CD07XXKdx7A7tlHCcxCZs5Jlv6F.	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1418	sivaranjani23td0723@svcet.ac.in	$2b$12$1hfvmpwST4ur46sBIEpBueMU.oI5V384jytnXt7pAaC398gsbqAOW	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1419	sivasankar23td0724@svcet.ac.in	$2b$12$vx.WQKfdm6qyDvL2xy7aSu5JNLWg11RuGMhWpNXWLOb7ykn.Z9jUS	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1421	sriram23td0726@svcet.ac.in	$2b$12$.zo7V7Jn4laE9VbnJj1LKOc4K3VTO6DEYLGmAV8TqZov/Qnbmal2W	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1422	srivardhini23td0727@svcet.ac.in	$2b$12$a2N8zLLWSRRbsO8ovAnuYOhYXdqzyizLrhD0m/BIdyMCoToZMZrFG	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1423	swetha23td0728@svcet.ac.in	$2b$12$jfey..KRjihMAjgY.HiaxeEd0yLuDn5gM7D.lg3O883z98DoT2orC	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1424	thulasimani23td0729@svcet.ac.in	$2b$12$SeWaMmAemDRl9fgTaUR7xOz/uJ7ZnO9hRj5mU1bL6e3PKZPvteBEi	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1425	vigneshwaran23td0730@svcet.ac.in	$2b$12$21hTUFLpefKfmrso/P59HuK5R651/4YwQdQ6ARMvjB8FPOo2cUiKa	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1426	vijayavel23td0731@svcet.ac.in	$2b$12$egwyq1.0LtujBBKUdsCdh.gLbtGheoTGxquP2ZF4WHSMKAYI/Bp1u	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1427	vishwa23td0732@svcet.ac.in	$2b$12$/PGJaxArEPeDB/NNxZh4ZuH3nL/GyXaH1NvpxdB2UogHN7w5GZ4YG	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1428	vithyasakar23td0733@svcet.ac.in	$2b$12$w5UcqcEwAFfoYQIUCretvO9YLFdAhNeSFNtvP4CVdy8YX6c1qlHOm	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1429	yogesh23td0734@svcet.ac.in	$2b$12$MlKcSJrsoNKj5t4TtHkCuOLbGLr4PDbkI2PcAbihp6eosJNTs2Jjy	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1430	yuvasree23td0735@svcet.ac.in	$2b$12$FSRJ79LdO512eyVBXUOR8OiMY8MVqZKLHMVIHteh9S24qgjS5OG4e	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1431	yuvasree23td0736@svcet.ac.in	$2b$12$pDBvYJxUWKDM91DbHBNWiOQzXMWePcSnR8hhulsFh4/MHwSBohr3O	STUDENT	t	2026-07-14 11:41:58.371248+05:30	\N
1379	jayasrinivasan23td0683@svcet.ac.in	$2b$12$FO7I6HCIUSO0RUl3M4HCTuac9UFwlDmhFQAQGKkG7vNTMNLGp2VX.	STUDENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-15 12:12:00.31249+05:30
1413	sathish23td0718@svcet.ac.in	$2b$12$BYahN5SmQfdMGc7rJs3v8u1iiZvLM4L8hTJHoqtDJTN7ojKJBPa5m	STUDENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-16 11:22:49.845007+05:30
1317	sujathaupt@svcet.ac.in	$2b$12$CdUOW3ZuciO13/q3U9OvJOr0FsbComfx3FpKor5fcjRePKpX1ugT2	FACULTY	t	2026-07-08 10:45:29.942778+05:30	\N
1376	hemachandran23td0680@svcet.ac.in	$2b$12$Y2HeR.JrlLGgS8vL.R1ej.4l.G40TUjR2zTeK/i6fEGSP62CHa7RS	STUDENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-18 13:54:47.762424+05:30
1319	mayavadyece@svcet.ac.in	$2b$12$JTVgeaPWP7NpenItrFCcueJynE10ukycz.LuwiD7YvNO7QOrcu1M2	FACULTY	t	2026-07-08 10:47:11.677914+05:30	\N
1320	kishor25@svcet.ac.in	$2b$12$bldI8HGgq5c4QRpvt23l6O.qOpF0XXKf7Bw5CegZK2InBrBCgYnOq	FACULTY	t	2026-07-08 10:47:50.46653+05:30	\N
1322	neeraja@svcet.ac.in	$2b$12$ol3o0xf1WfbyB3gqEbIZWusdlywbhkYIzHYZ37DLI7cbqFo/pWLhS	FACULTY	t	2026-07-08 10:51:47.055905+05:30	\N
1324	dhanalakshmi@svcet.ac.in	$2b$12$XfcgsOu8cibbumrPQkREeOnG1EMnY06cYTofM0tAqjQEwhaIxHD1u	FACULTY	t	2026-07-08 10:53:38.629935+05:30	\N
1529	mohamedibrahim23td0697@svcet.ac.in	$2b$12$zXCX8BK6s84kqShqSakote0REqgfjP8Z94zyw8s.CfLMkm0.HthZ.	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1314	r.bharathan@svcet.ac.in	$2b$12$jrhTvZdzuj1T.5aHQFmRz.lizOoYBRWFTzWKkJIHNQ1QuvMOFQ4m.	FACULTY	t	2026-07-08 10:38:30.669+05:30	2026-07-08 10:58:17.817264+05:30
1315	hod.ece@svcet.ac.in	$2b$12$nmKmXkYI.t.A6oRBZjDxletFmyh1Pb32o4pF6T5J.pVOnS5XIvRsO	HOD	t	2026-07-08 10:43:34.691849+05:30	2026-07-08 11:02:58.879396+05:30
1530	abdulhafil24td0751@svcet.ac.in	$2b$12$gU5iL9Uaco6jz4xFQRY0kelfP4PitI7x862AnQY95XYxBRUvfcoMC	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1531	abinaya24td0752@svcet.ac.in	$2b$12$7XgOPl1bAuy4xikiG3/QN.999fGHWmS281fpTqGiJ9ydv1dBRXyDS	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1532	afrine24td0753@svcet.ac.in	$2b$12$o9J5Te5VHqlA7qdd5uMJB.oMFFAGTNvxKbVXKeXivRr2a.pxb1ABm	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1533	ajai24td0754@svcet.ac.in	$2b$12$FwTlxn/yuuCiyMWU8p77QOmN4G4PgdJKvxNgHh1HCuMiLl7OoOg.e	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1534	akshaya24td0755@svcet.ac.in	$2b$12$aGxWVpfEMMTpupWIYkhu5uFv4WWT7.Tnel2Sq32YpyA0w.wRxLIWe	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1535	athiseshan24td0757@svcet.ac.in	$2b$12$3RHJnMV.HGoDDyR0NWNRH.JPiUs/ybnyCSO0/pOiUEClqOU/5uZ4i	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1536	bhavadharshni24td0758@svcet.ac.in	$2b$12$hXr1HI327Wwq3fTwdiqhVeSgbHIgD.AJVWO3Eq7/gF/nCW5G20HDC	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1537	buvanesh24td0759@svcet.ac.in	$2b$12$l3.B7PBY7BI1qm/bwnvEG.5HH20hWzvEW11FBUqgh5uxWzgNP/1l2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1538	catherine24td0760@svcet.ac.in	$2b$12$wzyeeaTNZu865/GvGHYnpuz6eHrxjDP2WxTMr5XZfUDGmoKtZUAKS	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1539	chandhru24td0761@svcet.ac.in	$2b$12$DjBXqVyjzwx7ivqKTbggUuskKYAcAJwmQThHHwh.2UFvoHTrpq/Ui	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1540	charu24td0762@svcet.ac.in	$2b$12$PighA34.PUp8h4KEhnNS6evRPJq1bCYoufZsHmNDXI99CHwmKuiMK	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1541	deepika24td0763@svcet.ac.in	$2b$12$8Nw9U3ls.cuJFM8uVC4Zku5s6PsQSlbgyqsJzKI5WKM2fzg6o/z9G	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1542	dhanasri24td0764@svcet.ac.in	$2b$12$obuj0Ehfcs5A7MGj/O8IVutIez8vgtfQstZCv2DpAG0xvKRyfd6.m	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1543	dharanipriya24td0765@svcet.ac.in	$2b$12$utI6acSpZfOYsI/pS9eipOB1BsUl9ZU3Si3jkoKpnFvXddop7M0qa	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1544	dharshini24td0766@svcet.ac.in	$2b$12$ki9HBZ5dJqwXUzj4ET8dr.Ox.Xp1rjwTvhsOY3NIry4pNmAfd5Qsu	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1545	dhinagar24td0767@svcet.ac.in	$2b$12$8Ln3/XipVmZcmC3FAHb4AePTTE2Ij32xLfCgaLZYF3lFG5DCSO1Vy	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1433	andalcse@svcet.ac.in	$2b$12$WVc/eq4l4yyDzkoLVExgp.Ts73kZv4vJhnhukgpsOf1TNyKUMo8zy	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1434	dmurugan27@svcet.ac.in	$2b$12$UmFU7vTMaB8Xd4.aw2m2WOtIHpX3oR/x2doPhMiuGjRGw0IcEd8l6	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1216	aswin@gmail.com	$2b$12$NRpr28z8HYQ1S1RVRSKmq.1RAB/7MLCro43XphTfjOoOmvQIGSl7O	FACULTY	t	2026-07-07 09:24:14.367145+05:30	\N
1435	cseloganathan@svcet.ac.in	$2b$12$SYHANaCw/k8Vmqs6ChuXhObEtWAaoCAHOVOTCWnrUs/aZPLnDhLMq	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1436	dhanasegaran21td0605@svcet.ac.in	$2b$12$8iXh5hxMw6rwpzyYJYt3Nu3Sx4e4PpD552zTgC.2ZYC4G42O/DLkG	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1325	hod@svcet.edu	$2b$12$w/Kzy4L87nRhhalG.0IP1OInx4psI5JmrBOKBky.DyD3DOARTuI76	HOD	t	2026-07-08 15:33:53.509848+05:30	\N
1326	student@svcet.edu	$2b$12$ceLaVNzjyFqM00C2MoK3wOmhaXCmRaULAMWlrfz23SCN9dnrS1jOq	STUDENT	t	2026-07-08 15:33:53.509848+05:30	\N
1327	hr@svcet.ac.in	$2b$12$SHIPFUQlojESKQtsQNLLYefK8HALC7ib8ln1auP0XsGE9Omp44B8m	AUTHORITY	t	2026-07-10 15:07:58.535836+05:30	\N
1437	sivasankari@svcet.ac.in	$2b$12$5WBVd.Q6T4/ss3PXPbVndOhAB21zHNd0YOEgFuvr5UoFTeIxfvvdG	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1438	cseanbus@svcet.ac.in	$2b$12$17gPlHuh4Rc3Ccfa4VkG8Oj5/k0ndNcyraskLp3t3cUxQlEXcWdjC	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1439	pavithraapcse@svcet.ac.in	$2b$12$zQewvpF0lPtR26E1eEDji.ga4zbPNakMX.j8V7Jhn9Yw/HayMSwmW	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1440	saranya28@svcet.ac.in	$2b$12$QFM8Q1Pz.KWncYPeZR/VQuJRAFvPq0h6v75MQwSaNr2wItCZL..KC	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1441	sathiya@svcet.ac.in	$2b$12$MXtahAyQMsQaTzveHaAAQOQol1G.zvEwou0KbVGGkEaOCi3qYrXM6	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1442	csepriya19@svcet.ac.in	$2b$12$JUIzcTKFJXly5cPfhVIHlO8sbUL2bPTjffB4djg6RNq05I.ZVJ0U2	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1443	vinayagam@svcet.ac.in	$2b$12$bikGBwG2Qypn.pnUTpGCBey9.am4VTo1RkkLM87wIsFpaWixpdrAm	FACULTY	t	2026-07-14 11:48:02.645612+05:30	\N
1432	hod.cse@svcet.ac.in	$2b$12$hZuyrArLgccjjO3pAbfTiuZUtSmtEKDMIWrxGsSym8fTAbG9NprZW	HOD	t	2026-07-14 11:48:02.645612+05:30	2026-07-14 11:48:27.050427+05:30
1527	ashwinoff2@gmail.com	$2b$12$h8bC0wJX4rtg14EeDky5QeJJX2BWOK6ahBxPVQKrfq0v4A.NtN9Ga	STUDENT	t	2026-07-18 12:20:18.516713+05:30	\N
1546	dhivyadharshini24td0768@svcet.ac.in	$2b$12$Ad9nDutxqwsdjtWmFZYDQuZeO5uTuOwtNqNLUnn6O.g2veMziYSqG	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1547	dhivyadharshini24td0769@svcet.ac.in	$2b$12$1uZYtnxeet9UQlGwzHIulOf42SNV/VHOOUJdoZAhvRlNd3NzxE7GW	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1548	dineshkumar24td0770@svcet.ac.in	$2b$12$UriiiRTmSmf9tnEe14yLP.Vjyw89DBQxdXger1qTSfDlhBn8RwvDW	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1549	divyadharshini24td0771@svcet.ac.in	$2b$12$TG3jeGC3pg3/RJy.7w3dkOEW1yTjTo/wVBWvwTz8Coi/lohPz9CLi	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1550	divyesh24td0772@svcet.ac.in	$2b$12$lkmvfnnsglrk3onoNDP9q.lwA4w/7bRzawMz8IIdKLtrOr8sO2sXW	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1551	eniyavarshan24td0773@svcet.ac.in	$2b$12$54CDQeyF4digiEhEqKUV4u4iUDbOue4S14CetWQ.DpRX9kJZGnG3i	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1552	felcina24td0774@svcet.ac.in	$2b$12$6J5CfWZyejf5KiFSr3ARAe72/0TkclCpN.WYSlYInik8iCP/zzd6O	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1553	ganesh24td0775@svcet.ac.in	$2b$12$BcgNqF0KSny6L9X0JDcPa.dCA9lvzpoIHmBT8o9hMbpKcr6fm1rjm	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1554	gopinath24td0776@svcet.ac.in	$2b$12$BCzhLei4MQxoyBPQfAoECur6R1eR2QE28qh9Q1MiA7yldneRJ51JW	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1555	gokulakrishnan24td0777@svcet.ac.in	$2b$12$s1/EXOI6BKXh29z0WRBc1ugJnIGqy3autO9klyW1jslwA0kbx9mJW	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1556	gopinath24td0779@svcet.ac.in	$2b$12$8a1CZgP4PvnmiDNSSxRMEunuTg0Frp8smq641l1svn3KTFBh3CHEm	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1557	gopika24td0778@svcet.ac.in	$2b$12$d6zoH.4K1hxlVPpkVswBButYS6MI2mN8UtL753svgpvfgGanblSEa	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1558	gowtham24td0780@svcet.ac.in	$2b$12$QCccCEEjsMt7I150WNEUb.Hj9edAiF7CT/gh.gAvCt8VZPA.R1V2y	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1560	harini24td0782@svcet.ac.in	$2b$12$Kgds/EFgCCE3Ksb41.jBN.Q7kdk69tSUl5N.fRyMohOpPUgwGNQ7G	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1561	hariprasath24td0783@svcet.ac.in	$2b$12$ZPArZ9PyvW3iTwL03WUCPOMr95erlPVENYJ1YydhZCRFDBJ09ElpC	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1562	harish24td0784@svcet.ac.in	$2b$12$zfSF9nRn/FUTRldFVgdQouO1pnmxgfpl/ic276lXOl/QEG9p/3cj.	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1563	harishkumar24td0785@svcet.ac.in	$2b$12$lHpP0MSkT2iFHIb9NLcBV.M3VNon.hOPIrVDtmHRM9R1Rd9FuOpG2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1564	hemavathy24td0786@svcet.ac.in	$2b$12$7gvikDXLtNnJgYIXMGE4NO2zCYo/RGYmRhWEOp0EwmsvARa9pvIGu	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1565	iniyan24td0787@svcet.ac.in	$2b$12$NHjjnYtswzCUfEUcPaQ0lOasitBHBFi4tqfIJHaJw7K3cAVn.yXTK	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1566	jayanthkarpageswar24td0789@svcet.ac.in	$2b$12$zg5YH3eFQrgaJFYgZAZms.Pg9CuDhD9MyaaQbPmPYp4kA4xS9fUYO	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1567	jhoncy24td0790@svcet.ac.in	$2b$12$bS11Xqd0/4kVV3JAyAQDM./XUUMSdi1o2c4M50wqLTtTGD32ld0I6	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1568	kabilan24td0791@svcet.ac.in	$2b$12$4xirzlOkrlYR5XoEZ2SMFur6L99vsWKiZbNQZDtqCLxxkPvogWAJS	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1569	kamali24td0792@svcet.ac.in	$2b$12$EXefIuZAjUblqHrjMmsv7eNZUZPhEfIl61rX.Ko.pD1Z3HV6j0Jue	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1570	karthivasan24td0793@svcet.ac.in	$2b$12$AbHKesIqtOTxwEWUw.Vkt.6cU7fLJKBHOtr7FhKqBmeqxSA.fQJ.e	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1571	kiruthika24td0794@svcet.ac.in	$2b$12$0PdOd12KuvAQXSi9lhDnnOZA.isETHLvVkG8LmqvaseKqYygYYXWe	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1572	kishore24td0795@svcet.ac.in	$2b$12$2jF2YR/S7jq/mnQgEsXazuqgH.OLSq6GmFnRi7ho.VxKexvJ7J1US	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1573	lavanya24td0796@svcet.ac.in	$2b$12$EYKSoQF0iCgcwH.JV0Lx1Ozmt2gAjNTxQ6o.PF8.McFfpS8Zvj7kq	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1574	maliksha24td0797@svcet.ac.in	$2b$12$aKKFvfDXvzp9ljyfsYEEV.OG8aTDm1/idC08.4LzUHkdwkz.JjZjq	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1575	mangalakshmy24td0798@svcet.ac.in	$2b$12$RaeyZMFQwVaKAo10g6V9R.RJrd5sZ8hWoCpwn4QL1IxWrrF6WIlpi	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1576	mathivanan24td0799@svcet.ac.in	$2b$12$7oMRFoTWw13kk.nYI/WEa.WEJidLINXyjElFoX4rs21XtGQGG2szq	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1577	meena24td0800@svcet.ac.in	$2b$12$Hm9Ot2qjF5r9yRVmhwdZqu8ALAoagoSdh64uOY5W0n9y7KYafmzNS	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1578	mohamedithris24td0801@svcet.ac.in	$2b$12$KWZhTgHI3XH4rlvdz.KryuGHRrOx9jOIIHfF6bSiajTpIh234JpgO	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1579	monish24td0802@svcet.ac.in	$2b$12$VnnEZ5AuseUkE/l17RWa/.k6IVrvzFZqnOiLJaKVntcZ7nUqRpPbK	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1580	nakkul24td0803@svcet.ac.in	$2b$12$8CytKJQQjGGGgBkHcCx5qOjCHq4sLT51O5AyOVF7gQCpubDm3dDzS	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1581	narkisbanu24td0804@svcet.ac.in	$2b$12$B.GMEsZsbKuNSe5qMCU06.5g1hOU46hq.jkDT2KqBlyq1PiLG0B22	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1582	naveen24td0805@svcet.ac.in	$2b$12$eRQZS4irEsC7mfd3fZaw4O2iVOcCtun2XFPn6XWbtQiIQgGxm7Lf6	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1583	nesika24td0806@svcet.ac.in	$2b$12$Gk1ISumN.cEfP0h9ZLeDY.TFSiJRkajS/2qDsaKmt6zP.8HEQVTTS	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1584	nethra24td0807@svcet.ac.in	$2b$12$7bqvBAn5EFWucruDDNHtouC2XKKsrKdBuvotITGYna.uyY5Snl4E2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1585	nirmal24td0808@svcet.ac.in	$2b$12$n/Mj6.TloxGamm7uU8OljuUJq7GyXM3XT6ff5SIklAAokjMxbDIa6	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1586	nivedha24td0809@svcet.ac.in	$2b$12$fZT0zdbhuCggpydMI.tCLeDVC9D/0JLjnFPhqI8nXFrvJsVE/CFT.	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1307	om@svcet.ac.in	$2b$12$k0PM/hs/QSkYOzgfNI09Reo917qL/mwcc7Vh5kU.fW22DxAI.yoQ6	AUTHORITY	t	2026-07-08 09:52:22.956103+05:30	\N
1444	teststudent1@svcet.ac.in	$2b$12$uyinOvtztXRaVf1nnuRKJu7G9sW5AXnutSQePNLNSXldkH063DPC2	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1445	teststudent2@svcet.ac.in	$2b$12$ronQB1VMKAgSxtJD/5xMje5Ef0GmlmK.IHZdRTWfGCIDav8EGpFEa	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1446	teststudent3@svcet.ac.in	$2b$12$Nwt7VTv9Zgw30MkJWoKhV.ZhwOdUNTD8R7IDU4.TeMCOYTsUMcls2	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1308	viceprincipal@svcet.ac.in	$2b$12$h9D18hsjmqIBKcuUWGmQie/o/flnk.NOL45rg9fo6FiCUYSAfngZa	AUTHORITY	t	2026-07-08 09:52:22.956103+05:30	\N
1217	hema@gmail.com	$2b$12$jFs6jsW6S0U.nT9BBIOCLefHUMzhKnquPsxIqgADkqFR7vuCaFXpS	FACULTY	t	2026-07-07 09:25:30.108804+05:30	\N
1447	teststudent4@svcet.ac.in	$2b$12$YhhJIq0aX2ZV/Bk66SaJQucVWW.oqaq75tumlAk77wkm1BTNbq4pO	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1448	teststudent5@svcet.ac.in	$2b$12$uAf6GSDNyTNLaAfO0nIk5eoFhGDdlklsztR2JrzqWglNRvxXj3r0q	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1449	teststudent6@svcet.ac.in	$2b$12$B3mTGeASGLPVDHwkfYxvSO3RRXGUdZlR4HLow8s1vvpFaak64juYG	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1450	teststudent7@svcet.ac.in	$2b$12$0wCuy7V0NaTc5B8H4p8dT.czyMb066IN5uycAD.lfYpxlfmKDB2m6	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1451	teststudent8@svcet.ac.in	$2b$12$aPwLNu3.itNcy5EAVl91t.lcl0l0NmvLEp5f0.LTx2ZT5Vi69FbRi	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1452	teststudent9@svcet.ac.in	$2b$12$lPoNS9sE9rBvqAjZwAHg0.E/t05H5jZAZ3OHvQCKUQHTWt6pAXQ.u	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1453	teststudent10@svcet.ac.in	$2b$12$suciEyhlHwZyatYb7jebkeqNbq3sBBpHYUYX.p3zTIZhu7ndvBfza	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1454	teststudent11@svcet.ac.in	$2b$12$pJQ8MhsIUpIfNmzfjo2EyOLRxqOidUujjxpbc8fr6zFeoRZ2SRdBy	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1455	teststudent12@svcet.ac.in	$2b$12$KytTlcK/B/66bDXWQbR66eyx7D.kcOdZijo/I5ihqtFpZ5HqyEDRK	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1340	testfaculty3@college.edu	$2b$12$u/xw4cznWAJ9/IDIL7lN6emzTz2Q5fRRa9VG0EGG664MN0ZuFYEXq	FACULTY	t	2026-07-14 10:48:57.430295+05:30	\N
1341	testfaculty4@college.edu	$2b$12$KjBoBXkqCYJ/1QHtAp55a.kT5uo7YTMAEcYfut1wLZH/PV9TLLxCC	FACULTY	t	2026-07-14 10:48:57.430295+05:30	\N
1342	testfaculty5@college.edu	$2b$12$Xulx.HSYUFLue58YnhZBhu44Q3/z7tYfjvhGFfYhk3lkDSrMQWx76	FACULTY	t	2026-07-14 10:48:57.430295+05:30	\N
1343	testfaculty6@college.edu	$2b$12$fWjeABZ8sCLEn2EGJ5UV6eSIg8ERF3j10DAYRWLIBJc16NHCYEMB.	FACULTY	t	2026-07-14 10:48:57.430295+05:30	\N
1344	testfaculty7@college.edu	$2b$12$dygbllkjAbFJpVG5A44bSukc/dVjJjxW.qh7tsT3SWsasn4Y/k6Le	FACULTY	t	2026-07-14 10:48:57.430295+05:30	\N
1345	testfaculty8@college.edu	$2b$12$LGy31/wMV5ze3HkPOz3WuOUSwJDg0c.hHT/d1tDNbuYj4foMaLMBS	FACULTY	t	2026-07-14 10:48:57.430295+05:30	\N
1346	testfaculty9@college.edu	$2b$12$le8/NQhyCp83XF7X.n/.PuYHNlEepEmT.qp68E9KnxyUSnUKC59pW	FACULTY	t	2026-07-14 10:48:57.430295+05:30	\N
1347	testfaculty10@college.edu	$2b$12$GhE4MNcwaG/81L6mgUFhOuc.sGYi6QlavmNfFiI5A/BiMUlAtDVYm	FACULTY	t	2026-07-14 10:48:57.430295+05:30	\N
1456	teststudent13@svcet.ac.in	$2b$12$cnqbQ2sJjqAHLjLsYb3XpeLvDhFc3rk7ABp6Wazl3IOVbxshfn9SO	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1457	teststudent14@svcet.ac.in	$2b$12$uzd7JkmJu1jR.ffc3QlvHerunMKfasOsMFqzMusxQCiBfIFQw6Ism	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1339	testfaculty2@college.edu	$2b$12$/UUpiYdpvkbNUA8Js99nXO/mFkpBVdDIBb7YrXk1C8AuxU0FrXjDe	FACULTY	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:22.718261+05:30
1338	hod.test@college.edu	$2b$12$naInSCh3APun6ABDCFwKCedxTqD8gomddP7GV25RFQpGxheVdDC0W	HOD	t	2026-07-14 10:48:57.430295+05:30	2026-07-14 10:51:35.368513+05:30
1458	teststudent15@svcet.ac.in	$2b$12$e5ZANAkseIw1OG87Tu4E4uYwc/0a/u4KCBm5rhe1ZUzW3wOx/xiKy	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1459	teststudent16@svcet.ac.in	$2b$12$BkCxtbjYeooLjD4mMijWSOsiBRob/JQYg6JCD.gh3/8eHHerbT2Ku	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1460	teststudent17@svcet.ac.in	$2b$12$AEEXwGJoz/gvM80822/4t.Ehd7HO6Z5PKne6ohG.mIOdG8qaQf5cC	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1461	teststudent18@svcet.ac.in	$2b$12$gFQS0sSAZiJATB3IQZBpluxFGIjoY7XYBGyGnRI6278X.XT0wbI42	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1462	teststudent19@svcet.ac.in	$2b$12$gIVMDP.m4o.zmZn0TeOODuQj5aVIxiG0mL/A/W6uXdl0nVyRA.pgC	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1463	teststudent20@svcet.ac.in	$2b$12$hR0TtCxtpJtMZcBGVJomEOKQjTSnTCEdcvICXjW2NzPCLq5vd75HO	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1464	teststudent21@svcet.ac.in	$2b$12$AkFYkVEc2vz54xR.wyPYT.jIFwx5Xr09unAO4czetvy1P.5tmr152	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1465	teststudent22@svcet.ac.in	$2b$12$AxJEtv0bNbm5o02RlG0veeug4NrXkeKeCnVnKdDtj8o7hMbeqOF.W	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1466	teststudent23@svcet.ac.in	$2b$12$hu4LhBJ6OG/3vdmLcdVdzevYx8FVMP9kKZnVMMZU4dKKv3uu1Y2E6	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1467	teststudent24@svcet.ac.in	$2b$12$7KS4Qqci4pYNhqYIsIMJPO3VBhBe14sgda3G0Xdv3Bak/bm4StGri	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1468	teststudent25@svcet.ac.in	$2b$12$2HNf8xl.AG8RTCFtkfxX8u.ErCsHOe.fG8lq6i0ZVAh0Phf.kckea	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1469	teststudent26@svcet.ac.in	$2b$12$3/JO2UVI6.5cJAwJySNKQO8Q3oz2ybekbkH7S44Jg2qOs9XiNr2wu	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1470	teststudent27@svcet.ac.in	$2b$12$rT6sxzk2H89p2KZdHRAOrOsg.YJ.u/xPH3wuB9ToN8H5zsOL5NuDW	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1471	teststudent28@svcet.ac.in	$2b$12$AJjFYdn4Ty45WHu0jEFsre2TYtgmR930ThEy.5tZlp13WCtQcfQbS	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1472	teststudent29@svcet.ac.in	$2b$12$gGRmk7swV7Z8LaDIsINNqe2GNzZ.LTqTDut.Qhs1dkm4EgvNb0nhi	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1473	teststudent30@svcet.ac.in	$2b$12$QNIfOZR4Teo/EDSZAJyGBOZi4wsn.LP3VJnCrEak8Gwmn6qBPQz7W	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1474	teststudent31@svcet.ac.in	$2b$12$l7g4WdJwp2M0A0XuNZp8qe3WzBKlp4lMEHjstpv4SSKBGPI7RHMdm	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1475	teststudent32@svcet.ac.in	$2b$12$vCeYnROcnrMps5a3rTmR6e6GF3zca1Pal8WEPzREsPaM3g7BHBYNS	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1476	teststudent33@svcet.ac.in	$2b$12$4H/iaTquFES5l7Sp4B5LTeBuzlYEXUjom0jhh1sOQTO/R7n.lp6oy	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1477	teststudent34@svcet.ac.in	$2b$12$wfHGO5TfRkErUMEDjembZu0CmeM7LeqeAQR0UE2lnDEWpBUH.52Ru	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1478	teststudent35@svcet.ac.in	$2b$12$27qLiYejKU6O/3dNXx7Hb.UMBmL6sgNjP4QCts63uF/.FzgKv0u9.	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1479	teststudent36@svcet.ac.in	$2b$12$.aa6NoEcn4GSZWmdOoG6kuRs4Qyp8C23jWF5/ItwkpKQdsTUQPGXO	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1480	teststudent37@svcet.ac.in	$2b$12$AbiSaT6YXGagNuB6k.MEcO.52Vsm3OSncemuZDXnY1wLmu/jQt6tS	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1481	teststudent38@svcet.ac.in	$2b$12$mMEOhyS2RxR9wWjh/SXqjuleKtyQQlFSW0ih7tf8a5/RLOQZTt/76	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1482	teststudent39@svcet.ac.in	$2b$12$KdQ5cl5Q8ik0kCAhPXFcNu8IZNXUJsg6NEOteE6yxc.OHQNObtVyS	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1483	teststudent40@svcet.ac.in	$2b$12$wlaMmgQmbZBAMktlVaa8Su96WFENYcYZzCX/XKfpZDSq44Acnu/hC	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1484	teststudent41@svcet.ac.in	$2b$12$Kjknr0oC5qkYiKCojQWTae8C1AwRZDvICu6QAYrhzpBU0YzZc4f9q	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1485	teststudent42@svcet.ac.in	$2b$12$u4cdWWWlRmKolRlDERIhyOzedkB6NDoDzOUanqjw3RAZygacKB2uK	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1486	teststudent43@svcet.ac.in	$2b$12$6giS9cUIwcTBgs4If0edYeS3U3stDpbI.jPnY7D3A4djD5QvwUcJG	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1487	teststudent44@svcet.ac.in	$2b$12$50C8piK0gIRit8Bgp4Phwu/Q0kqdyPCU/NxQ.UFaa4FYJ8PjPFhEu	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1488	teststudent45@svcet.ac.in	$2b$12$5.OggDHKb8FYrVn3QPyji.DbsX1cV8BoQJ74sB/O1RQgEY2AY1NAG	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1489	teststudent46@svcet.ac.in	$2b$12$p63fDqK6U7RP4N5OkkVAOe/hnET8ym9lsaFnryxMjnlLuwIa8z5TK	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1490	teststudent47@svcet.ac.in	$2b$12$ytkgghwmksHxUXp0WkdL3uwM2Sg.iRQr0DGsrlcbkngVOxU49DcUG	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1491	teststudent48@svcet.ac.in	$2b$12$3ZANvWbmTKANVJwrWT/cluIL/5ySt3OXNAgj3HmPub53qtLx.aZeK	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1492	teststudent49@svcet.ac.in	$2b$12$jTmI1x88oOE/OztClCErWOzx3zVMSs4yXeptW6juc41iNctR0wfXm	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1309	hod.eee@svcet.ac.in	$2b$12$smsopxiJzVUnhc9C7dnIAeH5nRasQdLAuYFFeAq8n6IaO681cyibC	HOD	t	2026-07-08 10:21:20.600723+05:30	\N
1310	sandoulouiskishor@svcet.ac.in	$2b$12$M1yhVwgk1vJngFpsCIV.fOUV0z7uBSE6dutb0ny5MohAAGTMorCt2	FACULTY	t	2026-07-08 10:28:09.414641+05:30	\N
1311	murali.eee@svcet.ac.in	$2b$12$j8Hq666UP95A7ivxVmpDMenT1.4UR.CA2nd6oZuncxrEi9VnI/wD2	FACULTY	t	2026-07-08 10:30:45.726466+05:30	2026-07-08 10:31:59.114129+05:30
1312	seelva.ar@svcet.ac.in	$2b$12$pE.5aeL941WgBV7E.6nzIOl7txUxsTnsx.XWZ.Uead52hYiHQRBBy	FACULTY	t	2026-07-08 10:35:40.890376+05:30	\N
1313	punitha@svcet.ac.in	$2b$12$ocoUy7oyHUQbOW246xSAyOcgbXCWqdsqfEo9xMkz1uR1yoX023iqm	FACULTY	t	2026-07-08 10:37:20.302448+05:30	\N
1316	amudhavalli@svcet.ac.in	$2b$12$pbQFXjFL.d4bwtiSTZhOnu2iSkCFVvl4TaTpV87y6l.DijMmt6cHy	FACULTY	t	2026-07-08 10:44:31.369362+05:30	\N
1318	devanathanece@svcet.ac.in	$2b$12$4Sd1GJDMgp0yBHFlQ882xeQYEQ2YMHdYvhANOHQCh0/FcoVZ.8NQK	FACULTY	t	2026-07-08 10:46:23.539091+05:30	\N
1321	sekarrajan@svcet.ac.in	$2b$12$NJbE3OPUkNZsy5W2VMp3IuSZAXwkrmVlsach5DPXjb54lZZZHpng.	FACULTY	t	2026-07-08 10:48:38.643538+05:30	\N
1323	deepaece@svcet.ac.in	$2b$12$dWZGh8lVUA3tWE029Uxo/.r9DbsmlEtDzXEjFCSE/6DFVWSgRQNGy	FACULTY	t	2026-07-08 10:52:33.759063+05:30	\N
769	principal@svcet.ac.in	$2b$12$89va20fTZ4HpQ0XpybbzGeJ08h/kTRuQFk.oVx6u28yIGg4zHDTRq	AUTHORITY	t	2026-06-28 16:32:58.189521+05:30	2026-07-10 15:30:52.174985+05:30
1493	teststudent50@svcet.ac.in	$2b$12$KCKgWhlwhOf1.fHWsiZV0ulWmzRbCizIEIqvtqul4rCMV79k2MoHi	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1494	teststudent51@svcet.ac.in	$2b$12$ovt3jsZn3N.LObToPLk2Weok8.ZF0l7Uq4hNPRpTcBta8UtoDCNca	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1495	teststudent52@svcet.ac.in	$2b$12$eMgCe7xuCbKFYY5Z/CnLAui0ExyQMBn3STshyeJXUAJrgVOlyhKBy	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1496	teststudent53@svcet.ac.in	$2b$12$Z3rEecXKVUNTbISaOxLnu.2VNNsYIevv4bwRp0.jhQ6S6hOlrd5am	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1497	teststudent54@svcet.ac.in	$2b$12$FnzXGPfHawwQDklCnWLZ6.UsNYyJrLmFAaggxe2iGVCkVmJYO3dca	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1498	teststudent55@svcet.ac.in	$2b$12$5ojGoanBamrPjNQFrPSJ/ectbutLwyfkMK8FEfrhAxW7zq/upLhKy	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1499	teststudent56@svcet.ac.in	$2b$12$PLO7NXXj1X4rJGKJGUg5OuKXj/6sJkICBbL6sRYgN8vzprh0gUL5G	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1500	teststudent57@svcet.ac.in	$2b$12$cCLNZDKEDWRXTBLRJKxAkOlTXCc644/LJesZC3c8dUDP5WDBMqsze	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1501	teststudent58@svcet.ac.in	$2b$12$e6FB0aC2xW2t4XDUYG6e4e5ln58r7rHxe7CojOlr6kxyOmXfgRM2q	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
767	latetracker@svcet.ac.in	$2b$12$HiDCuaWV9yTKA8J6boSUrO95QLj5k2v9uB35P9u8LCQz/Rq.u/MjG	LATE_TRACKER	t	2026-06-28 15:40:05.686615+05:30	\N
1502	teststudent59@svcet.ac.in	$2b$12$epMSmQtXDvFobocq6LTtteRiYhj3IwqmWevgOh5SJHAU3zlmxCGI2	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1503	teststudent60@svcet.ac.in	$2b$12$.BGsujbM8F8EH3J/x1mo8ex227szFRvNJZLZJYKMrIUubtpcKm.Yy	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1504	teststudent61@svcet.ac.in	$2b$12$3Ttn5cK.2MVTD7f5489qPe7E3l4YQs.TjtZVCOyifFpSFWBHjiEvS	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1505	teststudent62@svcet.ac.in	$2b$12$t9ScqxFpAJoKStAVyP.VE.5K51wKnRVYVi0/C4Z4ZU2vNM0GytyBq	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1506	teststudent63@svcet.ac.in	$2b$12$yzf/oMvW49xjDbebcJh6OOIdBHj9fUr/TfU6o4q/.dcHmw04dAoSq	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1507	teststudent64@svcet.ac.in	$2b$12$f/GUwHW.Gz5WlElp6xoHSOPId/ATEp2TmRxNqrOTETV.Og3VR7vQa	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1508	teststudent65@svcet.ac.in	$2b$12$dVjI.onFcdAaUCaBZcZ0ie4q7eRcaAqW9nk8M3PHG8H4sqsGPzq7m	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1509	teststudent66@svcet.ac.in	$2b$12$XTOSCpZyCUf/Mje6yKDH7uZ.CiW6Xniel.73T.HUFu92crL1yE91O	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1510	teststudent67@svcet.ac.in	$2b$12$0mFjImfsIXme1mI87wCVX.wLgvXD12IVwycBsKPKqySNpW30o6CMm	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1511	teststudent68@svcet.ac.in	$2b$12$cnfTtlFM/rgdw.8KnLIJ0eby/Q46s0K15kSLC0H53XlAs1xX1Pye6	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1512	teststudent69@svcet.ac.in	$2b$12$WseZilh7XFNgXuZxQ9XcXuIzBeprOHcYdBG4fWaa1/PAtThw/kMie	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1513	teststudent70@svcet.ac.in	$2b$12$P6ERUEYJ9OAFT85EqMmw4..d.CM5FuRGa0HbD4G082l3MPoZWoJjy	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1514	teststudent71@svcet.ac.in	$2b$12$KYpWs5mCg9EOCOzd8sdute2ISwSHF2iDellXN0Bx.Wl0eGq4uCf7S	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
780	om@gmail.com	$2b$12$mR42kjPgyM8mCvplW.G6JOA6GoRqoE4D9N9N/JhTIFWY.G/LXTI66	AUTHORITY	t	2026-07-01 12:09:46.444134+05:30	\N
1515	teststudent72@svcet.ac.in	$2b$12$4YT0rnFMl.BXWLy5RmKv0eCn1en/SWrUrUPNgG1lZNUkM6gRWn/vy	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1516	teststudent73@svcet.ac.in	$2b$12$VJ0Lphc3SoPOtuKnN5o/3e/jdDcCci851Ag2En8aHWo0hjNECal2C	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1517	teststudent74@svcet.ac.in	$2b$12$1PyOJNoCy47L4n0wXrTiouOlL3yORALde03k6Pyozj5No8Hxje3JO	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1518	teststudent75@svcet.ac.in	$2b$12$wywjp6yp8k3Jem445M2tEOMw7EGbOGuNHo9CJMNGeIKn0IqN63veG	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1519	teststudent76@svcet.ac.in	$2b$12$3foU0y8fMB3VihQCjLp9OuSgi2NqH82.ToASmH78GbBOX73ZpLKj.	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1520	teststudent77@svcet.ac.in	$2b$12$Lmvzk3FhqAasJ2YXTdg6k.U4ij44rm./fpH3d/zMLs.TIvGila1qS	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1521	teststudent78@svcet.ac.in	$2b$12$gOaOT5v/CLLcyOMOi5PLTe5XInb0QJH1UX9MybGU6wAmd06XpX3u6	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1522	teststudent79@svcet.ac.in	$2b$12$/owHG1Mwi0DO74em9j0rP.Xfzi7jFFYO13hL3.YFuqa4UY/EDecz.	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1523	teststudent80@svcet.ac.in	$2b$12$5eMJztjt.vrpW4ER/Xntr.UqFaJ05Hj9uuhcnNoDdAeisGvy5aZbq	STUDENT	t	2026-07-14 11:54:38.483082+05:30	\N
1587	nivetha24td0810@svcet.ac.in	$2b$12$CoHw3mIP2BSIxp9pykBMe.V6D6MGozqWOjTtRVX2gG57Uklkj8aRG	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1588	pooja24td0811@svcet.ac.in	$2b$12$LnJUu3pAH6vAAs7jhUbHW.irYT2XJSyZusicFfstoAwlxMoNHjy8m	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1589	pradhoshwaran24td0812@svcet.ac.in	$2b$12$ux0dAoMRxPFouXG83DXPgeIX4KghRqwZLc..iOpEIMayztdrJH.ay	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1590	pragathi24td0813@svcet.ac.in	$2b$12$Z77uZRpqNvgWu7/yH9Wat.HozwKkpwxZNr3OU/YlGTyM3nZ2gekRC	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1591	prakashidha24td0814@svcet.ac.in	$2b$12$DaU8qu3mr10oUNZJj/3BAeyIkkZYwOr7RCO3kdALBqoWjsIB7sD.m	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1592	prasanna24td0815@svcet.ac.in	$2b$12$jD97uC7yBJ7AySo2i0V/beUSg89ggjoAzoSTepCibXm0Lcf6jJfr2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1593	prashanthi24td0816@svcet.ac.in	$2b$12$OGWGTwkFpXmx9iXKuPD0LukJth5fzP201ssqhblT.CsX/Rw3181CC	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1594	priyadharshini24td0817@svcet.ac.in	$2b$12$0jfArTTZhcD4MUZaU63QMOJJgkPO9Z0.dyvTGEZawEjnrUTU372P2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1595	priyadharshini24td0818@svect.ac.in	$2b$12$kw3rIF23pPye8t9WETnZPuxvhy1qg03E0LjD9.FM0fYnO1due3zuS	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1596	priyanka24td0819@svcet.ac.in	$2b$12$lBcfxRSmov3tOyvS2eRxxu/Be3FyZhy3s8WlnH1aaNaTDHFDmNQBW	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1597	priyanka24td0820@svcet.ac.in	$2b$12$oKTKMtLIKuef4JKkJdNtSupcy5y2MfQOOEn7uZ29KmuNdWjmLajlK	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1598	priyavarsan24td0821@svcet.ac.in	$2b$12$lYuwNjhtcYu8S3ew/FIrGO7q1CQDogO8ClCJ8ZzUqIzy8kBD5xIwe	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1600	rakesh24td0823@svcet.ac.in	$2b$12$p2EqWKBu3dV326zCDidIaedMbHzCTou1BjliLUXH4qGVsO2XeyDPa	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1601	rakesh24td0824@svcet.ac.in	$2b$12$J9hRk4ltbrcmkb4sWEiGU.gFLM2bS8KOib.bGP2y.O3Q00Xwzrhci	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1602	rakshana24td0825@svcet.ac.in	$2b$12$lUpZujecIJwzDptNtEK0HO2VUxUga95HzGSl2WouAwWhej/f/ylKi	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1605	Sahanathfarveen24td0828@svcet.ac.in	$2b$12$4q91gcu87U48mWF4d73eVebmUZHasLZXlhWR7GsvwcSqf6rTTHznm	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1607	sakthivel24td0830@svcet.ac.in	$2b$12$1X/K7iIMo8saza8d8gsum.TQrdlXG9m.1jEJ.5ez5CbVBBc9AW/wG	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1609	sathishkumar24td0832@svcet.ac.in	$2b$12$G4hAJHY1a.HVZ5HlWzeUEebOSlyjkBLCVZDAWt1CSMaBl70nTN/Ry	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1610	shadhananeerthika24td0833@svcet.ac.in	$2b$12$kr9YfEhBxSXms3hoJIZWQuhmLhy1bq4jyeGmeSNJu8i/z.3N7K1ga	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1611	shafana24td0834@svcet.ac.in	$2b$12$iIImXhxz4iU5Jte/TtJSBuRn1vDBgeu6s/QHYmVrfZtM7Vtm7Opm.	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1612	shaharabanu24td0835@svcet.ac.in	$2b$12$hD.EHshsqmYIplbd0OVA8.uDyh1kwLcSwTTTPiq7Sen6hx.f.EJJu	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1613	shakshitha24td0836@svcet.ac.in	$2b$12$YldlXMrVDqmj2PLDUEVumuJHbfPNqxZ76uVlZu6.4Y/RCkMrjumZ2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1614	shanmugapriya24td0837@svcet.ac.in	$2b$12$N6PZs8P6KPmeDM2rM.mR5.8V1gjNxpxymEp51oqBBSG1gxWgco00S	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1615	sharmy24td0838@svcet.ac.in	$2b$12$NspSEP.bhD8S6Q4XZNuP5ug1EFQRjVmRLuao4K7VcIUt8AfUx7NDa	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1616	somayaramya24td0839@svcet.ac.in	$2b$12$jbKBZ920boMTHxUT2uPc2uFIGdccZ/uYAG5zaewG0FzMv/7VZMrfi	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1617	someshwar24td0840@svcet.ac.in	$2b$12$SgpLDLs/JQcWfq8D2daphOw26DpbKglN3N1m9uMIhPe0xIX2qgXUe	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1618	sountharya24td0841@svcet.ac.in	$2b$12$VyJttwujyOErVpxP8mMgCOaVyoT3QnnssSAZQrSS3cRLm4xxFm0YS	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1619	sreekrishnan24td0842@svcet.ac.in	$2b$12$gNA4E4KwbNbdfwWQbMrRV.AdOHQOhqM6v/45Ug8Q2VpjAKQPiBOIa	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1620	srividhya24td0843@svcet.ac.in	$2b$12$nT3Xxv8M1f6UKCTqWDjnV.55gnHxk7H5ZFAoCAQyJlIS.nexlGm/q	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1622	sunilkumar24td0845@svcet.ac.in	$2b$12$Eouht3/qqgE4lmJwXBB8LexMuSDNWmJJvOxGiZkDqx8nZAcPatOO2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1624	susi24td0847@svcet.ac.in	$2b$12$xVsyPpiD6U.6Hvdw3bibnOaPFi3qwN.lxWQDss/PyayWcpCePtz36	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1625	susindran24td0848@svcet.ac.in	$2b$12$sMerN6/LedjyxkZly9on.eRkW/2uJvgv2N.soyQG7dzyHgv4Ln7WG	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1626	tanzeelasultana24td0849@svcet.ac.in	$2b$12$.MxP0kD9HGj23hpYbIszTO7NwiOi3gm.r/hRhpZL18W1mJezZlfb2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1627	thilagavathi24td0850@svcet.ac.in	$2b$12$FGKP8c6GHM4iL0//ffk7Ae4qC5h4zt/HPaErLmZ5wRSUCuoXU1fiK	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1629	vaishnavi24td0853@svcet.ac.in	$2b$12$GDSQ9FcEgcPgrdKisAlo4.Qwd.qEZtNUnMsOKBEJQM9DlPIxkFVOG	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1630	vaishnavi24td0854@svcet.ac.in	$2b$12$tkDtQaW4j0IXvswz4O67ueltI8uRMPs3tmS9fNjloCZ9juAP1xA.6	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1631	vaishnavi24td0855@svcet.ac.in	$2b$12$TkBCY3xT8.TFkQ9h3UCo5OSe6GvAoq2K.9fHfw7ydFbCjnyPfV16K	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1632	vijayalakshmi24td0856@svcet.ac.in	$2b$12$KcQIZDuQKDbFQm8cpKRHduY1vMmW.gZaf1yRp8QFS01A7qKdg/zr.	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1634	vilasini24td0858@svcet.ac.in	$2b$12$SeX0vMRawrA65Xc50K19fO3T8lBNg7PUSAhanGm.J1ybl0yCjwNki	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1635	vishalini24td0859@svcet.ac.in	$2b$12$vrZPUBh5iJj.OgB3wUnof.6WHcjNZl6s8cTmq.Ti//mhFwRu.ZXES	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1636	yagajanani24td0860@svcet.ac.in	$2b$12$9/dFt0tQQP5KWkAn.MRJYOQ7GiK0l7X.iu7PjsqK/DImgUPWif/ge	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1637	yamikha24td0861@svcet.ac.in	$2b$12$LI.LGZxzB8odS2tFi1eRuOjIwhkri5YuHf2lvAfaVw/0uxRqntZmy	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1638	yeshua24td0862@svcet.ac.in	$2b$12$XS/oruNdf6dLPBsdCs4L6OgkIRRsJ9B5SBAXWPXS4wpgkkB4wOUFG	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1639	yogaprabu24td0863@svcet.ac.in	$2b$12$97/pFz0pBEiFpnuBXYMJoOzG6NSJA1zQqrUw9rbXyKUk6MeLl33GC	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1640	yogapriya24td0864@svcet.ac.in	$2b$12$jWWFDITiMho0QF5EDcA4CexsOVMZxEd5y3Rty06yl.i7x5jimB11G	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1641	yogesh24td0865@svcet.ac.in	$2b$12$W96b2Skgf2GnzCNIFasOcevr5nD8c.fJR3aolwicEZ7aX3BrIh3rq	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1643	yukessh24td0867@svcet.ac.in	$2b$12$vGKHFEZI5e7qBOahV.NQjONL3BSPvjPwfK.9NSK2YD1Ya/myk6BQ6	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1644	yuvaprasad24td0868@svcet.ac.in	$2b$12$eFDTM9ewbVjoxZTnSFbRUu1NHASZ7xL7HOiLiZuyAvhYgukqedujW	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1645	zainub24td0869@svcet.ac.in	$2b$12$YNoyG5ye.1KYJbmKSS2HRe90h4mqq.ttmJ3D5jxf247UiVwjMau6K	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1646	jb7524751@gmail.com	$2b$12$bEcCaUU0XDVLBRMIk191zeJee4vJKdXzoNX0ntODJE/aYanqjZJuO	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1647	rajasri24tdl019@svcet.ac.in	$2b$12$wZ2/Dxij4liG/maVmQcfo.GK.qEs9MC815a3PNvWwYugF2ucAjGtG	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1648	siranjeevi24tdl020@svcet.ac.in	$2b$12$JU4mretHcVjkYLJy.DFDjePXd0u7..GIcXZo24xfVWllWHzVrHGH2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	\N
1649	abishek25td0601@svcet.ac.in	$2b$12$xKEuFz311MlncHZNb.SI5eALBCEn9FJpwU5TbXp5NouPjZwKlmkne	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1650	abishek25td0602@svcet.ac.in	$2b$12$uLgzSxV7cF/Ctgw.cpkAZe3XyYU1dgBIGaA4yc6Fr8W.ULa5x94WS	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1651	ajaiy25td0603@svcet.ac.in	$2b$12$8/UIh8xO.2Hrx9zdyRjBjOu/izpCgnT9wgi0QSIJKOkBJbKy4pzeG	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1652	arikarthik25td0604@svcet.ac.in	$2b$12$Gn2A5ap8mcC7R.HYN0/biuks9L0BwVVipnKTMkNjj0u272UQJOB8i	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1653	arishraj25td0605@svcet.ac.in	$2b$12$tDLunG85EPhA0Ix7KrgOyOJsC73pW9rvNLNx0k/gmInkJqFFhk2mi	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1599	pugazhenthi24td0822@svcet.ac.in	$2b$12$bsmPXqeTjO26llDfUdiBpuXmn7GJfQKcv9ftF23FI1Yrda1JCQwj6	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:08:53.345228+05:30
1623	surendar24td0846@svcet.ac.in	$2b$12$TqJqW6XoYeYkWQmXG2Y.weg9pNp521qniJHjVl2aQMKb2051hOAIC	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 11:16:45.722056+05:30
1621	stephenantony24td0844@svcet.ac.in	$2b$12$yVKOljmkEX7sv4PZuYtUGeaSjC6De8sNb.JR12Qv/ZpjmBIPQMg32	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 12:02:13.953345+05:30
1642	yogeshwari24td0866@svcet.ac.in	$2b$12$gSAu3MVcY0deOdH8NLqlveWjj3Jq3uE4ny2zzTfQH7H3os0ZaHsW6	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 13:01:42.498488+05:30
1608	sanjay24td0831@svcet.ac.in	$2b$12$XGBrcfDqykZws9Xd8iV5hu0JQrUwOUK3iRgDtXaclrv5UbxHXWZby	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 14:50:15.686202+05:30
1604	sadhana24td0827@svcet.ac.in	$2b$12$Bsy/r8CFbFubkfyb72J3EuAXaeUMT9pM417WQpKRnPMAMbT7CMzR2	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:03:04.723306+05:30
1603	rithika24td0826@svcet.ac.in	$2b$12$ySN3DKEap/Z5iy5wSbY0w.P7FGS9jE0.D1EMyDU7y1NFPd2utzEK.	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:26:12.966549+05:30
1628	vaishali24td0852@svcet.ac.in	$2b$12$v.iSkaDjDFESNtAgVLmkD.A.lMoTkKBz8qHs3TsEScu/rwYBkV2/O	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:41:57.09191+05:30
1654	ashifabegum25td0606@svcet.ac.in	$2b$12$tWQnMJaw2frXHyJE.EUDWuPaNdstp8S1VbCtRkZgy9auBiXd1v3ZC	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1655	ashvika25td0607@svcet.ac.in	$2b$12$oTewf1gEoqi27ibCYXOdjO.uyqI6FX2fotLBw7P.LYYja6k374Sie	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1656	bharathraj25td0608@svcet.ac.in	$2b$12$Gx2laN1wuB2ADvDHxIfUV.o6laj3j70AsMj/bjtYkOoGchdHFmyj.	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1657	boomiganga25td0609@svcet.ac.in	$2b$12$YRAhtJ.6Eo7IU17LTNs/leX87P8o9i7.HuY98wGr07AWdETVmzHRG	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1658	deepak25td0610@svcet.ac.in	$2b$12$fAprRwnhddcUEgbgcOnJX.g3PqCFJvX3M7e.GvGpgmF6PPlIoviKC	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1659	deepiga25td0611@svcet.ac.in	$2b$12$lbp0z7tzJ7xOTl3aXxcAa.5nASTbxSt1naqVmywFq6dtaqvtun62i	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1660	dhanyashri25td0612@svcet.ac.in	$2b$12$GvZYH/p4EEScttXRgVRS1eJXykBWMhjiQIdfQIIcT2Lhd.XTpfdbG	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1661	dharshini25td0613@svcet.ac.in	$2b$12$7COyZggAB4dd6xBsf2qSKeRw/Sv38t8fDlUpMsmBSW/O3WJZpiq6C	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1662	dhivagar25td0614@svcet.ac.in	$2b$12$t5i3zghhKT6fslb/d1.7o.FMYUQ4FC.mcsYkwyj6Yp0fgYzrxxFhy	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1663	dhiviya25td0615@svcet.ac.in	$2b$12$i/RKaSkeUlenmRxllJCQJOYVK4YATIItElKZK4LJ/jIWOZX2NYXzK	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1664	dhivyadharshini25td0616@svcet.ac.in	$2b$12$094vp2mVGNwBqbG8BAu3ROlkyGieJU.GGBWvqG3POebIwv15voWf2	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1665	divyesh25td0617@svcet.ac.in	$2b$12$LJJxD./Se7D0pS8p94WGueaKEcehCYBOJi58ibbjdAiyhFGu9SDV.	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1666	gayathri25td0618@svcet.ac.in	$2b$12$ioCG95BUX78CKTYvtLO0ie07xxo1NUHtzs7yBhBb6T.EfEVvKFEP2	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1667	gershon25td0619@svcet.ac.in	$2b$12$hXcIJtzcQbwMhOMcu0omMeRym4tcYBYSSLv9yMCjumFuFDrEJJ2WG	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1668	gugan25td0620@svcet.ac.in	$2b$12$qiPjJjr7f/XrjdkzPcYGreYxxAzlGDlw9lRMB8VBnTQ.3HVpaaIdC	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1669	harini25td0621@svcet.ac.in	$2b$12$MPntOn0wfm55O8UkmpkQEObkNe//x06XR2p350EKwNtlG1HD3Oumq	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1670	harinivass25td0622@svcet.ac.in	$2b$12$OoE86P720lc8s0fbCDNvHOmRw2Gh/jFcjoqaUl0Ona1XJOfJCIOUu	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1671	hephzibbah25td0623@svcet.ac.in	$2b$12$Pep9l8ovu42dtsd70xJ5G.sgLLAXDmSrhxb2tJRYactoN9XjnMBJe	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1672	hitheshwarakrishnan25td0624@svcet.ac.in	$2b$12$f/TaN3gL9egHD99gTLcK0Odjf3bD1j9M.WZQ.H7jjBu6VyZwCcwiS	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1673	ilakian25td0625@svcet.ac.in	$2b$12$/2tyqTUi2bJj5VCgElqQFOO.2wifacZ6Q6h./VLKUkBfr5B.zDGvO	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1674	irfanmohammed25td0626@svcet.ac.in	$2b$12$OonqSnDjQsfWvGJJ9wHlWuuUrv1mcboirn/SYN5BNZmxy9vvwK69i	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1675	jaikrishna25td0627@svcet.ac.in	$2b$12$R7L1Y7803DEm73uZ8Jf6T.B2uNOYXsBH5jhT/MrgQVqoqyxYPjqQS	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1676	james25td0628@svcet.ac.in	$2b$12$.DDPEpSg4Qev1/TuapFeL.NyNmSFX7jHoXh9dLEHvVD/xVwspxPaq	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1677	janani25td0629@svcet.ac.in	$2b$12$6Z4ZXGH5Vj7kEScZnvImR.iHyYBcb/xUg5fk8Cu5djWuhkw0HeX.q	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1678	jayavasudevan25td0630@svcet.ac.in	$2b$12$EM6glQphcIow9KjxQjknp.CTpsXFTUW.re6l1Fek7pqOVjGcraBtK	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1679	jeevanantham25td0631@svcet.ac.in	$2b$12$EqWdEBMgFNN799U/bd427ONc/wP61pm8GC5tmaveIdkvVu5cfogGa	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1680	joel25td0632@svcet.ac.in	$2b$12$jNYHEmqXlcAYSbmrYnnIg.ro62u5lclemQIro/n7lp16y4NTR8Yk6	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1681	joyal25td0633@svcet.ac.in	$2b$12$D4t7BwoRhzt0TFa20p02We2nwiAeRQGxTVXbuDCp6GnhfZ5sicpd2	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1682	kabil25td0634@svcet.ac.in	$2b$12$rY4LHALEA.gIcJ44MyZb3.zYb2kFt9hv5SavaZ4vmC6NASPUmR.6C	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1683	kabilsha25td0635@svcet.ac.in	$2b$12$aPNYkvOhXOx7fvfXaT7T4uFVNaLJBeZ10EjLanpQsInPV7VDOgmDi	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1684	kailash25td0636@svcet.ac.in	$2b$12$b0SZ6BqsCxenMxo8xJyBI.AP9jnBamRYrjRGnPsqn7mYrS3gEfnQO	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1685	kamalesh25td0637@svcet.ac.in	$2b$12$lkY6HwmHfF0.gtrpKACvre6ehG6hxPzFZF3.is5b2aiKkAs8akVLq	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1686	karthikraj25td0638@svcet.ac.in	$2b$12$6tGhwuS6eIsm9LxJDDurC.f4NUuRkbdjH5Yoh.z5h7ccOVw0wHjPi	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1687	kaviya25td0639@svcet.ac.in	$2b$12$RhUSeXhss/L7pUgw2B5ubudLPSYJLQ/TMAxtQ0Sax7Blrb9Z/i8Gq	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1688	kavya25td0640@svcet.ac.in	$2b$12$qTwztT5IeGbF6nP.fRzhVO9S5W1tj8TSsqkDqf3CEW2eH6gr0/jmu	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1689	kayalvizhi25td0641@svcet.ac.in	$2b$12$6vrP0iT5.mqugBxyJODu0uEofKX9O.psUe5KxKwBUvmHGeAPR8yIO	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1690	keerthana25td0642@svcet.ac.in	$2b$12$MX.TXTGmuDkxBrcuExgxfug/oTuaMKSJ8L2DSbdCwtUgxI8SRyl9e	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1691	kirthika25td0643@svcet.ac.in	$2b$12$tuRvy4P6aITIwZZn8DKn5.1fJ/0sQo4BUOrxgskgggL492WA9VlmS	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1692	kishore25td0644@svcet.ac.in	$2b$12$rJJqsn2QllHtX7e2TNM80u34ZOfAb9VpNT65MCic7tGdvulIG69vu	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1693	kishore25td0645@svcet.ac.in	$2b$12$u.ITLuln.JoBtANochNymORb2JNeVcZe1pMCUpr07xWst0e5yIlma	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1694	krisha25td0646@svcet.ac.in	$2b$12$ZxLl3ZDb5u9mL7FRJDBTCOvL5ZOGm1dtbDgvVzGVENeGi/93QofR6	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1696	leelavinothini25td0648@svcet.ac.in	$2b$12$84BEBAAqi8e3PyZ06m3qW.wpS/l4JiQhxvjytTmgXUpbhISnds8Va	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1697	leveeshna25td0649@svcet.ac.in	$2b$12$qvzY6Y7vHubzss48KWq/Z.yhJ9qkZ8iuaxJj3i2ZOxRAbaO5UFGha	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1698	lokesh25td0650@svcet.ac.in	$2b$12$iFkvB7qh/1Iw3aSLnTR4QOe1eRXciKqy.3WHmxrirry9T3LdpqBgW	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1699	madhumalar25td0651@svcet.ac.in	$2b$12$hgFxJbL/c2nUZ9XQUpTkBepdkxY1yS95D4lzLRVjXIrIF1rgyW1py	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1700	mahaboobkhan25td0652@svcet.ac.in	$2b$12$R9OJxQ75S/3itRVbh6eNo.4EKtn7fAfMlBYW5vnIZXh64G10Mm5wS	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1701	mahalakshmi25td0653@svcet.ac.in	$2b$12$7ngE5DDcJkGGFuLkH7Bl7eN4jERPkZk6IeecazuSRiUlyEDik.Iui	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1702	manish25td0654@svcet.ac.in	$2b$12$0.ncJwu8gmbZkTCwDMlcR./nbRNRqOmVni75L1T3B/Cfc8wsUtXLu	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1703	mohamedfahath25td0655@svcet.ac.in	$2b$12$ZpxGdztgCa0cToJCSl.SE.qHn7Nf9uidsOui0uTN/VuMAHIN0dTFS	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1704	mohamedmujammil25td0656@svcet.ac.in	$2b$12$Gsyh8kf36HE44Ct9p3CcTeu0hqhFyOleV5tHA7kj9p3p42XTRbxXO	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1705	mohamedsahil25td0657@svcet.ac.in	$2b$12$i19piCg6BuEcIamfwTLfTOhrmguZ7yshWojCWYWCv8EXqS5hvOXLS	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1706	mohandoss25td0658@svcet.ac.in	$2b$12$7KJzJ6sorU4PfYpTo5ZfvOM2QAAXvg20ZCdISBgszZPDemQSFFNZu	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1708	mugesh25td0660@svcet.ac.in	$2b$12$p/.zaY3dkvs4uNr52SvzgOxdijLJEdAKUvO.2Lp7oMRlO8w4XRR62	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1709	nambiajan25td0661@svcet.ac.in	$2b$12$o61DRwZRjpn3Eat8peMM9uW2QHfkbDRTXCzuF1Mf4UxV8o97JqJPK	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1710	nishanth25td0662@svcet.ac.in	$2b$12$s4xOh1A8zW0YFbxAyIMeE.JsSOS0hTkocAAoke79D4hn34dHVqNTe	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1695	krishnaaganth25td0647@svcet.ac.in	$2b$12$PLoHo0Q1PSGx7irrFlci/OD6RpSjCg25B5SLtejTNXmxDm5LaMXRG	STUDENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:32:37.936205+05:30
1711	pavithra25td0663@svcet.ac.in	$2b$12$YSd6r.pQImbYrVMIcc1g3eifBtQJ8Q7sTKnTc6N.Ysau2jpMKt7.y	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1712	pradeep25td0664@svcet.ac.in	$2b$12$yHbRIjxLKBFwSgdQH/10K.8tYb/8EF0dBgiF7Oa0v8L40sto/KQvm	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1713	prathap25td0665@svcet.ac.in	$2b$12$F46ITyGvPFMwDuvkdaNwi.K0aUsT6rrwHs8xOftzEfN/n.BWwYGv.	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1714	prathibha25td0666@svcet.ac.in	$2b$12$TPBhehUq2wxjNaF5IHRN3.JemPznJ/dPxyxyHOVNrdYMjaERbnNKq	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1715	praveen25td0667@svcet.ac.in	$2b$12$ZhrnonUgeepMrfrij9YxwuSh4nfQXrHctcB8VVo8Q0yJnf61rzY/m	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1716	priyadharshini25td0668@svcet.ac.in	$2b$12$JE9YnrTgxFTdWjnBsTT5d.Map/zGzQiGOOL4QELbresYFGvdnmaYu	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1717	priyamathi25td0669@svcet.ac.in	$2b$12$o8lgJJw.6hp8O8NECYPPwOCQgrGBTDjUw77L0s72i0Zl9JrvIRa7q	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1718	raghavi25td0670@svcet.ac.in	$2b$12$B1jqZBI40v.k8LbgZEj5.Okivzp1oUL54W1cYlsUY1kzsRQZEO1WC	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1719	rahimmouhamadimthiaz25td0671@svcet.ac.in	$2b$12$ZM4ZxwJrDt9DORXHGRuzEu2zLdLJyJMcbGcRZ7daJj0h6HTQgDOlS	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1720	ratheesh25td0672@svcet.ac.in	$2b$12$TY9hoBFTVWzP/aBccfj/deGIQPFhIL7o9vHh/pmHXCy34deui1d1y	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1721	ravindharan25td0673@svcet.ac.in	$2b$12$pbnEyxF017pl501DA6eaH.QiNqNFncaTeSwDi0177allBOncaiC4m	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1722	rishi25td0674@svcet.ac.in	$2b$12$y2vujYlJNKAqjUuiF94oMODIiO/JmXTta/Yn.w3VnVKnV0ymusV7u	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1723	rupesh25td0675@svcet.ac.in	$2b$12$RKlP5b8VribBh69Uv1ndhO8R/T24z9eJ3bt/NG7StzBsQNrhiPo1.	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1725	sakthivel25td0677@svcet.ac.in	$2b$12$2C/KY9Fln.0YtbyH9de6z.lNHxKis086HO/FgiWbWYACXgKEmNRRW	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1726	sandosh25td0678@svcet.ac.in	$2b$12$VERC1froAOgcvjyOgn3UzuVkKHy5BOuaFXtQ9PamnoeOTaAd/gdMu	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1727	saran25td0679@svcet.ac.in	$2b$12$s2Nbyt7.jc90qNKobYDfKuC/QFWTAy5syGC4/OuGmeEP1fIBPmc16	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1728	sedhumadhavan25td0680@svcet.ac.in	$2b$12$VshqJFBTmhQB6ii9TY0p2OIfHqGwytyFc2PjCCdRRz/XDfLgFLPty	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1729	shajmi25td0681@svcet.ac.in	$2b$12$aW7U6cOZ9KHj92VuEM9cCO58aSEtEd./GTbf0ZYj5OB5T3ckv8S92	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1730	shalini25td0682@svcet.ac.in	$2b$12$a4Rm0r7H7JoSNFGR5Fm8SetNOF7vNvJE6JoNwYuXpdqgTRBvwZY8O	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1731	sharma25td0683@svcet.ac.in	$2b$12$3VAYr9IZCKb7UNP7TWbj0enNXr1wDp4p55Qv.d4hPemKfoM3pqmje	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1732	shyam25td0684@svcet.ac.in	$2b$12$rfVeaCAd5Fh3g3K3erfTyO8ge7WM2r8gDuzcXtInmzdCDsrVd/vSm	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1733	sripavithra25td0685@svcet.ac.in	$2b$12$64vi3WUWEe5fb7DP9DkFrOcx.d16cPErPLgZy2Un1nnh2Sn4o8te2	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1734	sujith25td0686@svcet.ac.in	$2b$12$tXG3AjuyY.uZH1ZvJ3g9SuZ74lo5r7PY//uaV9sdEl4dsG.hMWcUy	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1735	suwathi25td0687@svcet.ac.in	$2b$12$64SHgBT5PDIzaceXsqEMD.mGYBYp9Ky6OKMc3aYdOIXd7VPrLI47y	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1736	sweetha25td0688@svcet.ac.in	$2b$12$IXkqzYVvmsmPAar2MT2.1OvpzE09bzgS9R1eoHMdbdG6rE.mCzaMC	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1737	udhayanidhi25td0689@svcet.ac.in	$2b$12$50aY4T6w47JDlR3mdSFgDOgStFWtH9RPq61aiCKinWS4LFijYJnSi	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1738	ugam25td0690@svcet.ac.in	$2b$12$5PL5g6VABGLnUWeW4ubBqOqMYn5X7SRkT2tUDD42kATtc36eeGNq6	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1739	vairakiruthika25td0691@svcet.ac.in	$2b$12$VNZAzd7VQVK6kIhf3xBMH.gq4/gex.mMsaN6MpWgF1xxVVw3PqNJa	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1740	vijay25td0692@svcet.ac.in	$2b$12$GWNk3Cbv8SWJZSifmcmYBuuNK2ESJXEFvWhRLiHN9fAGMMMdggW2a	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1741	vijaya25td0693@svcet.ac.in	$2b$12$wGMn1ownxOY50Iks2Ep8TO2w1ew2yXSKc2yWgSZ79hfc56x8KiKUy	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1742	vimalathithan25td0694@svcet.ac.in	$2b$12$sN7HMsf3ggxtk7cZaEI.7OKb2vDjxgvzla8W7btKQKzy2ZaOhvVl2	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1743	vishali25td0695@svcet.ac.in	$2b$12$HQV9GFHGI3Ri0hxw7YHPi.gMutcetqnCzsiOuebdyeT3bifI530Ji	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1744	vishnupriya25td0696@svcet.ac.in	$2b$12$ScCmSREPkvnyX07UOs0vDOiIZzhdM16JyfcXR7nVEGtzllxwy8bTO	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1745	vishnupriyan25td0697@svcet.ac.in	$2b$12$ManfEND9km6qCX2XTS86R.AUu1jSFj28ykcqWqhlXqnnjtydB.Hce	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1746	yaageshpriyan25td0698@svcet.ac.in	$2b$12$2UICsa6OGaDUI0yT3g2f6.ph6TvGTTrxn01aa3ngUk9uRcJCMaRjK	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1747	yuvabharathi25td0699@svcet.ac.in	$2b$12$bXPDdZoY6JjvogAMskBcwOP8slFl009oqS4TVB9yCnRLxvB4Dt66a	STUDENT	t	2026-07-22 10:45:13.145749+05:30	\N
1748	jeevedha24te0151@svcet.ac.in	$2b$12$RQiS29tYIx9JbQnV8OIyAut1TXzwlT0i1mPQnP.GgeEa5FxnBIZEO	STUDENT	t	2026-07-22 10:48:27.994959+05:30	\N
1749	kaustubhmishra24te0152@svcet.ac.in	$2b$12$Le1CX9nWYxZ8H.sl/QbSE.QbmqOZ8k4iYN.ccS6hrto0CUnKDSwrS	STUDENT	t	2026-07-22 10:48:27.994959+05:30	\N
1750	kiranbhavan24te0153@svcet.ac.in	$2b$12$yA4WBiRdw7uQ5hbEJ7GTdulytsKC4eDx..dKzpd7fX.BhMUE7kTrO	STUDENT	t	2026-07-22 10:48:27.994959+05:30	\N
1751	rakshini24te0155@svcet.ac.in	$2b$12$dBOrIr/4jK.IO7UvlTzXJOh23H10dO6OSErXgloD.R9ijb3muouQy	STUDENT	t	2026-07-22 10:48:27.994959+05:30	\N
1752	sanjay24te0156@svcet.ac.in	$2b$12$3qPLKBffSlp2a9zL/jvXleTCAGFSQ22BqeYjM4mviOQZmHPsTGOVq	STUDENT	t	2026-07-22 10:48:27.994959+05:30	\N
1753	sarathi24te0157@svcet.ac.in	$2b$12$MJLnlICDtkS2cQjw5AbDU.eKV59RK9NmiJshf7mUOpTZNJhNXZmh2	STUDENT	t	2026-07-22 10:48:27.994959+05:30	\N
1754	abdhulalim23te0151@svcet.ac.in	$2b$12$frSXqX1o0rWbfOk32IWUVuV7Y5LhAmObCMUAM.m7i6AYtW9/1Bt/2	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1755	bhuvanesh23te0152@svcet.ac.in	$2b$12$0xOOyeJ0PnDCdIiEPH9xWe3pxWM0ARuhTyUM5x8gKvC2DFJLl.BhS	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1756	dheepkdayalraj23te0153@svcet.ac.in	$2b$12$s17h21whGOlkpZZFIRdqK.k/lgieQeEyNH3R/qNNeHQxyMmQhjmCG	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1757	gobinath23te0154@svcet.ac.in	$2b$12$u5vDJLihSBtjje14CWtkReOEyaK3NvxCnCQD1KTnt64.Frq8Q6AK2	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1758	pavishwaran23te0156@svcet.ac.in	$2b$12$lnPY6W9jnBDhdt5mfSQ4R.DCIC.6IkirKFLLwZ4x2Cjrb7IOZeDd2	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1759	praveen23te0156@svcet.ac.in	$2b$12$kNQraV9/a517bbumIrnXDO9jfAQnNonh6PTRPhjxMNnCS7sTYk4pC	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1760	sabitha23te0157@Svcet.ac.in	$2b$12$jMq78C4BxWyerf4Yta9C0e26DwL8V6dMPBiyhpta5vVFLNRfkg0wm	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1761	sanjai23te0158@svcet.ac.in	$2b$12$F.6KRmQ44NU/A1f4YsKHJuBOS4e1UeL3f4fsaJ4ZOsbzmD7G.5rKW	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1762	swetha23te0159@svcet.ac.in	$2b$12$Ruj5hyGKxTovU9i6.87a2.lXWdNYBi1j6V8CIFE70GFXOBmMDKL.m	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1763	thamizhvanan23te0160@svcet.ac.in	$2b$12$vDZVcM4SxLqqO2/ERW55E.bgKKT8Ieez78YbqEytG0wyzKO3AyB.m	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1764	tharun23te0161@svcet.ac.in	$2b$12$2gTX5b4QtOJLOkTfuY7lyegVETZmY2rJM64Nm3T7KmM/JcLs5CqaS	STUDENT	t	2026-07-22 10:49:42.618891+05:30	\N
1793	abishek25tp0401@svcet.ac.in	$2b$12$ouTTp/lfBPsG4gMpm71TJO.NNWVkRBSU.HFygztAognPG1Vk5kIMG	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1794	ajai25tp0402@svcet.ac.in	$2b$12$OL4ZZws3K9hATs8sLRimU.SbS6p/5RxzLqlh9bfamLS4vHYcuCbFW	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1795	akilesh25tp0403@svcet.ac.in	$2b$12$CzBO0Y6wNjgRSTw7.OwlOuiMLxzsUlNIhugYrv2aAsetz1/R4ut.m	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1796	akshaya25tp0404@svcet.ac.in	$2b$12$FY89SF9kccim3E/kxjDXie5sporoRuuw2h3z1C1f2c6ACh.NVTuSq	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1797	antonysanjay25tp0405@svcet.ac.in	$2b$12$wCMhAmHcefQY5eObe1K.NOjIYaH9kA6sCWjn/RDKDwJnjzR0k/MkG	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1798	ashwini25tp0406@svcet.ac.in	$2b$12$lSeZN3ltiV5y0wRZYOPduuNMYSNcN33Hdq3IlknDsv6AM4vQpgkre	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1799	assmadnajiya25tp0407@svcet.ac.in	$2b$12$CmfDrnbHEPDMXBneyZmG6.4hC/Uu.xj3Hfan1HVmfzbTglOM45uBu	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1800	aswathi25tp0408@svcet.ac.in	$2b$12$cOP8z6gbwApV2V8WbGHOLuHQc513.uf/n48VE73xMse2acsywt4f6	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1801	barkath25tp0409@svcet.ac.in	$2b$12$tOVaEPPw1anxB3TVXtchg.mwfAoUkj2iaE582EezZOmi3hKncQq3u	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1802	dhivyabarathi25tp0411@svcet.ac.in	$2b$12$hetWv7lz1NsYE12DWrIOPeRo3p3NwoPcRonPsvkoIX2IzPI2xLehC	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1803	dineshkarthik25tp0412@svcet.ac.in	$2b$12$4/2i1bchyUjXtMlDfGltkeW4Yoyv98sRxeWEG1Rwj49hOmY6SU8fi	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1804	gokulnath25tp0413@svcet.ac.in	$2b$12$LmhHBHSbklnLzPWltVrfZueVMR/UV/9ihq7W9uB0/m1m0.9lxkVmC	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1805	haarishjayakumar25tp0414@svcet.ac.in	$2b$12$z1iFzQHb.5WfwTOAkbPBxegq5K7ALWkrcv4sbCD7F5hD1.jUh4ScW	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1806	hemachandhiran25tp0415@svcet.ac.in	$2b$12$R.eZOg9stsoE3t02aE009Oyf.FZ8bt5xJCHi4.IiWxmCl9w/ONS1O	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1807	jayaprakash25tp0416@svcet.ac.in	$2b$12$/WfVttOtvcRwbph3ZTcE4O65.P.qud7Px10lEyafrCYMb8xUtAGva	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1808	joebenedict25tp0417@svcet.ac.in	$2b$12$75Uf/bVfLFau6btM6Z6H6eOxtUVhY79nruhiJPLn.ZFQY9XjG9QLy	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1809	kirubhamugilan25tp0418@svcet.ac.in	$2b$12$upOQEWHwNh4wB1md5/r49.Usc8wXkmbFYHdH4peeC48J4YbsJXvV6	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1810	koodalarasi25tp0419@svcet.ac.in	$2b$12$zJNLxfFgUQQJ4PKHwR7CQelHUzUaDf8Eqxitv.VTcxBQVpFG1ud.i	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1811	krishnakumar25tp0420@svcet.ac.in	$2b$12$npSgSMcJudm5v6QidQ25MOpWu//tC.wKhuNyT2IcgaadKLX4hjgUe	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1812	logeshwaran25tp0421@svcet.ac.in	$2b$12$UmNObWMhV8AMm1qd5x3Xo.rsxLS.XkrxHmEfAj71hdFlgohsnvhwG	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1813	madhumitha25tp0422@svcet.ac.in	$2b$12$c1SxHNFdltgtppxV.2B8R.cVjCPrAs5DjiwG6DfNV00cP0W2kt7ke	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1814	mahdiyahtahseen25tp0423@svcet.ac.in	$2b$12$N3Ieu4DOWcquGNtzDp6itetpHEb29IFirVatD8oiVbiGFgZBoESYu	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1815	ooviya25tp0425@svcet.ac.in	$2b$12$bPgh2RU8zm0o2m.PzCN9TOUYhbxEphFvcgd704h2EjDxTZD787rYO	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1816	oviya25tp0426@svcet.ac.in	$2b$12$EOmVfrDc.K.rRfHTbIgTL.ZtwZqYO0Lewc9umt9hudk1WCfWeGMya	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1817	prathika25tp0427@svcet.ac.in	$2b$12$4A28R4rb0OMwi4T8c5VIm.jiAKNF83gQ8Z2u7SyxzyR5..NAQNKni	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1818	praveenkumar25tp0428@svcet.ac.in	$2b$12$m2WgyZilkvHWnPbaNJq7VuwGPoqrOLYRjg1Koqb37nAIzuczRksOy	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1819	pravinkumar25tp0429@svcet.ac.in	$2b$12$OMekOkIbAw8TIHF5aEpTC.zKGk38Js0YN3YW/ol/BF4Fof.T2RNp.	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1820	punidha25tp0430@svcet.ac.in	$2b$12$fF.XsyiRbKMCW4OvuHh3quV/oE/uejHLSybG/APvfQC1UqNnsX4y.	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1821	rajapriyan25tp0431@svcet.ac.in	$2b$12$KGbrpycNzKN5Kzuf1X6xwecrEGIdqCDVFtpixSD8fJpO4p2EwcepC	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1822	rokesh25tp0432@svcet.ac.in	$2b$12$IiQhCdwMCnk2IDjnPpNNtePpKAh.6liw/iVPBdQwIs9UL6ctgqVoC	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1823	sadhana25tp0433@svcet.ac.in	$2b$12$QX/.yfhdHCgttZYES69oV.Q2vMvD3IPfro3EWe83g2sR0Kem2fT/u	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1824	sanjay25tp0434@svcet.ac.in	$2b$12$tbM4rAMbHHQX1x1J7YDSVOoLn1puYCkd8X3d4n3am8CysFQuzeOjS	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1825	sarathraj25tp0435@svcet.ac.in	$2b$12$UHecDpjAgwaHlL1jrfLIMe14Ywc1g7mczYJ5xE36NE.o17QlQ4lpu	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1826	sarathi25tp0436@svcet.ac.in	$2b$12$2zWzxerbz2QdOKSEM1aI1.b.0HmMOcEihcUwJzuI4248F7KYfqH8a	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1827	sarika25tp0437@svcet.ac.in	$2b$12$FWwYTSNDgKT8KTVeflmeSuNh4/yuj7jfsDrz/pMuPjHvlB3zEz0EK	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1828	shameema25tp0438@svcet.ac.in	$2b$12$fyYf0Wa7vYYOAp60dq90hu5CJzYBp7DV9XKz7knhmb2cqcqQyj1iy	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1829	sibiraj25tp0439@svcet.ac.in	$2b$12$QAebaI7GrCBl/YQ0Hkbp5.53wwRW1F9ZvBaLdJ.alAWKXxhdrsikG	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1830	sowmiya25tp0440@svcet.ac.in	$2b$12$Sc3Y4F3RrfoA1UhWudcUj.cyU2Euai8W3LVuEcTNzMPrZc07QalDW	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1831	subalakshmi25tp0441@svcet.ac.in	$2b$12$t4pIb8FgG5wXnzLqzYRHXel81AroQ6w9vqes8qsPm4FCz4RKMJjCa	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1832	subiksha25tp0442@svcet.ac.in	$2b$12$CMbXq4Fyto7FjGDN0EPrUejqt2oMlQWGvmAl65GayomMLkBu/0GHG	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1833	sudharshan25tp0443@svcet.ac.in	$2b$12$9xpaaNQZW6VE3d/SvobB2uVF6ddBBk1bY3cqeiE94R9NEGpeo0UAS	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1834	swathy25tp0444@svcet.ac.in	$2b$12$7yr2bX02dIvAM4O0bfZlxOOvgUdlpKziCcaWuwleXetf9SjxrL1Q.	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1835	tarshini25tp0445@svcet.ac.in	$2b$12$a/GRJUhTKCvwhLXzPNJ3aeu/UP.1jd45uEE/7hPNipCpzIkSVmwqq	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1836	vishalini25tp0446@svcet.ac.in	$2b$12$ehL7zaF7MgKpDwdsgZ3otO6ohASQSc3KXiSsKA7PHpl6sJuAGd5D6	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1837	yuvasri25tp0447@svcet.ac.in	$2b$12$FyFmbD6HArZrNKsqdNxcz.FBFUTmjNkNykLnFj4syQvxXuoldYizS	STUDENT	t	2026-07-22 11:21:31.778737+05:30	\N
1838	anbuselvan25tk0051@svcet.ac.in	$2b$12$NU6MrZSceaoUeba8sMEsNOaveYhUwiIV4KRVo9aTIxnFLoy4ErVw.	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1839	deepika25tk0052@svcet.ac.in	$2b$12$EJf3Eew6lyL7BWH5s0vCFuTF4w6cyI4N3LtJxr9oSEOj9GrbEhre.	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1840	jaiakash25tk0053@svcet.ac.in	$2b$12$UrO2E1crOgp0.tr28J26xOxks3H0Uxs/7V1Z.CqjD9Y8kjvv8.YBa	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1841	kamelesh25tk0054@svcet.ac.in	$2b$12$BjUnNayMaj0rsNVfTWOhj.NJvtSp0mKxbY8XG0.Rrg8zL/5Ii9QSC	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1842	kishore25tk0055@svcet.ac.in	$2b$12$wCJ3uFfT1FgQq0ElCjrT4eRac6acDzsesezLJzz56pq69GhEHaE4i	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1843	koushik25tk0056@svcet.ac.in	$2b$12$r973iD7DkscqHLhuXsECaOwFiRhu3051juRBIFcS5POwRfpBqPu8y	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1844	lalitkishore25tk0057@svcet.ac.in	$2b$12$O0MEqstKsBR/OKshD5W39uGcLMBvwK1l4vdWXVKGqrcEzcgDnsU5e	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1845	mohesh25tk0058@svcet.ac.in	$2b$12$JrYSNQ77fd0VO6tn6g8nNeRRxseQnAMJR/q8KUf6nl82svn2dP1VC	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1846	navinkumar25tk0059@svcet.ac.in	$2b$12$ywYYZtwyeMSzBvPPsK8M6uL7ZQDWXTGg5O..CfrDkoy9bd8WoKbgm	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1847	nethra25tk0060@svcet.ac.in	$2b$12$u8YQymF6az7sTIGaUhN4r.5ry2LIJCKXCMJu09gwFdahahFd3uJhK	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1848	pavithiran25tk0061@svcet.ac.in	$2b$12$9/sz3CoYYpqlkeiyI0B3RO9BYJbg4ToMiXskgo2JnmazE2jNT8VQm	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1849	pooja25tk0062@svcet.ac.in	$2b$12$mkPTmq1Yz1EZK2OpaZf1L.FfF8K1m8uq9HNog8O2ploa8qcf1WKGC	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1850	raghasree25tk0063@svcet.ac.in	$2b$12$SZDHpyHCANbYO985Ee3geOIFoqPYf.Ud50.uaYKcNN2eQxme9sLuK	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1851	ravichandiran25tk0064@svcet.ac.in	$2b$12$zFpvohvsG0vQGL2sni6NHuEyLssifS9so3WHqnhSbdQFW3B.VeIx.	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1852	sanjay25tk0065@svcet.ac.in	$2b$12$r81ejplJglBMEj/i4hExqevsTATz0qrSy3JzGrwYvSn/2XKkcjT9G	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1853	sasikumar25tk0066@svcet.ac.in	$2b$12$6UpvMrIg93G/sIBiz1qxoeeci8XmQ3LXLa5oqBtoynY5rnj4eZCc.	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1854	sheikimran25tk0067@svcet.ac.in	$2b$12$iFyaHGEuLR4g1T9un/WfY.j2hE3lDnVXemRLHosIkTyXAGmvj0yq2	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1855	suresh25tk0068@svcet.ac.in	$2b$12$6NU/Mgp.CVIICug87WZNee4OwxkQOsE4YeSQIcsNTD47Lr3jpYN/2	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1856	thenmozhi25tk0069@svcet.ac.in	$2b$12$QSohoYkoeZeF9.UIzGSB5O6cuhMRL5WhIZ3Wb.9QCK4I0pby9.fGa	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1857	thrisha25tk0070@svcet.ac.in	$2b$12$t/pYgBPBlyVbgtB2s0iNJ.wVNbHMxJXpe2q/CM3ZjqLOcBVdTI3j.	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1858	venkateshwaran25tk0071@svcet.ac.in	$2b$12$Uuv4qzmfT7XrCHE/r37KoOA04bJppvRoEwT9OryXFGasi.wepiSB6	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1859	vijay25tk0072@svcet.ac.in	$2b$12$L/TUBW/qei/T7CRJWsb48e6nUFbpljsD1lt9xGNd5Q2jdog1qmm6.	STUDENT	t	2026-07-22 11:21:56.354334+05:30	\N
1860	magimairaj@svcet.ac.in	$2b$12$MEP/b4iiONwnm4p9D3U.Du9DDOTBYPMVRs0ZrsKhuo.Q8PyIPfAMy	FACULTY	t	2026-07-22 13:48:43.079821+05:30	\N
1861	ravi.indranmech@svcet.ac.in	$2b$12$/2gSs29rE1nGWG/LwQ0urODDIbnr6SqJPLSLcIQo976orWLFb7dKm	FACULTY	t	2026-07-22 13:48:43.079821+05:30	\N
1862	karthikeyan.v@svcet.ac.in	$2b$12$R0WMWm0z8..sRqJAxwBKtOzuLPnhN7TELx0tWWeMQ6aLxKyizbqiu	FACULTY	t	2026-07-22 13:48:43.079821+05:30	\N
1863	r.kamal.nathan@svcet.ac.in	$2b$12$spt8yCFnNFG07/QdnREUE.qA17mKZIrMr4L5.QmdydDLvsLkiFt2u	FACULTY	t	2026-07-22 13:48:43.079821+05:30	\N
1864	palanivel.g14@svcet.ac.in	$2b$12$aCsMGFRVLDaJ8Lttqc0EBuP4Q6RUjYjU4iOerhvaf7m/1LoaESrb6	FACULTY	t	2026-07-22 13:48:43.079821+05:30	\N
1865	manikandan.ap@svcet.ac.in	$2b$12$U.F6z54UqXN3ZU8bOOsMM.uI7nYDgLEkeno5BtIGlGF.GappmbLo6	FACULTY	t	2026-07-22 13:48:43.079821+05:30	\N
1866	hod.bme@svcet.ac.in	$2b$12$iACK.piyZxCzeiic6MJ/n.Dm1NRUiOa0uBKsVLOt95Ck3x2apnSEG	FACULTY	t	2026-07-22 13:54:30.658745+05:30	\N
1867	venkedesh@svcet.ac.in	$2b$12$P2NGt5dNoVTugUSwpkgYPOxra/1Vu/H4dtVppDMPvpf3Xg95hOlYe	FACULTY	t	2026-07-22 13:54:30.658745+05:30	\N
1868	rajaianushbme@svcet.ac.in	$2b$12$xt47B.b97MwGr.fXgX0XSeNh7L2q/i/XeDMFXlpLc/5pirRtTWF2G	FACULTY	t	2026-07-22 13:54:30.658745+05:30	\N
1869	sowmiya@svcet.ac.in	$2b$12$QorLqrX5L41K5VDGLegQSOK6441dLlSa5DIonktqyJN18JSPtkqnO	FACULTY	t	2026-07-22 13:54:30.658745+05:30	\N
1870	kavinilavu06@svcet.ac.in	$2b$12$wjOn.bwc/vsJDSTi6g9JR.QBBBB3jdkjoXZYhTZCq.rGSEi0DZ6KC	FACULTY	t	2026-07-22 13:54:30.658745+05:30	\N
1871	kaviya01@svcet.ac.in	$2b$12$EoBBx1uNjpNEUfYTuVUgdOUMpVYeqfE4z8g9gcfcQGr8fMstTfPUu	FACULTY	t	2026-07-22 13:54:30.658745+05:30	\N
1872	kirubabme@svcet.ac.in	$2b$12$g54yKHKw8yP.Tps1qlBdZeLP40D9VjrzhQmbv0cUpMbIAy/e0/2Xq	FACULTY	t	2026-07-22 13:54:30.658745+05:30	\N
1873	ganesan@svcet.ac.in	$2b$12$hQNf5bgK/Q4kTYwWaixVU.RdMuDL8xqkt4DD/JmozIHBNP0vTPs8m	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1874	sathyavenkatesan@svcet.ac.in	$2b$12$Qcxxz0rZPTOwPtU0wYugVOJFNlW5mx7KAU/arJe8wCKvuAwcu474W	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1875	kavitha@svcet.ac.in	$2b$12$j41aAAtKampdcTikJGoZw.JdhqMC4OzI/T6k9jZ66YC3CmyOPDtdK	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1876	jsundarc@svcet.ac.in	$2b$12$evqEA2mJjWE8.hqR128WK./Akss7Yu1svcfyQQIfUsNpO7p8DTOPq	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1877	arulmozhisathya@gmail.com	$2b$12$wS7m99xmPnz7cz2QOOIJRudQh64pmkuzi6VYSQw1QyGEGMW0G34x6	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1878	thirumarran2022@svcet.ac.in	$2b$12$CgEj61RAqGFx2OMjP6byt.1eBGvQKaCrbE4yHl1K00F8yJ1JzzN02	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1879	mythuwinmile@svcet.ac.in	$2b$12$.9n2kcGVEkiJBwd9MveSFeZwa.RDLfDsOXd6rpYdr/3Xs33MmNHtW	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1880	shiamalaphysics@svcet.ac.in	$2b$12$mJmjnzdsZY2gL1o1o2tgS.lirbkH.pU8sefepXubT.T3O83roMNBS	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1881	gandhivikash@svcet.ac.in	$2b$12$cidCOnLjxV8GRH/0RNr0d.MeM08vVGjnbDpvnIb/nOhwXvq8qPB4W	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1882	ilamathi@svcet.ac.in	$2b$12$ZRzhsx2NgyiSkBcKjA8MrekqA9arG7hXNZCMsRKKD1DwStRYCI6Ku	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1883	lakshmipriya@svcet.ac.in	$2b$12$GQYHmHbPNy/zzmP67LlMFuc0XJjwJkjfBaBOM8VHpZJU5s9Jse.Ki	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1884	neeladevi@svcet.ac.in	$2b$12$ZZnm5pn9Zb0dt/5ClODjSedrjPpV7RyMhHRA4XHxnhEDbLeY1GfIK	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1885	gugansharika@svcet.ac.in	$2b$12$Q0byFRbVMq3FY7Gz19ZJiOtODoESmdwmxd2Nifs2bTLpHM5RqnCfq	FACULTY	t	2026-07-22 14:14:01.926516+05:30	\N
1886	accountant@svcet.edu	$2b$12$4vskM/8cglvKwd8iVPIYmufPTdOTC9OI1lJ1OYm4.0/Ckfhg3.dCi	ACCOUNTANT	t	2026-07-22 15:02:10.487987+05:30	\N
1633	vijayalakshmi24td0857@svcet.ac.in	$2b$12$Si8mdB2hEdls20gvOJitOOqMRXKOAb07q5AR7DmBXYsMZtA/OM9Qa	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-22 15:33:17.152257+05:30
1559	guhan24td0781@svcet.ac.in	$2b$12$dYOwCQHgAVQwx53TQvCbNe1KyEPg2xv3KrSHCbg5mYntTBJNQnCBW	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 14:52:01.152035+05:30
1724	sakthi25td0676@svcet.ac.in	$2b$12$EyDBjUyue8oVBt5Y2Lgxo.Jg6hVrd0SvJcq4RKpeNpKNQx8t6uldq	STUDENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 14:58:24.973383+05:30
1606	sakkeenabegam24td0829@svcet.ac.in	$2b$12$2l1Q6vkOlhlgNIQieQ.4p.j7fTBaaI9P71YV8UrRhkGx/bt86pqYq	STUDENT	t	2026-07-21 16:25:56.664347+05:30	2026-07-23 15:10:10.493927+05:30
1707	moizmurtazarangoonwala25td0659@svcet.ac.in	$2b$12$HcBBaaOYKCVmjr4DTDcwne6zT8goMm3CtRg.JWQLg8Bo/yJcvozJ.	STUDENT	t	2026-07-22 10:45:13.145749+05:30	2026-07-23 15:24:43.141793+05:30
1420	sowkanthini23td0725@svcet.ac.in	$2b$12$I8C8c6EAswUWj/qI6JYy6OYLHaFO.AWqZ7PXugUuTkS2UDMjAd6Im	STUDENT	t	2026-07-14 11:41:58.371248+05:30	2026-07-23 15:53:29.914697+05:30
1887	bavani25tj0051@svcet.ac.in	$2b$12$mTs7w6CScb9/.67za7SUmOWn6v9oqpJ9JrEK2eVADYJyhswWakFse	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1888	eunicejemima25tj0052@svcet.ac.in	$2b$12$Aw8vFNBJ8mcID1BZdFmW2eBHN60TGJ/OZHZbdUUzWb.J2CaFOr.0y	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1889	jayashree25tj0053@svcet.ac.in	$2b$12$zE2mXxHufWUV49p9ouaRGOigFXXCt32Dw7zYLeuvAdTWhtycVmZpu	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1890	kavya25tj0054@svcet.ac.in	$2b$12$cYZijZIVYhbgUa5f7FApfOKA1sGWcVyDrTDgf82WdCcs8DtrTm1.2	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1891	keerthana25tj0055@svcet.ac.in	$2b$12$cDGbMnhcWh6nbB0fMtiBheg2FAkLy2DPwQuyA4.FToqJosPm31S.2	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1892	maheswari25tj0056@svcet.ac.in	$2b$12$vSrAJcIRzgxmKx50mwkXkurflxNbF3cLIybxc/KO70JnW.rjZaJVi	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1893	mohammedimran25tj0057@svcet.ac.in	$2b$12$3tvzAuCDuHfiNVqqHmU7Vej754/MBCazOsVrYhLM/86yhx345z9TS	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1894	nandhini25tj0058@svcet.ac.in	$2b$12$nJRj2f85jQEky9o612yGOOQG.CPkkB0Iwv8NTERnSUrm2RelRwxHe	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1895	oviya25tj0059@svcet.ac.in	$2b$12$ziuzw3YfUq303YGLcCK2HORHLezVCQqlU3cOwZxSTIg3ayq9P0O3e	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1896	pavithra25tj0060@svcet.ac.in	$2b$12$0pM2Dn9sbD7cE2vk.E6f4OSUiLfSS5AtH/3jkD4UMWuhKSIKkfK0K	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1897	priyadharshini25tj0061@svcet.ac.in	$2b$12$Jgb1kBW3C6UzJ6Ws6E3NsOWWi3ZQUPkIalvP2MVV6WcPeZ1QC45xW	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1898	ragashri25tj0062@svcet.ac.in	$2b$12$QfMF21QJsMdgXSmXyrnuuuolGyrRe3VyxeiJMeg4/nlYlIrDecQda	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1899	reema25tj0063@svcet.ac.in	$2b$12$L.aj021Jbumv2X5z6poCLuSsOkN5MgI7kM5jD2GaXgurghZPzL9XS	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1900	rethishnath25tj0064@svcet.ac.in	$2b$12$.Y7kCv.ncOfEsRSZdgi8zeUd1tKYc6kjGkALeD.4BNjJzNH834u9y	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1901	rithickvasan25tj0065@svcet.ac.in	$2b$12$ppoAWbCzr6H6E8qJY/pxHOf6tOg5r5AyKODt2pZBiDe0dXSlC2WMC	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1902	rufena25tj0066@svcet.ac.in	$2b$12$acZulEoP0GoI/sKvyj6QkuaXbS6Qr8XYrzrfeQnX3DeSE0ixwMorG	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1903	shangari25tj0067@svcet.ac.in	$2b$12$P.rk9O/RIwPfy.xnrOmV..EZht5aer6PCcf.X/LbXHN1lWwuNlemq	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1904	sornarajeswari25tj0068@svcet.ac.in	$2b$12$bV0zIJKI41iMPU1r/HwNm.DucGc/xwMgYLFCb94Qjs169WvJdus8K	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1905	sridhar25tj0069@svcet.ac.in	$2b$12$Q/eB2a/L21Q8m8vxRtPnyOWVhBBYEunhvtbcAKTSmYEUYiR6JY3cW	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1906	subasree25tj0070@svcet.ac.in	$2b$12$8udrUAhjfldXsmmNQZYUw.hwSqOAeYF2GLpnSPPfEc/7Mw9.SYXbi	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1907	udhaya25tj0071@svcet.ac.in	$2b$12$Ey13AIW5vWnYq.M0DkvnmezNpMrA0jy3W6wf83aH6XjIGZ2eY8s9u	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1908	vishal25tj0072@svcet.ac.in	$2b$12$8Gf3tmuUVm6brIfZ6.ocGuqlsglkb4E0tygG10onzJ7pir3oNIeRe	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1909	vithiyasri25tj0073@svcet.ac.in	$2b$12$gzotCN2odMZosTKNkNizzufBjyspr1Komo9vtl5/etu.nCshdR74S	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1910	yoheswaran25tj0074@svcet.ac.in	$2b$12$wRIuWR00yYz4Xuv/2MiNvegnmk0PM/s2ZVOpl0oUREFSQkfL1sC0C	STUDENT	t	2026-07-24 10:23:51.570637+05:30	\N
1911	ajai24tc0551@svcet.ac.in	$2b$12$nGkM.uCzBQ6MkFaieDWUu.HiyLH98d8s1MUm26Ch7tJYBCTVf8Nom	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1912	ajay24tc0552@svcet.ac.in	$2b$12$g7uAc7aTyvo1c9Vs8NBKAOOud8roJxAm1JLXUJVbaqqcrb5KjXKsq	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1913	alex24tc0553@svcet.ac.in	$2b$12$pj.Ay9KqlIjmYw/3OcNytO2MRdRKw79dXc8hGB2Wgmm.1LKzbPOQm	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1914	aravind24tc0554@svcet.ac.in	$2b$12$1ZTd4oZsK75B4nHCqfuK1eBajcdiPUSJqRTkBwOIPEwbfGiZJSRXu	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1915	aravindh24tc0555@svcet.ac.in	$2b$12$JvDjG2tiPAgEqRi0UfkT.u1XqaQsjf8J4lLDcURBMf7Lmuy/YJSxq	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1916	balamurugan24tc0556@svcet.ac.in	$2b$12$RumwGGtxTROiypJkoCVT2u23vWQTCHsWt0SspQ3GalDHeHXtpoy.C	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1917	dayalan24tc0557@svcet.ac.in	$2b$12$K17UCxwr7VQvNSGY6UIaW.eoIbcbaSnFSByapGy5FVj8nCdOHuxqq	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1918	deepak24tc0558@svcet.ac.in	$2b$12$zbRDymSkwrGBPUrYZynjNuqfNrH6PC5rROcdNc.ei2.0jqWO7wpXO	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1919	dharshini24tc0559@svcet.ac.in	$2b$12$BD/J7pXIQFmb2EShosnYfenuGZiPf05cRzdzTME.HDQdTbN.3FF7O	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1920	dhineshbharathi24tc0560@svcet.ac.in	$2b$12$sx.ETA7M6shPuwd4KuZFGuCrUGtBNnz6uyatIhXa4FRFo6nF8efUa	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1921	dhivya24tc0561@svcet.ac.in	$2b$12$En.MKgKGQ0bKf4RifsO4UuBps8KqvdTBHpBnc1B/.SaKmNy43xXay	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1922	ganeshkumar24tc0562@svcet.ac.in	$2b$12$FUB2pmRJYAYjULo4pd69Cer34KQvjFeR/bZ.BBSSkcnGqna9sQW8C	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1923	giri24tc0563@svcet.ac.in	$2b$12$BHa6nKrn9TD/c.z3Q9wpp.IOzLfVdb88W94k86TM3brOQVghmgBBi	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1924	gowri24tc0564@svcet.ac.in	$2b$12$PMwOP6x/Zy/rizP0aCvDnetQ8yJXpf1U0DX3UQZ9mGdzGqiYPJhCm	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1925	harish24tc0565@svcet.ac.in	$2b$12$.n/Vz6OpzmBdbt5hKasrMugpDEupiYGOoEdPbT6AVcW7vymaoZgb2	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1926	harishraj24tc0566@svcet.ac.in	$2b$12$Z4YDSwgNRhoHKLsv69w7dOG5bZY0BxEsUsaA09h8IcnKNU/fsu4c2	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1927	jayasundarapandian24tc0567@svcet.ac.in	$2b$12$G1OO/tqksBxYe5egz8PEc.p/yVdn3qUtaDjE19u05vGBf4gvJa4Em	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1928	Johnson24tc0568@svcet.ac.in	$2b$12$Z3mABQkGIpAhtypL5qljYeU1R1tx9xcjtsJqP7TlaZl4lokb1V5Ja	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1929	kadhir24tc0569@svcet.ac.in	$2b$12$ExVqntY.wuwn1D.yq.vs5eaVqSXNEkYK08WGebNNQafGopOMerYIm	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1930	kalaivanan24tc0570@svcet.ac.in	$2b$12$CO/J4oZTi7NBItRbthtWPuvSGnee1uhRT4tLwgV85Ql28S0OUabMm	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1931	kaviya24tc0572@svcet.ac.in	$2b$12$Y.CKXOu2mKtwYBSd4C.DR.n9xkTberKZMwWX8KsG4M9/dDw9E6.w2	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1932	kishore24tc0573@svcet.ac.in	$2b$12$OhgvztqFR0VJ0JktgNLz5OgtEBM6h.lEbLxJiaRWw.HtU0FyLfgbG	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1933	laksitha24tc0574@svcet.ac.in	$2b$12$SrtgocJR9SrzjxtMvtctwegOCS0QXmaAfoaJI5PUnLeYB9IktcOoq	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1934	lokesh24tc0575@svcet.ac.in	$2b$12$f8/u1oyo3DPKl1UIg44CQONS1KnSAcL91C9t4lgDAPQ9krbrSarri	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1935	lokesh24tc0576@svcet.ac.in	$2b$12$3vtnlntd5v.zj/40sRxIo.Yc75mYuK/U5yarzZAIyO4gLGy/JXEKW	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1936	manikandan24tc0577@svcet.ac.in	$2b$12$BC9G7Tr1yshmUOcJpXqlr.4JM7JHQa29zJpqCTdmLaF2s.qgKJzvq	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1937	moshika24tc0579@svcet.ac.in	$2b$12$4wBr3FDQ82WkUKnHifR8hOQhzXn82f24hM55Uj4MFo1KALoEMtoeW	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1938	mouhamedmoosa24tc0580@svcet.ac.in	$2b$12$UbLU7aw/rjbN2P8s4w3CF.Zj1W/zdvhgrlMoKBDQwkNCokc1YXXi2	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1939	nivedha24tc0581@svcet.ac.in	$2b$12$Mr.PF9rkeyA3Nr1h933ARufNvC7EVD5AP10.bRA5X/UJNzSh1ZUMe	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1940	pavithran24tc0582@svcet.ac.in	$2b$12$vDSnHmXprKwnbl5uF6VTR.3EKH1XjlKjueGFG2htdVPYZHQ.P8xty	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1941	prabha24tc0583@svcet.ac.in	$2b$12$skz7tIcRBu4RbdxEQreUJuqWxraZH.ZfeAtO9Xx9c4/QKOq06n9LK	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1942	prathapan24tc0584@svcet.ac.in	$2b$12$zeoKlf.HRu5pYWO1//if6.ufiANwWH8IwOxSxSdRtgDDCPaaNtwxy	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1943	pugazhendhi24tc0585@svcet.ac.in	$2b$12$8nkUjjLIPHRzvLq38IfCMe3MDk8YgN0ISAd/lZxUZBPBYrl3EkVZW	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1944	ragavarshini24tc0586@svcet.ac.in	$2b$12$n8KHB/Jj5fKmqF4SqchSDuvhDU0Wnnf79JKsyQck.6Qc.H46L36Eq	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1945	raghulganesh24tc0587@svcet.ac.in	$2b$12$TN30guOB3.1mg.Ckhx3ojuEmqgMnmCwBD1KCaaoCSQgKOfWWrbx9W	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1946	rajalatchoumy24tc0588@svcet.ac.in	$2b$12$FbrtlURUQcCqXNRxS51lFublf3p9kR6C4Csyk.3pL7OZQomyHVEKO	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1947	ramkumar24tc0589@svcet.ac.in	$2b$12$fSDZDtT4e.XzLu0cj.tjx.8DQsZnM6f1xHIrRjzm.jg1QitAEKI9W	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1948	rathimeena24tc0590@svcet.ac.in	$2b$12$fjvrrxAWLafRElYCFgtt7OP1zMfmWD/57M6Vq.jPJL8i53ursOfcW	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1949	sakthiraman24tc0591@svcet.ac.in	$2b$12$EvDJL0xQc0piAoWpffDEIeJKZ/qbtrnWMkot9qW/kbK6.uBXpTymy	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1950	sanjeevprasath24tc0592@svcet.ac.in	$2b$12$lpZkBRfwgd9LmsAVZcr8dOhAWj0E0AuBzD.1h4wV7GeM9HiuC7UEK	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1951	saranpriya24tc0593@svcet.ac.in	$2b$12$z822Q8XKmK4meWVWTdIgcuvv.IMPSyHWtEmNNvx5ax.KaH3O05pA2	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1952	saranraj24tc0594@svcet.ac.in	$2b$12$MKF2PHt1zxaEoUqesXe8YOJ1FjMvnGZRW/wQLs3pXGrJGIamctgsW	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1953	sathishkumar24tc0595@svcet.ac.in	$2b$12$2GdtRelRqElGRfzA/sGxq./QBIb2OCp2Zhg/OPIM5aMGmiz2dxGQW	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1954	shanmuganathan24tc0596@svcet.ac.in	$2b$12$WHFDmW3VwC5q4wYcx2TT9eK92fdU8YHJvcU5u2o7O4VHJv3wlyx1W	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1955	sharmila24tc0597@svcet.ac.in	$2b$12$1vCmJyDxNSbEneVEy/IxmeZ4nIpqJ/zeFsDOlimYwBRoOErovNweW	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1956	shinakbagam24tc0598@svcet.ac.in	$2b$12$mJ22nJzyuCk0CKA6ok3GUOLWrT7pMetoWWrTP/kLdmbar0JNa58Ee	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1957	siddharth24tc0599@svcet.ac.in	$2b$12$HWT6A8vb9kE/w1eb3NtrWOInumQmUbw9K3eeEMw7gSQIdKh9t7jRC	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1958	sivaraj24tc0600@svcet.ac.in	$2b$12$sOwFbBiAobPtGCl2R.39f.D0FuREntsKXf/eJYmEGK0lnhf/2J21W	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1959	subiksha24tc0601@svcet.ac.in	$2b$12$Qk38mCnMD5JcBMqhX/ZLBOYC9EzNd4zrYUtHjEIiymVnUxaxknbVq	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1960	suresh24tc0602@svcet.ac.in	$2b$12$2HUAPt8ExKwcq3vKKgiyZu2VB.gLPkf5eK6NBPzzbBm67DXZE7OrK	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1961	sushmitha24tc0603@svcet.ac.in	$2b$12$cQ.S9zPsEVIVQ6WZWjQKdOtPaZmBq02.LC6BnYmlZr.RSi1B8uZFi	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1962	vignesh24tc0604@svcet.ac.in	$2b$12$Dxzk/h1Da5SQ.YWnOP5oZe67Y5OvaF4voZJ6zN8tZtPTQ4rdjYbJ6	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1963	yasararafath24tc0605@svcet.ac.in	$2b$12$ojrY3cp89qGL.UNnshQhdOIjGFFwALU9gW1.JqeAasKPTuhsNMCM.	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1964	yogapriya24tc0606@svcet.ac.in	$2b$12$BGG/sGXGF3jC9/icXdJppe9VNeRRHM9DPFrSao1mmLG3.QP4SCEcC	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
1965	yuvasri24tc0607@svcet.ac.in	$2b$12$v3a8qAdrKr3wodAyFWDk6.x/3zEyFOZjuImdjGu4MfOsz90Sf/JK.	STUDENT	t	2026-07-24 10:53:40.338865+05:30	\N
\.


--
-- Data for Name: whatsapp_sessions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.whatsapp_sessions (phone_number, language, current_menu) FROM stdin;
\.


--
-- Name: advising_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.advising_logs_id_seq', 4, true);


--
-- Name: alumni_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alumni_id_seq', 440, true);


--
-- Name: announcements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.announcements_id_seq', 11, true);


--
-- Name: assignment_grades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.assignment_grades_id_seq', 86, true);


--
-- Name: attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.attendance_id_seq', 1926, true);


--
-- Name: authorities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.authorities_id_seq', 8, true);


--
-- Name: compensation_registry_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.compensation_registry_requests_id_seq', 3, true);


--
-- Name: course_assignment_units_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_assignment_units_id_seq', 53, true);


--
-- Name: course_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_assignments_id_seq', 185, true);


--
-- Name: course_plan_topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_plan_topics_id_seq', 216, true);


--
-- Name: course_plans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.course_plans_id_seq', 7, true);


--
-- Name: courses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.courses_id_seq', 155, true);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_id_seq', 10, true);


--
-- Name: discipline_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.discipline_records_id_seq', 62, true);


--
-- Name: enrollments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.enrollments_id_seq', 12, true);


--
-- Name: faculty_attendance_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_attendance_id_seq', 1345, true);


--
-- Name: faculty_duty_arrangements_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_duty_arrangements_id_seq', 125, true);


--
-- Name: faculty_gate_passes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_gate_passes_id_seq', 9, true);


--
-- Name: faculty_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_id_seq', 115, true);


--
-- Name: faculty_leave_balances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_leave_balances_id_seq', 72, true);


--
-- Name: faculty_leave_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.faculty_leave_requests_id_seq', 84, true);


--
-- Name: fee_structures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fee_structures_id_seq', 1, false);


--
-- Name: gate_passes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gate_passes_id_seq', 39, true);


--
-- Name: grades_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.grades_id_seq', 484, true);


--
-- Name: holidays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.holidays_id_seq', 3, true);


--
-- Name: lab_marks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lab_marks_id_seq', 1, false);


--
-- Name: late_entry_notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.late_entry_notifications_id_seq', 73, true);


--
-- Name: late_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.late_records_id_seq', 71, true);


--
-- Name: leave_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_requests_id_seq', 1, false);


--
-- Name: lms_resources_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lms_resources_id_seq', 12, true);


--
-- Name: mentor_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mentor_assignments_id_seq', 191, true);


--
-- Name: mentoring_meetings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mentoring_meetings_id_seq', 1, true);


--
-- Name: msg_conversations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.msg_conversations_id_seq', 21, true);


--
-- Name: msg_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.msg_messages_id_seq', 30, true);


--
-- Name: notification_views_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_views_id_seq', 348, true);


--
-- Name: password_reset_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.password_reset_requests_id_seq', 5, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 85, true);


--
-- Name: restricted_holidays_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.restricted_holidays_id_seq', 1, false);


--
-- Name: retest_marks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.retest_marks_id_seq', 33, true);


--
-- Name: sections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sections_id_seq', 50, true);


--
-- Name: seminars_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.seminars_id_seq', 86, true);


--
-- Name: student_fee_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_fee_assignments_id_seq', 312, true);


--
-- Name: student_leave_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_leave_requests_id_seq', 42, true);


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.students_id_seq', 1841, true);


--
-- Name: tally_ledger_mappings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tally_ledger_mappings_id_seq', 349, true);


--
-- Name: timetable_slots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.timetable_slots_id_seq', 719, true);


--
-- Name: unmapped_ledger_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.unmapped_ledger_entries_id_seq', 335, true);


--
-- Name: upload_batches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.upload_batches_id_seq', 1, false);


--
-- Name: user_page_views_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_page_views_id_seq', 24, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1965, true);


--
-- Name: advising_logs advising_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advising_logs
    ADD CONSTRAINT advising_logs_pkey PRIMARY KEY (id);


--
-- Name: alumni alumni_college_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumni
    ADD CONSTRAINT alumni_college_email_key UNIQUE (college_email);


--
-- Name: alumni alumni_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumni
    ADD CONSTRAINT alumni_pkey PRIMARY KEY (id);


--
-- Name: alumni alumni_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumni
    ADD CONSTRAINT alumni_user_id_key UNIQUE (user_id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: assignment_grades assignment_grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_grades
    ADD CONSTRAINT assignment_grades_pkey PRIMARY KEY (id);


--
-- Name: attendance attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_pkey PRIMARY KEY (id);


--
-- Name: authorities authorities_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorities
    ADD CONSTRAINT authorities_email_key UNIQUE (email);


--
-- Name: authorities authorities_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorities
    ADD CONSTRAINT authorities_employee_id_key UNIQUE (employee_id);


--
-- Name: authorities authorities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorities
    ADD CONSTRAINT authorities_pkey PRIMARY KEY (id);


--
-- Name: authorities authorities_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorities
    ADD CONSTRAINT authorities_user_id_key UNIQUE (user_id);


--
-- Name: compensation_registry_requests compensation_registry_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_registry_requests
    ADD CONSTRAINT compensation_registry_requests_pkey PRIMARY KEY (id);


--
-- Name: course_assignment_units course_assignment_units_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignment_units
    ADD CONSTRAINT course_assignment_units_pkey PRIMARY KEY (id);


--
-- Name: course_assignments course_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignments
    ADD CONSTRAINT course_assignments_pkey PRIMARY KEY (id);


--
-- Name: course_plan_topics course_plan_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_plan_topics
    ADD CONSTRAINT course_plan_topics_pkey PRIMARY KEY (id);


--
-- Name: course_plans course_plans_course_assignment_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_plans
    ADD CONSTRAINT course_plans_course_assignment_id_key UNIQUE (course_assignment_id);


--
-- Name: course_plans course_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_plans
    ADD CONSTRAINT course_plans_pkey PRIMARY KEY (id);


--
-- Name: courses courses_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_code_key UNIQUE (code);


--
-- Name: courses courses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (id);


--
-- Name: departments departments_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_code_key UNIQUE (code);


--
-- Name: departments departments_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_name_key UNIQUE (name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: discipline_records discipline_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_records
    ADD CONSTRAINT discipline_records_pkey PRIMARY KEY (id);


--
-- Name: enrollments enrollments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_pkey PRIMARY KEY (id);


--
-- Name: faculty_attendance faculty_attendance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_attendance
    ADD CONSTRAINT faculty_attendance_pkey PRIMARY KEY (id);


--
-- Name: faculty faculty_college_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_college_email_key UNIQUE (college_email);


--
-- Name: faculty_duty_arrangements faculty_duty_arrangements_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_duty_arrangements
    ADD CONSTRAINT faculty_duty_arrangements_pkey PRIMARY KEY (id);


--
-- Name: faculty faculty_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_employee_id_key UNIQUE (employee_id);


--
-- Name: faculty_gate_passes faculty_gate_passes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_gate_passes
    ADD CONSTRAINT faculty_gate_passes_pkey PRIMARY KEY (id);


--
-- Name: faculty_leave_balances faculty_leave_balances_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_balances
    ADD CONSTRAINT faculty_leave_balances_pkey PRIMARY KEY (id);


--
-- Name: faculty_leave_requests faculty_leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_requests
    ADD CONSTRAINT faculty_leave_requests_pkey PRIMARY KEY (id);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (id);


--
-- Name: faculty faculty_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_user_id_key UNIQUE (user_id);


--
-- Name: fee_structures fee_structures_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_structures
    ADD CONSTRAINT fee_structures_pkey PRIMARY KEY (id);


--
-- Name: gate_passes gate_passes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate_passes
    ADD CONSTRAINT gate_passes_pkey PRIMARY KEY (id);


--
-- Name: grades grades_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_pkey PRIMARY KEY (id);


--
-- Name: holidays holidays_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT holidays_date_key UNIQUE (date);


--
-- Name: holidays holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT holidays_pkey PRIMARY KEY (id);


--
-- Name: lab_marks lab_marks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_marks
    ADD CONSTRAINT lab_marks_pkey PRIMARY KEY (id);


--
-- Name: late_entry_notifications late_entry_notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_entry_notifications
    ADD CONSTRAINT late_entry_notifications_pkey PRIMARY KEY (id);


--
-- Name: late_entry_notifications late_entry_notifications_student_id_date_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_entry_notifications
    ADD CONSTRAINT late_entry_notifications_student_id_date_key UNIQUE (student_id, date);


--
-- Name: late_records late_records_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_records
    ADD CONSTRAINT late_records_pkey PRIMARY KEY (id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (id);


--
-- Name: lms_resources lms_resources_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lms_resources
    ADD CONSTRAINT lms_resources_pkey PRIMARY KEY (id);


--
-- Name: mentor_assignments mentor_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_assignments
    ADD CONSTRAINT mentor_assignments_pkey PRIMARY KEY (id);


--
-- Name: mentor_assignments mentor_assignments_student_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_assignments
    ADD CONSTRAINT mentor_assignments_student_id_key UNIQUE (student_id);


--
-- Name: mentoring_meetings mentoring_meetings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentoring_meetings
    ADD CONSTRAINT mentoring_meetings_pkey PRIMARY KEY (id);


--
-- Name: msg_conversations msg_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_conversations
    ADD CONSTRAINT msg_conversations_pkey PRIMARY KEY (id);


--
-- Name: msg_messages msg_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_messages
    ADD CONSTRAINT msg_messages_pkey PRIMARY KEY (id);


--
-- Name: notification_views notification_views_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_views
    ADD CONSTRAINT notification_views_pkey PRIMARY KEY (id);


--
-- Name: password_reset_requests password_reset_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_requests
    ADD CONSTRAINT password_reset_requests_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: program_outcomes program_outcomes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcomes
    ADD CONSTRAINT program_outcomes_pkey PRIMARY KEY (id);


--
-- Name: restricted_holidays restricted_holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restricted_holidays
    ADD CONSTRAINT restricted_holidays_pkey PRIMARY KEY (id);


--
-- Name: retest_marks retest_marks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retest_marks
    ADD CONSTRAINT retest_marks_pkey PRIMARY KEY (id);


--
-- Name: sections sections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_pkey PRIMARY KEY (id);


--
-- Name: seminars seminars_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seminars
    ADD CONSTRAINT seminars_pkey PRIMARY KEY (id);


--
-- Name: student_fee_assignments student_fee_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fee_assignments
    ADD CONSTRAINT student_fee_assignments_pkey PRIMARY KEY (id);


--
-- Name: student_leave_requests student_leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_requests
    ADD CONSTRAINT student_leave_requests_pkey PRIMARY KEY (id);


--
-- Name: students students_college_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_college_email_key UNIQUE (college_email);


--
-- Name: students students_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: students students_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_key UNIQUE (user_id);


--
-- Name: tally_ledger_mappings tally_ledger_mappings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tally_ledger_mappings
    ADD CONSTRAINT tally_ledger_mappings_pkey PRIMARY KEY (id);


--
-- Name: timetable_slots timetable_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable_slots
    ADD CONSTRAINT timetable_slots_pkey PRIMARY KEY (id);


--
-- Name: unmapped_ledger_entries unmapped_ledger_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unmapped_ledger_entries
    ADD CONSTRAINT unmapped_ledger_entries_pkey PRIMARY KEY (id);


--
-- Name: upload_batches upload_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload_batches
    ADD CONSTRAINT upload_batches_pkey PRIMARY KEY (id);


--
-- Name: assignment_grades uq_assignment_grade_student; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_grades
    ADD CONSTRAINT uq_assignment_grade_student UNIQUE (assignment_id, student_id);


--
-- Name: faculty_attendance uq_faculty_date; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_attendance
    ADD CONSTRAINT uq_faculty_date UNIQUE (faculty_id, date);


--
-- Name: student_fee_assignments uq_fee_assignment_student_sem_year; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fee_assignments
    ADD CONSTRAINT uq_fee_assignment_student_sem_year UNIQUE (student_id, semester, academic_year);


--
-- Name: fee_structures uq_fee_structure_dept_sem_year; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_structures
    ADD CONSTRAINT uq_fee_structure_dept_sem_year UNIQUE (department_id, semester, academic_year);


--
-- Name: lab_marks uq_lab_mark_assignment_student; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_marks
    ADD CONSTRAINT uq_lab_mark_assignment_student UNIQUE (course_assignment_id, student_id);


--
-- Name: payments uq_payment_voucher_ledger; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT uq_payment_voucher_ledger UNIQUE (voucher_no, ledger_name_raw);


--
-- Name: retest_marks uq_retest_grade_student; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retest_marks
    ADD CONSTRAINT uq_retest_grade_student UNIQUE (grade_id, student_id);


--
-- Name: seminars uq_seminar_student; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seminars
    ADD CONSTRAINT uq_seminar_student UNIQUE (course_assignment_id, student_id);


--
-- Name: user_page_views user_page_views_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_page_views
    ADD CONSTRAINT user_page_views_pkey PRIMARY KEY (id);


--
-- Name: user_page_views user_page_views_user_id_page_path_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_page_views
    ADD CONSTRAINT user_page_views_user_id_page_path_key UNIQUE (user_id, page_path);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_sessions whatsapp_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.whatsapp_sessions
    ADD CONSTRAINT whatsapp_sessions_pkey PRIMARY KEY (phone_number);


--
-- Name: idx_late_entry_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_late_entry_date ON public.late_entry_notifications USING btree (date);


--
-- Name: idx_late_entry_mentor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_late_entry_mentor ON public.late_entry_notifications USING btree (mentor_id);


--
-- Name: idx_late_entry_student_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_late_entry_student_date ON public.late_entry_notifications USING btree (student_id, date);


--
-- Name: idx_user_page_views_page_path; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_page_views_page_path ON public.user_page_views USING btree (page_path);


--
-- Name: idx_user_page_views_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_page_views_user_id ON public.user_page_views USING btree (user_id);


--
-- Name: ix_advising_logs_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_advising_logs_id ON public.advising_logs USING btree (id);


--
-- Name: ix_alumni_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_alumni_id ON public.alumni USING btree (id);


--
-- Name: ix_alumni_register_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_alumni_register_number ON public.alumni USING btree (register_number);


--
-- Name: ix_announcements_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_announcements_id ON public.announcements USING btree (id);


--
-- Name: ix_assignment_grades_assignment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_assignment_grades_assignment_id ON public.assignment_grades USING btree (assignment_id);


--
-- Name: ix_assignment_grades_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_assignment_grades_student_id ON public.assignment_grades USING btree (student_id);


--
-- Name: ix_attendance_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_attendance_id ON public.attendance USING btree (id);


--
-- Name: ix_authorities_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_authorities_id ON public.authorities USING btree (id);


--
-- Name: ix_compensation_registry_requests_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_compensation_registry_requests_id ON public.compensation_registry_requests USING btree (id);


--
-- Name: ix_course_assignments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_course_assignments_id ON public.course_assignments USING btree (id);


--
-- Name: ix_course_plan_topics_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_course_plan_topics_id ON public.course_plan_topics USING btree (id);


--
-- Name: ix_course_plans_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_course_plans_id ON public.course_plans USING btree (id);


--
-- Name: ix_courses_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_courses_id ON public.courses USING btree (id);


--
-- Name: ix_departments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_departments_id ON public.departments USING btree (id);


--
-- Name: ix_discipline_records_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_discipline_records_id ON public.discipline_records USING btree (id);


--
-- Name: ix_enrollments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_enrollments_id ON public.enrollments USING btree (id);


--
-- Name: ix_faculty_attendance_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_faculty_attendance_date ON public.faculty_attendance USING btree (date);


--
-- Name: ix_faculty_attendance_faculty_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_faculty_attendance_faculty_id ON public.faculty_attendance USING btree (faculty_id);


--
-- Name: ix_faculty_duty_arrangements_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_faculty_duty_arrangements_id ON public.faculty_duty_arrangements USING btree (id);


--
-- Name: ix_faculty_gate_passes_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_faculty_gate_passes_id ON public.faculty_gate_passes USING btree (id);


--
-- Name: ix_faculty_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_faculty_id ON public.faculty USING btree (id);


--
-- Name: ix_faculty_leave_balances_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_faculty_leave_balances_id ON public.faculty_leave_balances USING btree (id);


--
-- Name: ix_faculty_leave_requests_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_faculty_leave_requests_id ON public.faculty_leave_requests USING btree (id);


--
-- Name: ix_fee_structures_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_fee_structures_id ON public.fee_structures USING btree (id);


--
-- Name: ix_gate_passes_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_gate_passes_id ON public.gate_passes USING btree (id);


--
-- Name: ix_grades_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_grades_id ON public.grades USING btree (id);


--
-- Name: ix_holidays_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_holidays_date ON public.holidays USING btree (date);


--
-- Name: ix_lab_marks_course_assignment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_lab_marks_course_assignment_id ON public.lab_marks USING btree (course_assignment_id);


--
-- Name: ix_lab_marks_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_lab_marks_student_id ON public.lab_marks USING btree (student_id);


--
-- Name: ix_late_records_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_late_records_id ON public.late_records USING btree (id);


--
-- Name: ix_leave_requests_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_leave_requests_id ON public.leave_requests USING btree (id);


--
-- Name: ix_lms_resources_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_lms_resources_id ON public.lms_resources USING btree (id);


--
-- Name: ix_mentor_assignments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_mentor_assignments_id ON public.mentor_assignments USING btree (id);


--
-- Name: ix_mentoring_meetings_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_mentoring_meetings_id ON public.mentoring_meetings USING btree (id);


--
-- Name: ix_msg_conversations_hod_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_msg_conversations_hod_id ON public.msg_conversations USING btree (dean_id);


--
-- Name: ix_msg_conversations_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_msg_conversations_id ON public.msg_conversations USING btree (id);


--
-- Name: ix_msg_conversations_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_msg_conversations_student_id ON public.msg_conversations USING btree (student_id);


--
-- Name: ix_msg_messages_conversation_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_msg_messages_conversation_id ON public.msg_messages USING btree (conversation_id);


--
-- Name: ix_msg_messages_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_msg_messages_id ON public.msg_messages USING btree (id);


--
-- Name: ix_password_reset_requests_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_password_reset_requests_id ON public.password_reset_requests USING btree (id);


--
-- Name: ix_payments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_id ON public.payments USING btree (id);


--
-- Name: ix_payments_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_student_id ON public.payments USING btree (student_id);


--
-- Name: ix_payments_voucher_no; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_payments_voucher_no ON public.payments USING btree (voucher_no);


--
-- Name: ix_restricted_holidays_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_restricted_holidays_id ON public.restricted_holidays USING btree (id);


--
-- Name: ix_retest_marks_course_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_retest_marks_course_id ON public.retest_marks USING btree (course_id);


--
-- Name: ix_retest_marks_grade_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_retest_marks_grade_id ON public.retest_marks USING btree (grade_id);


--
-- Name: ix_retest_marks_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_retest_marks_student_id ON public.retest_marks USING btree (student_id);


--
-- Name: ix_sections_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_sections_id ON public.sections USING btree (id);


--
-- Name: ix_seminars_course_assignment_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_seminars_course_assignment_id ON public.seminars USING btree (course_assignment_id);


--
-- Name: ix_seminars_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_seminars_student_id ON public.seminars USING btree (student_id);


--
-- Name: ix_student_fee_assignments_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_student_fee_assignments_id ON public.student_fee_assignments USING btree (id);


--
-- Name: ix_student_fee_assignments_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_student_fee_assignments_student_id ON public.student_fee_assignments USING btree (student_id);


--
-- Name: ix_student_leave_requests_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_student_leave_requests_id ON public.student_leave_requests USING btree (id);


--
-- Name: ix_students_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_students_id ON public.students USING btree (id);


--
-- Name: ix_students_register_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_students_register_number ON public.students USING btree (register_number);


--
-- Name: ix_tally_ledger_mappings_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tally_ledger_mappings_id ON public.tally_ledger_mappings USING btree (id);


--
-- Name: ix_tally_ledger_mappings_ledger_name_raw; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_tally_ledger_mappings_ledger_name_raw ON public.tally_ledger_mappings USING btree (ledger_name_raw);


--
-- Name: ix_tally_ledger_mappings_student_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tally_ledger_mappings_student_id ON public.tally_ledger_mappings USING btree (student_id);


--
-- Name: ix_timetable_slots_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_timetable_slots_id ON public.timetable_slots USING btree (id);


--
-- Name: ix_unmapped_ledger_entries_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_unmapped_ledger_entries_id ON public.unmapped_ledger_entries USING btree (id);


--
-- Name: ix_unmapped_ledger_entries_voucher_no; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_unmapped_ledger_entries_voucher_no ON public.unmapped_ledger_entries USING btree (voucher_no);


--
-- Name: ix_upload_batches_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_upload_batches_id ON public.upload_batches USING btree (id);


--
-- Name: ix_upload_batches_upload_batch; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_upload_batches_upload_batch ON public.upload_batches USING btree (upload_batch);


--
-- Name: ix_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_users_email ON public.users USING btree (email);


--
-- Name: ix_users_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_users_id ON public.users USING btree (id);


--
-- Name: ix_whatsapp_sessions_phone_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_whatsapp_sessions_phone_number ON public.whatsapp_sessions USING btree (phone_number);


--
-- Name: advising_logs advising_logs_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advising_logs
    ADD CONSTRAINT advising_logs_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.faculty(id);


--
-- Name: advising_logs advising_logs_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.advising_logs
    ADD CONSTRAINT advising_logs_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: alumni alumni_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumni
    ADD CONSTRAINT alumni_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: alumni alumni_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alumni
    ADD CONSTRAINT alumni_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: announcements announcements_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: announcements announcements_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: announcements announcements_posted_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_posted_by_id_fkey FOREIGN KEY (posted_by_id) REFERENCES public.users(id);


--
-- Name: assignment_grades assignment_grades_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_grades
    ADD CONSTRAINT assignment_grades_assignment_id_fkey FOREIGN KEY (assignment_id) REFERENCES public.lms_resources(id) ON DELETE CASCADE;


--
-- Name: assignment_grades assignment_grades_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.assignment_grades
    ADD CONSTRAINT assignment_grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: attendance attendance_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: attendance attendance_marked_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_marked_by_id_fkey FOREIGN KEY (marked_by_id) REFERENCES public.faculty(id);


--
-- Name: attendance attendance_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.attendance
    ADD CONSTRAINT attendance_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: authorities authorities_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.authorities
    ADD CONSTRAINT authorities_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: compensation_registry_requests compensation_registry_requests_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_registry_requests
    ADD CONSTRAINT compensation_registry_requests_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id);


--
-- Name: compensation_registry_requests compensation_registry_requests_peer_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.compensation_registry_requests
    ADD CONSTRAINT compensation_registry_requests_peer_faculty_id_fkey FOREIGN KEY (peer_faculty_id) REFERENCES public.faculty(id);


--
-- Name: course_assignment_units course_assignment_units_course_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignment_units
    ADD CONSTRAINT course_assignment_units_course_assignment_id_fkey FOREIGN KEY (course_assignment_id) REFERENCES public.course_assignments(id) ON DELETE CASCADE;


--
-- Name: course_assignments course_assignments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignments
    ADD CONSTRAINT course_assignments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: course_assignments course_assignments_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignments
    ADD CONSTRAINT course_assignments_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id);


--
-- Name: course_assignments course_assignments_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_assignments
    ADD CONSTRAINT course_assignments_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: course_plan_topics course_plan_topics_course_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_plan_topics
    ADD CONSTRAINT course_plan_topics_course_plan_id_fkey FOREIGN KEY (course_plan_id) REFERENCES public.course_plans(id);


--
-- Name: course_plans course_plans_course_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.course_plans
    ADD CONSTRAINT course_plans_course_assignment_id_fkey FOREIGN KEY (course_assignment_id) REFERENCES public.course_assignments(id);


--
-- Name: courses courses_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: departments departments_hod_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_hod_id_fkey FOREIGN KEY (hod_id) REFERENCES public.faculty(id);


--
-- Name: discipline_records discipline_records_reported_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_records
    ADD CONSTRAINT discipline_records_reported_by_id_fkey FOREIGN KEY (reported_by_id) REFERENCES public.users(id);


--
-- Name: discipline_records discipline_records_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.discipline_records
    ADD CONSTRAINT discipline_records_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: enrollments enrollments_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: enrollments enrollments_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: enrollments enrollments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.enrollments
    ADD CONSTRAINT enrollments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: faculty_attendance faculty_attendance_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_attendance
    ADD CONSTRAINT faculty_attendance_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id) ON DELETE CASCADE;


--
-- Name: faculty_attendance faculty_attendance_leave_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_attendance
    ADD CONSTRAINT faculty_attendance_leave_request_id_fkey FOREIGN KEY (leave_request_id) REFERENCES public.faculty_leave_requests(id) ON DELETE SET NULL;


--
-- Name: faculty faculty_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: faculty_duty_arrangements faculty_duty_arrangements_leave_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_duty_arrangements
    ADD CONSTRAINT faculty_duty_arrangements_leave_request_id_fkey FOREIGN KEY (leave_request_id) REFERENCES public.faculty_leave_requests(id);


--
-- Name: faculty_duty_arrangements faculty_duty_arrangements_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_duty_arrangements
    ADD CONSTRAINT faculty_duty_arrangements_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: faculty_duty_arrangements faculty_duty_arrangements_substitute_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_duty_arrangements
    ADD CONSTRAINT faculty_duty_arrangements_substitute_faculty_id_fkey FOREIGN KEY (substitute_faculty_id) REFERENCES public.faculty(id);


--
-- Name: faculty_gate_passes faculty_gate_passes_dean_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_gate_passes
    ADD CONSTRAINT faculty_gate_passes_dean_id_fkey FOREIGN KEY (dean_id) REFERENCES public.authorities(id);


--
-- Name: faculty_gate_passes faculty_gate_passes_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_gate_passes
    ADD CONSTRAINT faculty_gate_passes_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id);


--
-- Name: faculty_gate_passes faculty_gate_passes_hod_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_gate_passes
    ADD CONSTRAINT faculty_gate_passes_hod_id_fkey FOREIGN KEY (hod_id) REFERENCES public.faculty(id);


--
-- Name: faculty_gate_passes faculty_gate_passes_om_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_gate_passes
    ADD CONSTRAINT faculty_gate_passes_om_id_fkey FOREIGN KEY (om_id) REFERENCES public.authorities(id);


--
-- Name: faculty_leave_balances faculty_leave_balances_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_balances
    ADD CONSTRAINT faculty_leave_balances_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id);


--
-- Name: faculty_leave_requests faculty_leave_requests_alternate_hod_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_requests
    ADD CONSTRAINT faculty_leave_requests_alternate_hod_faculty_id_fkey FOREIGN KEY (alternate_hod_faculty_id) REFERENCES public.faculty(id) ON DELETE SET NULL;


--
-- Name: faculty_leave_requests faculty_leave_requests_compensation_verifier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_requests
    ADD CONSTRAINT faculty_leave_requests_compensation_verifier_id_fkey FOREIGN KEY (compensation_verifier_id) REFERENCES public.users(id);


--
-- Name: faculty_leave_requests faculty_leave_requests_dean_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_requests
    ADD CONSTRAINT faculty_leave_requests_dean_approved_by_fkey FOREIGN KEY (dean_approved_by) REFERENCES public.authorities(id);


--
-- Name: faculty_leave_requests faculty_leave_requests_faculty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_requests
    ADD CONSTRAINT faculty_leave_requests_faculty_id_fkey FOREIGN KEY (faculty_id) REFERENCES public.faculty(id);


--
-- Name: faculty_leave_requests faculty_leave_requests_hod_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_requests
    ADD CONSTRAINT faculty_leave_requests_hod_approved_by_fkey FOREIGN KEY (hod_approved_by) REFERENCES public.faculty(id);


--
-- Name: faculty_leave_requests faculty_leave_requests_om_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_requests
    ADD CONSTRAINT faculty_leave_requests_om_approved_by_fkey FOREIGN KEY (om_approved_by) REFERENCES public.authorities(id);


--
-- Name: faculty_leave_requests faculty_leave_requests_principal_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty_leave_requests
    ADD CONSTRAINT faculty_leave_requests_principal_approved_by_fkey FOREIGN KEY (principal_approved_by) REFERENCES public.authorities(id);


--
-- Name: faculty faculty_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: fee_structures fee_structures_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fee_structures
    ADD CONSTRAINT fee_structures_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: gate_passes gate_passes_hod_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate_passes
    ADD CONSTRAINT gate_passes_hod_id_fkey FOREIGN KEY (hod_id) REFERENCES public.faculty(id);


--
-- Name: gate_passes gate_passes_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate_passes
    ADD CONSTRAINT gate_passes_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.faculty(id);


--
-- Name: gate_passes gate_passes_om_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate_passes
    ADD CONSTRAINT gate_passes_om_id_fkey FOREIGN KEY (om_id) REFERENCES public.authorities(id);


--
-- Name: gate_passes gate_passes_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gate_passes
    ADD CONSTRAINT gate_passes_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: grades grades_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: grades grades_graded_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_graded_by_id_fkey FOREIGN KEY (graded_by_id) REFERENCES public.faculty(id);


--
-- Name: grades grades_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.grades
    ADD CONSTRAINT grades_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: holidays holidays_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.holidays
    ADD CONSTRAINT holidays_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: lab_marks lab_marks_course_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_marks
    ADD CONSTRAINT lab_marks_course_assignment_id_fkey FOREIGN KEY (course_assignment_id) REFERENCES public.course_assignments(id) ON DELETE CASCADE;


--
-- Name: lab_marks lab_marks_graded_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_marks
    ADD CONSTRAINT lab_marks_graded_by_id_fkey FOREIGN KEY (graded_by_id) REFERENCES public.faculty(id) ON DELETE SET NULL;


--
-- Name: lab_marks lab_marks_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lab_marks
    ADD CONSTRAINT lab_marks_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: late_entry_notifications late_entry_notifications_approved_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_entry_notifications
    ADD CONSTRAINT late_entry_notifications_approved_by_id_fkey FOREIGN KEY (approved_by_id) REFERENCES public.faculty(id);


--
-- Name: late_entry_notifications late_entry_notifications_class_advisor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_entry_notifications
    ADD CONSTRAINT late_entry_notifications_class_advisor_id_fkey FOREIGN KEY (class_advisor_id) REFERENCES public.faculty(id);


--
-- Name: late_entry_notifications late_entry_notifications_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_entry_notifications
    ADD CONSTRAINT late_entry_notifications_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.faculty(id) ON DELETE SET NULL;


--
-- Name: late_entry_notifications late_entry_notifications_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_entry_notifications
    ADD CONSTRAINT late_entry_notifications_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: late_records late_records_recorded_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_records
    ADD CONSTRAINT late_records_recorded_by_id_fkey FOREIGN KEY (recorded_by_id) REFERENCES public.users(id);


--
-- Name: late_records late_records_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.late_records
    ADD CONSTRAINT late_records_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: leave_requests leave_requests_hod_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_hod_approved_by_fkey FOREIGN KEY (hod_approved_by) REFERENCES public.faculty(id);


--
-- Name: leave_requests leave_requests_mentor_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_mentor_approved_by_fkey FOREIGN KEY (mentor_approved_by) REFERENCES public.faculty(id);


--
-- Name: leave_requests leave_requests_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: lms_resources lms_resources_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lms_resources
    ADD CONSTRAINT lms_resources_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id);


--
-- Name: lms_resources lms_resources_uploaded_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lms_resources
    ADD CONSTRAINT lms_resources_uploaded_by_id_fkey FOREIGN KEY (uploaded_by_id) REFERENCES public.faculty(id);


--
-- Name: mentor_assignments mentor_assignments_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_assignments
    ADD CONSTRAINT mentor_assignments_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.faculty(id);


--
-- Name: mentor_assignments mentor_assignments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentor_assignments
    ADD CONSTRAINT mentor_assignments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: mentoring_meetings mentoring_meetings_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentoring_meetings
    ADD CONSTRAINT mentoring_meetings_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.faculty(id);


--
-- Name: mentoring_meetings mentoring_meetings_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mentoring_meetings
    ADD CONSTRAINT mentoring_meetings_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: msg_conversations msg_conversations_dean_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_conversations
    ADD CONSTRAINT msg_conversations_dean_id_fkey FOREIGN KEY (dean_id) REFERENCES public.authorities(id) ON DELETE CASCADE;


--
-- Name: msg_conversations msg_conversations_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_conversations
    ADD CONSTRAINT msg_conversations_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: msg_conversations msg_conversations_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_conversations
    ADD CONSTRAINT msg_conversations_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: msg_messages msg_messages_conversation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.msg_messages
    ADD CONSTRAINT msg_messages_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.msg_conversations(id);


--
-- Name: notification_views notification_views_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_views
    ADD CONSTRAINT notification_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: payments payments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: payments payments_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: program_outcomes program_outcomes_updated_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.program_outcomes
    ADD CONSTRAINT program_outcomes_updated_by_id_fkey FOREIGN KEY (updated_by_id) REFERENCES public.users(id);


--
-- Name: restricted_holidays restricted_holidays_created_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.restricted_holidays
    ADD CONSTRAINT restricted_holidays_created_by_id_fkey FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: retest_marks retest_marks_course_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retest_marks
    ADD CONSTRAINT retest_marks_course_id_fkey FOREIGN KEY (course_id) REFERENCES public.courses(id) ON DELETE CASCADE;


--
-- Name: retest_marks retest_marks_entered_by_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retest_marks
    ADD CONSTRAINT retest_marks_entered_by_id_fkey FOREIGN KEY (entered_by_id) REFERENCES public.faculty(id) ON DELETE SET NULL;


--
-- Name: retest_marks retest_marks_grade_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retest_marks
    ADD CONSTRAINT retest_marks_grade_id_fkey FOREIGN KEY (grade_id) REFERENCES public.grades(id) ON DELETE CASCADE;


--
-- Name: retest_marks retest_marks_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.retest_marks
    ADD CONSTRAINT retest_marks_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: sections sections_class_advisor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_class_advisor_id_fkey FOREIGN KEY (class_advisor_id) REFERENCES public.faculty(id);


--
-- Name: sections sections_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sections
    ADD CONSTRAINT sections_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: seminars seminars_course_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seminars
    ADD CONSTRAINT seminars_course_assignment_id_fkey FOREIGN KEY (course_assignment_id) REFERENCES public.course_assignments(id) ON DELETE CASCADE;


--
-- Name: seminars seminars_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.seminars
    ADD CONSTRAINT seminars_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id) ON DELETE CASCADE;


--
-- Name: student_fee_assignments student_fee_assignments_fee_structure_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fee_assignments
    ADD CONSTRAINT student_fee_assignments_fee_structure_id_fkey FOREIGN KEY (fee_structure_id) REFERENCES public.fee_structures(id);


--
-- Name: student_fee_assignments student_fee_assignments_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_fee_assignments
    ADD CONSTRAINT student_fee_assignments_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: student_leave_requests student_leave_requests_class_advisor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_requests
    ADD CONSTRAINT student_leave_requests_class_advisor_id_fkey FOREIGN KEY (class_advisor_id) REFERENCES public.faculty(id);


--
-- Name: student_leave_requests student_leave_requests_hod_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_requests
    ADD CONSTRAINT student_leave_requests_hod_id_fkey FOREIGN KEY (hod_id) REFERENCES public.faculty(id);


--
-- Name: student_leave_requests student_leave_requests_mentor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_requests
    ADD CONSTRAINT student_leave_requests_mentor_id_fkey FOREIGN KEY (mentor_id) REFERENCES public.faculty(id);


--
-- Name: student_leave_requests student_leave_requests_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_leave_requests
    ADD CONSTRAINT student_leave_requests_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: students students_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: students students_intended_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_intended_department_id_fkey FOREIGN KEY (intended_department_id) REFERENCES public.departments(id);


--
-- Name: students students_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.sections(id);


--
-- Name: students students_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.students
    ADD CONSTRAINT students_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: tally_ledger_mappings tally_ledger_mappings_confirmed_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tally_ledger_mappings
    ADD CONSTRAINT tally_ledger_mappings_confirmed_by_fkey FOREIGN KEY (confirmed_by) REFERENCES public.users(id);


--
-- Name: tally_ledger_mappings tally_ledger_mappings_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tally_ledger_mappings
    ADD CONSTRAINT tally_ledger_mappings_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.students(id);


--
-- Name: timetable_slots timetable_slots_course_assignment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.timetable_slots
    ADD CONSTRAINT timetable_slots_course_assignment_id_fkey FOREIGN KEY (course_assignment_id) REFERENCES public.course_assignments(id);


--
-- Name: unmapped_ledger_entries unmapped_ledger_entries_suggested_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.unmapped_ledger_entries
    ADD CONSTRAINT unmapped_ledger_entries_suggested_student_id_fkey FOREIGN KEY (suggested_student_id) REFERENCES public.students(id);


--
-- Name: upload_batches upload_batches_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.upload_batches
    ADD CONSTRAINT upload_batches_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id);


--
-- Name: user_page_views user_page_views_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_page_views
    ADD CONSTRAINT user_page_views_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict fWXnkXNz6U3ThQ7ck2fWbnqLfDdfmSJgy4ahkhrpOHnBh1qqAR5RwUY8Qbslj77

