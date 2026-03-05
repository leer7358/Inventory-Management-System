<#import "../layout.ftlh" as layout>
<@layout.main title="Recent Updates" pageSubtitle="Audit log: recent account and item activity.">
  <div class="admin-history mt-2">
    <div class="d-flex justify-content-between align-items-center mb-3">
      <h3 class="mb-0">Recent updates</h3>
      <a href="/admin" class="btn btn-outline-secondary btn-sm">Back to Admin</a>
    </div>

    <div class="card">
      <div class="card-body">
        <#if entries?size == 0>
          <p class="text-muted mb-0">No history entries found.</p>
        <#else>
          <div class="table-responsive">
            <table class="table table-sm table-hover mb-0">
              <thead class="table-dark">
                <tr>
                  <th style="width:180px">Time</th>
                  <th>Actor</th>
                  <th>Action</th>
                  <th>Entity</th>
                  <th style="width:80px">ID</th>
                  <th>Details</th>
                </tr>
              </thead>
              <tbody>
                <#list entries as e>
                  <tr>
                    <td>${e.time!''}</td>
                    <td>${e.actor!''}</td>
                    <td>${e.action!''}</td>
                    <td>${e.entityType!''}</td>
                    <td>${e.entityId?if_exists?string("—")}</td>
                    <td>
                      <span class="details-text" style="color:#000 !important;">${e.details!''}</span>
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