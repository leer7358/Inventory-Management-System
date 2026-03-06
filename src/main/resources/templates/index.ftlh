<#import "layout.ftlh" as layout>

<@layout.main title="Dashboard">
    <h2 class="fw-bold mb-4"><i class="bi bi-bar-chart"></i> Inventory Dashboard</h2>

    <div class="row g-3 fade-in">
        <div class="col-md-4">
            <div class="card bg-primary text-white shadow-sm p-3 rounded-4">
                <h5>Total Categories</h5>
                <h2>${totalCategories}</h2>
                <p>Available product categories</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card bg-success text-white shadow-sm p-3 rounded-4">
                <h5>Total Items</h5>
                <h2>${totalItems}</h2>
                <p>All items currently in the system</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card bg-warning text-dark shadow-sm p-3 rounded-4">
                <h5>Low Stock</h5>
                <h2>${lowStock}</h2>
                <p>Items running low in quantity</p>
            </div>
        </div>
    </div>

    <div class="card mt-4 p-3 shadow-sm rounded-4">
        <h5 class="fw-bold mb-3">Quick Actions</h5>
        <div class="d-flex gap-3">
            <a href="/items" class="btn btn-outline-primary rounded-pill"><i class="bi bi-box"></i> Manage Items</a>
            <a href="/categories" class="btn btn-outline-secondary rounded-pill"><i class="bi bi-tags"></i> Manage Categories</a>
            <a href="/items/add" class="btn btn-outline-success rounded-pill"><i class="bi bi-plus-circle"></i> Add New Item</a>
        </div>
    </div>
</@layout.main>
