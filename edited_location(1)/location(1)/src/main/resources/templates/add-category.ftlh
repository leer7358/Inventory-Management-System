<#import "layout.ftlh" as layout>

<@layout.main title="Add Category">
    <div class="container mt-4">
        <div class="card shadow-sm">
            <div class="card-body">
                <form method="post" action="/categories/save">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Category Name</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Description</label>
                        <textarea name="description" class="form-control" rows="2"></textarea>
                    </div>

                    <div class="text-end">
                        <button type="submit" class="btn btn-success px-4">Save</button>
                        <a href="/categories" class="btn btn-outline-secondary px-4">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</@layout.main>
