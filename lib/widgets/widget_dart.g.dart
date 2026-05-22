var mapTemplates = {
	r"forms/form_register.j2.html": r"""<form action="/register" method="post" class="space-y-5">
    <input type="hidden" name="token" value="{{ $n('form_register/token/value') }}" />
    {% if $n('form_register/token/error') %}
    <span class="text-sm text-red-500 ms-2 flex items-center gap-1">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <p>{{ $n('form_register/token/error') | tr }}</p>
    </span>
    {% endif %}
    <div class="space-y-2">
        <label for="email" class="block text-sm font-bold text-slate-700">Email</label>
        <div
            class="flex items-center gap-3 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 transition focus-within:border-emerald-500 focus-within:bg-white focus-within:shadow-[0_0_0_4px_rgba(16,185,129,0.12)]">
            <i class="fa-regular fa-user text-slate-400"></i>
            <input id="email" name="email" type="email" autocomplete="email" placeholder="Enter your email"
                class="w-full border-0 bg-transparent p-0 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none"
                value="{{ $n('form_register/email/value') }}">
        </div>
        {% if $n('form_register/email/error') %}
        <span class="text-sm text-red-500 ms-2 flex items-center gap-1">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <p>{{ $n('form_register/email/error') | tr }}</p>
        </span>
        {% endif %}
    </div>

    <div class="space-y-2">
        <label for="username" class="block text-sm font-bold text-slate-700">Username</label>
        <div
            class="flex items-center gap-3 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 transition focus-within:border-emerald-500 focus-within:bg-white focus-within:shadow-[0_0_0_4px_rgba(16,185,129,0.12)]">
            <i class="fa-regular fa-user text-slate-400"></i>
            <input id="username" name="username" type="text" autocomplete="username" placeholder="Enter your username"
                class="w-full border-0 bg-transparent p-0 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none"
                value="{{ $n('form_register/username/value') }}">
        </div>
        {% if $n('form_register/username/error') %}
        <span class="text-sm text-red-500 ms-2 flex items-center gap-1">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <p>{{ $n('form_register/username/error') | tr }}</p>
        </span>
        {% endif %}
    </div>

    <div class="grid grid-cols-1 gap-4 sm:grid-cols-2 sm:gap-5">
        <div class="space-y-2">
            <label for="password" class="block text-sm font-bold text-slate-700">Password</label>
            <div
                class="flex items-center gap-3 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 transition focus-within:border-emerald-500 focus-within:bg-white focus-within:shadow-[0_0_0_4px_rgba(16,185,129,0.12)]">
                <i class="fa-solid fa-key text-slate-400"></i>
                <input id="password" name="password" type="password" autocomplete="current-password"
                    placeholder="Enter your password"
                    class="w-full border-0 bg-transparent p-0 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none"
                    value="{{ $n('form_register/password/value') }}">
            </div>
            {% if $n('form_register/password/error') %}
            <span class="text-sm text-red-500 ms-2 flex items-center gap-1">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <p>{{ $n('form_register/password/error') | tr }}</p>
            </span>
            {% endif %}
        </div>

        <div class="space-y-2">
            <label for="confirm_password" class="block text-sm font-bold text-slate-700">Confirm Password</label>
            <div
                class="flex items-center gap-3 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 transition focus-within:border-emerald-500 focus-within:bg-white focus-within:shadow-[0_0_0_4px_rgba(16,185,129,0.12)]">
                <i class="fa-solid fa-key text-slate-400"></i>
                <input id="confirm_password" name="confirm_password" type="password" autocomplete="current-password"
                    placeholder="Confirm your password"
                    class="w-full border-0 bg-transparent p-0 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none"
                    value="{{ $n('form_register/confirm_password/value') }}">
            </div>
            {% if $n('form_register/confirm_password/error') %}
            <span class="text-sm text-red-500 ms-2 flex items-center gap-1">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <p>{{ $n('form_register/confirm_password/error') | tr }}</p>
            </span>
            {% endif %}
        </div>
    </div>

    <button type="submit"
        class="inline-flex w-full items-center justify-center gap-3 rounded-2xl bg-slate-950 px-5 py-4 text-sm font-extrabold uppercase tracking-[0.2em] text-white transition hover:-translate-y-0.5 hover:bg-emerald-600 focus:outline-none focus:ring-4 focus:ring-emerald-200">
        Register
        <i class="fa-solid fa-arrow-right-to-bracket"></i>
    </button>
</form>""",
	r"forms/form_login.j2.html": r"""<form action="/login" method="post" class="space-y-5">
    <input type="hidden" name="token" value="{{ $n('form_login/token/value') }}" />
    {% if $n('form_login/token/error') %}
    <span class="text-sm text-red-500 ms-2 flex items-center gap-1">
        <i class="fa-solid fa-triangle-exclamation"></i>
        <p>{{ $n('form_login/token/error') | tr }}</p>
    </span>
    {% endif %}
    <div class="space-y-2">
        <label for="username" class="block text-sm font-bold text-slate-700">Username</label>
        <div
            class="flex items-center gap-3 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 transition focus-within:border-emerald-500 focus-within:bg-white focus-within:shadow-[0_0_0_4px_rgba(16,185,129,0.12)]">
            <i class="fa-regular fa-user text-slate-400"></i>
            <input id="username" name="username" type="text" autocomplete="username" placeholder="Enter your username"
                class="w-full border-0 bg-transparent p-0 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none"
                value="{{ $n('form_login/username/value') }}">
        </div>
        {% if $n('form_login/username/error') %}
        <span class="text-sm text-red-500 ms-2 flex items-center gap-1">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <p>{{ $n('form_login/username/error') | tr }}</p>
        </span>
        {% endif %}
    </div>

    <div class="space-y-2">
        <div class="flex items-center justify-between gap-3">
            <label for="password" class="block text-sm font-bold text-slate-700">Password</label>
            <a href="/register"
                class="text-xs font-bold uppercase tracking-[0.24em] text-emerald-700 transition hover:text-emerald-500">
                Register now
            </a>
        </div>
        <div
            class="flex items-center gap-3 rounded-2xl border border-slate-200 bg-slate-50 px-4 py-3 transition focus-within:border-emerald-500 focus-within:bg-white focus-within:shadow-[0_0_0_4px_rgba(16,185,129,0.12)]">
            <i class="fa-solid fa-key text-slate-400"></i>
            <input id="password" name="password" type="password" autocomplete="current-password"
                placeholder="Enter your password"
                class="w-full border-0 bg-transparent p-0 text-sm font-medium text-slate-900 placeholder:text-slate-400 focus:outline-none"
                value="{{ $n('form_login/password/value') }}">
        </div>
        {% if $n('form_login/password/error') %}
        <span class="text-sm text-red-500 ms-2 flex items-center gap-1">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <p>{{ $n('form_login/password/error') | tr }}</p>
        </span>
        {% endif %}
    </div>

    <button type="submit"
        class="inline-flex w-full items-center justify-center gap-3 rounded-2xl bg-slate-950 px-5 py-4 text-sm font-extrabold uppercase tracking-[0.2em] text-white transition hover:-translate-y-0.5 hover:bg-emerald-600 focus:outline-none focus:ring-4 focus:ring-emerald-200">
        Login
        <i class="fa-solid fa-arrow-right-to-bracket"></i>
    </button>
</form>""",
	r"footer.j2.html": r"""<script src="https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js"></script>
<script
  src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js"
  integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r"
  crossorigin="anonymous"
></script>
<script
  crossorigin="anonymous"
></script>
<script src="/assets/app.js"></script>
<script src="/assets/effects/wave/wave.js"></script>
{{ assets.dataJs() }}
{{ assets.js() }}
""",
	r"base/auth.base.j2.html": r"""<!DOCTYPE html>
<html lang="{{ $e.ln }}" dir="{{ $t('dir') }}" class="h-full overflow-x-hidden">

<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>{% block title %}{% endblock %} | {{ $t(title ?? 'Finch Chat') }}</title>
  <meta name="robots" content="noindex, nofollow">
  <link rel="icon" href="/favicon.ico" type="image/x-icon" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link rel="stylesheet" href="/assets/generated-tailwind.css" />
  <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
  {% block stylesheets %}
  {{ assets.css() }}
  {% endblock %}
</head>

<body class="h-full bg-gray-50 font-sans antialiased overflow-x-hidden">
  <div class="flex min-h-screen w-screen max-w-full bg-gradient-to-br from-gray-50 to-blue-50/30 overflow-x-hidden">
    <!-- Main Component -->
      <main class="content flex-1 px-4 py-6 mt-16 lg:px-8 lg:py-8 w-full min-w-0">
        <div class="mx-auto w-full max-w-7xl min-w-0">
          {% block content %}
          {% endblock %}
        </div>
      </main>
  </div>

  {% block footer %}
  {% include 'footer.j2.html' %}
  {% endblock %}

  {% block script %}{% endblock %}
</body>
</html>""",
	r"base/chat.base.j2.html": r"""<!DOCTYPE html>
<html lang="{{ $e.ln }}" dir="{{ $t('dir') }}" class="h-full overflow-hidden">

<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>{% block title %}{% endblock %} | {{ $t(title ?? 'Finch Chat') }}</title>
	<meta name="robots" content="noindex, nofollow">
	<link rel="icon" href="/favicon.ico" type="image/x-icon">
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
	<link rel="stylesheet" href="/assets/generated-tailwind.css">
	<link rel="stylesheet" href="/assets/app.css" crossorigin="anonymous">
	<script src="https://code.jquery.com/jquery-3.7.1.min.js"
		integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
	{% block stylesheets %}
	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap"
		rel="stylesheet">
	{{ assets.css() }}
	{% endblock %}
</head>

<body  class="h-full overflow-hidden bg-slate-950 font-sans antialiased text-slate-100">
	<div id="chat-home-vue"></div>

	{% block footer %}
	{% include 'footer.j2.html' %}
	{% endblock %}

	<script type="module" src="/assets/vue/home.js"></script>
</body>

</html>""",
	r"home.j2.html": r"""{% extends 'base/chat.base.j2.html' %}
""",
	r"register.j2.html": r"""{% extends 'base/auth.base.j2.html' %}

{% block title %}
    Register
{% endblock %}

{% block stylesheets %}
    {{ super() }}
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
{% endblock %}

{% block content %}
<section class="relative isolate overflow-hidden rounded-[2rem] border border-slate-200/70 bg-[radial-gradient(circle_at_top_left,_rgba(16,185,129,0.12),_transparent_30%),radial-gradient(circle_at_bottom_right,_rgba(15,23,42,0.1),_transparent_35%),linear-gradient(135deg,_rgba(255,255,255,0.98),_rgba(248,250,252,0.95))] px-6 py-10 shadow-[0_32px_80px_-48px_rgba(15,23,42,0.7)] sm:px-10 lg:px-12"
         style="font-family: 'Manrope', sans-serif;">
    <div class="pointer-events-none absolute inset-y-0 left-0 hidden w-2/5 bg-[linear-gradient(135deg,_rgba(15,23,42,0.96),_rgba(30,41,59,0.88))] lg:block"></div>
    <div class="pointer-events-none absolute -left-24 top-12 h-56 w-56 rounded-full bg-emerald-400/20 blur-3xl"></div>
    <div class="pointer-events-none absolute bottom-0 right-0 h-64 w-64 rounded-full bg-sky-300/20 blur-3xl"></div>

    <div class="relative grid items-stretch gap-8 lg:grid-cols-[0.4fr_0.6fr]">
        <div class="hidden rounded-[1.75rem] p-10 text-white lg:flex lg:flex-col lg:justify-between">
            <div class="space-y-5">
                <span class="inline-flex w-fit items-center rounded-full border border-white/15 bg-white/10 px-4 py-1 text-sm font-semibold uppercase tracking-[0.24em] text-emerald-200">
                    New account
                </span>
                <div class="space-y-4">
                    <h1 class="max-w-md text-3xl font-extrabold leading-tight text-white">
                        Register route preview with the same focused visual pattern.
                    </h1>
                    <p class="max-w-lg text-base leading-7 text-slate-300">
                        This page is display-only for now and is wired just to show the register route in the frontend.
                    </p>
                </div>
            </div>

            <div class="flex items-center justify-between rounded-[1.5rem] border border-white/10 bg-white/5 px-5 py-4 backdrop-blur-sm">
                <div>
                    <p class="text-sm uppercase tracking-[0.22em] text-slate-400">Already have access?</p>
                    <p class="mt-1 text-lg font-semibold text-white">Go back to the login screen.</p>
                </div>
                <a href="/"
                   class="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white px-5 py-3 text-sm font-bold text-slate-900 transition hover:-translate-y-0.5 hover:bg-emerald-300">
                    Login
                    <i class="fa-solid fa-arrow-right text-xs"></i>
                </a>
            </div>
        </div>

        <div class="relative flex items-center justify-center">
            <div class="w-full max-w-xl rounded-[1.75rem] border border-white/70 bg-white/90 p-6 shadow-[0_24px_60px_-40px_rgba(15,23,42,0.85)] backdrop-blur-xl sm:p-8">
                <div class="mb-8 flex items-start justify-between gap-4">
                    <div class="space-y-3">
                        <span class="inline-flex items-center rounded-full bg-emerald-50 px-3 py-1 text-xs font-bold uppercase tracking-[0.28em] text-emerald-700">
                            Register only
                        </span>
                        <div>
                            <h2 class="text-3xl font-extrabold tracking-tight text-slate-950">Create account</h2>
                            <p class="mt-2 text-sm leading-6 text-slate-500">
                                This is the frontend route preview for register and does not submit to backend logic yet.
                            </p>
                        </div>
                    </div>
                    <div class="hidden rounded-2xl bg-slate-950 p-4 text-white sm:block">
                        <i class="fa-solid fa-user-plus text-xl"></i>
                    </div>
                </div>

                {% include form_register.widget | unscape %}

                <div class="mt-6 rounded-2xl border border-dashed border-slate-200 bg-slate-50/80 px-4 py-4 text-sm text-slate-500">
                    This route is ready for UI preview.
                    <a href="/" class="font-bold text-slate-900 underline decoration-emerald-400 decoration-2 underline-offset-4">Return to login</a>
                    when you want the main entry screen.
                </div>
            </div>
        </div>
    </div>
</section>
{% endblock %}""",
	r"login.j2.html": r"""{% extends 'base/auth.base.j2.html' %}

{% block title %}
    {{ $t('sidebar.home') }}
{% endblock %}

{% block stylesheets %}
    {{ super() }}
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
{% endblock %}

{% block content %}
<section class="relative isolate overflow-hidden rounded-[2rem] border border-slate-200/70 bg-[radial-gradient(circle_at_top_left,_rgba(16,185,129,0.12),_transparent_30%),radial-gradient(circle_at_bottom_right,_rgba(15,23,42,0.1),_transparent_35%),linear-gradient(135deg,_rgba(255,255,255,0.98),_rgba(248,250,252,0.95))] px-6 py-10 shadow-[0_32px_80px_-48px_rgba(15,23,42,0.7)] sm:px-10 lg:px-12"
         style="font-family: 'Manrope', sans-serif;">
    <div class="pointer-events-none absolute inset-y-0 left-0 hidden w-2/5 bg-[linear-gradient(135deg,_rgba(15,23,42,0.96),_rgba(30,41,59,0.88))] lg:block"></div>
    <div class="pointer-events-none absolute -left-24 top-12 h-56 w-56 rounded-full bg-emerald-400/20 blur-3xl"></div>
    <div class="pointer-events-none absolute bottom-0 right-0 h-64 w-64 rounded-full bg-sky-300/20 blur-3xl"></div>

    <div class="relative grid items-stretch gap-8 lg:grid-cols-[0.4fr_0.6fr]">
        <div class="hidden rounded-[1.75rem] p-10 text-white lg:flex lg:flex-col lg:justify-between">
            <div class="space-y-5">
                <span class="inline-flex w-fit items-center rounded-full border border-white/15 bg-white/10 px-4 py-1 text-sm font-semibold uppercase tracking-[0.24em] text-emerald-200">
                    Secure access
                </span>
                <div class="space-y-4">
                    <h1 class="max-w-md text-3xl font-extrabold leading-tight text-white">
                        Sign in to your workspace with a clean, focused login flow.
                    </h1>
                    <p class="max-w-lg text-base leading-7 text-slate-300">
                        This home page is intentionally reduced to login only, so the first interaction is clear and direct.
                    </p>
                </div>
            </div>

            <div class="flex items-center justify-between rounded-[1.5rem] border border-white/10 bg-white/5 px-5 py-4 backdrop-blur-sm">
                <div>
                    <p class="text-sm uppercase tracking-[0.22em] text-slate-400">Need an account?</p>
                    <p class="mt-1 text-lg font-semibold text-white">Start with registration first.</p>
                </div>
                <a href="/register"
                   class="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white px-5 py-3 text-sm font-bold text-slate-900 transition hover:-translate-y-0.5 hover:bg-emerald-300">
                    Register
                    <i class="fa-solid fa-arrow-right text-xs"></i>
                </a>
            </div>
        </div>

        <div class="relative flex items-center justify-center">
            <div class="w-full max-w-xl rounded-[1.75rem] border border-white/70 bg-white/90 p-6 shadow-[0_24px_60px_-40px_rgba(15,23,42,0.85)] backdrop-blur-xl sm:p-8">
                <div class="mb-8 flex items-start justify-between gap-4">
                    <div class="space-y-3">
                        <span class="inline-flex items-center rounded-full bg-emerald-50 px-3 py-1 text-xs font-bold uppercase tracking-[0.28em] text-emerald-700">
                            Login only
                        </span>
                        <div>
                            <h2 class="text-3xl font-extrabold tracking-tight text-slate-950">Welcome back</h2>
                            <p class="mt-2 text-sm leading-6 text-slate-500">
                                Enter your username and password to continue.
                            </p>
                        </div>
                    </div>
                    <div class="hidden rounded-2xl bg-slate-950 p-4 text-white sm:block">
                        <i class="fa-solid fa-lock text-xl"></i>
                    </div>
                </div>

                {% include form_login.widget | unscape %}

                <div class="mt-6 rounded-2xl border border-dashed border-slate-200 bg-slate-50/80 px-4 py-4 text-sm text-slate-500">
                    New here?
                    <a href="/register" class="font-bold text-slate-900 underline decoration-emerald-400 decoration-2 underline-offset-4">Create your account</a>
                    and come back to login.
                </div>
            </div>
        </div>
    </div>
</section>
{% endblock %}
"""
};