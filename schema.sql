PRAGMA foreign_keys = ON;

CREATE TABLE "papers" (
    "id" INTEGER PRIMARY KEY,
    "title" TEXT NOT NULL,
    "publication_year" INTEGER CHECK (
        "publication_year" IS NULL
        OR "publication_year" BETWEEN 1900 AND 2100
    ),
    "doi" TEXT UNIQUE,
    "url" TEXT,
    "abstract" TEXT,
    "method" TEXT,
    "created_at" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "authors" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "orcid" TEXT UNIQUE
);

CREATE TABLE "paper_authors" (
    "paper_id" INTEGER NOT NULL,
    "author_id" INTEGER NOT NULL,
    "author_position" INTEGER NOT NULL CHECK ("author_position" > 0),
    PRIMARY KEY ("paper_id", "author_id"),
    UNIQUE ("paper_id", "author_position"),
    FOREIGN KEY ("paper_id") REFERENCES "papers" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("author_id") REFERENCES "authors" ("id") ON DELETE CASCADE
);

CREATE TABLE "topics" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL UNIQUE,
    "description" TEXT
);

CREATE TABLE "paper_topics" (
    "paper_id" INTEGER NOT NULL,
    "topic_id" INTEGER NOT NULL,
    PRIMARY KEY ("paper_id", "topic_id"),
    FOREIGN KEY ("paper_id") REFERENCES "papers" ("id") ON DELETE CASCADE,
    FOREIGN KEY ("topic_id") REFERENCES "topics" ("id") ON DELETE CASCADE
);

CREATE TABLE "reading_log" (
    "id" INTEGER PRIMARY KEY,
    "paper_id" INTEGER NOT NULL UNIQUE,
    "status" TEXT NOT NULL CHECK (
        "status" IN ('unread', 'in_progress', 'completed', 'skipped')
    ),
    "rating" INTEGER CHECK (
        "rating" IS NULL OR "rating" BETWEEN 1 AND 5
    ),
    "notes" TEXT,
    "updated_at" TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("paper_id") REFERENCES "papers" ("id") ON DELETE CASCADE
);

CREATE INDEX "idx_papers_year" ON "papers" ("publication_year");
CREATE INDEX "idx_papers_title" ON "papers" ("title");
CREATE INDEX "idx_paper_authors_author" ON "paper_authors" ("author_id");
CREATE INDEX "idx_paper_topics_topic" ON "paper_topics" ("topic_id");
CREATE INDEX "idx_reading_log_status" ON "reading_log" ("status");

CREATE VIEW "paper_catalog" AS
SELECT
    p."id",
    p."title",
    p."publication_year",
    p."doi",
    p."url",
    p."abstract",
    p."method",
    (
        SELECT GROUP_CONCAT(a."name", ', ')
        FROM "paper_authors" AS pa
        JOIN "authors" AS a ON a."id" = pa."author_id"
        WHERE pa."paper_id" = p."id"
    ) AS "authors",
    (
        SELECT GROUP_CONCAT(t."name", ', ')
        FROM "paper_topics" AS pt
        JOIN "topics" AS t ON t."id" = pt."topic_id"
        WHERE pt."paper_id" = p."id"
    ) AS "topics",
    rl."status",
    rl."rating",
    rl."notes",
    rl."updated_at"
FROM "papers" AS p
LEFT JOIN "reading_log" AS rl ON rl."paper_id" = p."id";

CREATE VIEW "topic_statistics" AS
SELECT
    t."id",
    t."name",
    COUNT(DISTINCT pt."paper_id") AS "paper_count",
    COUNT(
        DISTINCT CASE
            WHEN rl."status" = 'completed' THEN pt."paper_id"
        END
    ) AS "completed_count"
FROM "topics" AS t
LEFT JOIN "paper_topics" AS pt ON pt."topic_id" = t."id"
LEFT JOIN "reading_log" AS rl ON rl."paper_id" = pt."paper_id"
GROUP BY t."id", t."name";
