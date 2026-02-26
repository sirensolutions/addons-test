---
permalink: /siren-ocr/
layout: single
classes:
  - landing
  - dark-theme
sidebar:
  nav: "plugins_nav"
github_org: sirensolutions
github_repo: siren-arrow-java
toc: true
toc_sticky: true
toc_icon: "cog"
---

# Siren Intelligent Document Processing (IDP)

## Purpose

The File Processor is a document ingestion and enrichment pipeline designed to extract, transform, analyze, and index heterogeneous file content into Elasticsearch. It orchestrates multiple external services to produce structured, searchable, and analytics-ready records from raw source files. Additionally it generates a pdf-preview version of the file which allows for easy web viewing.

The system is intended to run within a controlled data management environment where required services are accessible over the network.

Currently supports the following file formats:
- ".doc", ".docx", ".pdf", ".ppt", ".pptx", ".odt", ".odp", ".txt", ".rtf", ".htm", ".html", ".xls", ".xlsx", ".csv", ".tsv",
- ".png", ".jpg", ".jpeg", ".bmp", ".tiff", ".tif", ".webp"

---

## Architectural Dependencies

The File Processor depends on the following infrastructure components:

### 1. Elasticsearch

**Target search and analytics engine.**

Must have the following ingest pipelines configured:

- **`attachment-pipeline`** – Extracts text and metadata from binary file content.  
- **`nlp-pipeline`** – Performs NLP enrichment (e.g., entity extraction, classification, etc.).

Elasticsearch acts as the authoritative indexed store for processed documents and derived metadata.

---

### 2. Source File Repository

- Network-accessible folders containing raw files to be ingested.  
- Supports heterogeneous file formats (documents, images, etc.).  
- Acts as the upstream data source for the pipeline.

---

### 3. External Processing Services

The script orchestrates several specialized microservices:

#### Image Extraction Service (`img_xtr`)

- Extracts embedded images from supported document formats.  
- Enables downstream OCR and facial analysis on extracted image content.

#### File Converter Service (`file_converter`)

- Converts files into normalized formats (PDF).  
- Ensures consistent downstream processing regardless of original format.

#### OCR Service (`ocr7`)

Performs Optical Character Recognition on:

- Standalone image files  
- Images extracted from documents  

Produces machine-readable text for indexing and NLP analysis.

#### Face Analyzer Service (Siren Face Standalone)

- Detects and analyzes faces in image content.  
- Produces structured facial metadata suitable for indexing and search.

---

### 4. Processed File Repository

- Network-accessible folder for:
  - File copies  
  - Generated PDF previews  

Serves as a durable artifact store for normalized content and downstream review.

---

## Processing Workflow (High-Level)

### File Discovery

- Scan source network folder for new or updated files.

### Normalization

- Convert files into standardized formats (e.g., PDF).  
- Store normalized copies in the processed file repository.

### Content Extraction

- Extract embedded images.  
- Run OCR on images and image-based documents.  
- Collect textual and metadata output.

### Enrichment

Send extracted content through Elasticsearch ingest pipelines:

- Attachment extraction  
- NLP enrichment  

Perform face detection and metadata extraction.

### Indexing

- Consolidate all extracted and enriched data.  
- Index the resulting document into Elasticsearch.  
- Ensure ingest pipelines apply structured transformations and enrichment.

---

## System Characteristics

- **Service-Oriented**: Relies on discrete, loosely coupled services for specialized processing.  
- **IO-Bound Workflow**: Most operations are network or service-call driven.  
- **Extensible**: Additional enrichment services can be integrated into the orchestration layer.  
- **Search-Centric**: Elasticsearch is the system of record for searchable output.

---

## Operational Assumptions

- All dependent services are reachable from the data management server.  
- Elasticsearch pipelines are preconfigured and validated.  
- Network shares are mounted and accessible with appropriate permissions.  
- Downstream consumers rely on Elasticsearch as the canonical search interface.