<#import "layout.ftlh" as layout>

<@layout.main title="Edit Category">
    <div class="container mt-4">
        <div class="card shadow-sm border-0 glass-card p-4">
            <div class="card-body">
                <h4 class="fw-bold mb-3"><i class="bi bi-pencil-square me-2"></i>Edit Category</h4>

                <form method="post" action="/categories/update">
                    <input type="hidden" name="id" value="${category.id!''}">

                    <!-- Category Name -->
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Category Name</label>
                        <input
                                type="text"
                                name="name"
                                class="form-control"
                                placeholder="Enter category name..."
                                value="${category.name!''}"
                                required>
                    </div>

                    <!-- Buttons -->
                    <div class="text-end mt-4">
                        <button type="submit" class="btn btn-warning px-4">
                            <i class="bi bi-save me-1"></i> Update
                        </button>
                        <a href="/categories" class="btn btn-outline-secondary px-4">
                            <i class="bi bi-x-circle me-1"></i> Cancel
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</@layout.main>
