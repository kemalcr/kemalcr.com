<div class="Sidebar">
  <div class="h3 Sidebar_title">Cookbook</div>
  <nav class="Sidebar_nav">
    {% assign sorted_pages = (site.cookbook | sort: 'title') %}
    
    <div class="Sidebar_category">
      <div class="Sidebar_category_title">Getting Started</div>
      {% for post in sorted_pages %}
        {% if post.slug == 'hello_world' %}
          <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        {% endif %}
      {% endfor %}
    </div>

    <div class="Sidebar_category">
      <div class="Sidebar_category_title">HTTP & API</div>
      {% for post in sorted_pages %}
        {% assign slug = post.slug %}
        {% if slug == 'json_api' or slug == 'json_mapping' or slug == 'cors' or slug == 'http_basic_auth' %}
          <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        {% endif %}
      {% endfor %}
    </div>

    <div class="Sidebar_category">
      <div class="Sidebar_category_title">File Operations</div>
      {% for post in sorted_pages %}
        {% assign slug = post.slug %}
        {% if slug == 'file_download' or slug == 'file_upload' or slug == 'multiple_file_upload' %}
          <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        {% endif %}
      {% endfor %}
    </div>

    <div class="Sidebar_category">
      <div class="Sidebar_category_title">Database</div>
      {% for post in sorted_pages %}
        {% assign slug = post.slug %}
        {% if slug == 'mysql-db' or slug == 'postgresql-db' or slug == 'redis' %}
          <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        {% endif %}
      {% endfor %}
    </div>

    <div class="Sidebar_category">
      <div class="Sidebar_category_title">Session & Auth</div>
      {% for post in sorted_pages %}
        {% assign slug = post.slug %}
        {% if slug == 'cookies' or slug == 'session' %}
          <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        {% endif %}
      {% endfor %}
    </div>

    <div class="Sidebar_category">
      <div class="Sidebar_category_title">Advanced</div>
      {% for post in sorted_pages %}
        {% assign slug = post.slug %}
        {% if slug == 'websocket_chat' or slug == 'reuse_port' or slug == 'unix_domain_socket' %}
          <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
        {% endif %}
      {% endfor %}
    </div>
  </nav>
</div>
