<#macro main title pageSubtitle=''>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>${title!}</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- Bootstrap -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

        <!-- Custom Global Styles -->
        <link rel="stylesheet" href="/styles.css?v=${.now?long}">

        <style>
            @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap');
            body {
                font-family: 'Poppins', sans-serif;
                margin: 0;
                background-color: #f5f7fb;
                color: #212529;
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            .dashboard {
                display: flex;
                min-height: 100vh;
            }

            /* Sidebar */
            .sidebar {
                width: 240px;
                background: linear-gradient(180deg, #0d6efd, #0a58ca);
                color: #fff;
                padding: 2rem 1rem;
                position: fixed;
                top: 0;
                bottom: 0;
                display: flex;
                flex-direction: column;
                transition: background 0.3s ease;
                z-index: 1000;
            }

            .brand {
                font-size: 1.4rem;
                font-weight: 600;
                margin-bottom: 2rem;
                display: flex;
                align-items: center;
            }

            .nav-links a {
                display: block;
                color: #ffffffb3;
                text-decoration: none;
                padding: 0.8rem 1rem;
                border-radius: 8px;
                margin-bottom: 0.5rem;
                transition: all 0.3s ease;
            }

            .nav-links a:hover,
            .nav-links a.active {
                background: #fff;
                color: #0d6efd;
                font-weight: 600;
            }

            .main-content {
                margin-left: 240px;
                flex: 1;
                padding: 2rem;
                transition: background-color 0.3s ease;
                min-height: 100vh;
            }

            /* small top area (user/logout row) */
            .topbar-row {
                display:flex;
                justify-content:flex-end;
                align-items:center;
                gap: 0.75rem;
            }

            /* 🌙 DARK THEME GLOBAL STYLES */
            body.dark-theme {
                background-color: #121212 !important;
                color: #f5f5f5 !important;
            }

            .dark-theme .sidebar {
                background: linear-gradient(180deg, #1e1e1e, #141414);
            }

            .dark-theme .nav-links a {
                color: #bbb !important;
            }
            .dark-theme .nav-links a:hover,
            .dark-theme .nav-links a.active {
                background: #0d6efd !important;
                color: #fff !important;
            }

            .dark-theme .main-content {
                background-color: #181818 !important;
                color: #e0e0e0 !important;
            }

            .dark-theme .card {
                background-color: #1f1f1f !important;
                border-color: #2a2a2a !important;
                color: #f8f9fa !important;
            }

            .dark-theme h1, .dark-theme h2, .dark-theme h3, .dark-theme h4, .dark-theme h5, .dark-theme h6,
            .dark-theme label, .dark-theme p, .dark-theme span, .dark-theme small {
                color: #fff !important;
            }

            .dark-theme .table {
                color: #fff !important;
            }
            .dark-theme .table thead {
                background-color: #2a2a2a !important;
            }
            .dark-theme .table-hover tbody tr:hover {
                background-color: rgba(255, 255, 255, 0.05) !important;
            }

            .dark-theme input,
            .dark-theme select,
            .dark-theme textarea {
                background-color: #2a2a2a !important;
                color: #fff !important;
                border: 1px solid #444 !important;
            }

            /* Buttons in dark theme */
            .dark-theme .btn-outline-primary,
            .dark-theme .btn-outline-primary i {
                color: #66b3ff !important;
                border-color: #66b3ff !important;
            }
            .dark-theme .btn-outline-primary:hover,
            .dark-theme .btn-outline-primary:hover i {
                background-color: #0d6efd !important;
                color: #fff !important;
            }

            .dark-theme .btn-outline-danger,
            .dark-theme .btn-outline-danger i {
                color: #ff7b7b !important;
                border-color: #ff7b7b !important;
            }
            .dark-theme .btn-outline-danger:hover,
            .dark-theme .btn-outline-danger:hover i {
                background-color: #dc3545 !important;
                color: #fff !important;
            }

            .dark-theme .btn-outline-secondary,
            .dark-theme .btn-outline-secondary i {
                color: #b0b0b0 !important;
                border-color: #666 !important;
            }
            .dark-theme .btn-outline-secondary:hover,
            .dark-theme .btn-outline-secondary:hover i {
                background-color: #b0b0b0 !important;
                color: #000 !important;
            }

            /* Responsive: collapse sidebar on small screens */
            @media (max-width: 991px) {
                .sidebar { transform: translateX(-110%); position: fixed; left: 0; top: 0; bottom: 0; }
                .sidebar.open { transform: translateX(0); }
                .main-content { margin-left: 0; padding: 1rem; }
                .brand { font-size: 1.05rem; }
            }
        </style>
    </head>

    <body>
    <div class="dashboard">
        <aside class="sidebar" id="appSidebar">
            <div class="brand">
                <i class="bi bi-box-seam-fill me-2"></i> InventoryPro
            </div>
            <nav class="nav-links">
                <a href="/" class="${(title == 'Dashboard')?then('active','')}"><i class="bi bi-speedometer2 me-2"></i> Dashboard</a>
                <a href="/items" class="${(title == 'Items')?then('active','')}"><i class="bi bi-box me-2"></i> Items</a>
                <a href="/categories" class="${(title == 'Categories')?then('active','')}"><i class="bi bi-tags me-2"></i> Categories</a>
                <a href="/reports" class="${(title == 'Reports')?then('active','')}"><i class="bi bi-bar-chart me-2"></i> Reports</a>
                <a href="/settings" class="${(title == 'Settings')?then('active','')}"><i class="bi bi-gear me-2"></i> Settings</a>

                <#-- Admin area link visible only to admins -->
                <#if isAdmin>
                    <a href="/admin" class="${(title == 'Admin' || title?starts_with('Admin'))?then('active','')}"><i class="bi bi-shield-lock me-2"></i> Admin</a>
                </#if>
            </nav>
        </aside>

        <main class="main-content">
            <div class="topbar-row mb-3">
                <div class="d-flex align-items-center me-auto">
                    <button id="sidebarToggle" class="btn btn-sm btn-outline-secondary d-lg-none me-2" aria-label="Toggle sidebar">
                        <i class="bi bi-list"></i>
                    </button>
                    <div>
                        <h1 class="h4 mb-0">${title!}</h1>
                        <#if pageSubtitle?has_content>
                            <small class="text-muted">${pageSubtitle}</small>
                        </#if>
                    </div>
                </div>

                <div class="d-flex align-items-center">
                    <#if currentUser?? && currentUser?has_content>
                        <div class="me-3 align-self-center">
                            <i class="bi bi-person-circle"></i> <strong>${currentUser}</strong>
                            <#if isAdmin> <span class="badge bg-warning text-dark ms-2">Admin</span></#if>
                        </div>
                        <form method="post" action="/logout" style="display:inline;">
                            <#-- include CSRF token if provided in the model as 'csrf' -->
                            <#if csrf??>
                                <input type="hidden" name="${csrf.parameterName}" value="${csrf.token}" />
                            </#if>
                            <button type="submit" class="btn btn-outline-secondary btn-sm">Logout</button>
                        </form>
                    <#else>
                        <a href="/login" class="btn btn-outline-primary btn-sm">Login</a>
                    </#if>
                </div>
            </div>

            <#nested>
        </main>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Sidebar toggle for small screens
        document.addEventListener("DOMContentLoaded", function() {
            const sidebar = document.getElementById('appSidebar');
            const toggle = document.getElementById('sidebarToggle');

            if (toggle && sidebar) {
                toggle.addEventListener('click', () => {
                    sidebar.classList.toggle('open');
                });
            }

            // Apply saved theme preference (light/dark)
            const savedTheme = localStorage.getItem('theme') || 'light';
            if (savedTheme === 'dark') {
                document.body.classList.add('dark-theme');
            }

            // Optional: expose a quick toggle via data attribute (templates can add a button with data-theme-toggle)
            document.querySelectorAll('[data-theme-toggle]').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const dark = document.body.classList.toggle('dark-theme');
                    localStorage.setItem('theme', dark ? 'dark' : 'light');
                });
            });
        });
    </script>
    </body>
    </html>
</#macro>