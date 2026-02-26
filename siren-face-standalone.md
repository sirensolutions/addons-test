---
permalink: /siren-face-standalone/
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

# Siren Face Search

## Overview
**Siren Face Search** brings face-based photo matching into the Siren Investigate experience. It allows investigators and analysts to upload a photo and quickly find visually similar faces across approved image collections, then review results in a familiar Siren workflow.

This module uses **siren-face-standalone** and **siren-face-plugin-light** to support both back-end processing and front-end investigation. The goal is simple: help teams move from an image to actionable leads, without leaving the Siren environment.

---

## What It Does
Siren Face Search:
- Lets an investigation panel search for face matches based on face vectors extracted from uploaded photos
- Returns ranked match results with helpful context to support review and decision-making
- Supports processing through back-end pipelines, so face data can be prepared and maintained as part of normal data operations
- Integrates results into Siren Investigate so analysts can connect findings with other entities, records, and investigative activity

At a high level, it compares face vectors (face "signatures") extracted from images to find the closest matches.

---

## Key Capabilities

### Panel-Based Face Matching
Users can upload a photo from within Siren and run a face search directly from a panel, making it easy to use during live investigations.

### Detailed Result Review
The front-end components present clear, investigation-friendly results that work well alongside other Siren Investigate features.

### Back-End Pipeline Support
Face processing can be incorporated into back-end pipelines, enabling organizations to scale how images are processed and kept up to date.
All data going into the siren that may contain photos is routed to extract Faces and vectorize them for searching.

### Investigation Workflow Fit
Face matches can be reviewed in context, supporting common investigation tasks like Profiling, Link analysys, triage, correlation, and follow-up.

---

## How It Works
1. A user uploads or selects a photo in Siren
2. The system extracts a face representation from the image (All faces in photomay be selected)
3. That representation is compared to existing face representations from available images
4. The panel displays likely matches, ranked by similarity
5. Investigators use the results alongside other Siren tools to continue analysis and document findings

---

## Benefits

### Faster Identification and Triage
Quickly narrow large image sets down to the most likely matches.

### Better Context During Investigations
Review face match results without losing the broader investigative picture in Siren.

### Scales with Operational Workflows
Use pipelines to support ongoing ingestion and processing, not just one-off searches.

### Consistent User Experience
Keeps the workflow inside Siren Investigate with results that align with the rest of the platform.

---

## Typical Use Cases
- Investigating persons of interest from a still image
- Comparing faces across collections of photos gathered during an investigation
- Quickly finding potential matches during time-sensitive operational work
- Supporting review and correlation workflows where images are one of several key data sources

---

## Positioning within Siren
Siren Face Search extends Siren Investigate by adding face-based matching as an investigation-friendly capability, supported by:
- **siren-face-standalone** for back-end face processing and pipeline integration
- **siren-face-plugin-light** for front-end components that display and integrate results within the Siren experience. It can server as a proxy to operate **siren-face-standalone** witout cross source issuess and API activation from the browser using SirenAPI
- The classic **siren-face-plugin** is also availble as a one stop shop for both of all functionalities combined in environment that requires a single node app.

It is designed to complement existing Siren features, helping teams connect image-based leads with the rest of their investigative data.

---

## Summary
**Siren Face Search** enables teams to run face match queries from within Siren Investigate, using uploaded photos to find similar faces and review results in context. By supporting both back-end processing and front-end investigation workflows, it helps organizations turn images into actionable investigative leads.