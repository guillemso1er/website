(function () {
  const $ = (sel, root = document) => root.querySelector(sel);
  const $$ = (sel, root = document) => Array.from(root.querySelectorAll(sel));

  // Language auto-redirect on the root page only.
  if (document.documentElement.dataset.page === 'lang-gateway') {
    try {
      const stored = localStorage.getItem('pref-lang');
      const lang = (stored || navigator.language || 'en').slice(0, 2).toLowerCase();
      const target = lang === 'es' ? '/es/' : '/en/';
      // If already on the right lang via direct link, do nothing.
      if (!location.pathname.startsWith('/en') && !location.pathname.startsWith('/es')) {
        // Delay a tick to avoid CLS; still instant.
        setTimeout(() => { location.href = target; }, 150);
      }
    } catch (_) { }
  }

  // Year in footer
  const yearEl = $('#year');
  if (yearEl) yearEl.textContent = new Date().getFullYear();

  // Mobile menu
  const menuBtn = $('#menuBtn');
  const mobileNav = $('#mobileNav');
  if (menuBtn && mobileNav) {
    menuBtn.addEventListener('click', () => {
      const isOpen = mobileNav.hasAttribute('hidden') ? false : true;
      if (isOpen) {
        mobileNav.setAttribute('hidden', '');
        menuBtn.setAttribute('aria-expanded', 'false');
      } else {
        mobileNav.removeAttribute('hidden');
        menuBtn.setAttribute('aria-expanded', 'true');
      }
    });
  }

  // Theme toggle (class-based for Tailwind dark:, and fallback CSS works via prefers-color-scheme)
  const themeToggle = $('#themeToggle');
  if (themeToggle) {
    const apply = (mode) => {
      const root = document.documentElement;
      if (mode === 'dark') root.classList.add('dark'); else root.classList.remove('dark');
      localStorage.setItem('theme', mode);
      themeToggle.setAttribute('aria-pressed', mode === 'dark' ? 'true' : 'false');
    };
    const stored = localStorage.getItem('theme');
    if (stored) apply(stored);
    themeToggle.addEventListener('click', () => {
      const isDark = document.documentElement.classList.contains('dark');
      apply(isDark ? 'light' : 'dark');
    });
  }

  // Copy email button
  const copyBtn = $('#copyEmail');
  if (copyBtn) {
    copyBtn.addEventListener('click', async () => {
      try {
        const email = copyBtn.dataset.email || '';
        await navigator.clipboard.writeText(email);
        const prev = copyBtn.textContent;
        copyBtn.textContent = 'Copied ✓';
        setTimeout(() => (copyBtn.textContent = prev), 1200);
      } catch (_) {
        // Fallback: open mailto
        const email = copyBtn.dataset.email || '';
        location.href = `mailto:${email}`;
      }
    });
  }

  // Remember chosen language when clicking locale links
  $$('#mobileNav a[href^="/"], header a[href^="/"]').forEach((link) => {
    link.addEventListener('click', () => {
      if (link.getAttribute('href').startsWith('/en/')) localStorage.setItem('pref-lang', 'en');
      if (link.getAttribute('href').startsWith('/es/')) localStorage.setItem('pref-lang', 'es');
    });
  });
})();

/**
      * Dynamically loads resume data from a JSON file and updates the page content.
      * This function is called on DOMContentLoaded to progressively enhance the page
      * with the latest data. If the fetch fails, the static content remains.
      */
async function loadDynamicResumeData() {
  try {
    // Determine the language from the page's <html lang="..."> attribute
    const lang = document.documentElement.lang || 'en';
    const jsonPath = `/assets/json/resume-${lang}.json`;

    const response = await fetch(jsonPath);
    if (!response.ok) {
      console.error(`Failed to fetch resume data from ${jsonPath}. Status: ${response.status}`);
      return;
    }
    const data = await response.json();
    updatePageContent(data);
  } catch (error) {
    console.error('Error loading or parsing resume data:', error);
  }
}

/**
 * Updates the DOM with the provided resume data.
 * @param {object} data - The resume data object from the JSON file.
 */
function updatePageContent(data) {
  // Update Basics
  document.title = `${data.basics.name} — ${data.basics.title}`;
  document.querySelector('#basics-name').textContent = data.basics.name;
  document.querySelector('#basics-title').textContent = data.basics.title;
  document.querySelector('#basics-summary').textContent = data.basics.summary;
  document.querySelector('#basics-location').textContent = `${data.basics.location} `;

  const emailLink = `mailto:${data.basics.email}?subject=Hiring%20Inquiry%20from%20your%20site&body=Hi%20${encodeURIComponent(data.basics.name)},%0D%0A`;
  document.querySelector('#hero-email-link').href = emailLink;
  document.querySelector('#contact-email-link').href = emailLink;
  document.querySelector('#copyEmail').dataset.email = data.basics.email;

  // Update Social Links
  const socialContainer = document.querySelector('#social-links');
  socialContainer.innerHTML = '';
  if (data.basics.github) {
    socialContainer.innerHTML += `<a href="${data.basics.github}" class="social-link">GitHub</a>`;
  }
  if (data.basics.linkedin) {
    socialContainer.innerHTML += `<a href="${data.basics.linkedin}" class="social-link">LinkedIn</a>`;
  }

  // Update Projects
  const projectsContainer = document.getElementById('projects-container');
  projectsContainer.innerHTML = ''; // Clear static content
  data.projects.forEach(project => {
    const article = document.createElement('article');
    article.className = 'card';
    article.innerHTML = `
                    <div class="card-body">
                        <h3 class="h3"><a href="${project.links[0].url}" class="card-link">${project.name}</a></h3>
                        <p>${project.summary}</p>
                        <ul class="tags">${project.tech.map(t => `<li class="tag">${t}</li>`).join('')}</ul>
                        <p class="muted"><a href="${project.links[0].url}" class="text-link">${project.links[0].label}</a>.</p>
                    </div>`;
    projectsContainer.appendChild(article);
  });


  // Update Testimonials
  const testimonialsContainer = document.getElementById('testimonials-container');
  if (data.testimonials && data.testimonials.length > 0) {
    testimonialsContainer.innerHTML = ''; // Clear static content
    data.testimonials.forEach(testimonial => {
      const blockquote = document.createElement('blockquote');
      blockquote.className = 'quote';
      blockquote.innerHTML = `
                        <p>“${testimonial.quote}”</p>
                        <footer>${testimonial.author}</footer>
                    `;
      testimonialsContainer.appendChild(blockquote);
    });
  }


  // Update Experience
  const experienceContainer = document.getElementById('experience-container');
  experienceContainer.innerHTML = ''; // Clear static content
  data.experience.forEach(job => {
    const li = document.createElement('li');
    li.className = 'timeline-item';
    li.innerHTML = `
                    <div class="timeline-dot"></div>
                    <div class="timeline-content">
                        <h3 class="h3">${job.title} · ${job.company}</h3>
                        <p class="muted">${job.start} — ${job.end} · ${job.location}</p>
                        <ul class="list">${job.bullets.map(b => `<li>${b}</li>`).join('')}</ul>
                    </div>`;
    experienceContainer.appendChild(li);
  });

  // Update Skills
  const skillsContainer = document.getElementById('skills-container');
  skillsContainer.innerHTML = ''; // Clear static content
  data.skills.forEach(skillCat => {
    const div = document.createElement('div');
    div.className = 'card';
    div.innerHTML = `
                    <div class="card-body">
                        <h3 class="h4">${skillCat.category}</h3>
                        <ul class="tags">${skillCat.items.map(item => `<li class="tag">${item}</li>`).join('')}</ul>
                    </div>`;
    skillsContainer.appendChild(div);
  });

  // Update footer
  document.getElementById('year').textContent = new Date().getFullYear();
  document.getElementById('footer-name').textContent = data.basics.name;
}


document.addEventListener('DOMContentLoaded', () => {
  // Check if we are on the resume page by looking for a unique element.
  if (document.getElementById('content')) {
    loadDynamicResumeData();
  }

});