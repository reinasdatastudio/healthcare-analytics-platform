CREATE TABLE patients (
    id TEXT PRIMARY KEY,
    birthdate DATE NOT NULL,
    deathdate DATE,
    ssn TEXT,
    drivers TEXT,
    passport TEXT,
    prefix TEXT,
    first TEXT,
    middle TEXT,
    last TEXT,
    suffix TEXT,
    maiden TEXT,
    marital TEXT,
    race TEXT,
    ethnicity TEXT,
    gender TEXT,
    birthplace TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    county TEXT,
    fips TEXT,
    zip TEXT,
    lat NUMERIC,
    lon NUMERIC,
    healthcare_expenses NUMERIC,
    healthcare_coverage NUMERIC,
    income NUMERIC
);

CREATE TABLE encounters (
    id TEXT PRIMARY KEY,
    start_time TIMESTAMP,
    stop_time TIMESTAMP,
    patient TEXT,
    organization TEXT,
    provider TEXT,
    payer TEXT,
    encounterclass TEXT,
    code TEXT,
    description TEXT,
    base_encounter_cost NUMERIC,
    total_claim_cost NUMERIC,
    payer_coverage NUMERIC,
    reasoncode TEXT,
    reasondescription TEXT
);

CREATE TABLE conditions (
    condition_id BIGSERIAL PRIMARY KEY,
    start_time TIMESTAMP,
    stop_time TIMESTAMP,
    patient TEXT NOT NULL,
    encounter TEXT NOT NULL,
    system TEXT,
    code TEXT,
    description TEXT
);

CREATE TABLE medications (
    start_time TIMESTAMP,
    stop_time TIMESTAMP,
    patient TEXT NOT NULL,
    payer TEXT,
    encounter TEXT NOT NULL,
    code TEXT,
    description TEXT,
    base_cost NUMERIC,
    payer_coverage NUMERIC,
    dispenses INTEGER,
    total_cost NUMERIC,
    reason_code TEXT,
    reason_description TEXT
);

CREATE TABLE observations (
    observation_date TIMESTAMP,
    patient TEXT NOT NULL,
    encounter TEXT,
    category TEXT,
    code TEXT,
    description TEXT,
    value TEXT,
    units TEXT,
    type TEXT
);