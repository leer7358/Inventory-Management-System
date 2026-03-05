<#import "layout.ftlh" as layout>
<@layout.main title="Settings">

    <div class="content fade-in">
        <h2 class="fw-bold mb-3"><i class="bi bi-gear"></i> Settings</h2>
        <p class="text-muted">Customize system preferences and alerts for your inventory management.</p>

        <!-- 🔹 Low Stock Threshold -->
        <div class="card shadow-sm border-0 rounded-4 mt-4">
            <div class="card-body">
                <h5 class="fw-semibold mb-3 text-primary">
                    <i class="bi bi-exclamation-triangle"></i> Low Stock Threshold
                </h5>
                <p class="text-muted small mb-4">
                    This setting determines when an item is considered <strong>“Low Stock.”</strong><br>
                    All pages (Dashboard, Items, Reports) will automatically update based on this value.
                </p>

                <div class="d-flex align-items-center mb-3 gap-3 flex-wrap">
                    <input type="range" id="thresholdSlider" min="1" max="50" value="${threshold}" class="form-range w-50">
                    <input type="number" id="thresholdInput" value="${threshold}" min="1" max="50" class="form-control w-auto text-center">
                    <button id="saveThreshold" class="btn btn-primary rounded-pill px-4">
                        <i class="bi bi-save"></i> Save
                    </button>
                </div>

                <div id="thresholdStatus" class="text-muted small mt-2">
                    Current Threshold: <strong id="thresholdValue">${threshold}</strong>
                </div>
            </div>
        </div>

        <!-- 🌙 Dark Mode Setting -->
        <div class="card shadow-sm border-0 rounded-4 mt-4">
            <div class="card-body">
                <h5 class="fw-semibold mb-3 text-dark">
                    <i class="bi bi-moon-stars"></i> Theme Preference
                </h5>
                <p class="text-muted small mb-3">
                    Toggle between Light and Dark Mode. This will apply to all pages.
                </p>

                <div class="form-check form-switch">
                    <input class="form-check-input" type="checkbox" id="themeToggle">
                    <label class="form-check-label" for="themeToggle">Enable Dark Mode</label>
                </div>
            </div>
        </div>

        <!-- 🔧 Coming Soon -->
        <div class="card shadow-sm border-0 rounded-4 mt-4 mb-5">
            <div class="card-body">
                <h5 class="fw-semibold mb-3 text-secondary"><i class="bi bi-tools"></i> Coming Soon</h5>
                <p class="text-muted small">
                    • Notification preferences<br>
                    • Auto-report scheduling<br>
                    • Data backup settings
                </p>
            </div>
        </div>
    </div>

    <!-- ✅ Toast Notification -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1055;">
        <div id="toastMessage" class="toast align-items-center text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="d-flex">
                <div class="toast-body" id="toastBody">
                    Settings updated successfully!
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- ✅ JS for Threshold + Dark Mode -->
    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const slider = document.getElementById("thresholdSlider");
            const input = document.getElementById("thresholdInput");
            const saveBtn = document.getElementById("saveThreshold");
            const status = document.getElementById("thresholdStatus");
            const thresholdValue = document.getElementById("thresholdValue");
            const toastElement = document.getElementById("toastMessage");
            const toastBody = document.getElementById("toastBody");
            const themeToggle = document.getElementById("themeToggle");

            // 🔹 Sync slider + input
            slider.addEventListener("input", () => {
                input.value = slider.value;
                thresholdValue.textContent = slider.value;
            });
            input.addEventListener("input", () => {
                slider.value = input.value;
                thresholdValue.textContent = input.value;
            });

            // 🔹 Save Threshold
            saveBtn.addEventListener("click", async () => {
                const newThreshold = input.value;
                try {
                    const response = await fetch("/settings/update-threshold", {
                        method: "POST",
                        headers: { "Content-Type": "application/x-www-form-urlencoded" },
                        body: "threshold=" + encodeURIComponent(newThreshold)
                    });
                    const msg = await response.text();
                    if (response.ok && msg.toLowerCase().includes("updated")) {
                        status.innerHTML = `<span class='text-success'><i class='bi bi-check-circle'></i> ${msg!}</span>`;
                        toastBody.textContent = "Threshold updated successfully!";
                        toastElement.classList.remove("text-bg-danger");
                        toastElement.classList.add("text-bg-success");
                        new bootstrap.Toast(toastElement, { delay: 3000 }).show();
                    }
                } catch (err) {
                    console.error(err);
                }
            });

            // 🌙 Dark Mode Global Toggle
            const body = document.body;
            const savedTheme = localStorage.getItem("theme") || "light";
            if (savedTheme === "dark") {
                body.classList.add("dark-theme");
                themeToggle.checked = true;
            }

            themeToggle.addEventListener("change", () => {
                if (themeToggle.checked) {
                    body.classList.add("dark-theme");
                    localStorage.setItem("theme", "dark");
                } else {
                    body.classList.remove("dark-theme");
                    localStorage.setItem("theme", "light");
                }
                // Reload so all pages apply theme
                setTimeout(() => location.reload(), 500);
            });
        });
    </script>

    <!-- ✅ Dark Theme Styles -->
    <style>
        .fade-in { animation: fadeIn 0.6s ease-in-out; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }

        input[type="range"] { accent-color: #0d6efd; }

        .card { transition: transform 0.2s ease, box-shadow 0.2s ease; }
        .card:hover { transform: translateY(-3px); box-shadow: 0 6px 18px rgba(0,0,0,0.08); }

        /* 🌙 Dark Mode Styles */
        .dark-theme {
            background-color: #121212 !important;
            color: #e0e0e0 !important;
        }
        .dark-theme .card {
            background-color: #1e1e1e !important;
            color: #f5f5f5 !important;
            border-color: #333 !important;
        }
        .dark-theme input,
        .dark-theme select,
        .dark-theme textarea {
            background-color: #2a2a2a;
            color: #fff;
            border: 1px solid #444;
        }
        .dark-theme .table {
            color: #f0f0f0;
        }
    </style>

</@layout.main>
