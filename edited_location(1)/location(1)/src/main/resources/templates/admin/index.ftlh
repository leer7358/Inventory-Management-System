<#import "../layout.ftlh" as layout>
<@layout.main title="Admin" pageSubtitle="Manage application-level features and users.">
  <style>
    /* Scoped: single container that holds both admin sections side-by-side */
    .admin-single-container {
      max-width: 1100px;
      margin: 0 auto;
      margin-top: 12px;
    }

    .admin-single-card {
      background: #fff;
      border-radius: 14px;
      padding: 18px;
      border: 1px solid rgba(15,23,42,0.04);
      box-shadow: 0 10px 30px rgba(7,11,25,0.04);
      overflow: hidden;
    }

    /* Modified today: Changed from 2 columns to 3 columns for email container */
    .admin-single-grid {
      display: grid;
      grid-template-columns: 1fr 1fr 1fr;
      gap: 18px;
      align-items: stretch;
    }

    /* Added today: Responsive breakpoints for 3-column layout */
    @media (max-width: 1200px) {
      .admin-single-grid { grid-template-columns: 1fr 1fr; }
    }
    @media (max-width: 880px) {
      .admin-single-grid { grid-template-columns: 1fr; }
    }

    .admin-section {
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      gap: 12px;
      padding: 10px;
      min-height: 120px;
    }

    .admin-section .head {
      display: flex;
      gap: 12px;
      align-items: flex-start;
    }
    .admin-section .icon {
      font-size: 28px;
      color: var(--accent, #0d6efd);
      margin-top: 2px;
      flex-shrink: 0;
    }
    .admin-section h4 {
      margin: 0 0 6px 0;
      font-size: 1.05rem;
    }
    .admin-section p {
      margin: 0;
      color: #6b7280;
      font-size: 0.95rem;
    }

    .admin-section .meta-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      margin-top: 8px;
    }
    .admin-section .meta {
      color: #6b7280;
      font-size: 0.86rem;
    }

    /* Buttons */
    .admin-section .btn { min-width: 86px; }

    /* Make the "Open" button neutral by default and blue only on hover */
    .open-btn {
      background: transparent;
      color: #374151; /* neutral text */
      border: 1px solid rgba(0,0,0,0.08);
      transition: background-color .15s ease, color .15s ease, border-color .15s ease, box-shadow .15s ease;
      padding: .35rem .75rem;
      font-size: .875rem;
    }
    .open-btn:hover,
    .open-btn:focus {
      background: var(--accent, #0d6efd);
      color: #fff;
      border-color: var(--accent, #0d6efd);
      box-shadow: 0 6px 16px rgba(13,110,253,0.14);
      text-decoration: none;
    }

    /* Modified today: Updated separator logic for 3 containers */
    .admin-single-card .admin-single-grid > :not(:last-child) {
      padding-right: 10px;
      border-right: 1px dashed rgba(15,23,42,0.04);
    }
    @media (max-width: 1200px) {
      .admin-single-card .admin-single-grid > :nth-child(2) { border-right: none; padding-right: 0; }
    }
    @media (max-width: 880px) {
      .admin-single-card .admin-single-grid > :not(:last-child) { border-right: none; padding-right: 0; }
    }

    /* Dark mode tweaks for the single card */
    body.dark-theme .admin-single-card {
      background: #1f1f1f !important;
      border-color: rgba(255,255,255,0.04) !important;
      color: #e6e6e6 !important;
    }
    body.dark-theme .admin-section p,
    body.dark-theme .admin-section .meta {
      color: #bfbfbf !important;
    }

    /* Ensure open button remains readable in dark mode but still only blue on hover */
    body.dark-theme .open-btn {
      color: #d1d5db !important;
      border-color: rgba(255,255,255,0.06) !important;
      background: transparent !important;
    }
    body.dark-theme .open-btn:hover,
    body.dark-theme .open-btn:focus {
      background: var(--accent, #0d6efd) !important;
      color: #fff !important;
      border-color: var(--accent, #0d6efd) !important;
      box-shadow: 0 6px 16px rgba(13,110,253,0.18) !important;
    }
  </style>

  <div class="admin-single-container">
    <div class="d-flex justify-content-between align-items-start mb-3">
      <div>
        <h2 class="mb-1"><i class="bi bi-shield-lock"></i> Admin Dashboard</h2>
        <p class="text-muted mb-0">Manage application-level features and users.</p>
      </div>
      <!-- Top-right quick buttons removed per request -->
    </div>

    <div class="admin-single-card">
      <div class="admin-single-grid">
        <!-- Left: User Management -->
        <div class="admin-section" aria-labelledby="user-mgmt-title">
          <div>
            <div class="head">
              <i class="bi bi-people-fill icon" aria-hidden="true"></i>
              <div>
                <h4 id="user-mgmt-title">User Management</h4>
                <p>Create, edit, reset passwords and remove application users. Control roles and access here.</p>
              </div>
            </div>
          </div>

          <div class="meta-row">
            <div class="meta">Manage accounts, roles and security</div>
            <div>
              <a href="/admin/users" class="btn open-btn btn-sm" role="button">Open</a>
            </div>
          </div>
        </div>

        <!-- Middle: Recent Updates -->
        <div class="admin-section" aria-labelledby="recent-updates-title">
          <div>
            <div class="head">
              <i class="bi bi-clock-history icon" aria-hidden="true"></i>
              <div>
                <h4 id="recent-updates-title">Recent Updates - Accounts</h4>
                <p>Audit log of recent account and item activity (creates/updates/deletes). Quickly review recent changes.</p>
              </div>
            </div>
          </div>

          <div class="meta-row">
            <div class="meta">View the latest admin and item events</div>
            <div>
              <a href="/admin/history" class="btn open-btn btn-sm" role="button">View</a>
            </div>
          </div>
        </div>

        <!-- Right: Admin Emails - Added today for email management -->
        <div class="admin-section" aria-labelledby="admin-emails-title">
          <div>
            <div class="head">
              <i class="bi bi-envelope icon" aria-hidden="true"></i>
              <div>
                <h4 id="admin-emails-title">Admin Emails
                  <!-- Added today: Unread email count badge -->
                  <#if unreadEmailCount?? && (unreadEmailCount > 0)>
                    <span class="badge bg-danger ms-2">${unreadEmailCount}</span>
                  </#if>
                </h4>
                <p>View and manage emails received by the admin. Stay updated with important communications.</p>
              </div>
            </div>
          </div>

          <div class="meta-row">
            <div class="meta">Manage admin email inbox</div>
            <div>
              <a href="/admin/emails" class="btn open-btn btn-sm" role="button">View</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</@layout.main>