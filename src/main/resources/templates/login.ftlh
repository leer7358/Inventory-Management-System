<#import "layout.ftlh" as layout>
<@layout.main title="Sign In">
    <div class="d-flex justify-content-center align-items-start" style="min-height:60vh;">
        <div class="card p-4" style="width:420px; background: rgba(255,255,255,0.03);">
            <h3 class="text-center mb-3">Sign in to InventoryPro</h3>

            <#if errorMessage??>
                <div class="alert alert-danger">${errorMessage}</div>
            </#if>

            <form method="post" action="/login">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input name="username" type="text" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input name="password" type="password" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Login as</label>
                    <div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="loginAs" id="loginUser" value="USER" checked>
                            <label class="form-check-label" for="loginUser">User</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="loginAs" id="loginAdmin" value="ADMIN">
                            <label class="form-check-label" for="loginAdmin">Admin</label>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Sign In</button>
                    <a href="/" class="btn btn-outline-secondary">Back</a>
                </div>
            </form>

            <hr class="my-3"/>
            <div class="text-center">
                <a href="/register" class="btn btn-link">Register new account</a>
            </div>
        </div>
    </div>
</@layout.main>