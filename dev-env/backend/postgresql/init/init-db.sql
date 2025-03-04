-- For roles, you can use a similar approach:
DO $$ BEGIN IF NOT EXISTS (
  SELECT
  FROM pg_roles
  WHERE rolname = 'admin'
) THEN CREATE ROLE admin WITH LOGIN PASSWORD 'admin' SUPERUSER;
END IF;
END $$;

DO $$ BEGIN IF NOT EXISTS (
  SELECT
  FROM pg_roles
  WHERE rolname = 'dev'
) THEN CREATE ROLE dev WITH LOGIN PASSWORD 'dev' SUPERUSER;
END IF;
END $$;

DO $$ BEGIN IF NOT EXISTS (
  SELECT
  FROM pg_roles
  WHERE rolname = 'swai_dev'
) THEN CREATE ROLE swai_dev WITH LOGIN PASSWORD 'swai_dev' SUPERUSER;
END IF;
END $$;

DO $$ BEGIN IF NOT EXISTS (
  SELECT
  FROM pg_roles
  WHERE rolname = 'logatron_dev'
) THEN CREATE ROLE logatron_dev WITH LOGIN PASSWORD 'logatron_dev' SUPERUSER;
END IF;
END $$;











