<#import "layout.ftlh" as layout>

<@layout.main title="Manage Categories">
    <div class="container mt-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="fw-bold text-dark">🗂️ Category Management</h2>
            <a href="/categories/add" class="btn btn-success">
                <i class="bi bi-plus-circle"></i> Add New Category
            </a>
        </div>

        <!-- 🔍 Search Bar -->
        <form action="/categories" method="get" class="d-flex align-items-center gap-2 mb-4">
            <input type="text" name="search" id="searchCategory" value="${search!}"
                   class="form-control" placeholder="Search category by name..."
                   style="max-width: 300px;">
            <button class="btn btn-outline-primary" type="submit">
                <i class="bi bi-search"></i> Search
            </button>
        </form>

        <!-- 📋 Categories Table -->
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <table class="table table-hover align-middle">
                    <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Category Name</th>
                        <th class="text-center">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if categories?size == 0>
                        <tr>
                            <td colspan="3" class="text-center text-muted py-3">
                                <i class="bi bi-folder-x"></i> No categories found for "<b>${search!}</b>"
                            </td>
                        </tr>
                    <#else>
                        <#list categories as cat>
                            <tr>
                                <td>${cat.id}</td>
                                <td>${cat.name}</td>
                                <td class="text-center">
                                    <a href="/categories/edit/${cat.id}" class="btn btn-sm btn-outline-primary me-1">
                                        <i class="bi bi-pencil-square"></i> Edit
                                    </a>
                                    <a href="/categories/delete/${cat.id}" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-trash"></i> Delete
                                    </a>
                                </td>
                            </tr>
                        </#list>
                    </#if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- ⚙️ Auto-refresh on empty search -->
    <script>
        const searchCategory = document.getElementById("searchCategory");
        searchCategory.addEventListener("input", function() {
            if (this.value.trim() === "") {
                window.location.href = "/categories";
            }
        });
    </script>
</@layout.main>
