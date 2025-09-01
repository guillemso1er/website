# Personal CV & Resume Website

This repository contains the source code for my personal CV and portfolio website. It's a modern, responsive, and bilingual (English/Spanish) site designed to be easily updated. The content is dynamically loaded from JSON files, and it includes a Typst template for generating a professional PDF resume.

**Live Demo:** [your-domain.com](https://guillemsoler.dev)

---

## ✨ Features

*   **Bilingual:** Full content available in both English (`/en/`) and Spanish (`/es/`).
*   **Dynamic Content:** Page content (experience, skills, projects) is loaded from `resume-en.json` and `resume-es.json`, making updates simple.
*   **Light & Dark Mode:** Theme support that respects user's system preference and can be toggled manually.
*   **Responsive Design:** Looks great on desktops, tablets, and mobile devices.
*   **Progressive Enhancement:** The site is fully functional with CSS-only and is enhanced with minimal JavaScript for dynamic data loading and interactivity.
*   **PDF Generation:** Includes a `resume.typ` template to generate a clean, ATS-friendly PDF resume from the same JSON data source.

---

## 🛠️ Tech Stack

*   **Frontend:** HTML5, Tailwind CSS (via CDN), vanilla JavaScript (ES6).
*   **PDF Generation:** [Typst](https://github.com/typst/typst) for programmatic resume layout.
*   **Data Source:** JSON (`resume-en.json`, `resume-es.json`).
*   **Hosting:** Designed for any static hosting provider (e.g., Vercel, Netlify, GitHub Pages).

---

## 🚀 Getting Started & Customization

Customizing this resume for your own use is straightforward.

### **Step 1: Update the Resume Data**

All personal information is stored in two files. Edit them with your details:

*   `assets/json/resume-en.json` (for the English version)
*   `assets/json/resume-es.json` (for the Spanish version)

**Key sections to update:**
*   `basics`: Your name, title, location, contact info, and social links.
*   `skills`: Your technical competencies, grouped by category.
*   `experience`: Your professional work history.
*   `projects`: Your key projects, with summaries, tech stacks, and links.
*   `education`: Your educational background.
*   `languages`: The languages you speak.

### **Step 2: Update SEO and Metadata**

For proper search engine indexing and social sharing, update the metadata in these files:

*   `en/index.html`
*   `es/index.html`

Find and replace all instances of `your-domain.com` and `@your_twitter` with your actual information.

### **Step 3: Replace Static Assets**

*   **Avatar:** Replace `/assets/img/avatar.png` with your own photo.
*   **Favicon:** (Optional) Add your own favicon files to the `/assets/img/` directory and link them in the `<head>` of the HTML files.
*   **PDF Resume:** Replace `/assets/docs/resume.pdf` with your generated PDF.

### **Step 4: Generate the PDF Resume**

The PDF resume is generated using a `.typ` file, which is a modern, scriptable typesetting system.

1.  **Install Typst:** Follow the [official installation guide](https://github.com/typst/typst#installation).
2.  **Configure the Template:** Open `typts/resume.typ` and change the language variable at the top:
    ```typst
    // Set the document language: "en" for English, "es" for Spanish.
    #let lang = "en"
    ```
3.  **Compile the PDF:** Run the following command from the root of the project directory:
    ```bash
    typst compile typts/resume.typ assets/docs/resume-en.pdf
    ```
    To generate the Spanish version, change `lang` to `"es"` in the `.typ` file and run:
    ```bash
    typst compile typts/resume.typ assets/docs/resume-es.pdf
    ```

---

## 📁 Project Structure