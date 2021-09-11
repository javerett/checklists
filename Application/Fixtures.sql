

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


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.users DISABLE TRIGGER ALL;



ALTER TABLE public.users ENABLE TRIGGER ALL;


ALTER TABLE public.assignments DISABLE TRIGGER ALL;



ALTER TABLE public.assignments ENABLE TRIGGER ALL;


ALTER TABLE public.buildings DISABLE TRIGGER ALL;



ALTER TABLE public.buildings ENABLE TRIGGER ALL;


ALTER TABLE public.checklist_items DISABLE TRIGGER ALL;



ALTER TABLE public.checklist_items ENABLE TRIGGER ALL;


ALTER TABLE public.checklist_answers DISABLE TRIGGER ALL;



ALTER TABLE public.checklist_answers ENABLE TRIGGER ALL;


ALTER TABLE public.checklist_groups DISABLE TRIGGER ALL;



ALTER TABLE public.checklist_groups ENABLE TRIGGER ALL;


ALTER TABLE public.checklist_template_groups DISABLE TRIGGER ALL;



ALTER TABLE public.checklist_template_groups ENABLE TRIGGER ALL;


ALTER TABLE public.checklist_template_items DISABLE TRIGGER ALL;



ALTER TABLE public.checklist_template_items ENABLE TRIGGER ALL;


ALTER TABLE public.checklist_templates DISABLE TRIGGER ALL;



ALTER TABLE public.checklist_templates ENABLE TRIGGER ALL;


ALTER TABLE public.checklists DISABLE TRIGGER ALL;



ALTER TABLE public.checklists ENABLE TRIGGER ALL;


ALTER TABLE public.locations DISABLE TRIGGER ALL;



ALTER TABLE public.locations ENABLE TRIGGER ALL;


ALTER TABLE public.request_buildings DISABLE TRIGGER ALL;



ALTER TABLE public.request_buildings ENABLE TRIGGER ALL;


ALTER TABLE public.request_files DISABLE TRIGGER ALL;



ALTER TABLE public.request_files ENABLE TRIGGER ALL;


ALTER TABLE public.requests DISABLE TRIGGER ALL;



ALTER TABLE public.requests ENABLE TRIGGER ALL;


ALTER TABLE public.training_types DISABLE TRIGGER ALL;



ALTER TABLE public.training_types ENABLE TRIGGER ALL;


ALTER TABLE public.user_trainings DISABLE TRIGGER ALL;



ALTER TABLE public.user_trainings ENABLE TRIGGER ALL;


