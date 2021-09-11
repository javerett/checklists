-- Your database schema. Use the Schema Designer at http://localhost:8001/ to add some tables.
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    email TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL
);
CREATE TABLE locations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL UNIQUE,
    address TEXT NOT NULL,
    job_num TEXT NOT NULL,
    site_tracker_num TEXT NOT NULL
);
CREATE TABLE buildings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    "location" UUID NOT NULL,
    name TEXT NOT NULL,
    square_footage INT NOT NULL
);
CREATE TABLE requests (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    description TEXT NOT NULL,
    notes TEXT NOT NULL,
    submission_time TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    quote_due_time TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    final_due_time TIMESTAMP WITH TIME ZONE NOT NULL,
    complete_time TIMESTAMP WITH TIME ZONE DEFAULT NULL,
    complete_notes TEXT DEFAULT NULL
);
CREATE TABLE request_buildings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    request UUID NOT NULL,
    building UUID NOT NULL
);
CREATE TABLE request_files (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL
);
CREATE TABLE checklist_groups (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    request_building_id UUID NOT NULL,
    name TEXT NOT NULL
);
CREATE TABLE checklists (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    group_id UUID NOT NULL,
    name TEXT NOT NULL,
    "index" INT NOT NULL
);
CREATE TABLE checklist_items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    checklist_id UUID NOT NULL,
    question TEXT NOT NULL,
    response_type INT NOT NULL,
    "index" INT NOT NULL
);
CREATE TABLE checklist_template_groups (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL
);
CREATE TABLE checklist_templates (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    group_id UUID NOT NULL,
    name TEXT NOT NULL
);
CREATE TABLE checklist_template_items (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    template_id UUID NOT NULL,
    question TEXT NOT NULL,
    response_type INT NOT NULL,
    "index" INT NOT NULL
);
CREATE TABLE assignments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    request UUID NOT NULL,
    user_id UUID NOT NULL,
    assignment_time TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL
);
CREATE TYPE state_codes AS ENUM ('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'DC', 'FL', 'GA', 'HI', 'ID', 'IL', 'IN', 'IA', 'KS', 'KY', 'LA', 'ME', 'MD', 'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'de', 'AS', 'GU', 'MH', 'FM', 'MP', 'PW', 'PR', 'VI');
CREATE TYPE customer_codes AS ENUM ('ENT', 'ATT', 'E2E', 'CCI', 'HNW', 'TEST', 'VZW');
CREATE TABLE user_trainings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    training_id UUID NOT NULL
);
CREATE TABLE training_types (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    name TEXT NOT NULL
);
CREATE TABLE checklist_answers (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL,
    checklist_item_id UUID NOT NULL,
    answer_time TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    answer_value UUID NOT NULL
);
ALTER TABLE assignments ADD CONSTRAINT assignments_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE checklist_answers ADD CONSTRAINT checklist_answers_ref_checklist_item_id FOREIGN KEY (checklist_item_id) REFERENCES checklist_items (id) ON DELETE NO ACTION;
ALTER TABLE checklist_answers ADD CONSTRAINT checklist_answers_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
ALTER TABLE checklist_items ADD CONSTRAINT checklist_items_ordered UNIQUE(checklist_id, index);
ALTER TABLE checklist_items ADD CONSTRAINT checklist_items_ref_checklist FOREIGN KEY (checklist_id) REFERENCES checklists (id) ON DELETE NO ACTION;
ALTER TABLE checklist_template_items ADD CONSTRAINT checklist_template_items_ordered UNIQUE(template, index);
ALTER TABLE checklist_template_items ADD CONSTRAINT checklist_template_items_ref_checklist_template FOREIGN KEY ("template") REFERENCES checklist_templates (ID) ON DELETE NO ACTION;
ALTER TABLE checklist_templates ADD CONSTRAINT checklist_templates_ref_group FOREIGN KEY (group) REFERENCES checklist_template_groups (id) ON DELETE NO ACTION;
ALTER TABLE checklists ADD CONSTRAINT checklists_ref_checklist_groups FOREIGN KEY (request) REFERENCES requests (id) ON DELETE NO ACTION;
ALTER TABLE requests ADD CONSTRAINT requests_ref_location FOREIGN KEY ("location") REFERENCES locations (id) ON DELETE NO ACTION;
ALTER TABLE user_trainings ADD CONSTRAINT user_trainings_ref_user_id FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE NO ACTION;
