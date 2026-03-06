<#import "../layout.ftlh" as layout>
<@layout.main title="Reset Password" pageSubtitle="Reset or generate a temporary password for a user.">
  <div class="d-flex justify-content-center mt-3">
    <div style="max-width:520px; width:100%;">
      <div class="card">
        <div class="card-body">
          <h4 class="mb-3">Reset password for <strong>${user.username}</strong></h4>

          <form method="post" action="/admin/users/reset">
            <input type="hidden" name="id" value="${user.id}" />
            <#if csrf??>
              <input type="hidden" name="${csrf.parameterName}" value="${csrf.token}" />
            </#if>

            <div class="mb-3">
              <label class="form-label">Set New Password (leave blank to generate)</label>
              <input type="text" name="newPassword" class="form-control" placeholder="Enter a new password (optional)"/>
            </div>

            <div class="d-flex gap-2">
              <button type="submit" name="action" value="set" class="btn btn-primary">Set Password</button>
              <button type="submit" name="action" value="generate" class="btn btn-outline-secondary">Generate Temporary Password</button>
              <a href="/admin/users" class="btn btn-link">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</@layout.main>