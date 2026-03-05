<#import "layout.ftlh" as layout>

<@layout.main title="Items">
    <div class="header d-flex justify-content-between align-items-center mb-4">
        <h2 class="fw-bold"><i class="bi bi-box"></i> Manage Items</h2>
        <a href="/items/add" class="btn btn-primary"><i class="bi bi-plus-circle"></i> Add New Item</a>
    </div>

    <div class="search-container mb-4 d-flex gap-2">
        <input type="text" id="searchInput" class="form-control rounded-pill" placeholder="Search by name or category...">
        <button class="btn btn-outline-primary rounded-pill"><i class="bi bi-search"></i></button>
    </div>

    <div class="card shadow-sm">
        <div class="card-body">
            <table class="table table-hover text-center align-middle">
                <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Description</th>
                    <th>Quantity</th>
                    <th>Price</th>
                    <th>Category</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody id="itemTable">
                <#if items?size == 0>
                    <tr>
                        <td colspan="7" class="text-muted py-3">
                            <i class="bi bi-search"></i> No items found.
                        </td>
                    </tr>
                <#else>
                    <#list items as item>
                        <tr class="${(item.quantity <= threshold)?then('table-danger','')}">
                        <td>${item.id}</td>
                            <td>${item.name}</td>
                            <td>${item.description}</td>
                            <td>
                                <#if item.quantity <= threshold>
                                    <span class="badge bg-danger">Low: ${item.quantity}</span>
                                <#else>
                                    <span class="badge bg-success">${item.quantity}</span>
                                </#if>
                            </td>
                            <td>₱${item.price?string["#,##0.00"]}</td>
                            <td>${item.category.name}</td>
                            <td>
                                <a href="/items/edit/${item.id}" class="btn btn-outline-primary btn-sm"><i class="bi bi-pencil"></i></a>
                                <a href="/items/delete/${item.id}" class="btn btn-outline-danger btn-sm"><i class="bi bi-trash"></i></a>
                            </td>
                        </tr>
                    </#list>
                </#if>
                </tbody>
            </table>
            <div class="text-end mt-3">
                <a href="/items/export" class="btn btn-outline-secondary rounded-pill"><i class="bi bi-file-earmark-arrow-down"></i> Export CSV</a>
            </div>
        </div>
    </div>

    <script>
        document.getElementById("searchInput").addEventListener("input", function() {
            const keyword = this.value.toLowerCase().trim();
            const rows = document.querySelectorAll("#itemTable tr");
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = keyword === "" || text.includes(keyword) ? "" : "none";
            });
        });
    </script>
</@layout.main>
