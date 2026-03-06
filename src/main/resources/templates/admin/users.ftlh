<#import "../layout.ftlh" as layout>
<@layout.main title="Admin - Users" pageSubtitle="Create, edit and remove users.">
  <div class="mt-2">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3 class="mb-0">User Management</h3>
      <a href="/admin" class="btn btn-outline-secondary btn-sm">Back to Admin</a>
    </div>

    <#-- Flash messages -->
    <#if successMessage??>
      <div class="alert alert-success">${successMessage}</div>
    </#if>
    <#if errorMessage??>
      <div class="alert alert-danger">${errorMessage}</div>
    </#if>

    <#if tempPassword?? && tempPassword?has_content>
      <div class="alert alert-success">
        Temporary password for <strong>${resetFor}</strong>: <code>${tempPassword}</code>
        <div class="small text-muted mt-1">This password is shown only once. Ask the user to change it after logging in.</div>
      </div>
    </#if>

    <div class="card">
      <div class="card-body">
        <#if users?size == 0>
          <p class="text-muted mb-0">No users found.</p>
        <#else>
          <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
              <thead class="table-dark">
                <tr>
                  <th style="width:6%">ID</th>
                  <th>Username</th>
                  <th style="width:18%">Role</th>
                  <th style="width:24%" class="text-end">Actions</th>
                </tr>
              </thead>
              <tbody>
                <#list users as u>
                  <tr>
                    <td>${u.id}</td>
                    <td>${u.username}</td>
                    <td>${u.role}</td>
                    <td class="text-end">
                      <a href="/admin/users/reset/${u.id}" class="btn btn-sm btn-outline-primary me-1">
                        <i class="bi bi-key-fill"></i> Reset
                      </a>

                      <#-- Delete: POST form with CSRF if available -->
                      <form method="post" action="/admin/users/delete/${u.id}" style="display:inline;" onsubmit="return confirm('Delete user ${u.username}?');">
                        <#if csrf??>
                          <input type="hidden" name="${csrf.parameterName}" value="${csrf.token}" />
                        </#if>
                        <button type="submit" class="btn btn-sm btn-outline-danger">Delete</button>
                      </form>
                    </td>
                  </tr>
                </#list>
              </tbody>
            </table>
          </div>
        </#if>
      </div>
    </div>
  </div>
</@layout.main>