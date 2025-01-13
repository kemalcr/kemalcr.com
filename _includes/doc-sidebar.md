<div class="Sidebar">
  <div class="h3 Sidebar_title">Cookbooks</div>
  <nav class="Sidebar_nav">
    {% assign sorted_pages = (site.cookbook | sort: 'title') %}
    {% for post in sorted_pages %}
      <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
    {% endfor %}
  </nav>
</div>
