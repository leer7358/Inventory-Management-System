<#import "layout.ftlh" as layout>

<@layout.main title="Edit Item">
    <div class="container mt-5">
        <div class="card shadow-lg border-0 rounded-4">
            <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                <h4 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Item</h4>
                <a href="/items" class="btn btn-light btn-sm"><i class="bi bi-arrow-left"></i> Back</a>
            </div>

            <div class="card-body p-4">
                <form action="/items/update" method="post">
                    <input type="hidden" name="id" value="${item.id}">

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Item Name</label>
                        <input type="text" name="name" class="form-control" value="${item.name}" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="3">${item.description}</textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-semibold">Quantity</label>
                            <input type="number" name="quantity" class="form-control" value="${item.quantity}" required>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-semibold">Price</label>
                            <input type="number" step="0.01" name="price" class="form-control" value="${item.price}" required>
                        </div>

                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-semibold">Category</label>
                            <select name="category.id" class="form-select">
                                <#list categories as cat>
                                    <#if item.category?? && item.category.id == cat.id>
                                        <option value="${cat.id}" selected>${cat.name}</option>
                                    <#else>
                                        <option value="${cat.id}">${cat.name}</option>
                                    </#if>
                                </#list>
                            </select>
                        </div>
                    </div>

                    <div class="d-flex justify-content-end gap-2 mt-4">
                        <a href="/items" class="btn btn-outline-secondary px-4">Cancel</a>
                        <button type="submit" class="btn btn-success px-4">
                            <i class="bi bi-save"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</@layout.main>
