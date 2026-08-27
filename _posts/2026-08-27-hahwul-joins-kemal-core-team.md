---
title: 'HAHWUL joins the Kemal Core Team as Security Lead'
date: '2026-08-27 17:00'
layout: 'post'
tags:
  - crystal
  - kemal
  - security
post_author: Serdar Dogruyol
excerpt: 'World-renowned white-hat hacker HAHWUL has joined the Kemal Core Team as Security Lead. The same security review that started with a WebSocket smuggling report shaped the 1.13 release — and it is only the beginning.'
---

>Kemal is a Fast, Effective, Simple web framework for [Crystal](https://crystal-lang.org/).

Hello everyone,

I have a special announcement today :tada:

**[HAHWUL](https://hahwul.com)** — Lee Hwan, the South Korea–based offensive security engineer, open-source hacker, and author of tools that security teams around the world actually use — has joined the **Kemal Core Team as Security Lead**.

<p style="text-align:center;margin:8px 0 28px;">
  <img src="/img/blog/hahwul.jpg" alt="HAHWUL" style="width:132px;height:132px;border-radius:50%;object-fit:cover;margin:0 auto;box-shadow:0 8px 24px rgba(44,62,80,0.18);" />
</p>

He [wrote it up on his blog](https://www.hahwul.com/posts/2026/i-ve-joined-the-kemal-core-team/) as well, and shared it on [X](https://x.com/hahwul/status/2092946937276412313). Welcome, HAHWUL. Kemal is stronger with you on the team :shield:

## Who he is :mag:

If you work in web security, you already know the name. HAHWUL is a white-hat hacker and Offensive Security Engineer — Red Team, AppSec, DevSecOps by day, and a prolific open-source builder the rest of the time. His GitHub is a map of the modern web-hacking toolkit:

- **[Dalfox](https://github.com/hahwul/dalfox)** — a widely used XSS scanner built for automation
- **[OWASP Noir](https://github.com/owasp-noir/noir)** — attack-surface detection through static analysis
- **[Authz0](https://github.com/hahwul/authz0)**, **[jwt-hack](https://github.com/hahwul/jwt-hack)**, **[Gori](https://github.com/hahwul/gori)**, and a long list of other tools the community reaches for on real assessments

He is also a Crystal person, not a tourist. Crystal is one of his two main languages. He ships Crystal software of his own — including [Hwaro](https://hahwul.com/projects/), the static site generator behind hahwul.com — and he already runs Kemal in the real world, in projects like [XSSMaze](https://github.com/hahwul/xssmaze). That combination is rare: someone who can break web frameworks for a living, and who already writes production Crystal.

You can follow his work on [hahwul.com](https://hahwul.com), [GitHub](https://github.com/hahwul), and [X](https://x.com/hahwul).

## A security report, and what came after :lock:

HAHWUL did not join because we asked nicely. He joined because he showed up the way a great security engineer shows up: he found something real, reported it, and helped fix it.

In his own words:

> Earlier this month, I joined the Core Team of Kemal, Crystal’s leading web framework.
>
> It started with reporting and fixing request smuggling via WebSocket upgrades. From there, one thing led to another and I was invited to join the Core Team. After joining, I spent some time reviewing and fixing various security issues through the v1.13 release.

That first finding — **WebSocket request smuggling** — is the kind of bug that hides in the gap between a framework and the reverse proxy in front of it. A rejected upgrade that left the connection keep-alive could let a pipelined request slip past the proxy's access controls. The fix in [Kemal 1.13.0](/blog/2026/08/24/kemal-1.13.0-released/) closes the connection on a failed handshake, requires `GET` for upgrades per RFC 6455, and makes same-origin the default for WebSocket `Origin` checks.

That was the door. Then he walked the rest of the house.

## Already in your apps :wrench:

1.13 was a **security-focused** release. HAHWUL's review is all over it — not as a drive-by issue dump, but as someone reading handlers the way an attacker does:

- **SSE injection** — `Kemal::EventStream` now rejects newlines in `event` / `id` and normalizes CR/LF in `data` / `comment`
- **URL params** — the route lookup cache no longer double-decodes parameters
- **WebSocket origin and smuggling** — same-origin by default, `Connection: close` on rejected upgrades, `403` instead of `500` on a malformed `Origin`
- **Handler matching** — sharper `only` / `exclude` behavior so security middleware cannot be accidentally skipped

If you run Kemal in production, [upgrade to 1.13.0](/blog/2026/08/24/kemal-1.13.0-released/). That release is the first public snapshot of this collaboration. It will not be the last.

## What Security Lead means for Kemal :crystal_ball:

Kemal's job is to stay **fast, effective, and simple** — including when the request is hostile.

Having a Security Lead on the Core Team means security is part of how we design handlers, defaults, and the edges that attackers actually use: uploads, ranges, filters, WebSockets, SSE, error pages, and everything that sits in front of your routes.

Expect more of what 1.13 already started:

- Threat modeling of new features before they land
- Hardening of defaults so the safe path is the easy path
- Coordinated handling of reports from the community
- The same standard HAHWUL already applied: find it, fix it, ship it

If you find something in Kemal, we still want to hear it — [open an issue](https://github.com/kemalcr/kemal/issues) or reach the team through the usual [community channels](/community). The difference is that those reports now have a Security Lead on the other side.

## Thank you :heart:

HAHWUL, thank you for the reports, the patches, the reviews, and for treating Kemal like infrastructure that people depend on. That is exactly what it is.

Welcome to the Core Team. Let's make Kemal not only fast and simple, but boringly hard to break.

Read his announcement: [I've joined the Kemal Core Team!](https://www.hahwul.com/posts/2026/i-ve-joined-the-kemal-core-team/)

Happy Crystalling :heart:
