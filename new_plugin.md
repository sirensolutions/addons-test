---
permalink: /new-plugin/
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

{% include github-badges.html %}

{% capture readme_url %}
https://raw.githubusercontent.com/{{ page.github_org }}/{{ page.github_repo }}/main/README.md
{% endcapture %}

{% remote_include readme_url %}