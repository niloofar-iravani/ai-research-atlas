# AI Research Atlas

A relational database for organizing, tracking, and exploring research papers in Artificial Intelligence (AI), Machine Learning (ML), and Natural Language Processing (NLP).

AI Research Atlas helps students and early-career researchers manage paper metadata, organize research topics, track reading progress, and record personal notes and ratings. The project focuses on database design, relational modeling, and practical SQL queries.

## Features

- **Paper management:** Store paper titles, publication years, abstracts, DOIs, URLs, and research methods.
- **Author management:** Connect papers with their authors and record author order.
- **Topic organization:** Categorize papers using reusable research topics.
- **Reading tracker:** Track reading status, personal ratings, notes, and update timestamps.
- **Research queries:** Find papers by topic, year, author, reading status, or keywords.
- **Summary statistics:** Explore publication counts and reading progress by topic.
- **Data integrity:** Use primary keys, foreign keys, unique constraints, and check constraints.

## Database Design

The database uses a relational model with six tables.

| Table | Purpose |
|---|---|
| `papers` | Stores paper metadata and publication information. |
| `authors` | Stores author names and optional ORCID identifiers. |
| `paper_authors` | Connects papers and authors, including author position. |
| `topics` | Stores research topics and descriptions. |
| `paper_topics` | Connects papers with research topics. |
| `reading_log` | Stores reading status, ratings, notes, and update timestamps. |

### Relationships

- A paper can have multiple authors, and an author can contribute to multiple papers.
- A paper can belong to multiple topics, and a topic can include multiple papers.
- Each paper can have one reading-log record in the current single-user design.

The junction tables `paper_authors` and `paper_topics` represent many-to-many relationships.

## Database Views and Indexes

### Views

- **`paper_catalog`:** Combines paper metadata with author names, topic names, and available reading-log information.
- **`topic_statistics`:** Summarizes the number of papers associated with each topic and the number marked as completed.

### Indexes

Indexes are defined on frequently queried fields and relationships, including publication year, paper title, author relationships, topic relationships, and reading status.

## SQL Queries

The `queries.sql` file demonstrates:

- Selecting and filtering research papers
- Searching titles and abstracts using `LIKE`
- Finding papers that have not been completed
- Counting papers by publication year
- Identifying authors with the most papers
- Calculating topic coverage and reading progress
- Inserting new paper records
- Updating reading status
- Using `UPSERT` to insert or update a reading record
- Deleting a reading-log record
- Inspecting query execution plans with `EXPLAIN QUERY PLAN`

Sample papers include *Attention Is All You Need*, *BERT*, and *ResNet*.

**Note:** `queries.sql` contains both read-only queries and statements that modify data. Review the statements before executing them against a database you want to preserve.

## Entity-Relationship Diagram

The diagram illustrates the database tables and their relationships.

![AI Research Atlas Entity-Relationship Diagram](er_diagram.png)

## Technology Stack

- **Database:** SQLite
- **Query language:** SQL
- **Concepts:** Relational modeling, normalization, primary and foreign keys, constraints, indexes, and views
- **Documentation:** Markdown

## Repository Structure

```text
ai-research-atlas/
├── README.md
├── design.md
├── schema.sql
├── queries.sql
├── er_diagram.png
└── atlas_test.db
```

## Getting Started

### Prerequisites

Install [SQLite](https://www.sqlite.org/download.html) if it is not already available on your system.

### 1. Clone the Repository

```bash
git clone https://github.com/niloofar-iravani/ai-research-atlas.git
cd ai-research-atlas
```

### 2. Inspect the Database

Open the included database:

```bash
sqlite3 atlas_test.db
```

List the tables:

```sql
.tables
```

Inspect the schema:

```sql
.schema
```

Query the paper catalog:

```sql
SELECT * FROM paper_catalog;
```

View topic statistics:

```sql
SELECT * FROM topic_statistics;
```

Exit SQLite:

```sql
.quit
```

### 3. Create a New Database

```bash
sqlite3 atlas_demo.db < schema.sql
```

This creates the tables, indexes, and views defined in `schema.sql`. It does not automatically populate the database with sample research papers.

Review `queries.sql` before running its statements, especially the `UPDATE` and `DELETE` examples.

## Limitations

- The project is designed for a single user.
- Research papers are entered manually; automatic paper retrieval is not implemented.
- The database stores paper metadata rather than full-text PDF documents.
- Machine-learning models, semantic search, automated recommendations, and scientific evaluation of papers are not implemented.

## Future Development

Potential extensions include:

- Integrating academic paper APIs for metadata retrieval
- Adding a web interface or REST API
- Supporting multiple users
- Implementing semantic search using text embeddings
- Exploring automated topic classification and paper recommendations

These are possible future improvements, not current features.

## Project Walkthrough

Watch the project demonstration:

[AI Research Atlas — Project Walkthrough](https://youtu.be/-VU1WBBwQRk)

## Author

Created by **Niloofar Iravani** as a SQL database project focused on organizing AI research literature and demonstrating relational database design.
