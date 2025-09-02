// --- CONFIGURATION ---
// Set the document language: "en" for English, "es" for Spanish.
#let lang = "en"

// Toggle "mode" to "ats" for a printer/ATS-safe variant.
#let mode = "visual" // "visual" | "ats"

// --- DATA & LABELS ---
// Load the correct resume data and labels based on the selected language.
#let cv = if lang == "es" {
  json("/assets/json/resume-es.json")
} else {
  json("/assets/json/resume-en.json")
}

#let labels = if lang == "es" {
  (
    professional_summary: "Resumen Profesional",
    core_competencies: "Competencias Clave",
    professional_experience: "Experiencia Profesional",
    key_projects: "Proyectos Clave",
    education: "Educación",
    certifications: "Certificaciones",
    languages: "Idiomas",
    technologies: "Tecnologías",
    links: "Enlaces",
    portfolio: "Portafolio",
    english_level: "Nivel de Inglés",
    ats_keywords: "Palabras Clave Técnicas",
  )
} else {
  (
    professional_summary: "Professional Summary",
    core_competencies: "Core Competencies",
    professional_experience: "Professional Experience",
    key_projects: "Key Projects",
    education: "Education",
    certifications: "Certifications",
    languages: "Languages",
    technologies: "Technologies",
    links: "Links",
    portfolio: "Portfolio",
    english_level: "English",
    ats_keywords: "Technical Keywords",
  )
}


// --- STYLING & HELPERS (No changes needed below this line) ---

// Page + typography
#set page(
  paper: "a4",
  margin: (top: 1.5cm, right: 1.5cm, bottom: 1.5cm, left: 1.5cm),
)

#let fonts = (
  "Inter",
  "Source Sans 3",
  "Source Sans Pro",
  "IBM Plex Sans",
  "Helvetica Neue",
  "Helvetica",
  "Arial",
  "Noto Sans",
  "Liberation Sans",
)

#set text(font: fonts, size: 10.5pt, hyphenate: false, fill: rgb("#0f172a"))
#set par(justify: false, leading: 1.35em, spacing: 0.6em)

// Color palette
#let accent = rgb("#2563eb")
#let secondary = if mode == "ats" { rgb("#111827") } else { rgb("#1e40af") }
#let muted = rgb("#64748b")
#let light = rgb("#f1f5f9")
#let subtle = rgb("#e5e7eb")

// Global link style
#show link: set text(
  fill: if mode == "ats" { rgb("#0f172a") } else { accent },
  weight: 600,
)

// Spacing scale
#let space = (xs: 2pt, sm: 4pt, md: 6pt, lg: 10pt, xl: 14pt, xxl: 20pt)

// Horizontal rule for sections
#let hr() = {
  v(space.sm)
  line(length: 100%, stroke: 0.9pt + (if mode == "ats" { subtle } else { accent }))
  v(space.lg)
}

// Section block
#let section(title, body) = {
  v(space.xl)
  block(spacing: space.sm)[
    #set text(size: 11.5pt, weight: 800, fill: secondary, tracking: 0.03em)
    #upper(title)
    #hr()
    #body
  ]
}

// Modern "chip" for tags (disabled in ATS mode)
#let chip(t) = box(
  stroke: if mode == "ats" { none } else { 0.5pt + subtle },
  fill: if mode == "ats" { none } else { light },
  radius: 3pt,
  inset: (x: 8pt, y: 1.4pt),
)[
  #set text(size: 9pt, weight: 500)
  #t
]

// Bullets + separators
#let bullet = text(size: 12pt, fill: if mode == "ats" { rgb("#0f172a") } else { accent })[•]
#let contact-sep = text(size: 9pt, fill: muted)[ • ]


// --- DOCUMENT STRUCTURE ---

// --- HEADER ---
#align(center)[
  #block(spacing: space.sm)[
    #set text(size: 23.5pt, weight: 900, fill: secondary, tracking: 0.01em)
    #cv.basics.name
  ]

  #block(spacing: space.sm)[
    #set text(size: 12.5pt, weight: 700, fill: if mode == "ats" { rgb("#0f172a") } else { accent })
    #cv.basics.title
  ]

  #block(spacing: space.lg)[
    #set text(size: 10pt, fill: muted)
    #cv.basics.location
    #contact-sep #link("mailto:" + cv.basics.email)[#cv.basics.email]
    #contact-sep #cv.basics.phone
    #if cv.basics.linkedin != "" [
      #contact-sep #link(cv.basics.linkedin)[LinkedIn]
    ]
    #if cv.basics.github != "" [
      #contact-sep #link(cv.basics.github)[GitHub]
    ]
    #if cv.basics.website != "" [
      #contact-sep #link(cv.basics.website)[#labels.portfolio]
    ]
    #if "english_level" in cv.basics [
      #contact-sep #labels.english_level: #cv.basics.english_level
    ]
  ]
]

#v(space.lg)

// --- PROFESSIONAL SUMMARY ---
#section(labels.professional_summary, [
  #set text(size: 10.5pt)
  #set par(leading: 1.4em)
  #cv.basics.summary
])

// --- CORE COMPETENCIES ---
#section(labels.core_competencies, [
  #let skills = cv.skills
  #for (i, skill) in skills.enumerate() [
    #grid(
      columns: (auto, 1fr),
      gutter: 10pt,
      align: top,
      [
        #box(height: 1.2em)[
          #set text(weight: 700, fill: secondary)
          #skill.category:
        ]
      ],
      [
        #set par(leading: 0.9em)
        #let items = skill.items
        #for (j, item) in items.enumerate() [
          #chip(item)#if j < items.len() - 1 [#h(3pt)]
        ]
      ],
    )
    #if i < skills.len() - 1 [#v(8pt)]
  ]
])

// --- JOB ENTRY HELPER ---
#let job-entry(job) = {
  grid(
    columns: (1fr, auto),
    gutter: 16pt,
    [
      #set text(size: 11pt, weight: 700, fill: secondary)
      #job.title
      #linebreak()
      #set text(size: 10.5pt, weight: 600, style: "italic")
      #job.company
    ],
    [
      #align(right)[
        #set text(size: 10pt, fill: muted, weight: 500)
        #if "location" in job [#job.location #linebreak()]
        #job.start — #job.end
      ]
    ],
  )
  v(space.sm)

  let bullet-items = job.bullets.map(bullet-text => grid(
    columns: (auto, 1fr),
    gutter: 10pt,
    align(top)[#bullet],
    [
      #set par(leading: 1.2em)
      #bullet-text
    ],
  ))
  bullet-items.join(v(space.md))
}

// --- PROFESSIONAL EXPERIENCE ---
#section(labels.professional_experience, [
  #for (i, job) in cv.experience.enumerate() [
    #job-entry(job)
    #if i < cv.experience.len() - 1 [#v(space.lg)]
  ]
])

// --- KEY PROJECTS ---
#if cv.projects.len() > 0 [
  #section(labels.key_projects, [
    #for (i, project) in cv.projects.enumerate() [
      #block(spacing: space.sm)[
        #set text(size: 11pt, weight: 700, fill: secondary)
        #project.name
        #linebreak()

        #set text(size: 10pt)
        #project.summary
        #v(space.md)

        #grid(
          columns: (auto, 1fr),
          gutter: 8pt,
          [
            #set text(size: 9.5pt, weight: 600, fill: muted)
            #labels.technologies:
          ],
          [
            #if mode == "ats" [
              #set text(size: 9.5pt)
              #project.tech.join(" • ")
            ] else [
              #let tech-chips = project.tech.map(t => chip(t))
              #let cols = calc.min(4, tech-chips.len())
              #grid(
                columns: (auto,) * cols,
                gutter: 6pt,
                row-gutter: 6pt,
                ..tech-chips
              )
            ]
          ],
        )

        #if project.links.len() > 0 [
          #set text(size: 9.5pt, fill: if mode == "ats" { rgb("#0f172a") } else { accent }, weight: 600)
          #labels.links: #project.links.map(l => link(l.url, l.label)).join(" | ")
        ]
      ]
      #if i < cv.projects.len() - 1 [#v(space.lg)]
    ]
  ])
]


// --- EDUCATION & CERTIFICATIONS ---
#let show_education = cv.education.len() > 0
#let show_certs = cv.certifications.len() > 0

#if show_education or show_certs [
  #grid(
    columns: if show_education and show_certs { (1fr, 1fr) } else { (1fr,) },
    gutter: 20pt,

    ..if show_education {
      (
        section(labels.education, [
          #for (i, edu) in cv.education.enumerate() [
            #set text(size: 10.5pt, weight: 600, fill: secondary)
            #edu.degree
            #linebreak()
            #set text(size: 10pt, weight: 400)
            #edu.institution
            #linebreak()
            #set text(size: 9.5pt, fill: muted)
            #edu.location • #edu.start — #edu.end
            #if i < cv.education.len() - 1 [#v(space.md)]
          ]
        ]),
      )
    } else { () },

    ..if show_certs {
      (
        section(labels.certifications, [
          #for cert in cv.certifications [
            #set text(size: 10.5pt, weight: 600, fill: secondary)
            #cert.name
            #if "year" in cert [
              #h(4pt)
              #set text(size: 10pt, fill: muted)
              (#cert.year)
            ]
            #v(space.sm)
          ]
        ]),
      )
    } else { () }
  )
]

// --- LANGUAGES ---
#if cv.languages.len() > 0 [
  #section(labels.languages, [
    #for lang in cv.languages [
      #grid(
        columns: (auto, 1fr),
        gutter: 12pt,
        [
          #set text(size: 10pt, weight: 700, fill: secondary)
          #lang.name:
        ],
        [
          #set text(size: 10pt)
          #lang.level
        ],
      )
    ]
  ])
]

// --- ATS KEYWORDS ---
#if cv.keywords.len() > 0 [
  #v(space.xl)
  #block[
    #set text(size: 8.75pt, fill: muted.lighten(20%))
    #set par(leading: 1.1em)
    #labels.ats_keywords: #cv.keywords.join(" • ")
  ]
]
