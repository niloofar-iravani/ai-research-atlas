-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database
-- AI Research Atlas -- Representative data and common database operations.

-- ========================================================= -- 1. Insert sample papers. -- Explicit IDs make the example relationships predictable. -- INSERT OR IGNORE allows this seed section to be rerun. -- =========================================================

INSERT OR IGNORE INTO "papers" ("id", "title", "publication_year", "doi", "url", "abstract", "method") VALUES ( 1, 'Attention Is All You Need', 2017, '10.48550/arXiv.1706.03762', 'https://arxiv.org/abs/1706.03762', 'Introduces the Transformer architecture based on attention mechanisms.', 'Transformer; self-attention' ), ( 2, 'BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding', 2018, NULL, 'https://arxiv.org/abs/1810.04805', 'Presents a method for pre-training bidirectional language representations.', 'Transformer; masked language modeling' ), ( 3, 'Deep Residual Learning for Image Recognition', 2015, NULL, 'https://arxiv.org/abs/1512.03385', 'Introduces residual learning for training deep neural networks.', 'Residual neural networks' );

-- ========================================================= -- 2. Insert authors. -- =========================================================

INSERT OR IGNORE INTO "authors" ("id", "name", "orcid") VALUES (1, 'Ashish Vaswani', NULL), (2, 'Noam Shazeer', NULL), (3, 'Jacob Devlin', NULL), (4, 'Kaiming He', NULL);

-- ========================================================= -- 3. Link papers to authors. -- Author position preserves publication order. -- =========================================================

INSERT OR IGNORE INTO "paper_authors" ("paper_id", "author_id", "author_position") VALUES (1, 1, 1), (1, 2, 2), (2, 3, 1), (3, 4, 1);

-- ========================================================= -- 4. Create research topics and classify papers. -- =========================================================

INSERT OR IGNORE INTO "topics" ("id", "name", "description") VALUES (1, 'Natural Language Processing', 'Language understanding and generation.'), (2, 'Machine Learning', 'Methods for learning patterns from data.'), (3, 'Computer Vision', 'Methods for understanding visual data.');

INSERT OR IGNORE INTO "paper_topics" ("paper_id", "topic_id") VALUES (1, 1), (1, 2), (2, 1), (2, 2), (3, 2), (3, 3);

-- ========================================================= -- 5. Create initial reading records. -- =========================================================

INSERT OR IGNORE INTO "reading_log" ("paper_id", "status", "rating", "notes") VALUES (1, 'completed', 5, 'Review the self-attention mechanism.'), (2, 'in_progress', NULL, 'Focus on pre-training objectives.'), (3, 'unread', NULL, NULL);

-- ========================================================= -- 6. Retrieve the complete paper catalog. -- =========================================================

SELECT * FROM "paper_catalog" ORDER BY "publication_year" DESC, "title";

-- ========================================================= -- 7. Find papers related to NLP. -- =========================================================

SELECT "p"."id", "p"."title", "p"."publication_year", "rl"."status" FROM "papers" AS "p" JOIN "paper_topics" AS "pt" ON "pt"."paper_id" = "p"."id" JOIN "topics" AS "t" ON "t"."id" = "pt"."topic_id" LEFT JOIN "reading_log" AS "rl" ON "rl"."paper_id" = "p"."id" WHERE "t"."name" = 'Natural Language Processing' ORDER BY "p"."publication_year" DESC;

-- ========================================================= -- 8. Find papers that have not been completed. -- Papers without a reading record are also included. -- =========================================================

SELECT "p"."id", "p"."title", COALESCE("rl"."status", 'unread') AS "status" FROM "papers" AS "p" LEFT JOIN "reading_log" AS "rl" ON "rl"."paper_id" = "p"."id" WHERE "rl"."status" IS NULL OR "rl"."status" <> 'completed' ORDER BY "p"."title";

-- ========================================================= -- 9. Count papers by publication year. -- =========================================================

SELECT "publication_year", COUNT(*) AS "paper_count" FROM "papers" WHERE "publication_year" IS NOT NULL GROUP BY "publication_year" ORDER BY "publication_year" DESC;

-- ========================================================= -- 10. Find authors with the most papers in this database. -- =========================================================

SELECT "a"."name", COUNT("pa"."paper_id") AS "paper_count" FROM "authors" AS "a" JOIN "paper_authors" AS "pa" ON "pa"."author_id" = "a"."id" GROUP BY "a"."id", "a"."name" ORDER BY "paper_count" DESC, "a"."name";

-- ========================================================= -- 11. Compare topic coverage and reading completion. -- =========================================================

SELECT "topic", "paper_count", "completed_count", ROUND( 100.0 * "completed_count" / NULLIF("paper_count", 0), 1 ) AS "completion_percentage" FROM "topic_statistics" ORDER BY "paper_count" DESC, "topic";

-- ========================================================= -- 12. Search titles and abstracts for a keyword. -- This is basic text matching, not semantic search. -- =========================================================

SELECT "id", "title", "publication_year" FROM "papers" WHERE "title" LIKE '%Transformer%' OR "abstract" LIKE '%Transformer%' ORDER BY "publication_year" DESC;

-- ========================================================= -- 13. Add a new paper. -- The ID is generated automatically. -- =========================================================

INSERT OR IGNORE INTO "papers"
    ("id", "title", "publication_year", "url", "abstract", "method")
VALUES
    (
        4,
        'Example Research Paper on Retrieval-Augmented Generation',
        2024,
        'https://example.org/rag-paper',
        'An illustrative record for testing research discovery queries.',
        'Retrieval-augmented generation'
    );
-- ========================================================= -- 14. Update a paper's reading status and notes. -- =========================================================

UPDATE "reading_log" SET "status" = 'completed', "rating" = 4, "notes" = 'Completed review; compare its approach with related work.', "updated_at" = CURRENT_TIMESTAMP WHERE "paper_id" = 2;

-- ========================================================= -- 15. Add or update a reading record for a paper. -- This works whether or not that paper already has a log. -- =========================================================

INSERT INTO "reading_log" ("paper_id", "status", "rating", "notes") VALUES (4, 'in_progress', NULL, 'Investigate this paper further.') ON CONFLICT ("paper_id") DO UPDATE SET "status" = excluded."status", "rating" = excluded."rating", "notes" = excluded."notes", "updated_at" = CURRENT_TIMESTAMP;

-- ========================================================= -- 16. Delete a reading record without deleting the paper. -- Run this only when you want to clear paper 3's reading log. -- =========================================================

DELETE FROM "reading_log" WHERE "paper_id" = 3;

-- ========================================================= -- 17. Inspect the query plan for a topic lookup. -- Useful for understanding index usage. -- =========================================================

EXPLAIN QUERY PLAN SELECT "paper_id" FROM "paper_topics" WHERE "topic_id" = 1;
