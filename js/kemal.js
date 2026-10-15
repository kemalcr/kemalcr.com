/* Kemal site interactions. No dependencies. */
(function () {
  'use strict';
  var $ = function (s, r) { return (r || document).querySelector(s); };
  var $$ = function (s, r) { return Array.prototype.slice.call((r || document).querySelectorAll(s)); };
  var root = document.documentElement;
  var fmt = window.Intl ? new Intl.NumberFormat('en-US') : { format: String };
  var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  // Theme
  function setThemeIcon() {
    $$('[data-theme-toggle]').forEach(function (b) { b.textContent = root.getAttribute('data-theme') === 'light' ? '☾' : '☀'; });
  }
  $$('[data-theme-toggle]').forEach(function (b) {
    b.addEventListener('click', function () {
      var next = root.getAttribute('data-theme') === 'light' ? 'dark' : 'light';
      root.setAttribute('data-theme', next);
      try { localStorage.setItem('kemal-theme', next); } catch (e) {}
      setThemeIcon();
    });
  });
  setThemeIcon();

  // Mobile menu
  var nav = $('#k-nav'), menuBtn = $('[data-menu-toggle]');
  if (nav && menuBtn) {
    menuBtn.addEventListener('click', function () {
      var open = nav.classList.toggle('is-open');
      menuBtn.setAttribute('aria-expanded', open);
      menuBtn.textContent = open ? '✕' : '☰';
    });
    nav.addEventListener('click', function (e) {
      if (e.target.tagName === 'A') { nav.classList.remove('is-open'); menuBtn.setAttribute('aria-expanded', 'false'); menuBtn.textContent = '☰'; }
    });
  }

  // Current page in nav + cookbook sidebar
  var path = location.pathname.replace(/\/$/, '');
  $$('#k-nav a, .Sidebar_category a').forEach(function (a) {
    var href = (a.getAttribute('href') || '').replace(/\/$/, '');
    if (href && href.indexOf('#') === -1 && (path === href || (href.length > 1 && path.indexOf(href) === 0 && a.closest('#k-nav')))) a.classList.add('is-current');
  });
  var docsMenu = $('[data-docs-menu]');
  if (docsMenu && window.innerWidth < 900) docsMenu.removeAttribute('open');

  // Copy command
  $$('[data-copy]').forEach(function (b) {
    var label = $('[data-copy-label]', b);
    b.addEventListener('click', function () {
      var text = b.getAttribute('data-copy');
      var done = function () { if (label) { label.textContent = 'Copied'; setTimeout(function () { label.textContent = 'Copy'; }, 1600); } };
      if (navigator.clipboard) navigator.clipboard.writeText(text).then(done, done); else done();
    });
  });

  // Hero route try-out
  var resp = $('[data-route-resp]');
  function showRoute(name) {
    $$('[data-route-btn]').forEach(function (b) {
      var on = b.getAttribute('data-route-btn') === name;
      b.classList.toggle('is-active', on);
      if (on && resp) resp.textContent = '← ' + b.getAttribute('data-body');
    });
    $$('.k-line').forEach(function (l) { l.classList.toggle('is-on', l.getAttribute('data-route') === name); });
  }
  $$('[data-route-btn]').forEach(function (b) { b.addEventListener('click', function () { showRoute(b.getAttribute('data-route-btn')); }); });
  if ($('[data-route-btn]')) showRoute('root');

  // Live counters + request log (illustrative, based on ~85k req/sec)
  var served = $('[data-served]'), rps = $('[data-rps]'), log = $('[data-log]');
  if (served) {
    var t0 = performance.now();
    setInterval(function () { served.textContent = fmt.format(Math.floor((performance.now() - t0) / 1000 * 85000)); }, 50);
  }
  if (rps) setInterval(function () { rps.textContent = fmt.format(84200 + Math.floor(Math.random() * 1700)); }, 700);
  if (log && !reduce) {
    var routes = [['GET', '/', '200'], ['GET', '/api', '200'], ['POST', '/users', '201'], ['GET', '/posts/hello-world', '200'], ['WS', '/chat', '101'], ['GET', '/assets/app.css', '200'], ['GET', '/api/users/42', '200'], ['QUERY', '/search', '200']];
    var cell = function (cls, txt) { var s = document.createElement('span'); s.className = cls; s.textContent = txt; return s; };
    setInterval(function () {
      if (document.hidden) return;
      var r = routes[Math.floor(Math.random() * routes.length)], d = new Date();
      var row = document.createElement('div'); row.className = 'k-log';
      row.appendChild(cell('k-log__t', d.toTimeString().slice(0, 8) + '.' + String(d.getMilliseconds()).padStart(3, '0')));
      row.appendChild(cell('k-log__m', r[0]));
      row.appendChild(cell('k-log__p', r[1]));
      row.appendChild(cell('k-log__s' + (r[2] === '101' ? ' is-ws' : ''), r[2]));
      row.appendChild(cell('k-log__d', (0.04 + Math.random() * 0.16).toFixed(2) + 'ms'));
      log.appendChild(row);
      while (log.children.length > 16) log.removeChild(log.firstChild);
    }, 140);
  }

  // Grow bars when visible
  var grow = $$('[data-bench], .k-goal');
  if ('IntersectionObserver' in window) {
    var io = new IntersectionObserver(function (es) {
      es.forEach(function (e) { if (e.isIntersecting) { e.target.classList.add('is-grown'); io.unobserve(e.target); } });
    }, { threshold: 0.3 });
    grow.forEach(function (g) { io.observe(g); });
  } else grow.forEach(function (g) { g.classList.add('is-grown'); });

  // Use-case tabs
  $$('[data-tab]').forEach(function (t) {
    t.addEventListener('click', function () {
      var id = t.getAttribute('data-tab');
      $$('[data-tab]').forEach(function (x) { x.classList.toggle('is-active', x === t); x.setAttribute('aria-selected', x === t); });
      $$('[data-panel]').forEach(function (p) { p.hidden = p.getAttribute('data-panel') !== id; });
    });
  });
})();
