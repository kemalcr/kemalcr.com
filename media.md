---
layout: page
title: Media
---

<div class="media-page">
  <div class="media-intro">
    <p class="lead">Official Kemal brand assets and usage guidelines for the community.</p>
  </div>

  <section class="media-section">
    <h2 class="section-title">
      <span class="section-icon">🎨</span>
      Logo
    </h2>
    
    <div class="alert alert-info">
      <strong>Note:</strong> Please follow the <a href="#guidelines">guidelines</a> below when using this material.
    </div>

    <div class="logo-showcase">
      <div class="logo-preview">
        <div class="logo-container">
          <img src="{{ site.baseurl }}/img/kemal.png" alt="Kemal Logo" class="kemal-logo">
        </div>
        <div class="logo-actions">
          <a href="{{ site.baseurl }}/img/kemal.png" download="kemal.png" class="btn btn-primary">
            <span class="download-icon">⬇</span> Download PNG
          </a>
        </div>
      </div>
    </div>
  </section>

  <section class="media-section" id="guidelines">
    <h2 class="section-title">
      <span class="section-icon">📋</span>
      Usage Guidelines
    </h2>

    <div class="guidelines-grid">
      <div class="guideline-card guideline-allowed">
        <div class="card-header">
          <span class="card-icon">✅</span>
          <h3>Acceptable Use</h3>
        </div>
        <ul class="guideline-list">
          <li>Include it in technical articles, blog posts, or news about Kemal</li>
          <li>Display it in conference presentations, academic papers, or community talks</li>
          <li>Feature it when showcasing projects you've built with Kemal</li>
          <li>Incorporate it into educational content and tutorials</li>
          <li>Use it on personal, non-commercial merchandise</li>
        </ul>
      </div>

      <div class="guideline-card guideline-restricted">
        <div class="card-header">
          <span class="card-icon">❌</span>
          <h3>Please Refrain From</h3>
        </div>
        <ul class="guideline-list">
          <li>Altering the logo's design, colors, or proportions</li>
          <li>Commercializing products featuring the logo without permission</li>
          <li>Creating combination logos that merge Kemal's branding with your own</li>
          <li>Adopting the logo as your primary brand identity</li>
          <li>Presenting the logo in ways that imply official endorsement from the Kemal project</li>
        </ul>
      </div>
    </div>
  </section>

  <section class="media-section">
    <div class="contact-card">
      <h3>Questions About Usage?</h3>
      <p>If you have questions about using Kemal's brand assets, please reach out to the community through our <a href="{{ site.baseurl }}/community">community channels</a>.</p>
    </div>
  </section>
</div>

<style>
.media-page {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem 1rem;
}

.media-intro {
  text-align: center;
  margin-bottom: 3rem;
}

.media-intro .lead {
  font-size: 1.25rem;
  color: #666;
  margin: 0;
}

.media-section {
  margin-bottom: 4rem;
}

.section-title {
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 1.5rem;
  color: #333;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.section-icon {
  font-size: 1.75rem;
}

.alert {
  padding: 1rem 1.5rem;
  border-radius: 8px;
  margin-bottom: 2rem;
  border-left: 4px solid;
}

.alert-info {
  background-color: #e3f2fd;
  border-color: #2196f3;
  color: #1565c0;
}

.alert strong {
  font-weight: 600;
}

.alert a {
  color: #1565c0;
  text-decoration: underline;
}

.logo-showcase {
  background: #f8f9fa;
  border-radius: 12px;
  padding: 3rem 2rem;
  text-align: center;
}

.logo-container {
  background: white;
  padding: 3rem;
  border-radius: 12px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  margin-bottom: 2rem;
  display: inline-block;
}

.kemal-logo {
  max-width: 300px;
  height: auto;
  display: block;
}

.logo-actions {
  display: flex;
  justify-content: center;
  gap: 1rem;
}

.btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.5rem;
  font-size: 1rem;
  font-weight: 600;
  text-decoration: none;
  border-radius: 6px;
  transition: all 0.2s ease;
  cursor: pointer;
}

.btn-primary {
  background: #ee4266;
  color: white;
}

.btn-primary:hover {
  background: #d93859;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(238, 66, 102, 0.3);
}

.download-icon {
  font-size: 1.2rem;
}

.guidelines-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-top: 2rem;
}

.guideline-card {
  background: white;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.guideline-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
}

.guideline-allowed {
  border-top: 4px solid #4caf50;
}

.guideline-restricted {
  border-top: 4px solid #f44336;
}

.card-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1.5rem;
}

.card-icon {
  font-size: 2rem;
}

.card-header h3 {
  margin: 0;
  font-size: 1.5rem;
  font-weight: 700;
  color: #333;
}

.guideline-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.guideline-list li {
  padding: 0.75rem 0;
  padding-left: 1.5rem;
  position: relative;
  color: #555;
  line-height: 1.6;
}

.guideline-list li::before {
  content: "•";
  position: absolute;
  left: 0;
  font-weight: bold;
  font-size: 1.5rem;
}

.guideline-allowed .guideline-list li::before {
  color: #4caf50;
}

.guideline-restricted .guideline-list li::before {
  color: #f44336;
}

.contact-card {
  background: linear-gradient(135deg, #f52b31 0%, #15a2ab 100%);
  color: white;
  padding: 2.5rem;
  border-radius: 12px;
  text-align: center;
  box-shadow: 0 8px 24px rgba(245, 43, 49, 0.3);
}

.contact-card h3 {
  margin: 0 0 1rem 0;
  font-size: 1.75rem;
  font-weight: 700;
}

.contact-card p {
  margin: 0;
  font-size: 1.1rem;
  opacity: 0.95;
}

.contact-card a {
  color: white;
  text-decoration: underline;
  font-weight: 600;
}

.contact-card a:hover {
  opacity: 0.8;
}

@media (max-width: 768px) {
  .media-page {
    padding: 1rem 0.5rem;
  }

  .section-title {
    font-size: 1.5rem;
  }

  .logo-showcase {
    padding: 2rem 1rem;
  }

  .logo-container {
    padding: 2rem 1rem;
  }

  .kemal-logo {
    max-width: 200px;
  }

  .guidelines-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }

  .guideline-card {
    padding: 1.5rem;
  }

  .contact-card {
    padding: 2rem 1.5rem;
  }
}
</style>
