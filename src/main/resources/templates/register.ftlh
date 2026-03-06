<#import "layout.ftlh" as layout>
<@layout.main title="Register">
    <div class="d-flex justify-content-center align-items-start" style="min-height:60vh;">
        <div class="card p-4" style="width:480px; background: rgba(255,255,255,0.03);">
            <h3 class="text-center mb-3">Create an account</h3>

            <#if errorMessage??>
                <div class="alert alert-danger">${errorMessage}</div>
            </#if>

            <form method="post" action="/register">
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <input name="username" type="text" class="form-control" required />
                </div>

                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <input name="password" type="password" class="form-control" required minlength="6" />
                </div>

                <div class="mb-3">
                    <label class="form-label">Role</label>
                    <div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="role" id="roleUser" value="USER" checked>
                            <label class="form-check-label" for="roleUser">User</label>
                        </div>
                    </div>
                    <div class="form-text text-muted"></div>
                </div>

                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Register</button>
                    <a href="/login" class="btn btn-outline-secondary">Back to login</a>
                </div>
            </form>
        </div>
    </div>
</@layout.main>