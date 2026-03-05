<#import "layout.ftlh" as layout>
<@layout.main title="Reports">

    <div class="content fade-in">
        <h2 class="fw-bold mb-3"><i class="bi bi-graph-up"></i> Reports Overview</h2>
        <p class="text-muted">Visual summary of your inventory performance and low stock status.</p>
        <p class="text-muted small">
            Current Low Stock Threshold: <strong>${threshold}</strong>
        </p>

        <!-- Summary Cards -->
        <div class="row mb-4 g-3">
            <div class="col-md-4">
                <div class="card text-white bg-primary p-3 shadow-sm text-center rounded-4">
                    <h3 class="fw-bold">${totalCategories}</h3>
                    <p class="m-0">Total Categories</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-white bg-success p-3 shadow-sm text-center rounded-4">
                    <h3 class="fw-bold">${totalItems}</h3>
                    <p class="m-0">Total Items</p>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card text-dark bg-warning p-3 shadow-sm text-center rounded-4">
                    <h3 class="fw-bold">${lowStockCount}</h3>
                    <p class="m-0">Low Stock Items</p>
                </div>
            </div>
        </div>

        <!-- Charts -->
        <div class="row mt-4">
            <div class="col-md-6 mb-4">
                <div class="card shadow-sm p-3 rounded-4 chart-card">
                    <h5 class="fw-semibold mb-3 text-center text-primary">📊 Items by Category</h5>
                    <div class="chart-container">
                        <canvas id="categoryPieChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="col-md-6 mb-4">
                <div class="card shadow-sm p-3 rounded-4 chart-card">
                    <h5 class="fw-semibold mb-3 text-center text-danger">⚠️ Low Stock Items</h5>
                    <div class="chart-container">
                        <canvas id="lowStockBarChart"></canvas>
                    </div>
                </div>
            </div>
        </div>

        <!-- Low Stock Table -->
        <div class="card shadow-sm mt-4 rounded-4">
            <div class="card-body">
                <h5 class="fw-bold mb-3"><i class="bi bi-exclamation-triangle"></i> Low Stock Details</h5>
                <table class="table table-striped align-middle text-center">
                    <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Quantity</th>
                        <th>Category</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if lowStockItems?size == 0>
                        <tr>
                            <td colspan="4" class="text-center text-muted py-3">
                                <i class="bi bi-check-circle"></i> No low stock items — all good!
                            </td>
                        </tr>
                    <#else>
                        <#list lowStockItems as item>
                            <tr class="${(item.quantity <= threshold)?then('table-danger','')}">
                                <td>${item.id}</td>
                                <td>${item.name}</td>
                                <td>${item.quantity}</td>
                                <td>${item.category.name}</td>
                            </tr>
                        </#list>
                    </#if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            try {
                const countByCategory = ${countByCategoryJson?no_esc};
                const lowStockItems = ${lowStockItemsJson?no_esc};

                console.log("✅ Category Data:", countByCategory);
                console.log("✅ Low Stock Data:", lowStockItems);

                // PIE CHART
                const categoryLabels = Object.keys(countByCategory);
                const categoryData = Object.values(countByCategory);

                if (categoryLabels.length > 0) {
                    new Chart(document.getElementById("categoryPieChart"), {
                        type: "pie",
                        data: {
                            labels: categoryLabels,
                            datasets: [{
                                label: "Items by Category",
                                data: categoryData,
                                backgroundColor: [
                                    "#007bff", "#28a745", "#ffc107", "#17a2b8",
                                    "#6f42c1", "#e83e8c", "#fd7e14", "#20c997"
                                ],
                                borderColor: "#fff",
                                borderWidth: 2
                            }]
                        },
                        options: {
                            maintainAspectRatio: false,
                            responsive: true,
                            plugins: { legend: { position: "bottom" } }
                        }
                    });
                }

                // BAR CHART
                const lowLabels = lowStockItems.map(i => i.name);
                const lowData = lowStockItems.map(i => i.quantity);

                if (lowLabels.length > 0) {
                    new Chart(document.getElementById("lowStockBarChart"), {
                        type: "bar",
                        data: {
                            labels: lowLabels,
                            datasets: [{
                                label: "Quantity Remaining",
                                data: lowData,
                                backgroundColor: "#dc3545",
                                borderColor: "#a71d2a",
                                borderWidth: 1.5
                            }]
                        },
                        options: {
                            maintainAspectRatio: false,
                            responsive: true,
                            scales: {
                                y: { beginAtZero: true, ticks: { stepSize: 1 } }
                            },
                            plugins: { legend: { display: false } }
                        }
                    });
                }

            } catch (error) {
                console.error("❌ Error rendering charts:", error);
            }
        });
    </script>

    <style>
        .fade-in {
            animation: fadeIn 0.6s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .card {
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        /* ✅ Equal chart height & width */
        .chart-card {
            height: 400px; /* same height for both */
        }
        .chart-container {
            position: relative;
            height: 100%;
            width: 100%;
        }
        canvas {
            width: 100% !important;
            height: 100% !important;
        }
    </style>

</@layout.main>
