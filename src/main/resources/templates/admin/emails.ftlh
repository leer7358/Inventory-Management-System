<#import "../layout.ftlh" as layout>
<@layout.main title="Admin Notifications" pageSubtitle="System-generated alerts for administrators.">
    <div class="container-fluid">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2><i class="bi bi-bell"></i> System Notifications</h2>
                <p class="text-muted">All automatic alerts and important messages appear here.</p>
            </div>
            <a href="/admin" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Back to Admin
            </a>
        </div>

        <#if successMessage??>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </#if>

        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white d-flex align-items-center">
                <i class="bi bi-inbox me-2"></i>
                <h5 class="mb-0">Admin Notifications (${emails?size})</h5>
            </div>

            <div class="card-body p-0">
                <#if emails?has_content>
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 align-middle">
                            <thead class="table-light">
                            <tr>
                                <th>Status</th>
                                <th>Type</th>
                                <th>Message</th>
                                <th>Received</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <#list emails as email>
                                <tr class="${email.read?then('', 'table-warning')}">
                                    <td>
                                        <#if email.read>
                                            <span class="badge bg-secondary">Read</span>
                                        <#else>
                                            <span class="badge bg-danger">Unread</span>
                                        </#if>
                                    </td>

                                    <td>
                                        <#if email.subject?contains("Low Stock")>
                                            <span class="badge bg-warning text-dark"><i class="bi bi-exclamation-triangle"></i> Low Stock</span>
                                        <#elseif email.subject?contains("Security")>
                                            <span class="badge bg-danger"><i class="bi bi-shield-lock"></i> Security</span>
                                        <#elseif email.subject?contains("Report")>
                                            <span class="badge bg-info text-dark"><i class="bi bi-bar-chart"></i> Report</span>
                                        <#else>
                                            <span class="badge bg-light text-dark"><i class="bi bi-info-circle"></i> General</span>
                                        </#if>
                                    </td>

                                    <td>
                                        <strong>${email.subject}</strong><br>
                                        <small class="text-muted">${email.content?truncate(100, "...")}</small>
                                    </td>

                                    <td><small>${email.receivedAt}</small></td>

                                    <td>
                                        <button type="button" class="btn btn-sm btn-outline-info"
                                                data-bs-toggle="modal"
                                                data-bs-target="#viewEmailModal${email.id}">
                                            <i class="bi bi-eye"></i> View
                                        </button>

                                        <#if !email.read>
                                            <form method="post" action="/admin/emails/mark-read/${email.id}" style="display:inline;">
                                                <button type="submit" class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-check-circle"></i> Mark Read
                                                </button>
                                            </form>
                                        </#if>
                                    </td>
                                </tr>
                            </#list>
                            </tbody>
                        </table>
                    </div>
                <#else>
                    <div class="text-center py-5">
                        <i class="bi bi-bell-slash display-1 text-muted"></i>
                        <h4 class="mt-3">No notifications yet</h4>
                        <p class="text-muted">System alerts such as low-stock warnings will appear here automatically.</p>
                    </div>
                </#if>
            </div>
        </div>
    </div>

    <!-- 🔹 MODALS -->
    <#list emails as email>
        <div class="modal fade" id="viewEmailModal${email.id}" tabindex="-1" aria-labelledby="viewEmailLabel${email.id}" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
                <div class="modal-content shadow-lg">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title" id="viewEmailLabel${email.id}">
                            <i class="bi bi-envelope-paper"></i> ${email.subject}
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p><strong>From:</strong> ${email.sender}</p>
                        <p><strong>Received:</strong> ${email.receivedAt}</p>
                        <hr>

                        <!-- 🔹 Format email content as bullet points -->
                        <div class="formatted-email">
                            <ul class="email-list">
                                <#list email.content?split("\n") as line>
                                    <#if line?trim != "">
                                        <li>${line}</li>
                                    </#if>
                                </#list>
                            </ul>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="bi bi-x-circle"></i> Close
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </#list>

    <style>
        /* 🌙 DARK THEME OPTIMIZED — TEXT IS CLEAR AND BALANCED */
        .dark-theme {
            color: #eaeaea !important;
            background-color: #121212 !important;
        }

        /* Table and general text */
        .dark-theme .table {
            color: #eaeaea !important;
        }
        .dark-theme .table td,
        .dark-theme .table th {
            border-color: #3a3a3a !important;
        }

        /* Make all normal text bright enough */
        .dark-theme td,
        .dark-theme th,
        .dark-theme strong,
        .dark-theme p,
        .dark-theme small,
        .dark-theme span {
            color: #f5f5f5 !important;
        }

        /* Keep muted readable but softer */
        .dark-theme .text-muted,
        .dark-theme small.text-muted {
            color: #dcdcdc !important;
            opacity: 0.95 !important;
        }

        /* Unread row (yellow) — dark text to contrast */
        .dark-theme tr.table-warning {
            background-color: rgba(255, 222, 89, 0.9) !important;
            color: #1a1a1a !important;
            border-top: 1px solid #ffd84f !important;
            border-bottom: 1px solid #ffd84f !important;
        }
        .dark-theme tr.table-warning strong,
        .dark-theme tr.table-warning small,
        .dark-theme tr.table-warning span,
        .dark-theme tr.table-warning td,
        .dark-theme tr.table-warning th {
            color: #1a1a1a !important;
        }

        /* Table header */
        .dark-theme .table thead {
            background-color: #2b2b2b !important;
            color: #ffffff !important;
        }

        /* Hover rows */
        .dark-theme .table-hover tbody tr:hover {
            background-color: rgba(255, 255, 255, 0.07) !important;
        }

        /* Modal Styling */
        .dark-theme .modal-content {
            background-color: #1e1e1e !important;
            color: #ffffff !important;
            border: 1px solid #333 !important;
        }
        .dark-theme .modal-header {
            background-color: #0d6efd !important;
            color: #fff !important;
        }
        .dark-theme .modal-body p,
        .dark-theme .modal-body strong,
        .dark-theme .modal-body .email-content {
            color: #f5f5f5 !important;
        }
        .dark-theme .modal-footer {
            background-color: #2a2a2a !important;
            border-top: 1px solid #444 !important;
        }
        .dark-theme .btn-close {
            filter: invert(1);
        }

        /* Buttons */
        .dark-theme .btn-outline-info {
            border-color: #66b3ff !important;
            color: #66b3ff !important;
        }
        .dark-theme .btn-outline-info:hover {
            background-color: #0d6efd !important;
            color: #fff !important;
        }
        .dark-theme .btn-outline-primary {
            border-color: #4da3ff !important;
            color: #4da3ff !important;
        }
        .dark-theme .btn-outline-primary:hover {
            background-color: #0d6efd !important;
            color: #fff !important;
        }

        /* Badges */
        .dark-theme .badge.bg-warning {
            color: #000 !important;
        }
        .dark-theme .badge.bg-info {
            color: #000 !important;
        }
        .dark-theme .badge.bg-danger {
            color: #fff !important;
        }
        .dark-theme .badge.bg-secondary {
            color: #fff !important;
        }

        /* Scrollbar */
        .dark-theme ::-webkit-scrollbar-thumb {
            background: #666;
            border-radius: 5px;
        }

        /* 🧾 Bullet list inside modal */
        .formatted-email ul.email-list {
            list-style-type: disc;
            padding-left: 1.5rem;
            margin-top: 0.5rem;
            margin-bottom: 0.5rem;
        }
        .formatted-email ul.email-list li {
            margin-bottom: 0.25rem;
            line-height: 1.5;
        }
        .dark-theme .formatted-email ul.email-list li {
            color: #f5f5f5 !important;
        }
    </style>
</@layout.main>
