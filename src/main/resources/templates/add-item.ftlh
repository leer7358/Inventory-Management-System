<#import "layout.ftlh" as layout>

<@layout.main title="Add New Item">
    <div class="container mt-4">
        <div class="card shadow-sm">
            <div class="card-body">
                <form method="post" action="/items/save">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Item Name</label>
                        <input type="text" name="name" class="form-control" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-bold">Description</label>
                        <textarea name="description" class="form-control" rows="2"></textarea>
                    </div>

                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Quantity</label>
                            <input type="number" name="quantity" class="form-control" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Price</label>
                            <input type="number" step="0.01" name="price" class="form-control" required>
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label fw-bold">Category</label>
                            <select name="category.id" class="form-select" required>
                                <#list categories as cat>
                                    <option value="${cat.id}">${cat.name}</option>
                                </#list>
                            </select>
                        </div>
                    </div>

                    <div class="text-end">
                        <button type="submit" class="btn btn-success px-4">Save</button>
                        <a href="/items" class="btn btn-outline-secondary px-4">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</@layout.main>
