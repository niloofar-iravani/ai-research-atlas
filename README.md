AI Research Atlas
A Relational Database for AI, Machine Learning, and NLP Research
AI Research Atlas is a SQLite database project designed to organize research papers and track reading progress across Artificial Intelligence (AI), Machine Learning (ML), and Natural Language Processing (NLP).

When exploring a research area, keeping track of publications, authors, topics, and reading notes can quickly become difficult. This project brings that information into a relational database, making it easier to retrieve papers, explore their relationships, and review research activity through SQL queries.

The project focuses on database design and implementation rather than machine learning itself. Its structure also provides a foundation for a future research discovery application, where additional functionality could be built on top of the database.

Features
Research paper catalog: Store paper titles, publication years, abstracts, DOIs, URLs, and descriptions of research methods.
Author management: Associate multiple authors with papers while preserving their original publication order.
Topic classification: Organize papers by research areas and support multiple topics per paper.
Reading tracker: Record reading status, personal ratings, notes, and timestamps.
SQL-based search and reporting: Retrieve papers by topic, year, author, or reading status, and generate summaries of research activity.
Reusable database views: Combine bibliographic information with reading records and summarize paper counts by topic.
Data integrity: Use primary keys, foreign keys, uniqueness constraints, and CHECK constraints to maintain consistent records.
Query optimization: Add indexes for common lookups and inspect query plans with SQLite's EXPLAIN QUERY PLAN.
Database Design
The database separates publication metadata from authors, topic classifications, and personal reading records. This structure avoids duplicating related information and supports queries across multiple entities.

Schema Overview
The database consists of six tables:

Table	Responsibility
papers	Stores bibliographic metadata and research method descriptions.
authors	Stores author names and optional ORCID identifiers.
paper_authors	Implements the many-to-many relationship between papers and authors.
topics	Stores unique research topic names and optional descriptions.
paper_topics	Implements the many-to-many relationship between papers and topics.
reading_log	Stores reading status, ratings, personal notes, and the last-update timestamp.
Relationships
A paper can have multiple authors, and an author can contribute to multiple papers.
A paper can belong to multiple topics, and each topic can be associated with multiple papers.
Each paper can have at most one reading record in the current single-user design.
The paper_authors and paper_topics junction tables use composite primary keys to prevent duplicate relationships. The author relationship also records author_position, with a uniqueness constraint to prevent two authors from occupying the same position on a paper.

Data Integrity
The schema uses SQLite constraints to enforce key data rules:

Paper titles and author names are required.
Publication years, when provided, must fall between 1900 and 2100.
DOI and ORCID values must be unique when present.
Reading status is restricted to unread, in_progress, completed, or skipped.
Ratings must be integers from 1 to 5 when provided.
Foreign keys maintain relationships between papers and their associated records.
Cascading deletion removes dependent junction and reading records when a paper is deleted.
Foreign-key enforcement is enabled through PRAGMA foreign_keys = ON. SQLite requires this setting to be enabled for each database connection that needs foreign-key enforcement.

Views and Indexes
Database Views
Two views provide reusable access to commonly needed information:

paper_catalog

Combines paper metadata with associated author names, topic names, and available reading information, including status, rating, notes, and update timestamp. It provides a consolidated view of the research collection without duplicating the underlying records.

topic_statistics

Summarizes the number of papers associated with each topic and the number marked as completed. These results can be used to compare topic coverage and reading progress.

Indexes
The schema defines indexes on:

papers.publication_year
papers.title
paper_authors.author_id
paper_topics.topic_id
reading_log.status
These indexes are intended to support common filtering and relationship lookups. Their actual performance benefits depend on the queries and data distribution; query plans can be inspected using EXPLAIN QUERY PLAN.

SQL Queries
The queries.sql file contains representative SQL operations covering data creation, retrieval, analysis, and modification.

Examples include:

Inserting sample papers, authors, and topics.
Linking papers to their authors and research areas.
Retrieving the complete paper catalog.
Finding papers associated with Natural Language Processing.
Identifying papers that have not been completed.
Counting publications by year and author.
Comparing topic coverage and reading completion rates.
Searching titles and abstracts with LIKE.
Updating reading records and using INSERT ... ON CONFLICT ... DO UPDATE.
Inspecting query plans for topic lookups.
The text search uses standard SQL pattern matching. Semantic search, embedding-based retrieval, and automated recommendations are not implemented in the current version.

Entity-Relationship Diagram
The diagram illustrates the database tables, their key relationships, and the overall structure of the data model.

AI Research Atlas Entity-Relationship Diagram

Technology Stack
SQLite — Relational database engine
SQL — Schema definition, data manipulation, and analytical queries
Entity-Relationship Modeling — Database design and relationship representation
Markdown — Project documentation
Repository Structure
ai-research-atlas/
├── README.md
├── design.md
├── schema.sql
├── queries.sql
├── er_diagram.png
└── atlas_test.db
File	Description
README.md	Project overview, database features, and usage instructions.
design.md	Design rationale, scope, relationships, limitations, and future development.
schema.sql	Table definitions, constraints, indexes, and views.
queries.sql	Sample records and representative SQL operations.
er_diagram.png	Entity-Relationship diagram.
atlas_test.db	SQLite database file for inspecting and testing the project.
Getting Started
Requirements
SQLite 3
A local copy of the repository
1. Clone the repository
git clone https://github.com/YOUR-USERNAME/ai-research-atlas.git
cd ai-research-atlas
Replace YOUR-USERNAME with your GitHub username.

2. Inspect the included database
Open the supplied SQLite database:

sqlite3 atlas_test.db
List the available tables and views:

.tables
Inspect the schema:

.schema
You can query the catalog view directly:

SELECT *
FROM paper_catalog
ORDER BY publication_year DESC, title;
To inspect topic statistics:

SELECT *
FROM topic_statistics
ORDER BY paper_count DESC, name;
3. Create a fresh database
To create a separate database using the schema:

sqlite3 atlas_demo.db < schema.sql
This creates the tables, indexes, and views defined in schema.sql. It does not automatically populate the database with sample records.

To add the sample data, review queries.sql and execute the relevant statements against the newly created database.

Important: queries.sql contains INSERT, UPDATE, and DELETE statements as well as retrieval queries. Do not run the entire file against the original database without reviewing its effects. Use a separate test database when experimenting.

Limitations and Future Development
The current version focuses on structured metadata and reading management for a single reader. It does not download research papers, store full PDF documents, evaluate scientific validity, or generate automated recommendations.

Possible extensions include:

Importing publication metadata from scholarly APIs.
Building a Python interface for managing research records.
Adding user accounts and separate reading histories.
Implementing semantic search using embeddings generated from paper abstracts.
Exploring automatic topic classification and recommendation methods.
These extensions would require additional application logic and, depending on the implementation, external data sources or specialized search infrastructure.

Project Walkthrough
A short video walkthrough of the project is available here:

Watch the AI Research Atlas project walkthrough

Project type: Relational database
Research domains: Artificial Intelligence, Machine Learning, Natural Language Processing
Core technologies: SQLite and SQL
